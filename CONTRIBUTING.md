<picture>
  <source media="(prefers-color-scheme: dark)" srcset="resources/logos/claude-howto-logo-dark.svg">
  <img alt="Claude How To" src="resources/logos/claude-howto-logo.svg">
</picture>

# 为 Claude How To 做贡献

感谢你有兴趣为本项目做贡献！本指南将帮助你了解如何有效地贡献。

## 关于本项目

Claude How To 是一个可视化、以示例驱动的 Claude Code 指南。我们提供：
- **Mermaid 图表**解释功能的工作原理
- **生产级模板**可立即使用
- **真实示例**附带上文和最佳实践
- **渐进式学习路径**从初学者到高级

## 贡献类型

### 1. 新示例或模板
为现有功能添加示例（斜杠命令、技能、钩子等）

### 2. 文档改进
澄清混淆的部分、修正错别字和语法、添加缺失的信息

### 3. 功能指南
为新 Claude Code 功能创建指南：分步教程、架构图、常见模式等

### 4. Bug 报告
报告你遇到的问题

### 5. 反馈和建议
帮助改进指南

## 入门

### 1. Fork 和克隆
```bash
git clone https://github.com/luongnv89/claude-howto.git
cd claude-howto
```

### 2. 创建分支
```bash
git checkout -b add/功能名
git checkout -b fix/问题描述
git checkout -b docs/改进领域
```

### 3. 设置环境

```bash
pip install uv
uv venv
source .venv/bin/activate
uv pip install -r scripts/requirements-dev.txt
npm install -g markdownlint-cli
npm install -g @mermaid-js/mermaid-cli
uv pip install pre-commit
pre-commit install
```

每次提交运行的钩子：

| 钩子 | 检查内容 |
|------|---------------|
| `markdown-lint` | Markdown 格式和结构 |
| `cross-references` | 相对链接、锚点、代码块 |
| `mermaid-syntax` | 所有 mermaid 块解析正确 |
| `link-check` | 外部 URL 可访问 |
| `build-epub` | EPUB 无错误生成 |

## 目录结构

```
├── 01-slash-commands/      # 用户调用快捷方式
├── 02-memory/              # 持久化上下文示例
├── 03-skills/              # 可复用能力
├── 04-subagents/           # 专业 AI 助手
├── 05-mcp/                 # MCP 协议示例
├── 06-hooks/               # 事件驱动自动化
├── 07-plugins/             # 功能包
├── 08-checkpoints/         # 会话快照
├── 09-advanced-features/   # 计划、思考、后台
├── 10-cli/                 # CLI 参考
├── scripts/                # 构建和工具脚本
└── README.md               # 主指南
```

## 提交规范

遵循约定式提交格式：
```
type(scope): description
```

类型：`feat`（新功能）、`fix`（修复）、`docs`（文档）、`refactor`（重构）、`style`（格式）、`test`（测试）、`chore`（构建/依赖）

## 安全

贡献示例和文档时，请遵循安全编码实践：
- **绝不硬编码密钥或 API 密钥** — 使用环境变量
- **警告安全影响** — 突出潜在风险
- **使用安全默认值** — 默认启用安全功能

有关安全问题，请参阅 [SECURITY.md](SECURITY.md)。

## 行为准则

我们致力于提供一个热情友好的包容性社区。请阅读 [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)。

## 许可证

通过为本项目做贡献，您同意您的贡献将根据 MIT 许可证授权。

---

**最后更新**：2026 年 4 月 9 日
