# CLAUDE.md

教程仓库。输出是编号模块 `01-` 到 `10-` 中的 Markdown 文件，而非应用程序。`scripts/` 中的脚本仅用于验证文档和构建 EPUB。

另请参见 `.claude/CLAUDE.md` 了解技术栈/命令，以及 `STYLE_GUIDE.md` 了解课程结构。

## 关键命令

```bash
# 质量关卡（也通过 pre-commit 钩子在提交时运行）
pre-commit run --all-files

# 测试
pytest scripts/tests/ -v

# EPUB 构建（调用 Kroki.io API 渲染 Mermaid — 需要网络）
uv run scripts/build_epub.py

# Python 工具
ruff check scripts/ && ruff format scripts/
mypy scripts/ --ignore-missing-imports
bandit -c scripts/pyproject.toml -r scripts/ --exclude scripts/tests/
```

Pre-commit 运行 5 项检查：markdown-lint、交叉引用、mermaid-syntax、link-check、build-epub（针对 `.md` 变更）。全部必须通过。

## 架构图

- `01-` … `10-` — 教程模块。**编号前缀 = 学习顺序**，而非字母顺序。不要重新排列。
- 每个模块：`README.md` + 可复制的模板（`.md`、`.json`、`.sh`）。
- `scripts/` — 工具（EPUB 构建器、链接/mermaid/交叉引用验证器）。不是产品。
- `02-memory/*.md` — 用户复制到其自己项目中的 CLAUDE.md 模板。不要与本文件混淆。
- `openspec/` — 基于规范的变更提案。

## 硬性规则

- **未经用户明确要求，不得提交或推送。**
- **不得在任何提交消息中添加 `Co-Authored-By: Claude`。**
- 运行 Python 脚本前始终激活 `.venv`（检查 `venv/`、`.venv/`、`env/`）。
- 内部链接使用**相对路径**（如 `01-slash-commands/README.md`）；锚点使用 `#heading-name`。
- 代码块**必须**声明语言（`bash`、`python`、`json`……）——否则交叉引用检查会失败。
- 外部 URL 必须可访问且稳定。不得使用临时链接。
- Mermaid 图表必须能解析（pre-commit 验证）。EPUB 构建失败通常是由于无效的 Mermaid 或无网络连接到 Kroki。
- 提交格式：`type(scope): subject`，其中 `scope` 对应模块文件夹（如 `feat(slash-commands):`、`docs(memory):`、`fix(README):`）。
- 不要重新排列 `01-`–`10-` 的编号。该顺序即为课程安排。

## 工作流偏好

- 对于课程编辑，遵循 `STYLE_GUIDE.md` 的结构/命名/图表规范。
- 小修复 → 最小化差异。不要为了修正一个错别字而重写整个部分。
- 添加模块页面时：先写 README + 模板，然后更新根目录 `README.md` 的索引，如果顺序/时间变化则更新 `LEARNING-ROADMAP.md`。
- 教程 > 库：优先考虑清晰的解释和可复制的示例，而非可复用的抽象。
- 如果质量检查失败，修复根本问题。不要用 `--no-verify` 绕过。

## Token 效率
- 永远不要重新读取刚刚写入或编辑过的文件。你已经知道内容。
- 永远不要重新运行命令来"验证"，除非结果不确定。
- 除非被要求，否则不要回显大段代码或文件内容。
- 将相关编辑批量合并为单个操作。不要用 5 次编辑完成 1 次就能处理的事。
- 跳过"我将继续……"之类的确认语。直接做。
- 如果任务只需要 1 次工具调用，就不要用 3 次。行动前先计划。
- 不要总结你刚刚做的事情，除非结果不明确或你需要额外输入。
