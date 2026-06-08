```
#!/usr/bin/env bash
# SessionEnd 钩子：提示输入学习的模块，然后将学习记录追加到
# ~/.claude-howto-progress.json 以实现持久化的学习进度跟踪。
#
# 在 Claude Code 会话终止时触发一次 —— 并非每次响应后都触发。
# 使用 /dev/tty 进行交互式输入，因为 stdin 承载了钩子的 JSON 负载。
#
# 安装方式：将以下内容添加到 .claude/settings.json 的 "SessionEnd" 事件中（见下文）。

PROGRESS_FILE="$HOME/.claude-howto-progress.json"

# 守卫：仅在本仓库内运行
if [[ "$CLAUDE_PROJECT_DIR" != *"claude-howto"* ]] && [[ "$PWD" != *"claude-howto"* ]]; then
  exit 0
fi

# 如果进度文件不存在则创建
if [ ! -f "$PROGRESS_FILE" ]; then
  echo '{"sessions":[]}' > "$PROGRESS_FILE"
fi

DATE=$(date +"%Y-%m-%d")
TIME=$(date +"%H:%M")

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Claude Code — 学习会话结束"
echo " $DATE $TIME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo " 你学习了哪些模块？（例如 06,07 或按回车跳过）"
echo " 01=斜杠命令  02=记忆  03=技能  04=子代理  05=MCP"
echo " 06=钩子  07=插件  08=检查点  09=高级功能  10=CLI"
echo ""
printf " > "
read -r INPUT </dev/tty

if [ -z "$INPUT" ] || [ "$INPUT" = "skip" ]; then
  echo " 已跳过 —— 未记录本次会话。"
  echo ""
  exit 0
fi

# 将短编号映射为模块名称（使用 for 循环避免 pipeline+while，后者在 bash 3.2 中无法解析）
IFS=',' read -ra PARTS <<< "$INPUT"
MODULES_JSON=""
for m in "${PARTS[@]}"; do
  m="${m// /}"  # 去除空格
  case "$m" in
    01) label='"01-slash-commands"' ;;
    02) label='"02-memory"' ;;
    03) label='"03-skills"' ;;
    04) label='"04-subagents"' ;;
    05) label='"05-mcp"' ;;
    06) label='"06-hooks"' ;;
    07) label='"07-plugins"' ;;
    08) label='"08-checkpoints"' ;;
    09) label='"09-advanced-features"' ;;
    10) label='"10-cli"' ;;
    *)  label="\"$m\"" ;;
  esac
  MODULES_JSON="${MODULES_JSON:+$MODULES_JSON,}$label"
done

printf " 备注？（可选，按回车跳过）："
read -r NOTES </dev/tty

# 将 NOTES 作为单独的参数传递，以便 Python 处理 JSON 转义 ——
# 避免备注中包含引号或反斜杠时导致 JSON 损坏。
python3 - "$PROGRESS_FILE" "$DATE" "$TIME" "$MODULES_JSON" "$NOTES" <<'PYEOF'
import sys, json

path, date, time_str, modules_raw, notes = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5]

new_session = {
    "date": date,
    "time": time_str,
    "modules": json.loads(f"[{modules_raw}]") if modules_raw else [],
    "notes": notes,
}

with open(path, 'r') as f:
    data = json.load(f)

data.setdefault('sessions', []).append(new_session)

with open(path, 'w') as f:
    json.dump(data, f, indent=2)
PYEOF

echo ""
echo " 已保存至 $PROGRESS_FILE"
[ -n "$NOTES" ] && echo " 备注：$NOTES"
echo ""
```
