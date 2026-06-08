```bash
#!/bin/bash
# 文件写入时的安全扫描
# 钩子: PostToolUse:Write
#
# 扫描文件中的硬编码密钥、API 密钥和凭据。
# 发现问题时通过 additionalContext 输出非阻塞警告。
#
# 兼容平台: macOS, Linux, Windows (Git Bash)

# 从 stdin 读取 JSON 输入（Claude Code 钩子协议）
INPUT=$(cat)

# 使用 sed 提取 file_path（兼容所有平台，包括 Windows Git Bash）
# 避免使用 grep -P（Windows Git Bash 不可用）和 python3 依赖
FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# 跳过二进制文件、vendor 目录和构建产物
case "$FILE_PATH" in
  *.png|*.jpg|*.jpeg|*.gif|*.svg|*.ico|*.woff|*.woff2|*.ttf|*.eot) exit 0 ;;
  */node_modules/*|*/.git/*|*/dist/*|*/build/*) exit 0 ;;
esac

ISSUES=""

# 检查硬编码密码
# 同时处理 JSON 格式（"password": "value"）和代码格式（password = 'value'）
# 使用 \\n 作为分隔符 — 它是有效的 JSON 换行转义，可以通过 printf 安全传递
if grep -qiE '"password"[[:space:]]*:[[:space:]]*"[^"]+"' "$FILE_PATH" 2>/dev/null; then
  ISSUES="${ISSUES}- 警告: 检测到潜在的硬编码密码\\n"
elif grep -qiE '(password|passwd|pwd)[[:space:]]*=[[:space:]]*'"'"'[^'"'"']+'"'"'' "$FILE_PATH" 2>/dev/null; then
  ISSUES="${ISSUES}- 警告: 检测到潜在的硬编码密码\\n"
fi

# 检查硬编码 API 密钥
if grep -qiE '"(api[_-]?key|apikey|access[_-]?token)"[[:space:]]*:[[:space:]]*"[^"]+"' "$FILE_PATH" 2>/dev/null; then
  ISSUES="${ISSUES}- 警告: 检测到潜在的硬编码 API 密钥\\n"
fi

# 检查硬编码密钥和令牌
if grep -qiE '(secret|token)[[:space:]]*=[[:space:]]*['"'"'"][^'"'"'"]+['"'"'"]' "$FILE_PATH" 2>/dev/null; then
  ISSUES="${ISSUES}- 警告: 检测到潜在的硬编码密钥或令牌\\n"
fi

# 检查私钥
if grep -q "BEGIN.*PRIVATE KEY" "$FILE_PATH" 2>/dev/null; then
  ISSUES="${ISSUES}- 警告: 检测到私钥\\n"
fi

# 检查 AWS 密钥
if grep -qE "AKIA[0-9A-Z]{16}" "$FILE_PATH" 2>/dev/null; then
  ISSUES="${ISSUES}- 警告: 检测到 AWS 访问密钥\\n"
fi

# 如果 semgrep 可用，则使用 semgrep 扫描（抑制 stdout 以避免与 JSON 输出混合）
if command -v semgrep &> /dev/null; then
  semgrep --config=auto "$FILE_PATH" --quiet >/dev/null 2>/dev/null
fi

# 如果 trufflehog 可用，则使用 trufflehog 扫描（抑制 stdout 以避免与 JSON 输出混合）
if command -v trufflehog &> /dev/null; then
  trufflehog filesystem "$FILE_PATH" --only-verified --quiet >/dev/null 2>/dev/null
fi

# 如果发现问题，通过 additionalContext 输出（非阻塞警告）
# 使用 Claude Code PostToolUse 协议要求的 hookSpecificOutput 格式
if [ -n "$ISSUES" ]; then
  # 对 JSON 中的文件路径进行转义（反斜杠和双引号）
  # ISSUES 已使用 \\n 作为分隔符（有效的 JSON 转义）— 只需转义双引号
  SAFE_PATH=$(printf '%s' "$FILE_PATH" | sed 's/\\/\\\\/g; s/"/\\"/g')
  SAFE_ISSUES=$(printf '%s' "$ISSUES" | sed 's/"/\\"/g')
  printf '{"hookSpecificOutput": {"hookEventName": "PostToolUse", "additionalContext": "安全扫描在 %s 中发现问题：\\n%s请检查并使用环境变量替代。"}}' "$SAFE_PATH" "$SAFE_ISSUES"
fi

exit 0
```
