<picture>
  <source media="(prefers-color-scheme: dark)" srcset="resources/logos/claude-howto-logo-dark.svg">
  <img alt="Claude How To" src="resources/logos/claude-howto-logo.svg">
</picture>

# Claude Code 示例 — 快速参考卡

## 🚀 安装快速命令

### 斜杠命令
```bash
# Install all
cp 01-slash-commands/*.md .claude/commands/

# Install specific
cp 01-slash-commands/optimize.md .claude/commands/
```

### 记忆
```bash
# Project memory
cp 02-memory/project-CLAUDE.md ./CLAUDE.md

# Personal memory
cp 02-memory/personal-CLAUDE.md ~/.claude/CLAUDE.md
```

### 技能
```bash
# Personal skills
cp -r 03-skills/code-review-specialist ~/.claude/skills/

# Project skills
cp -r 03-skills/code-review-specialist .claude/skills/
```

### 子代理
```bash
# Install all
cp 04-subagents/*.md .claude/agents/

# Install specific
cp 04-subagents/code-reviewer.md .claude/agents/
```

### MCP
```bash
# Set credentials
export GITHUB_TOKEN="your_token"
export DATABASE_URL="postgresql://..."

# Install config (project scope)
cp 05-mcp/github-mcp.json .mcp.json

# Or user scope: add to ~/.claude.json
```

### 钩子
```bash
# Install hooks
mkdir -p ~/.claude/hooks
cp 06-hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# Configure in settings (~/.claude/settings.json)
```

### 插件
```bash
# Install from examples (if published)
/plugin install pr-review
/plugin install devops-automation
/plugin install documentation
```

### 检查点
```bash
# Checkpoints are created automatically with every user prompt
# To rewind, press Esc twice or use:
/rewind

# Then choose: Restore code and conversation, Restore conversation,
# Restore code, Summarize from here, or Never mind
```

### 高级功能
```bash
# Configure in settings (.claude/settings.json)
# See 09-advanced-features/config-examples.json

# Planning mode
/plan Task description

# Permission modes (use --permission-mode flag)
# default        - Ask for approval on risky actions
# acceptEdits    - Auto-accept file edits, ask for others
# plan           - Read-only analysis, no modifications
# dontAsk        - Accept all actions except risky ones
# auto           - Background classifier decides permissions automatically
# bypassPermissions - Accept all actions (requires --dangerously-skip-permissions)

# Session management
/resume                # Resume a previous conversation
/rename "name"         # Name the current session
/fork                  # Fork the current session
claude -c              # Continue most recent conversation
claude -r "session"    # Resume session by name/ID
```

---

## 📋 功能速查表

| 功能 | 安装路径 | 使用方式 |
|---------|-------------|-------|
| **斜杠命令 (60+)** | `.claude/commands/*.md` | `/command-name` |
| **记忆** | `./CLAUDE.md` | 自动加载 |
| **技能** | `.claude/skills/*/SKILL.md` | 自动调用 |
| **子代理** | `.claude/agents/*.md` | 自动委派 |
| **MCP** | `.mcp.json`（项目）或 `~/.claude.json`（用户） | `/mcp__server__action` |
| **钩子 (29 个事件)** | `~/.claude/hooks/*.sh` | 事件触发（5 种类型） |
| **插件** | 通过 `/plugin install` | 打包所有功能 |
| **检查点** | 内置 | `Esc+Esc` 或 `/rewind` |
| **规划模式** | 内置 | `/plan <task>` |
| **权限模式 (6 种)** | 内置 | `--allowedTools`、`--permission-mode` |
| **会话** | 内置 | `/session <command>` |
| **后台任务** | 内置 | 在后台运行 |
| **远程控制** | 内置 | WebSocket API |
| **Web 会话** | 内置 | `claude web` |
| **Git 工作树** | 内置 | `/worktree` |
| **自动记忆** | 内置 | 自动保存到 CLAUDE.md |
| **任务列表** | 内置 | `/task list` |
| **内置技能 (10 个)** | 内置 | `/batch`、`/claude-api`、`/code-review`、`/simplify` *（仅限清理性审查；自 v2.1.154 起再次与 `/code-review` 区分）*、`/debug`、`/fewer-permission-prompts`、`/loop`、`/run` *（v2.1.145+）*、`/run-skill-generator` *（v2.1.145+）*、`/verify` *（v2.1.145+）* |

