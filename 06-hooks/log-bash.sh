```bash
#!/bin/bash
# 记录所有 bash 命令
# Hook: PostToolUse:Bash
#
# 从标准输入 JSON 中读取已执行的命令并将其记录到文件中。
#
# 兼容：macOS、Linux、Windows（Git Bash）

# 从标准输入读取 JSON（Claude Code 钩子协议）
INPUT=$(cat)

# 从 tool_input 中提取 bash 命令
# 注意：sed [^"]* 会在 JSON 中的转义引号处停止；对于包含双引号字符串的命令，
# 只能捕获到第一个 \" 之前的部分——这是基于 sed 的 JSON 解析的已知限制，
# 对于日志记录目的来说是可以接受的。
COMMAND=$(echo "$INPUT" | sed -n 's/.*"command"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)

if [ -z "$COMMAND" ]; then
  exit 0
fi

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
LOGFILE="$HOME/.claude/bash-commands.log"

# 如果日志目录不存在则创建
mkdir -p "$(dirname "$LOGFILE")"

# 记录命令
echo "[$TIMESTAMP] $COMMAND" >> "$LOGFILE"

exit 0
```
