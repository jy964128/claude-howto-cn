#!/bin/bash
# 在依赖清单文件被修改后，检查已知的依赖漏洞。
# Hook: PostToolUse:Write

FILE=$1

if [ -z "$FILE" ]; then
  echo "用法: $0 <文件路径>"
  exit 0
fi

# 使用 basename 进行匹配 — $1 可能是绝对路径
BASENAME=$(basename "$FILE")

# 仅在依赖清单文件被写入时运行
case "$BASENAME" in
  package.json|package-lock.json|yarn.lock|pnpm-lock.yaml| \
  requirements.txt|Pipfile|Pipfile.lock|pyproject.toml| \
  go.mod|go.sum| \
  Cargo.toml|Cargo.lock| \
  Gemfile|Gemfile.lock| \
  composer.json|composer.lock| \
  pom.xml|build.gradle|build.gradle.kts)
    echo "📦 依赖清单已更新: $FILE — 正在扫描漏洞..."
    ;;
  *)
    exit 0
    ;;
esac

ISSUES_FOUND=0

# ── npm / yarn / pnpm ────────────────────────────────────────────────────────
if [[ "$BASENAME" == package*.json || "$BASENAME" == yarn.lock || "$BASENAME" == pnpm-lock.yaml ]]; then
  if command -v npm &>/dev/null; then
    echo "🔍 正在运行 npm audit..."
    if ! npm audit --audit-level=high --json 2>/dev/null | \
        python3 -c "
import sys, json
data = json.load(sys.stdin)
vulns = data.get('metadata', {}).get('vulnerabilities', {})
high = vulns.get('high', 0) + vulns.get('critical', 0)
if high:
    print(f'  ⚠️  发现 {high} 个高危/严重 npm 漏洞。运行: npm audit fix')
    sys.exit(1)
" 2>/dev/null; then
      ISSUES_FOUND=1
    else
      echo "  ✅ 未发现高危/严重 npm 漏洞"
    fi
  fi

  if command -v yarn &>/dev/null && [[ "$BASENAME" == yarn.lock ]]; then
    echo "🔍 正在运行 yarn audit..."
    if ! yarn audit --level high --json 2>/dev/null | \
        grep -q '"type":"auditAdvisory"' 2>/dev/null; then
      echo "  ✅ 未发现高危 yarn 漏洞"
    else
      echo "  ⚠️  yarn audit 发现漏洞。运行: yarn audit --level high"
      ISSUES_FOUND=1
    fi
  fi
fi

# ── Python ───────────────────────────────────────────────────────────────────
if [[ "$BASENAME" == requirements.txt || "$BASENAME" == Pipfile* || "$BASENAME" == pyproject.toml ]]; then
  if command -v pip-audit &>/dev/null; then
    echo "🔍 正在运行 pip-audit..."
    if pip-audit --format=json 2>/dev/null | \
        python3 -c "
import sys, json
data = json.load(sys.stdin)
vulns = [d for d in data.get('dependencies', []) if d.get('vulns')]
if vulns:
    for dep in vulns:
        for v in dep['vulns']:
            print(f'  ⚠️  {dep[\"name\"]} {dep[\"version\"]}: {v[\"id\"]} — {v[\"fix_versions\"]}')
    sys.exit(1)
" 2>/dev/null; then
      echo "  ✅ 未发现 Python 漏洞"
    else
      ISSUES_FOUND=1
      echo "  运行: pip-audit 查看详情"
    fi
  elif command -v safety &>/dev/null; then
    echo "🔍 正在运行 safety 检查..."
    OUTPUT=$(safety check --short-report 2>&1)
    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 0 ]; then
      echo "  ✅ 未发现 Python 漏洞"
    elif echo "$OUTPUT" | grep -qiE "vulnerability|CVE|insecure"; then
      echo "$OUTPUT"
      ISSUES_FOUND=1
    else
      echo "  ⚠️  safety 检查无法完成（网络或配置错误）" >&2
    fi
  fi
fi

# ── Go ───────────────────────────────────────────────────────────────────────
if [[ "$BASENAME" == go.mod || "$BASENAME" == go.sum ]]; then
  if command -v govulncheck &>/dev/null; then
    echo "🔍 正在运行 govulncheck..."
    OUTPUT=$(govulncheck ./... 2>&1)
    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 0 ]; then
      echo "  ✅ 未发现 Go 漏洞"
    elif echo "$OUTPUT" | grep -q "Vulnerability #"; then
      echo "$OUTPUT"
      ISSUES_FOUND=1
    else
      echo "  ⚠️  govulncheck 无法完成: $OUTPUT" >&2
    fi
  fi
fi

# ── Rust ─────────────────────────────────────────────────────────────────────
if [[ "$BASENAME" == Cargo.toml || "$BASENAME" == Cargo.lock ]]; then
  if command -v cargo-audit &>/dev/null; then
    echo "🔍 正在运行 cargo audit..."
    if ! cargo audit 2>/dev/null; then
      ISSUES_FOUND=1
    else
      echo "  ✅ 未发现 Rust 漏洞"
    fi
  fi
fi

# ── Ruby ─────────────────────────────────────────────────────────────────────
if [[ "$BASENAME" == Gemfile || "$BASENAME" == Gemfile.lock ]]; then
  if command -v bundler-audit &>/dev/null; then
    echo "🔍 正在运行 bundler-audit..."
    bundler-audit check --update 2>/dev/null || ISSUES_FOUND=1
  fi
fi

# ── 通用后备方案: trivy ──────────────────────────────────────────────────────
if command -v trivy &>/dev/null; then
  echo "🔍 正在运行 trivy 文件系统扫描..."
  if ! trivy fs --exit-code 1 --severity HIGH,CRITICAL --quiet . 2>/dev/null; then
    ISSUES_FOUND=1
  else
    echo "  ✅ trivy 未发现高危/严重问题"
  fi
fi

if [ "$ISSUES_FOUND" -eq 0 ]; then
  echo "✅ 依赖检查通过 — 未检测到漏洞"
else
  echo ""
  echo "⚠️  检测到漏洞。请在提交前审查并更新依赖。"
  echo "   此钩子仅为建议性质，不会阻止您的工作流程。"
fi

# 始终以 0 退出 — 此钩子仅警告，不阻止
exit 0