---

## 🎯 常见用例

### 代码审查
```bash
# Method 1: Slash command
cp 01-slash-commands/optimize.md .claude/commands/
# Use: /optimize

# Method 2: Subagent
cp 04-subagents/code-reviewer.md .claude/agents/
# Use: Auto-delegated

# Method 3: Skill
cp -r 03-skills/code-review-specialist ~/.claude/skills/
# Use: Auto-invoked

# Method 4: Plugin (best)
/plugin install pr-review
# Use: /review-pr
```

### 文档
```bash
# Slash command
cp 01-slash-commands/generate-api-docs.md .claude/commands/

# Subagent
cp 04-subagents/documentation-writer.md .claude/agents/

# Skill
cp -r 03-skills/doc-generator ~/.claude/skills/

# Plugin (complete solution)
/plugin install documentation
```

### DevOps
```bash
# Complete plugin
/plugin install devops-automation

# Commands: /deploy, /rollback, /status, /incident
```

### 团队标准
```bash
# Project memory
cp 02-memory/project-CLAUDE.md ./CLAUDE.md

# Edit for your team
vim CLAUDE.md
```

### 自动化与钩子
```bash
# Install hooks (29 events, 5 types: command, http, mcp_tool, prompt, agent)
mkdir -p ~/.claude/hooks
cp 06-hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh

# Examples:
# - Pre-commit tests: pre-commit.sh
# - Auto-format code: format-code.sh
# - Security scanning: security-scan.sh

# Auto Mode for fully autonomous workflows
claude --enable-auto-mode -p "Refactor and test the auth module"
# Or cycle modes interactively with Shift+Tab
```

### 安全重构
```bash
# Checkpoints are created automatically before each prompt
# Try refactoring
# If it works: continue
# If it fails: press Esc+Esc or use /rewind to go back
```

### 复杂实现
```bash
# Use planning mode
/plan Implement user authentication system

# Claude creates detailed plan
# Review and approve
# Claude implements systematically
```

### CI/CD 集成
```bash
# Run in headless mode (non-interactive)
claude -p "Run all tests and generate report"

# With permission mode for CI
claude -p "Run tests" --permission-mode dontAsk

# With Auto Mode for fully autonomous CI tasks
claude --enable-auto-mode -p "Run tests and fix failures"

# With hooks for automation
# See 09-advanced-features/README.md
```

### 学习与实验
```bash
# Use plan mode for safe analysis
claude --permission-mode plan

# Experiment safely - checkpoints are created automatically
# If you need to rewind: press Esc+Esc or use /rewind
```

### 代理团队
```bash
# Enable agent teams
export CLAUDE_AGENT_TEAMS=1

# Or in settings.json
{ "agentTeams": { "enabled": true } }

# Start with: "Implement feature X using a team approach"
```

### 定时任务
```bash
# Run a command every 5 minutes
/loop 5m /check-status

# One-time reminder
/loop 30m "remind me to check the deploy"
```

---

## 📁 文件位置参考

```
Your Project/
├── .claude/
│   ├── commands/              # 斜杠命令放这里
│   ├── agents/                # 子代理放这里
│   ├── skills/                # 项目技能放这里
│   └── settings.json          # 项目设置（钩子等）
├── .mcp.json                  # MCP 配置（项目范围）
├── CLAUDE.md                  # 项目记忆
└── src/
    └── api/
        └── CLAUDE.md          # 目录特定记忆

User Home/
├── .claude/
│   ├── commands/              # 个人命令
│   ├── agents/                # 个人代理
│   ├── skills/                # 个人技能
│   ├── hooks/                 # 钩子脚本
│   ├── settings.json          # 用户设置
│   ├── managed-settings.d/    # 托管设置（企业/组织）
│   └── CLAUDE.md              # 个人记忆
└── .claude.json               # 个人 MCP 配置（用户范围）
```

---

## 🔍 查找示例

