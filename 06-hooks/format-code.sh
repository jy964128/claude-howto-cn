```bash
#!/bin/bash
# 代码写入后自动格式化
# Hook: PostToolUse:Write
#
# 从 stdin JSON 读取目标文件路径，在 Claude 写入文件后
# 对该文件运行合适的格式化工具进行原地格式化。
#
# 兼容平台：macOS、Linux、Windows (Git Bash)

# 从 stdin 读取 JSON 输入（Claude Code hook 协议）
INPUT=$(cat)

# 使用 sed 提取 file_path（兼容所有平台）
FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# 检测文件类型并调用对应的格式化工具
case "$FILE_PATH" in
  *.js|*.jsx|*.ts|*.tsx)
    if command -v prettier &> /dev/null; then
      prettier --write "$FILE_PATH" 2>/dev/null
    fi
    ;;
  *.py)
    if command -v black &> /dev/null; then
      black "$FILE_PATH" 2>/dev/null
    fi
    ;;
  *.go)
    if command -v gofmt &> /dev/null; then
      gofmt -w "$FILE_PATH" 2>/dev/null
    fi
    ;;
  *.rs)
    if command -v rustfmt &> /dev/null; then
      rustfmt "$FILE_PATH" 2>/dev/null
    fi
    ;;
  *.java)
    if command -v google-java-format &> /dev/null; then
      google-java-format -i "$FILE_PATH" 2>/dev/null
    fi
    ;;
esac

exit 0
```
