```bash
#!/bin/bash
# Bash 命令执行前的安全检查
# 钩子: PreToolUse (匹配器: Bash)
#
# 此钩子在每个 Bash 工具执行前运行，对具有潜在破坏性或高风险的
# shell 命令进行拦截或发出警告。
#
# 安装:
#   cp 06-hooks/pre-tool-check.sh ~/.claude/hooks/
#   chmod +x ~/.claude/hooks/pre-tool-check.sh
#
# 在 ~/.claude/settings.json 中配置:
#   {
#     "hooks": {
#       "PreToolUse": [
#         {
#           "matcher": "Bash",
#           "hooks": [
#             {
#               "type": "command",
#               "command": "~/.claude/hooks/pre-tool-check.sh"
#             }
#           ]
#         }
#       ]
#     }
#   }
#
# 输入: 通过标准输入传入 JSON，格式如下:
#   { "tool_name": "Bash", "tool_input": { "command": "..." } }
#
# 输出约定 (遵循 Claude Code 钩子协议):
#   - 退出码 0 → 放行。stdout 可以包含 JSON (hookSpecificOutput)；stderr
#     会被静默丢弃，因此打印到 stderr 的警告不可见。
#     如需对放行的命令进行可观测记录，请写入审计日志文件。
#   - 退出码 2 → 拦截。stderr 会作为拦截原因反馈给 Claude。
#     任何解释命令被拦截原因的 echo 输出必须通过 `>&2` 重定向到
#     stderr，否则 Claude Code 会报告 "No stderr output"。
#
# 审计日志: 每次调用都会记录到
#   $CLAUDE_PROJECT_DIR/.claude/hooks/audit.log
# 并附上决策结果 (BLOCK/WARN/ALLOW)，这样即使 WARN 级别的匹配
# 的 stderr 输出被 Claude Code 丢弃，你也能观察到它们。

# 从标准输入读取完整的 JSON 输入
INPUT=$(cat)

# 使用可移植的 sed 提取命令 (兼容 macOS 和 Linux)
COMMAND=$(echo "$INPUT" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)

# 如果提取失败，回退到原始输入
if [ -z "$COMMAND" ]; then
  COMMAND="$INPUT"
fi

# ── 审计日志 ─────────────────────────────────────────────────────────────────
# 记录每次调用及其最终决策。这是在 WARN 级别下唯一可靠的
# 观察方式，因为 Claude Code 在退出码为 0 时会静默丢弃 stderr。
# 当钩子在 Claude Code 外部调用时 (例如本地测试)，回退到 $(pwd)。
LOG_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}/.claude/hooks"
LOG_FILE="$LOG_DIR/audit.log"
mkdir -p "$LOG_DIR" 2>/dev/null
log_decision() {
  echo "$(date -u +%FT%TZ) [$1] $COMMAND" >> "$LOG_FILE"
}

# ── 拦截模式 ──────────────────────────────────────────────────────────────────
# 以下命令会被无条件拦截，因为它们在自动化上下文中几乎总是
# 破坏性的，且极少是有意为之。

BLOCKED_PATTERNS=(
  # 锚定 `rm -rf /`，使得 `/` 后面必须是空白字符或行尾，
  # 否则子字符串匹配会误判，例如 `rm -rf /tmp/foo`。
  "rm -rf /([[:space:]]|$)"
  "rm -rf \*"
  "dd if=/dev/zero"
  "dd if=/dev/random"
  ":\(\)\{:\|:&\};:"  # Fork 炸弹 (正则元字符已转义)
  "mkfs\."           # 格式化文件系统
  "format c:"        # Windows 磁盘格式化
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    log_decision "BLOCK:$pattern"
    # 以下 echo 必须输出到 stderr — Claude Code 在退出码为 2 时将 stderr
    # 作为拦截原因反馈给用户。输出到 stdout 则会导致显示 "No stderr output"。
    echo "❌ 已拦截: 检测到潜在破坏性命令: $pattern" >&2
    echo "   命令: $COMMAND" >&2
    exit 2
  fi
done

# ── 警告模式 ──────────────────────────────────────────────────────────────────
# 以下模式存在风险，但可能是有意执行的。记录警告并放行。

WARNING_PATTERNS=(
  "rm -rf"
  "git push --force"
  "git reset --hard"
  "git clean -f"
  "chmod -R 777"
  "sudo rm"
  "DROP TABLE"
  "DROP DATABASE"
  "truncate"
)

MATCHED_WARNINGS=""
for pattern in "${WARNING_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qi "$pattern"; then
    MATCHED_WARNINGS="${MATCHED_WARNINGS:+$MATCHED_WARNINGS,}$pattern"
    # 同时在 stderr 上输出警告，方便手动运行此钩子的人查看。
    # Claude Code 在退出码为 0 时会丢弃这些输出 — 审计日志才是可靠的
    # 记录来源 (参见 WARN 条目)。
    echo "⚠️  警告: 检测到高风险操作: $pattern" >&2
  fi
done

if [ -n "$MATCHED_WARNINGS" ]; then
  log_decision "WARN:$MATCHED_WARNINGS"
  echo "   命令: $COMMAND" >&2
  echo "   正在继续 — 请在继续之前仔细检查上述警告。" >&2
else
  log_decision "ALLOW"
fi

# ── 放行 ─────────────────────────────────────────────────────────────────────
exit 0
```