### 按类别
- **斜杠命令**：`01-slash-commands/`
- **记忆**：`02-memory/`
- **技能**：`03-skills/`
- **子代理**：`04-subagents/`
- **MCP**：`05-mcp/`
- **钩子**：`06-hooks/`
- **插件**：`07-plugins/`
- **检查点**：`08-checkpoints/`
- **高级功能**：`09-advanced-features/`
- **CLI**：`10-cli/`

### 按用例
- **性能**：`01-slash-commands/optimize.md`
- **安全**：`04-subagents/secure-reviewer.md`
- **测试**：`04-subagents/test-engineer.md`
- **文档**：`03-skills/doc-generator/`
- **DevOps**：`07-plugins/devops-automation/`

### 按复杂度
- **简单**：斜杠命令
- **中等**：子代理、记忆
- **高级**：技能、钩子
- **完整方案**：插件

---

## 🎓 学习路径

### 第 1 天
```bash
# Read overview
cat README.md

# Install a command
cp 01-slash-commands/optimize.md .claude/commands/

# Try it
/optimize
```

### 第 2-3 天
```bash
# Set up memory
cp 02-memory/project-CLAUDE.md ./CLAUDE.md
vim CLAUDE.md

# Install subagent
cp 04-subagents/code-reviewer.md .claude/agents/
```

### 第 4-5 天
```bash
# Set up MCP
export GITHUB_TOKEN="your_token"
cp 05-mcp/github-mcp.json .mcp.json

# Try MCP commands
/mcp__github__list_prs
```

### 第 2 周
```bash
# Install skill
cp -r 03-skills/code-review-specialist ~/.claude/skills/

# Let it auto-invoke
# Just say: "Review this code for issues"
```

### 第 3 周及以后
```bash
# Install complete plugin
/plugin install pr-review

# Use bundled features
/review-pr
/check-security
/check-tests
```

---

## 新功能（2026 年 5 月）

| 功能 | 描述 | 使用方式 |
|---------|-------------|-------|
| **Auto Mode（自动模式）** | 通过后台分类器实现完全自主运行 | `--enable-auto-mode` 标志，`Shift+Tab` 切换模式 |
| **Channels（频道）** | Discord 和 Telegram 集成 | `--channels` 标志，Discord/Telegram 机器人 |
| **Voice Dictation（语音输入）** | 通过语音向 Claude 传达命令和上下文 | `/voice` 命令 |
| **Hooks（钩子，29 个事件）** | 扩展的钩子系统，支持 5 种类型 | command、http、mcp_tool、prompt、agent 钩子类型 |
| **MCP Elicitation（MCP 提示）** | MCP 服务器可在运行时请求用户输入 | 服务器需要澄清时自动提示 |
| **Plugin LSP（插件 LSP）** | 插件支持语言服务器协议 | `userConfig`、`${CLAUDE_PLUGIN_DATA}` 变量 |
| **Remote Control（远程控制）** | 通过 WebSocket API 控制 Claude Code | `claude --remote` 用于外部集成 |
| **Web Sessions（Web 会话）** | 基于浏览器的 Claude Code 界面 | `claude web` 启动 |
| **Desktop App（桌面应用）** | 原生桌面应用程序 | 从 claude.ai/download 下载 |
| **Task List（任务列表）** | 管理后台任务 | `/task list`、`/task status <id>` |
| **Auto Memory（自动记忆）** | 从对话中自动保存记忆 | Claude 自动将关键上下文保存到 CLAUDE.md |
| **Git Worktrees（Git 工作树）** | 用于并行开发的隔离工作空间 | `/worktree` 创建隔离工作空间 |
| **Model Selection（模型选择）** | 在 Sonnet 4.6、Opus 4.8 和 Haiku 4.5 之间切换 | `/model` — 自 v2.1.153 起，选择会保存为新会话的默认值；按 `s` 仅限当前会话 |
| **Agent Teams（代理团队）** | 协调多个代理完成任务 | 通过 `CLAUDE_AGENT_TEAMS=1` 环境变量启用 |
| **Dynamic Workflows（动态工作流）** *（v2.1.154）* | 确定性的多代理编排 | `/workflows` 查看运行记录；让 Claude 创建一个 |
| **Scheduled Tasks（定时任务）** | 使用 `/loop` 执行重复任务 | `/loop 5m /command` 或 CronCreate 工具 |
| **Chrome Integration（Chrome 集成）** | 浏览器自动化 | `--chrome` 标志或 `/chrome` 命令 |
| **Keyboard Customization（键盘自定义）** | 自定义键绑定 | `/keybindings` 命令 |
| **/usage-credits（用量配额）** | 配置额外用量限制（在 v2.1.144 中从 `/extra-usage` 重命名；旧名称仍可作为别名使用） | `/usage-credits` |
| **/run** *（v2.1.145+）* | 启动本项目应用以查看更改运行效果 | `/run` |
| **/verify** *（v2.1.145+）* | 构建、运行并观察应用以确认修复有效 | `/verify` |
| **/run-skill-generator** *（v2.1.145+）* | 教 `/run`/`/verify` 如何处理特定项目 | `/run-skill-generator` |

