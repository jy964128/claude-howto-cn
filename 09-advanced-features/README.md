翻译已写入 `09-advanced-features/README.zh-CN.md`。以下是完整的简体中文翻译：

---

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="../resources/logos/claude-howto-logo-dark.svg">
  <img alt="Claude How To" src="../resources/logos/claude-howto-logo.svg">
</picture>

# 高级功能

全面介绍 Claude Code 的高级功能，包括规划模式、扩展思考、自动模式、后台任务、权限模式、打印模式（非交互式）、会话管理、交互功能、通道、语音输入、远程控制、Web 会话、桌面应用、任务列表、提示建议、Git 工作树、沙箱、托管设置和配置。

## 目录

1. [概述](#概述)
2. [规划模式](#规划模式)
3. [Ultraplan（云端计划起草）](#ultraplan云端计划起草)
4. [扩展思考](#扩展思考)
5. [自动模式](#自动模式)
6. [后台任务](#后台任务)
7. [Monitor 工具（事件驱动流）](#monitor-工具事件驱动流)
8. [动态工作流](#动态工作流)
9. [计划任务](#计划任务)
10. [权限模式](#权限模式)
11. [无界面模式](#无界面模式)
12. [会话管理](#会话管理)
13. [交互功能](#交互功能)
14. [TUI 模式（全屏）](#tui-模式全屏)
15. [语音输入](#语音输入)
16. [通道](#通道)
17. [Chrome 集成](#chrome-集成)
18. [远程控制](#远程控制)
19. [Web 会话](#web-会话)
20. [桌面应用](#桌面应用)
21. [任务列表](#任务列表)
22. [提示建议](#提示建议)
23. [Git 工作树](#git-工作树)
24. [沙箱](#沙箱)
25. [托管设置（企业版）](#托管设置企业版)
26. [配置与设置](#配置与设置)
27. [Agent 团队](#agent-团队)
28. [最佳实践](#最佳实践)
29. [其他资源](#其他资源)

---

## 概述

Claude Code 的高级功能通过规划、推理、自动化和控制机制扩展了核心能力。这些功能为复杂的开发任务、代码审查、自动化和多会话管理提供了强大的工作流支持。

**主要高级功能包括：**
- **规划模式**：在编码前创建详细的实现计划
- **扩展思考**：针对复杂问题进行深度推理
- **自动模式**：后台安全分类器在执行每个操作前进行审查（研究预览）
- **后台任务**：在不阻塞对话的情况下运行长时间操作
- **权限模式**：控制 Claude 可执行的操作（`default`、`acceptEdits`、`plan`、`auto`、`dontAsk`、`bypassPermissions`）
- **打印模式**：以非交互方式运行 Claude Code，适用于自动化和 CI/CD（`claude -p`）
- **会话管理**：管理多个工作会话
- **交互功能**：键盘快捷键、多行输入和命令历史
- **语音输入**：按住通话式语音输入，支持 20 种语言的语音转文字
- **通道**：MCP 服务器将消息推送到运行中的会话（研究预览）
- **远程控制**：从 Claude.ai 或 Claude 应用远程控制 Claude Code
- **Web 会话**：在 claude.ai/code 浏览器中运行 Claude Code
- **桌面应用**：用于可视化差异审查和多会话的独立应用
- **任务列表**：在上下文压缩期间持续跟踪任务
- **提示建议**：基于上下文的智能命令建议
- **Git 工作树**：用于并行工作的隔离工作树分支
- **沙箱**：操作系统级别的文件系统和网络隔离
- **托管设置**：通过 plist、注册表或托管文件进行企业部署
- **配置**：使用 JSON 配置文件自定义行为

---

## 规划模式

规划模式允许 Claude 在实现复杂任务之前进行深入思考，创建一份详细的计划供您审查和批准。

### 什么是规划模式？

规划模式采用两阶段方法：
1. **规划阶段**：Claude 分析任务并创建详细的实现计划
2. **执行阶段**：经批准后，Claude 执行计划

### 何时使用规划模式

✅ 适合使用规划模式：
- 复杂的多文件重构
- 新功能实现
- 架构变更
- 数据库迁移
- 重大 API 重新设计

❌ 不适合使用规划模式：
- 简单的错误修复
- 格式更改
- 单文件编辑
- 快速查询

### 激活规划模式

**斜杠命令**：
```bash
/plan Implement user authentication system
```

**CLI 标志**：
```bash
claude --permission-mode plan
```

**设置为默认**：
```json
{
  "permissions": {
    "defaultMode": "plan"
  }
}
```

**键盘快捷键**：
- `Shift + Tab` - 切换权限模式（包括规划模式）
- `Alt + M` - 切换权限模式（Windows/Linux）

### 规划模式的好处

- **结构化的实现方法**：详细分解实现步骤
- **审查和批准**：在执行前批准或调整计划
- **风险识别**：在实现前识别潜在问题
- **清晰的阶段划分**：有组织的实现阶段和里程碑

### 示例：功能实现

```
User: /plan Add a real-time notification system

Claude: I'll create a plan for implementing real-time notifications.

## Implementation Plan

### Phase 1: Infrastructure Setup
1. Install WebSocket libraries (socket.io)
2. Set up WebSocket server
3. Configure connection management

### Phase 2: Backend Implementation
4. Create notification service
5. Implement notification queue
6. Add database schema for notifications
7. Create API endpoints

### Phase 3: Frontend Integration
8. Set up WebSocket client
9. Create notification UI components
10. Implement notification state management
11. Add notification permissions

### Phase 4: Testing & Deployment
12. Write unit tests
13. Write integration tests
14. Update documentation
15. Deploy to staging

Estimated time: 3-4 hours
Files to modify: 12
New files to create: 8

Ready to proceed? (yes/no/modify plan)

User: yes

Claude: [Begins implementation following the plan]
```

### 修改计划

```
User: Modify the plan - skip the queue for now, we'll add it later

Claude: Updated plan:
[Shows modified plan with queue removed]

User: Looks good, proceed

Claude: [Implements modified plan]
```

### 规划模式配置

规划模式通过 CLI 标志或斜杠命令激活：

```bash
# 通过 CLI 激活规划模式
claude --permission-mode plan

# 或在 REPL 中使用 /plan 斜杠命令
/plan Implement user authentication system
```

**规划专用模型别名**：使用 `opusplan` 作为模型别名，让 Opus 负责规划、Sonnet 负责执行：

```bash
claude --model opusplan "design and implement the new API"
```

**在外部编辑计划**：按 `Ctrl+G` 在外部编辑器中打开当前计划以进行详细修改。

> **v2.1.112 更新**：计划文件现在以生成它的提示命名（而非随机词），便于浏览和复用。

> **v2.1.136 更新 — 规划模式下的写拦截是无条件的**：规划模式现在阻止所有文件写入，包括 `permissions.allow` 中存在匹配的 `Edit(...)` 规则时。此前，宽松的 `Edit(...)` 规则可能在规划模式下允许写入；该绕过已关闭。如果您的工作流依赖于旧行为，请在编辑前退出规划模式（`Shift+Tab`）。

---

## Ultraplan（云端计划起草）

> **v2.1.101 新增**：Ultraplan 现在在您首次调用时自动创建一个 Claude Code on the web 云端环境——无需手动设置，也无需等待容器预热即可开始起草计划。

> **注意**：Ultraplan 为研究预览功能，需要 Claude Code v2.1.91 或更高版本。

`/ultraplan` 将本地 CLI 中的规划任务交给运行在规划模式下的 Claude Code on the web 会话进行处理。Claude 在云端起草计划，同时您的终端可自由进行其他工作，之后您在浏览器中审查草稿并选择执行位置——在同一云端会话中执行或传送回您的终端。

### 何时使用 Ultraplan

- 您希望获得比终端更丰富的审查界面：行内评论、表情反应、大纲侧边栏和持久化的历史记录。
- 您希望进行离线起草，同时继续在本地编码——云端会话研究代码仓库并编写计划，不会阻塞您的 CLI。
- 计划需要利益相关者在执行前审查——可共享的网页 URL 比粘贴终端滚动记录更好。

### 要求

- 一个 Claude Code on the web 账户。
- 一个 GitHub 仓库（云端会话克隆您的仓库以基于真实代码起草计划）。
- **不可用**于 Amazon Bedrock、Google Cloud Vertex AI 或 Microsoft Foundry。

### 三种启动方式

- **命令**：`/ultraplan <prompt>` —— 显式调用。
- **关键词**：在普通提示中任何位置包含 `ultraplan` 一词，Claude 会将请求路由到云端。
- **从本地计划触发**：当 Claude 在本地完成计划后，在批准对话框中选择"No, refine with Ultraplan on Claude Code on the web"，将草稿交给云端进行更深入的研究。

### 使用示例

```bash
/ultraplan migrate the auth service from sessions to JWTs
```

Claude 确认后，启动云端环境（v2.1.101+ 首次运行时自动创建），并返回一个可在浏览器中打开的会话链接。

### 状态指示器

| 状态 | 含义 |
|---|---|
| `◇ ultraplan` | Claude 正在研究您的代码库并起草计划 |
| `◇ ultraplan needs your input` | Claude 有待澄清的问题；打开会话链接回复 |
| `◆ ultraplan ready` | 计划已准备就绪，可在浏览器中审查 |

### 执行选项

计划准备就绪后，您有两种执行路径。在浏览器中批准计划将在同一云端会话中执行——Claude 远程实现更改并通过 Web 界面创建拉取请求。或者选择"Approve plan and teleport back to terminal"在本地实现。终端传送对话框提供三个选项：

- **Implement here（在此处实现）**——在当前终端会话中运行已批准的计划。
- **Start new session（启动新会话）**——在同一工作目录中打开新会话并在此实现。
- **Cancel（取消）**——将计划保存到文件，以便稍后继续。

> **警告**：Ultraplan 启动时远程控制会断开连接。这两个功能共享 claude.ai/code 界面，因此一次只能激活其中一个。

---

## 扩展思考

扩展思考允许 Claude 在提供解决方案之前花更多时间推理复杂问题。

### 什么是扩展思考？

扩展思考是一种深思熟虑的、逐步的推理过程，Claude 会：
- 分解复杂问题
- 考虑多种方法
- 评估利弊
- 推理边缘情况

### 激活扩展思考

**键盘快捷键**：
- `Option + T`（macOS）/ `Alt + T`（Windows/Linux）- 切换扩展思考

**自动激活**：
- 对所有模型默认启用（Opus 4.8、Opus 4.7、Sonnet 4.6、Haiku 4.5）
- Opus 4.8：自适应推理，努力级别为：`low`（○）、`medium`（◐）、`high`（●）、`xhigh`、`max`。Opus 4.8（v2.1.154）、Opus 4.6 和 Sonnet 4.6 上的默认值为 `high`，Opus 4.7 上为 `xhigh`。`xhigh` 在 Opus 4.8 和 Opus 4.7 上可用（在 Opus 4.6 / Sonnet 4.6 上回退到 `high`）。`max` 在 Opus 4.8/4.7/4.6 和 Sonnet 4.6 上可用（仅会话级别）。Haiku 4.5 没有努力级别。Opus 4.8 和 Opus 4.7 拥有 100 万 token 的原生上下文窗口（100 万上下文修复已于 v2.1.117 落地——在此之前，`/context` 将 Opus 4.7 误算为 20 万窗口并触发过早的自动压缩）。自 v2.1.129 起，`/context` 仅在 UI 中显示其可视化内容；ASCII 可视化不再漏入对话上下文（每次调用节省约 1,600 token），因此 `/context` 可以放心随意调用。
- Opus 4.6 / Sonnet 4.6 上的 Pro/Max 订阅者：默认努力级别已从 v2.1.117 起从 `medium` 提升到 `high`。
- 其他模型：固定预算最高 31,999 token

**配置方法**：
- 切换：`Alt+T` / `Option+T`，或通过 `/config`
- 查看推理：`Ctrl+O`（详细模式）
- 设置努力级别：`/effort` 命令或 `--effort` 标志

**自定义预算**：
```bash
export MAX_THINKING_TOKENS=1024
```

**努力级别**（在 Opus 4.8、Opus 4.7、Opus 4.6 和 Sonnet 4.6 上支持——Haiku 4.5 不支持）：
```bash
export CLAUDE_CODE_EFFORT_LEVEL=high   # low (○), medium (◐), high (●), xhigh (Opus 4.8/4.7), 或 max —— Opus 4.8 上默认为 high
```

**CLI 标志**：
```bash
claude --effort high "complex architectural review"
```

**斜杠命令**：
```
/effort high
```

> **注意：** 提示中的关键词 "ultrathink" 会激活深度推理模式。努力级别 `low`、`medium`、`high` 和 `max` 在 Opus 4.8、Opus 4.7、Opus 4.6 和 Sonnet 4.6 上支持（Haiku 4.5 不支持任何努力级别）。`xhigh` 在 Opus 4.8 和 Opus 4.7 上可用。Opus 4.8（以及 Opus 4.6 / Sonnet 4.6）上的默认努力级别为 `high`，Opus 4.7 上为 `xhigh`。`/effort` 菜单还提供 `ultracode` 选项，它**不是**模型努力级别——它发送 `xhigh` 并让 Claude 编排动态工作流（仅会话级别）。

### 扩展思考的好处

- **深度推理**：花更多时间思考复杂问题
- **更好的架构决策**：通过全面评估做出明智选择
- **考虑边缘情况**：深入思考潜在问题和场景
- **彻底分析**：结构化的复杂问题解决方法

### 示例：架构决策

```
User: ultrathink Should we use microservices or a monolith for our e-commerce platform?

Claude: Let me think through this architectural decision carefully...

<extended_thinking>
## Context Analysis
- Team size: 5 developers
- Expected traffic: 10k daily users initially
- Need to scale to 100k+ users
- Limited DevOps resources
- 6-month timeline to MVP

## Approach 1: Microservices
Pros:
+ Independent scaling
+ Technology flexibility
+ Team independence
+ Fault isolation

Cons:
- Operational complexity
- Network overhead
- Distributed tracing needed
- Requires DevOps expertise
- Slower initial development

## Approach 2: Monolith
Pros:
+ Simpler deployment
+ Faster initial development
+ Easier debugging
+ Lower operational overhead
+ Single codebase

Cons:
- Scaling challenges later
- All-or-nothing deployments
- Technology lock-in
- Potential for tight coupling

## Decision Factors
1. Team size (5 devs) → Favors monolith
2. DevOps resources (limited) → Favors monolith
3. Timeline (6 months) → Favors monolith
4. Future scale (100k users) → Achievable with monolith + caching
5. Complexity budget → Limited

## Recommendation
Start with a **modular monolith**:
- Single deployment unit
- Clear module boundaries
- Clean interfaces between modules
- Prepare for future extraction to microservices if needed

This gives you:
✓ Fast initial development
✓ Low operational complexity
✓ Option to extract services later
✓ Clear architecture

Migration path: When you reach 50k+ users or specific modules need independent scaling, extract those modules into microservices.
</extended_thinking>

**Recommendation**: Implement a modular monolith with clean module boundaries.

This approach balances your current constraints (team size, timeline, DevOps resources) with future scalability needs. You can migrate specific modules to microservices later when there's a clear business need.
```

### 扩展思考配置

扩展思考通过环境变量、键盘快捷键和 CLI 标志进行控制：

```bash
# 设置思考 token 预算
export MAX_THINKING_TOKENS=16000

# 设置努力级别（Opus 4.8、Opus 4.7、Opus 4.6、Sonnet 4.6）：low (○), medium (◐), high (●), xhigh (Opus 4.8/4.7), 或 max —— Opus 4.8 上默认为 high
export CLAUDE_CODE_EFFORT_LEVEL=high
```

在会话中通过 `Alt+T` / `Option+T` 切换，通过 `/effort` 设置努力级别，或通过 `/config` 进行配置。

> **精简系统提示（v2.1.154）：** 精简系统提示现在是除 Haiku、Sonnet 和 Opus 4.7 及更早版本之外的所有模型的**默认**设置，减少了 Opus 4.8 上的基准 token 开销。

---

## 自动模式

自动模式是一种研究预览权限模式（2026 年 3 月发布），使用后台安全分类器在执行每个操作前进行审查。它允许 Claude 自主工作，同时阻止危险操作。

### 要求

- **计划**：Team、Enterprise 或 API（Pro 或 Max 计划上不可用）
- **模型**：Claude Sonnet 4.6 或 Opus 4.8
- **提供商**：仅限 Anthropic API（不支持 Bedrock、Vertex 或 Foundry）
- **分类器**：运行在 Claude Sonnet 4.6 上（会产生额外的 token 费用）

### 启用自动模式

```bash
# 通过 CLI 标志解锁自动模式（Max 订阅者在 Opus 4.7 上不再需要此标志——可直接访问）
claude --enable-auto-mode

# 然后在 REPL 中使用 Shift+Tab 切换到该模式
```

> **v2.1.112 更新**：自动模式不再需要 `--enable-auto-mode` 标志。Max 订阅者在 Opus 4.7 上直接访问。

> **v2.1.158 更新**：在 Bedrock、Vertex 和 Foundry 上，Opus 4.7/4.8 现在均可使用自动模式——通过设置 `CLAUDE_CODE_ENABLE_AUTO_MODE=1` **选择加入**。

或设置为默认权限模式：

```bash
claude --permission-mode auto
```

通过配置设置：
```json
{
  "permissions": {
    "defaultMode": "auto"
  }
}
```

### 分类器的工作原理

后台分类器按照以下决策顺序评估每个操作：

1. **允许/拒绝规则**——首先检查显式的权限规则
2. **只读/编辑自动批准**——文件读取和编辑自动通过
3. **分类器**——后台分类器审查操作
4. **回退**——连续 3 次或累计 20 次分类器阻止后回退到提示用户

### 默认阻止的操作

默认情况下，自动模式阻止以下操作：

| 阻止的操作 | 示例 |
|----------------|---------|
| 管道安装到 shell | `curl \| bash` |
| 向外部发送敏感数据 | 通过网络传输 API 密钥、凭证 |
| 生产环境部署 | 针对生产环境的部署命令 |
| 大量删除 | 在大型目录上执行 `rm -rf` |
| IAM 更改 | 权限和角色修改 |
| 强制推送到 main | `git push --force origin main` |

### 默认允许的操作

| 允许的操作 | 示例 |
|----------------|---------|
| 本地文件操作 | 读取、写入、编辑项目文件 |
| 声明的依赖安装 | 根据清单进行 `npm install`、`pip install` |
| 只读 HTTP | 用于获取文档的 `curl` |
| 推送到当前分支 | `git push origin feature-branch` |

### 配置自动模式

**以 JSON 格式打印默认规则**：
```bash
claude auto-mode defaults
```

**通过企业部署的 `autoMode.environment` 托管设置配置可信基础设施**。这允许管理员定义可信的 CI/CD 环境、部署目标和基础设施模式。

#### 使用 `"$defaults"` 扩展默认值（v2.1.118）

自 v2.1.118 起，`autoMode.allow`、`autoMode.soft_deny` 和 `autoMode.environment` 接受 `"$defaults"` 标记，该标记将您的规则**追加**到内置列表，而不是替换它。在 v2.1.118 之前，任何用户定义的数组都会静默覆盖内置规则。

#### 使用 `autoMode.hard_deny` 实现无条件拦截（v2.1.136）

`autoMode.hard_deny`（v2.1.136+）是一个分类器规则数组，用于阻止某类操作，**无论推断的用户意图如何**。用于在自动模式下绝对不能执行的操作——例如，在根路径上的 `rm -rf` 或在受保护分支上的 `git push --force`。与 `soft_deny` 不同，hard-deny 规则不可由分类器协商。

```json
{
  "autoMode": {
    "hard_deny": ["Bash(rm -rf /:*)", "Bash(git push --force*)"]
  }
}
```

**之前（替换内置规则——v2.1.118 之前的行为）：**

```json
{
  "autoMode": {
    "allow": ["Bash(gh pr list:*)"]
  }
}
```

**之后（扩展内置规则——v2.1.118+）：**

```json
{
  "autoMode": {
    "allow": ["$defaults", "Bash(gh pr list:*)"],
    "soft_deny": ["$defaults", "Bash(kubectl delete:*)"],
    "environment": ["$defaults", "trusted-ci.internal"]
  }
}
```

使用 `"$defaults"` 可以在保留内置基线规则的同时，叠加组织或项目特定的补充规则。

### 回退行为

当分类器不确定时，自动模式回退到提示用户：
- 会话中**连续 3 次**分类器阻止后
- 会话中**累计 20 次**分类器阻止后

这确保用户在分类器无法自信地批准操作时始终保留控制权。

### 播种等效自动模式权限（无需 Team 计划）

如果您没有 Team 计划，或希望采用更简单的方式而不使用后台分类器，您可以为一个保守的安全权限规则基线播种您的 `~/.claude/settings.json`。脚本从只读和本地检查规则开始，然后让您根据需要选择加入编辑、测试、本地 Git 写入、包安装和 GitHub 写入操作。

**文件：** `09-advanced-features/setup-auto-mode-permissions.py`

```bash
# 预览将要添加的内容（不写入更改）
python3 09-advanced-features/setup-auto-mode-permissions.py --dry-run

# 应用保守的基线
python3 09-advanced-features/setup-auto-mode-permissions.py

# 仅在需要时添加更多功能
python3 09-advanced-features/setup-auto-mode-permissions.py --include-edits --include-tests
python3 09-advanced-features/setup-auto-mode-permissions.py --include-git-write --include-packages
```

该脚本按以下类别添加规则：

| 类别 | 示例 |
|----------|---------|
| 核心只读工具 | `Read(*)`、`Glob(*)`、`Grep(*)`、`Agent(*)`、`WebSearch(*)`、`WebFetch(*)` |
| 本地检查 | `Bash(git status:*)`、`Bash(git log:*)`、`Bash(git diff:*)`、`Bash(cat:*)` |
| 可选编辑 | `Edit(*)`、`Write(*)`、`NotebookEdit(*)` |
| 可选测试/构建 | `Bash(pytest:*)`、`Bash(python3 -m pytest:*)`、`Bash(cargo test:*)` |
| 可选 Git 写入 | `Bash(git add:*)`、`Bash(git commit:*)`、`Bash(git stash:*)` |
| Git（本地写入） | `Bash(git add:*)`、`Bash(git commit:*)`、`Bash(git checkout:*)` |
| 包管理器 | `Bash(npm install:*)`、`Bash(pip install:*)`、`Bash(cargo build:*)` |
| 构建与测试 | `Bash(make:*)`、`Bash(pytest:*)`、`Bash(go test:*)` |
| 常用 Shell | `Bash(ls:*)`、`Bash(cat:*)`、`Bash(find:*)`、`Bash(cp:*)`、`Bash(mv:*)` |
| GitHub CLI | `Bash(gh pr view:*)`、`Bash(gh pr create:*)`、`Bash(gh issue list:*)` |

危险操作（`rm -rf`、`sudo`、强制推送、`DROP TABLE`、`terraform destroy` 等）被有意排除。该脚本是幂等的——运行两次不会重复规则。

---

## 后台任务

后台任务允许长时间运行的操作在不阻塞对话的情况下执行。

### 什么是后台任务？

后台任务在您继续工作时异步运行：
- 长时间运行的测试套件
- 构建过程
- 数据库迁移
- 部署脚本
- 分析工具

**基本用法：**
```bash
User: Run tests in background

Claude: Started task bg-1234

/task list           # 显示所有任务
/task status bg-1234 # 检查进度
/task show bg-1234   # 查看输出
/task cancel bg-1234 # 取消任务
```

### 启动后台任务

```
User: Run the full test suite in the background

Claude: Starting tests in background (task-id: bg-1234)
You can continue working while tests run.

[您可以继续对话]

User: Meanwhile, let's refactor the auth module

Claude: [在测试后台运行的同时处理 auth 模块]

[稍后，测试完成后]

Claude: 📢 Background task bg-1234 completed:
✅ 245 tests passed
❌ 3 tests failed
View results: /task show bg-1234
```

### 管理后台任务

**列出活动任务**：
```
User: /task list

Active background tasks:
1. [bg-1234] Running tests (50% complete, 2min remaining)
2. [bg-1235] Building Docker image (25% complete, 8min remaining)
3. [bg-1236] Deploying to staging (90% complete, 30sec remaining)
```

**检查任务状态**：
```
User: /task status bg-1234

Task bg-1234: Running tests
Status: In progress
Progress: 120/245 tests (49%)
Started: 2025-11-08 10:30:15
Estimated completion: 2025-11-08 10:34:22
```

**查看任务输出**：
```
User: /task show bg-1234

[显示测试运行的实时输出]
```

**取消任务**：
```
User: /task cancel bg-1234

Cancelled background task bg-1234
```

### 示例：并行开发

```
User: Run the build in the background

Claude: Starting build... (task-id: bg-5001)

User: Also run the linter in background

Claude: Starting linter... (task-id: bg-5002)

User: While those run, let's implement the new API endpoint

Claude: [在构建和代码检查后台运行的同时实现 API 端点]

[10 分钟后]

Claude: 📢 Build completed successfully (bg-5001)
📢 Linter found 12 issues (bg-5002)

User: Show me the linter issues

Claude: [显示 bg-5002 的代码检查输出]
```

### 配置

```json
{
  "backgroundTasks": {
    "enabled": true,
    "maxConcurrentTasks": 5,
    "notifyOnCompletion": true,
    "autoCleanup": true,
    "logOutput": true
  }
}
```

---

## Monitor 工具（事件驱动流）

> **v2.1.98 新增**：Monitor 工具让 Claude 监控后台命令的标准输出，并在匹配事件出现时立即做出反应——替代了等待长时间运行进程的轮询循环和 `sleep`。

Monitor 附加到任何写入 stdout 的 shell 命令。命令的每一行 stdout 输出都会成为唤醒会话的通知。Claude 指定命令；系统框架流式传输输出并在事件触发时传递。有关启动底层进程，请参阅相关的[后台任务](#后台任务)部分。

### 为什么重要

使用 `/loop` 或 `sleep` 进行轮询，每次循环都会产生完整的 API 往返，无论是否有变化。Monitor 保持静默直到事件触发，在命令无输出时消耗**零 token**。当事件确实发生时，Claude 立即做出反应——不会因等待下一次轮询而延迟发现。对于运行超过几分钟的任何任务，这比轮询循环更便宜、更快。

### 两种常见模式

**流过滤器**监控来自长期运行来源的连续输出。命令永远运行；每个匹配行都是一个事件。

```bash
tail -f /var/log/app.log | grep --line-buffered "ERROR"
```

**轮询-发出过滤器**定期检查来源，仅在发生变化时发出。用于 API、数据库或任何没有原生流的数据源。

```bash
last=$(date -u +%Y-%m-%dT%H:%M:%SZ)
while true; do
  gh api "repos/owner/repo/issues/123/comments?since=$last" || true
  last=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  sleep 30
done
```

### 具体示例

"启动我的开发服务器并监控错误。" Claude 将服务器作为后台任务启动，附加一个 Monitor 过滤器（`tail -F server.log | grep --line-buffered -E "ERROR|FATAL"`），然后会话进入静默状态。当日志中出现错误行时，Claude 立即被唤醒，读取错误，并可以做出反应——重启服务器、修复 bug，或向您展示——无需您手动检查。

> **警告**：当通过管道输入 `grep` 时，**始终**使用 `grep --line-buffered`。如果不加此标志，grep 会以 4KB 块缓冲 stdout，在低流量流上可能延迟事件数分钟。这是 Monitor 在实践中最常见的问题——如果您的过滤器似乎无响应但应该有输出，首先检查 `--line-buffered` 标志。

---

## 动态工作流

> **v2.1.154 新增**

动态工作流让 Claude **确定性地**编排数十到数百个后台[子代理](../04-subagents/README.md)——通过脚本编码展开、管道和并行阶段，而非留给模型即兴发挥。单个代理仅持有一个上下文窗口，而工作流将任务分解到多个代理并重组其结果。

### 何时使用

- **全面覆盖**——跨多个文件/维度并行审计或审查。
- **高置信度**——生成独立视角，然后在提交前对抗性验证发现。
- **超越单个上下文的规模**——单个上下文无法容纳的大型迁移、广泛扫描或研究。

对于您已经理解的单次任务，单个代理（或直接编辑）仍然是正确的工具——当工作需要展开时，工作流才会体现其价值。

### 启动和查看

- **启动**：要求 Claude 为任务创建工作流（例如"run a workflow to review every file in `src/`"）。Claude 编写编排脚本并在后台运行。
- **查看**：`/workflows` 命令显示正在运行和已完成的工作流运行及其实时进度。
- **`ultracode`**：在 `/effort` 菜单中选择 `ultracode` 可为当前会话启用此功能——它向模型发送 `xhigh`，**并**让 Claude 默认编排动态工作流。它是会话级别功能，不在设置文件中接受。（截至 v2.1.160，触发关键词是 `ultracode`；裸词"workflow"不再触发运行。）

工作流建立在子代理模型之上——有关如何定义和限定单个代理，请参阅[子代理](../04-subagents/README.md)。

---

## 计划任务

计划任务允许您按循环计划或作为一次性提醒自动运行提示。任务是会话范围的——它们在 Claude Code 活动期间运行，会话结束时清除。自 v2.1.72+ 起可用。

> **在 claude.com 上以"Routines"（例程）命名（2026-05-14）**：Anthropic 的产品博客将此功能介绍为 **Routines**。CLI 命令保持为 `/schedule`；本指南沿用原始的"计划任务"命名以保持连续性。如果您在 claude.com 文档或桌面应用中看到"Routines"，它指的是同一功能。

### `/loop` 命令

```bash
# 显式间隔
/loop 5m check if the deployment finished

# 自然语言
/loop check build status every 30 minutes
```

标准 5 字段 cron 表达式也支持精确调度。

### 一次性提醒

设置在特定时间触发一次的提醒：

```
remind me at 3pm to push the release branch
in 45 minutes, run the integration tests
```

### 管理计划任务

| 工具 | 描述 |
|------|-------------|
| `CronCreate` | 创建新的计划任务 |
| `CronList` | 列出所有活动的计划任务。自 v2.1.136 起，输出还包括限定词和计划提示正文，以便您可以审计每个 cron 将运行什么，而无需打开它。 |
| `CronDelete` | 删除计划任务 |

**限制和行为**：
- 每个会话最多 **50 个计划任务**
- 会话范围——会话结束时清除
- 循环任务在 **3 天**后自动过期
- 任务仅在 Claude Code 运行时触发——不会补发错过的触发

### 行为详情

| 方面 | 详情 |
|--------|--------|
| **循环抖动** | 最多为间隔的 10%（最大 15 分钟） |
| **一次性抖动** | 在 :00/:30 边界上最多 90 秒 |
| **错过的触发** | 不补发——如果 Claude Code 未运行则跳过 |
| **持久性** | 不会随重启持久化 |

### 云端计划任务

使用 `/schedule` 创建在 Anthropic 基础设施上运行的云端计划任务：

```
/schedule daily at 9am run the test suite and report failures
```

云端计划任务在重启后持续存在，不需要 Claude Code 在本地运行。

### 禁用计划任务

```bash
export CLAUDE_CODE_DISABLE_CRON=1
```

> **API 密钥层级自动禁用 `/schedule`（v2.1.139）**：当 `ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN` 或 `apiKeyHelper` 中的任何一个被设置时——即使您同时使用 claude.ai 登录——云端 `/schedule` 将静默不可用。同样的条件也会禁用[远程控制](#禁用远程控制-disableremotecontrol-v21128)、claude.ai MCP 连接器和通知偏好设置。取消设置 API 密钥（或在 Pro/Max OAuth 层级运行）以使用 `/schedule`。本地的 `CronCreate` 不受影响。

### 示例：监控部署

```
/loop 5m check the deployment status of the staging environment.
        If the deploy succeeded, notify me and stop looping.
        If it failed, show the error logs.
```

> **提示**：计划任务是会话范围的。对于需要跨重启持久化的自动化，请改用 CI/CD 流水线、GitHub Actions 或桌面应用的计划任务。

---

## 权限模式

权限模式控制 Claude 可以无需明确批准就执行哪些操作。

### 可用的权限模式

| 模式 | 行为 |
|---|---|
| `default` | 仅读取文件；所有其他操作需要提示确认 |
| `acceptEdits` | 读取和编辑文件；命令需要提示确认 |
| `plan` | 仅读取文件（研究模式，不进行编辑） |
| `auto` | 所有操作经过后台安全分类器检查（研究预览） |
| `bypassPermissions` | 所有操作，无权限检查（危险） |
| `dontAsk` | 仅执行预先批准的工具；所有其他操作被拒绝 |

在 CLI 中使用 `Shift+Tab` 循环切换模式。使用 `--permission-mode` 标志或 `permissions.defaultMode` 设置来设置默认值。

自 v2.1.160 起，即使是 `acceptEdits` 模式在写入 shell 启动文件（`.zshenv`、`.zlogin`、`.bash_login`、`~/.config/git/`）和会执行代码的构建配置文件（`.npmrc`、`.yarnrc*`、`bunfig.toml`、`.bazelrc`、`.pre-commit-config.yaml`、`.devcontainer/` 等）之前也会提示确认，否则可能导致意外的命令执行。

> **`--dangerously-skip-permissions` 扩展路径覆盖（v2.1.121、v2.1.126）**：`--dangerously-skip-permissions` CLI 标志（以及等效的 `bypassPermissions` 模式）现在绕过对更广泛允许列表的写入提示——`.claude/skills/`、`.claude/agents/`、`.claude/commands/`、`.claude/`、`.git/`、`.vscode/` 和 shell 配置文件。灾难性删除命令（`rm -rf /` 等）无论何种模式仍然会提示确认。请将该标志视为比以前更锋利的工具；仅在一次性沙箱中使用。

> **Windows Shell 检测（v2.1.120、v2.1.126）**：不再强制要求 Git for Windows / Git Bash。当 Git Bash 不存在时，Claude Code 使用 PowerShell 作为 Shell 工具。从 v2.1.126 起，当 PowerShell 工具启用时，PowerShell 是*主要* Shell，检测覆盖通过 Microsoft Store 安装、无 PATH 的 MSI 安装或作为 `.NET 全局工具` 安装的 PowerShell 7。

> **Windows 上 Bedrock/Vertex/Foundry 的 PowerShell 工具默认启用（v2.1.143）**：自 v2.1.143 起，PowerShell 工具在 Windows 上对 Bedrock、Vertex 和 Foundry 用户**默认启用**。Claude Code 使用 `-ExecutionPolicy Bypass` 调用 PowerShell，因此即使系统策略为 `Restricted`，脚本也能运行。要使 Claude Code 遵守系统执行策略，请设置 `CLAUDE_CODE_POWERSHELL_RESPECT_EXECUTION_POLICY=1`。要完全禁用 PowerShell 工具，请设置 `CLAUDE_CODE_USE_POWERSHELL_TOOL=0`。

### 激活方式

**键盘快捷键**：
```bash
Shift + Tab  # 循环切换所有 6 种模式
```

**斜杠命令**：
```bash
/plan                  # 进入规划模式
```

**CLI 标志**：
```bash
claude --permission-mode plan
claude --permission-mode auto
```

**设置**：
```json
{
  "permissions": {
    "defaultMode": "auto"
  }
}
```

### 权限模式示例

#### 默认模式
Claude 在重要操作前请求确认：

```
User: Fix the bug in auth.ts

Claude: I need to modify src/auth.ts to fix the bug.
The change will update the password validation logic.

Approve this change? (yes/no/show)
```

#### 规划模式
在执行前审查实现计划：

```
User: /plan Implement user authentication system

Claude: I'll create a plan for implementing authentication.

## Implementation Plan
[包含阶段和步骤的详细计划]

Ready to proceed? (yes/no/modify)
```

#### 接受编辑模式
自动接受文件修改：

```
User: acceptEdits
User: Fix the bug in auth.ts

Claude: [不询问直接进行更改]
```

### 使用场景

**代码审查**：
```
User: claude --permission-mode plan
User: Review this PR and suggest improvements

Claude: [读取代码，提供反馈，但不能修改]
```

**结对编程**：
```
User: claude --permission-mode default
User: Let's implement the feature together

Claude: [每次更改前请求批准]
```

**自动化任务**：
```
User: claude --permission-mode acceptEdits
User: Fix all linting issues in the codebase

Claude: [自动接受文件编辑而不询问]
```

---

## 无界面模式

打印模式（`claude -p`）允许 Claude Code 在无交互输入的情况下运行，非常适合自动化和 CI/CD。这是非交互模式，取代了旧的 `--headless` 标志。

### 什么是打印模式？

打印模式支持：
- 自动化脚本执行
- CI/CD 集成
- 批处理
- 计划任务

### 在打印模式（非交互式）下运行

```bash
# 运行特定任务
claude -p "Run all tests"

# 处理管道内容
cat error.log | claude -p "Analyze these errors"

# CI/CD 集成（GitHub Actions）
- name: AI Code Review
  run: claude -p "Review PR"
```

### 更多打印模式使用示例

```bash
# 运行特定任务并捕获输出
claude -p "Run all tests and generate coverage report"

# 使用结构化输出
claude -p --output-format json "Analyze code quality"

# 从标准输入获取输入
echo "Analyze code quality" | claude -p "explain this"
```

### 示例：CI/CD 集成

**GitHub Actions**：
```yaml
# .github/workflows/code-review.yml
name: AI Code Review

on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install Claude Code
        run: npm install -g @anthropic-ai/claude-code

      - name: Run Claude Code Review
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude -p --output-format json \
            --max-turns 3 \
            "Review this PR for:
            - Code quality issues
            - Security vulnerabilities
            - Performance concerns
            - Test coverage
            Output results as JSON" > review.json

      - name: Post Review Comment
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const review = JSON.parse(fs.readFileSync('review.json', 'utf8'));
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: JSON.stringify(review, null, 2)
            });
```

### 打印模式配置

打印模式（`claude -p`）支持多个用于自动化的标志：

```bash
# 限制自主轮次
claude -p --max-turns 5 "refactor this module"

# 结构化 JSON 输出
claude -p --output-format json "analyze this codebase"

# 带 Schema 验证
claude -p --json-schema '{"type":"object","properties":{"issues":{"type":"array"}}}' \
  "find bugs in this code"

# 禁用会话持久化
claude -p --no-session-persistence "one-off analysis"
```

---

## 会话管理

有效管理多个 Claude Code 会话。

### 会话管理命令

| 命令 | 描述 |
|---------|-------------|
| `/resume` | 通过 ID 或名称恢复对话 |
| `/rename` | 为当前会话命名 |
| `/fork` | 将当前会话分支到新分支 |
| `claude -c` | 继续最近的对话 |
| `claude -r "session"` | 通过名称或 ID 恢复会话 |

### 恢复会话

**继续上一次对话**：
```bash
claude -c
```

**恢复已命名会话**：
```bash
claude -r "auth-refactor" "finish this PR"
```

**重命名当前会话**（在 REPL 中）：
```
/rename auth-refactor
```

### 分支会话

分支会话以尝试替代方案而不丢失原始会话：

```
/fork
```

或从 CLI：
```bash
claude --resume auth-refactor --fork-session "try OAuth instead"
```

### 会话持久化

会话自动保存并可以恢复：

```bash
# 继续上一次对话
claude -c

# 通过名称或 ID 恢复特定会话
claude -r "auth-refactor"

# 恢复并分支以进行实验
claude --resume auth-refactor --fork-session "alternative approach"
```

### 会话回顾（v2.1.108）

当您离开一段时间后返回会话时，Claude 可以显示已完成工作的简要回顾。此功能默认为禁用遥测的用户（Bedrock、Vertex、Foundry 用户）启用。

> **OTEL 遥测——重新启用反馈调查（v2.1.136+）**：捕获 OpenTelemetry 数据的组织可以通过设置 `CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL=1` 重新启用 Anthropic 的会话质量调查。该调查在 OTEL 部署中默认关闭，因为之前已从遥测管道重定向。

**控制回顾行为：**

```bash
/recap                                 # 手动触发回顾
/config                                # 切换自动回顾开/关
```

或通过环境变量：
```bash
CLAUDE_CODE_ENABLE_AWAY_SUMMARY=0 claude   # 禁用回顾
CLAUDE_CODE_ENABLE_AWAY_SUMMARY=1 claude   # 强制启用回顾
```

---

## 交互功能

### 键盘快捷键

Claude Code 支持键盘快捷键以提高效率。以下是官方文档中的完整参考：

| 快捷键 | 描述 |
|----------|-------------|
| `Ctrl+C` | 取消当前输入/生成 |
| `Ctrl+D` | 退出 Claude Code |
| `Ctrl+G` | 在外部编辑器中编辑计划 |
| `Ctrl+L` | 清除终端屏幕 |
| `Ctrl+O` | 切换详细输出（查看推理过程） |
| `Ctrl+R` | 反向搜索历史。默认为**所有项目中的所有提示**（v2.1.129+）；在选择器中按 `Ctrl+S` 可缩小到当前项目。早期版本默认为仅项目内。 |
| `Ctrl+T` | 切换任务列表视图 |
| `Ctrl+B` | 后台运行任务 |
| `Esc+Esc` | 回退代码/对话 |
| `Shift+Tab` / `Alt+M` | 切换权限模式 |
| `Option+P` / `Alt+P` | 切换模型 |
| `Option+T` / `Alt+T` | 切换扩展思考 |

**行编辑（标准 readline 快捷键）：**

| 快捷键 | 操作 |
|----------|--------|
| `Ctrl + A` | 移动到行首 |
| `Ctrl + E` | 移动到行尾 |
| `Ctrl + K` | 剪切到行尾 |
| `Ctrl + U` | 剪切到行首 |
| `Ctrl + W` | 向前删除一个词 |
| `Ctrl + Y` | 粘贴（拖出） |
| `Tab` | 自动补全 |
| `↑ / ↓` | 命令历史 |

### 自定义键绑定

运行 `/keybindings` 创建自定义键盘快捷键，该命令会打开 `~/.claude/keybindings.json` 进行编辑（v2.1.18+）。

**配置格式**：

```json
{
  "$schema": "https://www.schemastore.org/claude-code-keybindings.json",
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "ctrl+e": "chat:externalEditor",
        "ctrl+u": null,
        "ctrl+k ctrl+s": "chat:stash"
      }
    },
    {
      "context": "Confirmation",
      "bindings": {
        "ctrl+a": "confirmation:yes"
      }
    }
  ]
}
```

将绑定设为 `null` 以解除默认快捷键。

### 可用上下文

键绑定按特定 UI 上下文限定范围：

| 上下文 | 关键操作 |
|---------|-------------|
| **Chat** | `submit`、`cancel`、`cycleMode`、`modelPicker`、`thinkingToggle`、`undo`、`externalEditor`、`stash`、`imagePaste` |
| **Confirmation** | `yes`、`no`、`previous`、`next`、`nextField`、`cycleMode`、`toggleExplanation` |
| **Global** | `interrupt`、`exit`、`toggleTodos`、`toggleTranscript` |
| **Autocomplete** | `accept`、`dismiss`、`next`、`previous` |
| **HistorySearch** | `search`、`previous`、`next` |
| **Settings** | 上下文相关的设置导航 |
| **Tabs** | 标签页切换和管理 |
| **Help** | 帮助面板导航 |

共有 18 种上下文，包括 `Transcript`、`Task`、`ThemePicker`、`Attachments`、`Footer`、`MessageSelector`、`DiffDialog`、`ModelPicker` 和 `Select`。

### 和弦键支持

键绑定支持和弦序列（多键组合）：

```
"ctrl+k ctrl+s"   → 两键序列：按 ctrl+k，然后按 ctrl+s
"ctrl+shift+p"    → 同时按下修饰键
```

**键击语法**：
- **修饰键**：`ctrl`、`alt`（或 `opt`）、`shift`、`meta`（或 `cmd`）
- **大写表示 Shift**：`K` 等同于 `shift+k`
- **特殊键**：`escape`、`enter`、`return`、`tab`、`space`、`backspace`、`delete`、箭头键

### 保留键和冲突键

| 键 | 状态 | 备注 |
|-----|--------|-------|
| `Ctrl+C` | 保留 | 不能重新绑定（中断） |
| `Ctrl+D` | 保留 | 不能重新绑定（退出） |
| `Ctrl+B` | 终端冲突 | tmux 前缀键 |
| `Ctrl+A` | 终端冲突 | GNU Screen 前缀键 |
| `Ctrl+Z` | 终端冲突 | 进程挂起 |

> **提示**：如果快捷键不起作用，请检查是否与您的终端模拟器或多路复用器冲突。

### Tab 补全

Claude Code 提供智能 Tab 补全：

```
User: /rew<TAB>
→ /rewind

User: /plu<TAB>
→ /plugin

User: /plugin <TAB>
→ /plugin install
→ /plugin enable
→ /plugin disable
```

### 命令历史

访问之前的命令：

```
User: <↑>  # 上一条命令
User: <↓>  # 下一条命令
User: Ctrl+R  # 搜索历史

(reverse-i-search)`test': run all tests
```

### 多行输入

对于复杂查询，使用多行模式：

```bash
User: \
> Long complex prompt
> spanning multiple lines
> \end
```

**示例：**

```
User: \
> Implement a user authentication system
> with the following requirements:
> - JWT tokens
> - Email verification
> - Password reset
> - 2FA support
> \end

Claude: [处理多行请求]
```

### 行内编辑

在发送前编辑命令：

```
User: Deploy to prodcution<Backspace><Backspace>uction

[在发送前就地编辑]
```

### Vim 模式

启用 Vi/Vim 键绑定进行文本编辑：

**激活**：
- 通过 `/config`（切换"Editor / Vim mode"）或在 `~/.claude/settings.json` 中设置 `editorMode: "vim"` 来启用。独立的 `/vim` 斜杠命令已被移除（参见 [issue #43370](https://github.com/anthropics/claude-code/issues/43370)）；vim 模式现在由配置驱动。
- 使用 `Esc` 切换到 NORMAL 模式，`i/a/o` 切换到 INSERT 模式，`v` 切换到 VISUAL 模式，`V` 切换到 VISUAL-LINE 模式（v2.1.118+）

**导航键**：
- `h` / `l` - 向左/向右移动
- `j` / `k` - 向下/向上移动
- `w` / `b` / `e` - 按单词移动
- `0` / `$` - 移动到行首/行尾
- `gg` / `G` - 跳转到文本开头/末尾

**文本对象**：
- `iw` / `aw` - 单词内部/周围
- `i"` / `a"` - 引号字符串内部/周围
- `i(` / `a(` - 括号内部/周围

**可视模式（v2.1.118+）**：

| 键 | 模式 | 行为 |
|-----|------|----------|
| `v` | 可视模式 | 逐字选择，带视觉反馈；使用移动键扩展选择 |
| `V` | 可视行模式 | 逐行选择；始终选择整行 |
| `y` | 复制 | 复制当前可视选择 |
| `d` / `x` | 删除 | 删除当前可视选择 |
| `c` | 更改 | 删除选择并进入 INSERT 模式 |
| `Esc` | 退出 | 返回 NORMAL 模式 |

可视选择在输入字段中高亮显示，因此您可以在提交操作之前看到将要复制、删除或更改的确切内容。

### Bash 模式

使用 `!` 前缀直接执行 shell 命令：

```bash
! npm test
! git status
! cat src/index.js
```

用于快速执行命令而无需切换上下文。

---

## TUI 模式（全屏）

> **v2.1.110 新增**

TUI（文本用户界面）模式以全屏方式渲染 Claude Code，输出无闪烁——非常适合 tmux 或 iTerm2 分割窗格等终端多路复用器。

### 启用 TUI 模式

使用 `/tui` 命令切换 TUI 模式，或使用 `--tui` 标志启动：

```bash
/tui          # 在会话中切换
claude --tui  # 直接以 TUI 模式启动
```

### 配置

| 设置 | 描述 | 默认值 |
|---------|-------------|---------|
| `autoScrollEnabled` | 自动滚动到最新消息 | `true` |

通过 `/config` 或 `settings.json` 禁用自动滚动：

```json
{
  "autoScrollEnabled": false
}
```

### 专注视图

`/focus` 命令切换专注视图——一种无干扰的显示方式，仅显示最相关的输出。`Ctrl+O` 现在仅在普通和详细记录之间切换（专注视图通过 `/focus` 控制）。

---

## 语音输入

语音输入为 Claude Code 提供按住通话式语音输入，允许您说出提示而不必键入。

### 激活语音输入

```
/voice
```

### 功能

| 功能 | 描述 |
|---------|-------------|
| **按住通话** | 按住键录音，松开发送 |
| **20 种语言** | 语音转文字支持 20 种语言 |
| **自定义键绑定** | 通过 `/keybindings` 配置按住通话键 |
| **账户要求** | 需要 Claude.ai 账户进行语音转文字处理 |

### 配置

在键绑定文件（`/keybindings`）中自定义按住通话键绑定。语音输入使用您的 Claude.ai 账户进行语音转文字处理。

---

## 通道

通道是一项研究预览功能，通过 MCP 服务器将外部服务的事件推送到运行中的 Claude Code 会话。来源包括 Telegram、Discord、iMessage 和任意 webhook，使 Claude 能够在无需轮询的情况下响应实时通知。

> **认证（v2.1.128+）**：`--channels` 现在同时支持 Pro/Max OAuth **和** API 密钥（控制台）认证。早期版本要求 OAuth。

### 订阅通道

```bash
# 在启动时订阅通道插件
claude --channels discord,telegram

# 订阅多个来源
claude --channels discord,telegram,imessage,webhooks
```

### 支持的集成

| 集成 | 描述 |
|-------------|-------------|
| **Discord** | 在会话中接收和回复 Discord 消息 |
| **Telegram** | 在会话中接收和回复 Telegram 消息 |
| **iMessage** | 在会话中接收 iMessage 通知 |
| **Webhooks** | 从任意 webhook 来源接收事件 |

### 配置

在启动时使用 `--channels` 标志配置通道。对于企业部署，使用托管设置控制允许哪些通道插件：

```json
{
  "allowedChannelPlugins": ["discord", "telegram"]
}
```

`allowedChannelPlugins` 托管设置控制组织中允许哪些通道插件。

### 工作原理

1. MCP 服务器作为通道插件连接到外部服务
2. 传入的消息和事件被推送到活动的 Claude Code 会话中
3. Claude 可以在会话上下文中读取和回复消息
4. 通道插件必须通过 `allowedChannelPlugins` 托管设置获得批准
5. 无需轮询——事件实时推送

---

## Chrome 集成

Chrome 集成将 Claude Code 连接到您的 Chrome 或 Microsoft Edge 浏览器，用于实时 Web 自动化和调试。这是一项测试版功能，自 v2.0.73+ 起可用（Edge 支持在 v1.0.36+ 中添加）。

### 启用 Chrome 集成

**启动时**：

```bash
claude --chrome      # 启用 Chrome 连接
claude --no-chrome   # 禁用 Chrome 连接
```

**在会话中**：

```
/chrome
```

选择"默认启用"以激活所有未来会话的 Chrome 集成。Claude Code 共享您浏览器的登录状态，因此它可以与已认证的 Web 应用交互。

### 功能

| 功能 | 描述 |
|------------|-------------|
| **实时调试** | 读取控制台日志、检查 DOM 元素、实时调试 JavaScript |
| **设计验证** | 将渲染页面与设计稿进行比较 |
| **表单验证** | 测试表单提交、输入验证和错误处理 |
| **Web 应用测试** | 与已认证的应用（Gmail、Google Docs、Notion 等）交互 |
| **数据提取** | 从网页抓取和处理内容 |
| **会话录制** | 将浏览器交互录制为 GIF 文件 |

### 站点级权限

Chrome 扩展管理每个站点的访问权限。您可以随时通过扩展弹出窗口授予或撤销特定站点的访问权限。Claude Code 仅与您明确允许的站点交互。

### 工作原理

Claude Code 在可见窗口中控制浏览器——您可以实时观看操作。当浏览器遇到登录页面或 CAPTCHA 时，Claude 会暂停并等待您手动处理后再继续。

### 已知限制

- **浏览器支持**：仅支持 Chrome 和 Edge——不支持 Brave、Arc 和其他基于 Chromium 的浏览器
- **WSL**：在 Windows Subsystem for Linux 中不可用
- **第三方提供商**：不支持 Bedrock、Vertex 或 Foundry API 提供商
- **Service Worker 空闲**：Chrome 扩展的 Service Worker 可能在长时间会话期间进入空闲状态

> **提示**：Chrome 集成是测试版功能。浏览器支持可能在未来的版本中扩展。

---

## 远程控制

远程控制允许您从手机、平板电脑或任何浏览器继续控制本地运行的 Claude Code 会话。您的本地会话在您自己的机器上继续运行——不会移动到云端。适用于 Pro、Max、Team 和 Enterprise 计划（v2.1.51+）。

### 启动远程控制

**从 CLI**：

```bash
# 使用默认会话名称启动
claude remote-control

# 使用自定义名称启动
claude remote-control --name "Auth Refactor"
```

**在会话中**：

```
/remote-control
/remote-control "Auth Refactor"
```

**可用标志**：

| 标志 | 描述 |
|------|-------------|
| `--name "title"` | 自定义会话标题以便识别 |
| `--verbose` | 显示详细的连接日志 |
| `--sandbox` | 启用文件系统和网络隔离 |
| `--no-sandbox` | 禁用沙箱（默认） |

### 连接到会话

从其他设备连接的三种方式：

1. **会话 URL**——会话启动时打印在终端中；可在任何浏览器中打开
2. **二维码**——启动后按 `空格键` 显示可扫描的二维码
3. **按名称查找**——在 claude.ai/code 或 Claude 移动应用（iOS/Android）中浏览您的会话

### 安全性

- **不开放入站端口**到您的机器
- **仅出站 HTTPS**，通过 TLS 加密
- **范围凭证**——多个短期、范围狭窄的 token
- **会话隔离**——每个远程会话是独立的

### 远程控制与 Claude Code on the web

| 方面 | 远程控制 | Claude Code on Web |
|--------|---------------|-------------------|
| **执行** | 在您的机器上运行 | 在 Anthropic 云端运行 |
| **本地工具** | 完全访问本地 MCP 服务器、文件和 CLI | 无本地依赖 |
| **使用场景** | 从其他设备继续本地工作 | 从任何浏览器全新开始 |

### 限制

- 每个 Claude Code 实例一个远程会话
- 主机上的终端必须保持打开
- 如果网络不可达，会话约 10 分钟后超时

### 使用场景

- 在离开办公桌时从移动设备或平板电脑控制 Claude Code
- 在保持本地工具执行的同时使用更丰富的 claude.ai 界面
- 在移动中快速进行代码审查，使用完整的本地开发环境

### 推送通知（v2.1.110）

当远程控制处于活动状态且 `/config` 中启用了"Push when Claude decides"（Claude 决定时推送）时，Claude 可以向您的手机发送移动推送通知——例如，当耗时较长的任务完成或需要您的输入时。

启用方法：
1. 激活远程控制：`/remote-control` 或 `claude --rc`
2. 打开 `/config` 并启用 **Push when Claude decides**（Claude 决定时推送）

推送通知需要 Claude 订阅和 Claude 移动应用。

### 禁用远程控制（`disableRemoteControl`，v2.1.128+）

Team 或 Enterprise 计划的管理员可以使用 `disableRemoteControl` 设置完全阻止远程控制。当设为 `true` 时，`claude remote-control` 和 `/remote-control` 都拒绝启动。

```json
{
  "disableRemoteControl": true
}
```

该设置在**托管/策略**范围内生效（例如 macOS 上的 `/Library/Application Support/ClaudeCode/managed-settings.json`），因此个人用户无法覆盖。适用于必须在组织范围内强制执行仅本地执行的场景。

> **当 API 密钥层级自动禁用远程控制时（v2.1.139）**：当以下任何一项被设置时，远程控制将被**静默禁用**，即使您同时使用 claude.ai 登录：
>
> - `ANTHROPIC_API_KEY`
> - `ANTHROPIC_AUTH_TOKEN`
> - `apiKeyHelper`（settings.json）
>
> 同样的条件也会禁用 [`/schedule`](#计划任务)、claude.ai MCP 连接器和通知偏好设置——所有四个 claude.ai 桥接功能都要求 OAuth 登录为活动凭证。取消设置 API 密钥（或在 Pro/Max OAuth 层级运行）以使用这些功能。

---

## Web 会话

Web 会话允许您直接在 claude.ai/code 浏览器中运行 Claude Code，或从 CLI 创建 Web 会话。

### 创建 Web 会话

```bash
# 从 CLI 创建新的 Web 会话
claude --remote "implement the new API endpoints"
```

这将在 claude.ai 上启动一个 Claude Code 会话，您可以从任何浏览器访问。

### 在本地恢复 Web 会话

如果您在 Web 上启动了会话并希望在本地继续：

```bash
# 在本地终端中恢复 Web 会话
claude --teleport
```

或在交互式 REPL 中：
```
/teleport
```

### 使用场景

- 在一台机器上开始工作，在另一台机器上继续
- 与团队成员共享会话 URL
- 使用 Web 界面进行可视化差异审查，然后切换到终端执行

---

## 桌面应用

Claude Code 桌面应用提供独立的应用程序，具有可视化差异审查、并行会话和集成连接器。适用于 macOS 和 Windows（Pro、Max、Team 和 Enterprise 计划）。

### 安装

从 [claude.ai](https://claude.ai) 下载适用于您平台的版本：
- **macOS**：通用构建（Apple Silicon 和 Intel）
- **Windows**：提供 x64 和 ARM64 安装程序

请参阅[桌面快速入门](https://code.claude.com/docs/en/desktop-quickstart)获取安装说明。

### 从 CLI 移交

将当前 CLI 会话传输到桌面应用：

```
/desktop
```

### 核心功能

| 功能 | 描述 |
|---------|-------------|
| **差异视图** | 逐文件可视化审查并支持行内评论；Claude 阅读评论并修改 |
| **应用预览** | 自动启动开发服务器并嵌入浏览器进行实时验证 |
| **PR 监控** | GitHub CLI 集成，自动修复 CI 失败并在检查通过时自动合并 |
| **并行会话** | 侧边栏中的多个会话，自动进行 Git 工作树隔离 |
| **计划任务** | 循环任务（每小时、每天、工作日、每周），在应用打开时运行 |
| **丰富渲染** | 代码、Markdown 和图表的渲染，带语法高亮；GitHub-Flavored-Markdown 任务列表复选框（`- [ ]` / `- [x]`）渲染为复选框（v2.1.149+） |

### 应用预览配置

在 `.claude/launch.json` 中配置开发服务器行为：

```json
{
  "command": "npm run dev",
  "port": 3000,
  "readyPattern": "ready on",
  "persistCookies": true
}
```

### 连接器

连接外部服务以获取更丰富的上下文：

| 连接器 | 功能 |
|-----------|------------|
| **GitHub** | PR 监控、问题跟踪、代码审查 |
| **Slack** | 通知、频道上下文 |
| **Linear** | 问题跟踪、冲刺管理 |
| **Notion** | 文档、知识库访问 |
| **Asana** | 任务管理、项目跟踪 |
| **Calendar** | 日程感知、会议上下文 |

> **注意**：连接器不适用于远程（云端）会话。

### 远程和 SSH 会话

- **远程会话**：在 Anthropic 云基础设施上运行；即使应用关闭也会继续。可从 claude.ai/code 或 Claude 移动应用访问
- **SSH 会话**：通过 SSH 连接到远程机器，完全访问远程文件系统和工具。Claude Code 必须安装在远程机器上

### 桌面应用中的权限模式

桌面应用支持与 CLI 相同的 4 种权限模式：

| 模式 | 行为 |
|------|----------|
| **Ask permissions**（默认） | 审查和批准每次编辑和命令 |
| **Auto accept edits** | 文件编辑自动批准；命令需要手动批准 |
| **Plan mode** | 在进行任何更改前审查方案 |
| **Bypass permissions** | 自动执行（仅限沙箱，管理员控制） |

### 企业功能

- **管理控制台**：控制组织的 Code 标签页访问和权限设置
- **MDM 部署**：通过 macOS 上的 MDM 或 Windows 上的 MSIX 进行部署
- **SSO 集成**：要求组织成员使用单点登录
- **托管设置**：集中管理团队配置和模型可用性

---

## 任务列表

任务列表功能提供持久的任务跟踪，在上下文压缩（对话历史被裁剪以适应上下文窗口）期间得以保留。

### 切换任务列表

在会话中按 `Ctrl+T` 可开关任务列表视图。

### 持久化任务

任务在上下文压缩期间持续保留，确保长时间运行的工作项在对话上下文被裁剪时不会丢失。这对复杂的多步骤实现尤其有用。

### 命名任务目录

使用 `CLAUDE_CODE_TASK_LIST_ID` 环境变量创建跨会话共享的命名任务目录：

```bash
export CLAUDE_CODE_TASK_LIST_ID=my-project-sprint-3
```

这允许多个会话共享同一个任务列表，使其适用于团队工作流或多会话项目。

---

## 提示建议

提示建议根据您的 Git 历史记录和当前对话上下文显示灰色示例命令。

### 工作原理

- 建议以灰色文字显示在输入提示下方
- 按 `Tab` 接受建议
- 按 `Enter` 接受并立即提交
- 建议是上下文感知的，从 Git 历史记录和对话状态中提取

### 禁用提示建议

```bash
export CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION=false
```

---

## Git 工作树

Git 工作树允许您在隔离的工作树中启动 Claude Code，从而在不同分支上并行工作而无需暂存或切换。

### 在工作树中启动

```bash
# 在隔离的工作树中启动 Claude Code
claude --worktree
# 或
claude -w
```

### 工作树位置

工作树创建在：
```
<repo>/.claude/worktrees/<name>
```

### 单体仓库的稀疏检出

使用 `worktree.sparsePaths` 设置在单体仓库中执行稀疏检出，减少磁盘占用和克隆时间：

```json
{
  "worktree": {
    "sparsePaths": ["packages/my-package", "shared/"]
  }
}
```

### 基础分支引用（`worktree.baseRef`）

**`worktree.baseRef`**（v2.1.133 新增）——控制 `claude --worktree` 是从 `origin/<default>` 还是本地 `HEAD` 分支。

- `"fresh"`（默认）——从 `origin/<default-branch>` 分支，忽略本地的未推送提交。**这恢复了 v2.1.128 中引入的行为**，因此在 v2.1.128 之后依赖本地 HEAD 分支的用户必须选择重新加入。
- `"head"`——从本地 `HEAD` 分支，保留未推送的提交。

在 `~/.claude/settings.json` 中设置：

```json
{ "worktree": { "baseRef": "head" } }
```

### 后台会话隔离（`worktree.bgIsolation`）

**`worktree.bgIsolation`**（v2.1.143 新增）——控制后台会话（例如来自 `/bg`、`claude --bg` 或代理视图）是获得自己的工作树，还是直接编辑前台工作副本。

- *（默认）*——后台会话在 `<repo>/.claude/worktrees/` 下创建隔离的工作树，与 `--worktree` 的方式相同。
- `"none"`——后台会话直接编辑当前工作副本。当工作树不切实际时（例如繁重的原生构建产物）或后台代理必须与前台会话协调编辑时使用。

```json
{ "worktree": { "bgIsolation": "none" } }
```

权衡：`"none"` 移除了工作树隔离的安全网——来自后台和前台会话的并行编辑可能在实时工作副本中产生合并冲突。

### 工作树工具和钩子

| 项目 | 描述 |
|------|-------------|
| `EnterWorktree` | 进入工作树的工具；自 v2.1.157 起可以在 Claude 管理的工作树之间切换 |
| `ExitWorktree` | 退出并清理当前工作树的工具 |
| `WorktreeCreate` | 创建工作树时触发的钩子事件 |
| `WorktreeRemove` | 移除工作树时触发的钩子事件 |

自 v2.1.157 起，Claude 管理的工作树在代理完成后保持解锁，因此 `git worktree remove`/`prune` 可以清理它们。

### 自动清理

如果工作树中没有进行任何更改，会话结束时将自动清理。

### 使用场景

- 在功能分支上工作，同时保持主分支不被修改
- 在隔离环境中运行测试而不影响工作目录
- 在一次性环境中尝试实验性更改
- 在单体仓库中稀疏检出特定包以加快启动速度

---

## 沙箱

沙箱为 Claude Code 执行的 Bash 命令提供操作系统级别的文件系统和网络隔离。这是对权限规则的补充，提供了额外的安全层。

### 启用沙箱

**斜杠命令**：
```
/sandbox
```

**CLI 标志**：
```bash
claude --sandbox       # 启用沙箱
claude --no-sandbox    # 禁用沙箱
```

### 配置设置

| 设置 | 描述 |
|---------|-------------|
| `sandbox.enabled` | 启用或禁用沙箱 |
| `sandbox.failIfUnavailable` | 如果无法激活沙箱则失败 |
| `sandbox.filesystem.allowWrite` | 允许写入访问的路径 |
| `sandbox.filesystem.allowRead` | 允许读取访问的路径 |
| `sandbox.filesystem.denyRead` | 拒绝读取访问的路径 |
| `sandbox.network.allowedDomains` | Bash 启动的进程允许访问的域（支持 `*.` 通配符） |
| `sandbox.network.deniedDomains` | 即使 `allowedDomains` 通配符允许也要阻止的域（v2.1.113+） |
| `sandbox.enableWeakerNetworkIsolation` | 在 macOS 上启用较弱的网络隔离 |
| `sandbox.bwrapPath` | （v2.1.133+，Linux/WSL）指向 `bubblewrap` 二进制文件的路径。默认值：`$PATH` 查找。 |
| `sandbox.socatPath` | （v2.1.133+，Linux/WSL）指向 `socat` 二进制文件的路径。默认值：`$PATH` 查找。 |

**Linux/WSL 二进制路径**（v2.1.133+）——将 Claude Code 指向非标准安装位置：

```json
{
  "sandbox": {
    "bwrapPath": "/opt/bubblewrap/bin/bwrap",
    "socatPath": "/opt/socat/bin/socat"
  }
}
```

`deniedDomains` 覆盖广泛通配符的示例（v2.1.113+）：

```json
{
  "sandbox": {
    "network": {
      "allowedDomains": ["*.example.com"],
      "deniedDomains": ["evil.example.com"]
    }
  }
}
```

通配符允许 `example.com` 上的所有内容通过，但 `deniedDomains` 仍然会阻止特定命名的域名。

### 配置示例

```json
{
  "sandbox": {
    "enabled": true,
    "failIfUnavailable": true,
    "filesystem": {
      "allowWrite": ["/Users/me/project"],
      "allowRead": ["/Users/me/project", "/usr/local/lib"],
      "denyRead": ["/Users/me/.ssh", "/Users/me/.aws"]
    },
    "enableWeakerNetworkIsolation": true
  }
}
```

### 工作原理

- Bash 命令在具有受限文件系统访问权限的沙箱环境中运行
- 网络访问可以被隔离以防止意外的外部连接
- 与权限规则一起提供纵深防御
- 在 macOS 上，使用 `sandbox.enableWeakerNetworkIsolation` 进行网络限制（macOS 上不提供完整的网络隔离）

### 使用场景

- 安全运行不可信或生成的代码
- 防止对项目外部文件的意外修改
- 在自动化任务期间限制网络访问

---

## 托管设置（企业版）

托管设置使企业管理员能够使用平台原生的管理工具在整个组织中部署 Claude Code 配置。

### 部署方式

| 平台 | 方式 | 起始版本 |
|----------|--------|-------|
| macOS | 托管 plist 文件（MDM） | v2.1.51+ |
| Windows | Windows 注册表 | v2.1.51+ |
| 跨平台 | 托管配置文件 | v2.1.51+ |
| 跨平台 | 托管分项配置（`managed-settings.d/` 目录） | v2.1.83+ |

### 托管分项配置

自 v2.1.83 起，管理员可以将多个托管设置文件部署到 `managed-settings.d/` 目录中。文件按字母顺序合并，允许跨团队模块化配置：

```
~/.claude/managed-settings.d/
  00-org-defaults.json
  10-team-policies.json
  20-project-overrides.json
```

### 可用的托管设置

| 设置 | 描述 |
|---------|-------------|
| `disableBypassPermissionsMode` | 阻止用户启用绕过权限模式 |
| `availableModels` | 限制用户可选择的模型 |
| `allowedChannelPlugins` | 控制允许哪些通道插件 |
| `autoMode.environment` | 为自动模式配置可信基础设施 |
| `wslInheritsWindowsSettings` | 仅限 Windows/WSL（v2.1.118+）：当设为 `true` 时，在 WSL 中运行的 Claude Code 从 Windows 主机继承托管设置，因此通过注册表/MDM 部署的企业策略在 Windows 和 WSL shell 中统一适用 |
| `parentSettingsBehavior` | （v2.1.133+，管理员级别）控制 SDK 的 `managedSettings` 如何与父进程设置合并。`"first-wins"` 保持现有优先级（冲突时较早的设置优先）；`"merge"` 深度合并值。 |
| 自定义策略 | 组织特定的权限和工具策略 |

### 示例：macOS Plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>disableBypassPermissionsMode</key>
  <true/>
  <key>availableModels</key>
  <array>
    <string>claude-sonnet-4-6</string>
    <string>claude-haiku-4-5</string>
  </array>
</dict>
</plist>
```

---

## 配置与设置

### 配置文件位置

1. **全局配置**：`~/.claude/config.json`
2. **项目配置**：`./.claude/config.json`
3. **用户配置**：`~/.config/claude-code/settings.json`

### 完整配置示例

**核心高级功能配置：**

```json
{
  "permissions": {
    "mode": "default"
  },
  "hooks": {
    "PreToolUse:Edit": "eslint --fix ${file_path}",
    "PostToolUse:Write": "~/.claude/hooks/security-scan.sh"
  },
  "mcp": {
    "enabled": true,
    "servers": {
      "github": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-github"]
      }
    }
  }
}
```

**扩展配置示例：**

```json
{
  "permissions": {
    "mode": "default",
    "allowedTools": ["Bash(git log:*)", "Read"],
    "disallowedTools": ["Bash(rm -rf:*)"]
  },

  "hooks": {
    "PreToolUse": [{ "matcher": "Edit", "hooks": ["eslint --fix ${file_path}"] }],
    "PostToolUse": [{ "matcher": "Write", "hooks": ["~/.claude/hooks/security-scan.sh"] }],
    "Stop": [{ "hooks": ["~/.claude/hooks/notify.sh"] }]
  },

  "mcp": {
    "enabled": true,
    "servers": {
      "github": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-github"],
        "env": {
          "GITHUB_TOKEN": "${GITHUB_TOKEN}"
        }
      }
    }
  }
}
```

### 环境变量

使用环境变量覆盖配置：

```bash
# 模型选择
export ANTHROPIC_MODEL=claude-opus-4-8
export ANTHROPIC_DEFAULT_OPUS_MODEL=claude-opus-4-8
export ANTHROPIC_DEFAULT_SONNET_MODEL=claude-sonnet-4-6
export ANTHROPIC_DEFAULT_HAIKU_MODEL=claude-haiku-4-5

# API 配置
export ANTHROPIC_API_KEY=sk-ant-...

# 思考配置
export MAX_THINKING_TOKENS=16000
export CLAUDE_CODE_EFFORT_LEVEL=high   # low, medium, high, xhigh (Opus 4.8/4.7), 或 max —— Opus 4.8 上默认为 high（在 Opus 4.8、Opus 4.7、Opus 4.6、Sonnet 4.6 上支持）

# 功能开关
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=true
export CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=true
export CLAUDE_CODE_DISABLE_CRON=1
export CLAUDE_CODE_DISABLE_GIT_INSTRUCTIONS=true
export CLAUDE_CODE_DISABLE_TERMINAL_TITLE=true
export CLAUDE_CODE_DISABLE_1M_CONTEXT=true
export CLAUDE_CODE_DISABLE_NONSTREAMING_FALLBACK=true
export CLAUDE_CODE_ENABLE_PROMPT_SUGGESTION=false
export CLAUDE_CODE_ENABLE_TASKS=true
export CLAUDE_CODE_SIMPLE=true              # 由 --bare 标志设置

# MCP 配置
export MAX_MCP_OUTPUT_TOKENS=50000
export ENABLE_TOOL_SEARCH=true

# 提示缓存
export ENABLE_PROMPT_CACHING_1H=1      # 使用 1 小时提示缓存 TTL（默认 5 分钟）

# 任务管理
export CLAUDE_CODE_TASK_LIST_ID=my-project-tasks

# Agent 团队（实验性）
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# 子代理和插件配置
export CLAUDE_CODE_SUBAGENT_MODEL=sonnet
export CLAUDE_CODE_PLUGIN_SEED_DIR=./my-plugins
export CLAUDE_CODE_NEW_INIT=1

# 子进程和流
export CLAUDE_CODE_SUBPROCESS_ENV_SCRUB="SECRET_KEY,DB_PASSWORD"
export CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=80
export CLAUDE_STREAM_IDLE_TIMEOUT_MS=30000
export ANTHROPIC_CUSTOM_MODEL_OPTION=my-custom-model
export SLASH_COMMAND_TOOL_CHAR_BUDGET=50000

# 输出和包管理器 (v2.1.129+)
export CLAUDE_CODE_FORCE_SYNC_OUTPUT=1                      # 在自动检测失败的终端（Emacs eat 等）上强制同步输出
export CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE=1            # 为 Homebrew/WinGet 安装启用后台升级
export CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1         # 在设置 ANTHROPIC_BASE_URL 时选择启用 /v1/models 网关发现

# Windows PowerShell 工具 (v2.1.143+) — Windows 上 Bedrock/Vertex/Foundry 默认开启
export CLAUDE_CODE_USE_POWERSHELL_TOOL=0                    # 完全禁用 PowerShell 工具
export CLAUDE_CODE_POWERSHELL_RESPECT_EXECUTION_POLICY=1    # 遵守系统 ExecutionPolicy 而非使用 `-ExecutionPolicy Bypass`

# 工作负载身份联合 (v2.1.141+)
export ANTHROPIC_WORKSPACE_ID=ws_abc123                     # 在规则涵盖多个工作空间时，将联合 token 限定到特定工作空间

# Stop 钩子安全上限 (v2.1.143+)
export CLAUDE_CODE_STOP_HOOK_BLOCK_CAP=8                    # Stop 钩子连续阻止的最大次数，超过阈值后会话结束并警告。设为 0 禁用上限。
```

> **v2.1.108**：`ENABLE_PROMPT_CACHING_1H=1` —— 使用 1 小时提示缓存 TTL，而非默认的 5 分钟 TTL。可减少长时间稳定会话中的缓存未命中。（v2.1.129 修复了 1 小时 TTL 被静默降级至 5 分钟的回归问题。）

> **v2.1.129**：`CLAUDE_CODE_FORCE_SYNC_OUTPUT=1` 在终端功能自动检测失败时（例如 Emacs `eat`）强制同步输出。`CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE=1` 为 Homebrew/WinGet 安装启用后台升级，否则这些安装永远不会自动更新。

### 配置管理命令

```
User: /config
[打开交互式配置菜单]
```

`/config` 命令提供一个交互式菜单来切换设置，例如：
- 扩展思考 开/关
- 详细输出
- 权限模式
- 模型选择

### 按项目配置

在项目中创建 `.claude/config.json`：

```json
{
  "hooks": {
    "PreToolUse": [{ "matcher": "Bash", "hooks": ["npm test && npm run lint"] }]
  },
  "permissions": {
    "mode": "default"
  },
  "mcp": {
    "servers": {
      "project-db": {
        "command": "mcp-postgres",
        "env": {
          "DATABASE_URL": "${PROJECT_DB_URL}"
        }
      }
    }
  }
}
```

---

## Agent 团队

Agent 团队是一项实验性功能，允许多个 Claude Code 实例在任务上进行协作。默认情况下处于禁用状态。

### 启用 Agent 团队

通过环境变量或设置启用：

```bash
# 环境变量
export CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

或添加到您的设置 JSON 中：

```json
{
  "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
}
```

### Agent 团队的工作原理

- **团队负责人**协调总体任务并将子任务委派给团队成员
- **团队成员**独立工作，每个成员有自己的上下文窗口
- **共享任务列表**实现团队成员之间的自我协调
- 使用子代理定义（`.claude/agents/` 或 `--agents` 标志）来定义团队成员角色和专业领域

### 显示模式

Agent 团队支持两种显示模式，通过 `--teammate-mode` 标志配置：

| 模式 | 描述 |
|------|-------------|
| `in-process`（默认） | 团队成员在同一终端进程中运行 |
| `tmux` | 每个团队成员获得一个专用的分割窗格（需要 tmux 或 iTerm2） |
| `auto` | 自动选择最佳显示模式 |

```bash
# 使用 tmux 分割窗格显示团队成员
claude --teammate-mode tmux

# 显式使用进程内模式
claude --teammate-mode in-process
```

### 使用场景

- 大型重构任务，不同团队成员处理不同模块
- 并行代码审查和实现
- 跨代码库的协调多文件更改

> **注意**：Agent 团队是实验性的，可能在未来的版本中有所更改。请参阅 [code.claude.com/docs/en/agent-teams](https://code.claude.com/docs/en/agent-teams) 获取完整参考。

---

## 最佳实践

### 规划模式
- ✅ 用于复杂的多步骤任务
- ✅ 在批准前审查计划
- ✅ 在需要时修改计划
- ❌ 不要用于简单任务

### 扩展思考
- ✅ 用于架构决策
- ✅ 用于复杂问题解决
- ✅ 审查思考过程
- ❌ 不要用于简单查询

### 后台任务
- ✅ 用于长时间运行的操作
- ✅ 监控任务进度
- ✅ 优雅地处理任务失败
- ❌ 不要启动太多并发任务

### 权限
- ✅ 使用 `plan` 进行代码审查（只读）
- ✅ 使用 `default` 进行交互式开发
- ✅ 使用 `acceptEdits` 进行自动化工作流
- ✅ 使用 `auto` 进行带安全护栏的自主工作
- ❌ 除非绝对必要，不要使用 `bypassPermissions`

### 会话
- ✅ 为不同任务使用单独的会话
- ✅ 保存重要的会话状态
- ✅ 清理旧会话
- ❌ 不要在一个会话中混合不相关的工作

---

## 其他资源

有关 Claude Code 及相关功能的更多信息：

- [官方交互模式文档](https://code.claude.com/docs/en/interactive-mode)
- [官方无界面模式文档](https://code.claude.com/docs/en/headless)
- [CLI 参考](https://code.claude.com/docs/en/cli-reference)
- [检查点指南](../08-checkpoints/) - 会话管理和回退
- [斜杠命令](../01-slash-commands/) - 命令参考
- [记忆指南](../02-memory/) - 持久化上下文
- [技能指南](../03-skills/) - 自主能力
- [子代理指南](../04-subagents/) - 委派任务执行
- [MCP 指南](../05-mcp/) - 外部数据访问
- [钩子指南](../06-hooks/) - 事件驱动自动化
- [插件指南](../07-plugins/) - 捆绑扩展
- [官方计划任务文档](https://code.claude.com/docs/en/scheduled-tasks)
- [官方 Chrome 集成文档](https://code.claude.com/docs/en/chrome)
- [官方远程控制文档](https://code.claude.com/docs/en/remote-control)
- [官方键绑定文档](https://code.claude.com/docs/en/keybindings)
- [官方桌面应用文档](https://code.claude.com/docs/en/desktop)
- [官方 Agent 团队文档](https://code.claude.com/docs/en/agent-teams)

---

**最后更新**：2026 年 6 月 2 日
**Claude Code 版本**：2.1.160
**来源**：
- https://code.claude.com/docs/en/permission-modes
- https://code.claude.com/docs/en/interactive-mode
- https://code.claude.com/docs/en/settings
- https://code.claude.com/docs/en/cli-reference
- https://code.claude.com/docs/en/model-config
- https://www.anthropic.com/news/claude-opus-4-8
- https://claude.com/blog/introducing-routines-in-claude-code
- https://github.com/anthropics/claude-code/releases/tag/v2.1.117
- https://github.com/anthropics/claude-code/releases/tag/v2.1.139
- https://github.com/anthropics/claude-code/releases/tag/v2.1.154
- https://code.claude.com/docs/en/overview
- https://code.claude.com/docs/en/sub-agents
**兼容模型**：Claude Sonnet 4.6、Claude Opus 4.8、Claude Haiku 4.5
