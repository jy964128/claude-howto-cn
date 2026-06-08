```bash
#!/bin/bash
# 验证用户提示
# 钩子: UserPromptSubmit
#
# 从标准输入 JSON 读取用户提示并阻止危险操作。
#
# 兼容平台: macOS、Linux、Windows (Git Bash)

# 从标准输入读取 JSON (Claude Code 钩子协议)
INPUT=$(cat)

# 从 JSON 输入中提取提示文本
# Claude Code 通过 "user_prompt" 字段发送 UserPromptSubmit (回退到 "prompt")
PROMPT=$(echo "$INPUT" | sed -n 's/.*"user_prompt"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
if [ -z "$PROMPT" ]; then
  PROMPT=$(echo "$INPUT" | sed -n 's/.*"prompt"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)
fi

if [ -z "$PROMPT" ]; then
  exit 0
fi

# 检查危险操作
DANGEROUS_PATTERNS=(
  "rm -rf /"
  "delete database"
  "drop database"
  "format disk"
  "dd if="
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$PROMPT" | grep -qi "$pattern"; then
    printf '{"decision": "block", "reason": "检测到危险操作: %s"}' "$pattern"
    exit 0
  fi
done

# 检查生产环境部署
if echo "$PROMPT" | grep -qiE "(deploy|push).*production"; then
  if [ ! -f ".deployment-approved" ]; then
    echo '{"decision": "block", "reason": "生产环境部署需要审批。请创建 .deployment-approved 文件以继续。"}'
    exit 0
  fi
fi

# 检查某些操作所需的上下文
if echo "$PROMPT" | grep -qi "refactor"; then
  if [ ! -d "tests" ] && [ ! -d "test" ]; then
    printf '{"additionalContext": "警告: 在没有测试的情况下重构可能有风险。建议先编写测试。"}'
  fi
fi

exit 0
```