---

## 提示与技巧

### 自定义
- 先按原样使用示例
- 根据需求进行修改
- 分享给团队前先测试
- 对配置文件进行版本控制

### 最佳实践
- 用记忆管理团队标准
- 用插件实现完整工作流
- 用子代理处理复杂任务
- 用斜杠命令处理快捷任务

### 故障排除
```bash
# Check file locations
ls -la .claude/commands/
ls -la .claude/agents/

# Verify YAML syntax
head -20 .claude/agents/code-reviewer.md

# Test MCP connection
echo $GITHUB_TOKEN
```

---

## 📊 功能矩阵

| 需求 | 使用 | 示例 |
|------|----------|---------|
| 快捷操作 | 斜杠命令 (60+) | `01-slash-commands/optimize.md` |
| 团队标准 | 记忆 | `02-memory/project-CLAUDE.md` |
| 自动工作流 | 技能 | `03-skills/code-review-specialist/` |
| 专业任务 | 子代理 | `04-subagents/code-reviewer.md` |
| 外部数据 | MCP（+ 提示） | `05-mcp/github-mcp.json` |
| 事件自动化 | 钩子（29 个事件，5 种类型） | `06-hooks/pre-commit.sh` |
| 完整解决方案 | 插件（+ LSP 支持） | `07-plugins/pr-review/` |
| 安全实验 | 检查点 | `08-checkpoints/checkpoint-examples.md` |
| 完全自主 | Auto Mode（自动模式） | `--enable-auto-mode` 或 `Shift+Tab` |
| 聊天集成 | 频道 | `--channels`（Discord、Telegram） |
| CI/CD 流水线 | CLI | `10-cli/README.md` |

---

## 🔗 快速链接

- **主指南**：`README.md`
- **完整索引**：`INDEX.md`
- **原始指南**：`claude_concepts_guide.md`

---

## 📞 常见问题

**问：我应该用哪个？**
答：从斜杠命令开始，根据需要逐步添加功能。

**问：可以混合使用功能吗？**
答：可以！它们可以协同工作。记忆 + 命令 + MCP = 强大组合。

**问：如何与团队共享？**
答：将 `.claude/` 目录提交到 git。

**问：密钥怎么处理？**
答：使用环境变量，切勿硬编码。

**问：可以修改示例吗？**
答：当然！它们是供自定义使用的模板。

---

## ✅ 清单

入门清单：

- [ ] 阅读 `README.md`
- [ ] 安装一个斜杠命令
- [ ] 试用该命令
- [ ] 创建项目 `CLAUDE.md`
- [ ] 安装一个子代理
- [ ] 设置一个 MCP 集成
- [ ] 安装一个技能
- [ ] 试用一个完整的插件
- [ ] 根据需求进行自定义
- [ ] 与团队共享

---

**快速入门**：`cat README.md`

**完整索引**：`cat INDEX.md`

**本参考卡**：随身携带，随时查阅！

---
**最后更新**：2026 年 6 月 2 日
**Claude Code 版本**：2.1.160
**来源**：
- https://code.claude.com/docs/en/overview
- https://code.claude.com/docs/en/hooks
- https://code.claude.com/docs/en/commands
- https://github.com/anthropics/claude-code/releases/tag/v2.1.153
- https://github.com/anthropics/claude-code/releases/tag/v2.1.154
**兼容模型**：Claude Sonnet 4.6、Claude Opus 4.8、Claude Haiku 4.5
