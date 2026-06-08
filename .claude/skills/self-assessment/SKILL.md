---
name: self-assessment
version: 2.3.0
description: Comprehensive Claude Code self-assessment and learning path advisor. Runs a multi-category quiz covering 10 feature areas, produces a detailed skill profile with per-topic scores, identifies specific gaps, and generates a personalized learning path with prioritized next steps. Use when asked to "assess my level", "take the quiz", "find my level", "where should I start", "what should I learn next", "check my skills", "skill check", or "level up".
---

# 自评与学习路径顾问

全面的交互式评估，涵盖 10 个功能领域评估 Claude Code 熟练度，识别具体的技能差距，并生成个性化的学习路径以提升水平。

## 指令

### 第 1 步：欢迎与选择评估模式

让用户选择评估深度：

使用 AskUserQuestion，选项如下：
- **快速评估** — "8 个问题，约 2 分钟。确定你的总体水平（初级/中级/高级）并给出学习路径。"
- **深度评估** — "5 个类别，包含详细问题，约 5 分钟。给出每个主题的技能分数，识别具体差距，并构建优先排序的学习路径。"

如果用户选择**快速评估**，跳至第 2A 步。
如果用户选择**深度评估**，跳至第 2B 步。

---

### 第 2A 步：快速评估

提出**两个**多选问题（AskUserQuestion 每个问题最多支持 4 个选项）：

**第 1 题**（header: "基础"）：
"第 1/2 部分：你已经掌握以下哪些 Claude Code 技能？"
选项：
1. "启动 Claude Code 并对话" — 我可以运行 `claude` 并与之交互
2. "创建/编辑过 CLAUDE.md" — 我已经设置过项目或用户记忆
3. "使用过 3 个以上斜杠命令" — 例如 /help、/compact、/model、/clear
4. "创建过自定义命令/技能" — 编写过 SKILL.md 或自定义命令文件

**第 2 题**（header: "高级"）：
"第 2/2 部分：你已经掌握以下哪些高级技能？"
选项：
1. "配置过 MCP 服务器" — 例如 GitHub、数据库或其他外部数据源
2. "设置过 hooks" — 在 ~/.claude/settings.json 中配置过 hooks
3. "创建/使用过子代理" — 使用 .claude/agents/ 进行任务委派
4. "使用过打印模式 (claude -p)" — 使用 `claude -p` 进行非交互式或 CI/CD 使用

**评分：**
- 总计 0-2 项 = 等级 1：初级
- 总计 3-5 项 = 等级 2：中级
- 总计 6-8 项 = 等级 3：高级

跳至第 3 步，给出等级结果，列出**未勾选**的具体项目作为差距。

---

### 第 2B 步：深度评估

提出 5 轮问题，每轮调用一次 AskUserQuestion。每轮覆盖 2 个相关的功能领域。所有轮次均使用多选。

**重要提示**：AskUserQuestion 每个问题最多支持 4 个选项。每轮恰好有 1 个问题，包含 4 个选项，覆盖 2 个主题（每个主题 2 个选项）。

---

**第 1 轮 — 斜杠命令与记忆**（header: "命令"）

"你已经做过以下哪些？请选择所有适用的。"
选项：
1. "创建过自定义斜杠命令或技能" — 编写过带有 frontmatter 的 SKILL.md 文件，或创建过 .claude/commands/ 文件
2. "在命令中使用过动态上下文" — 在技能/命令文件中使用过 `$ARGUMENTS`、`$0`/`$1`、反引号 `!command` 语法或 `@file` 引用
3. "设置过项目 + 个人记忆" — 同时创建过项目 CLAUDE.md 和个人 ~/.claude/CLAUDE.md（或 CLAUDE.local.md）
4. "使用过记忆层级功能" — 理解 7 级优先级顺序，使用过 .claude/rules/ 目录、路径特定规则或 @import 语法

**第 1 轮评分：**
- 选项 1-2 对应**斜杠命令**（0-2 分）
- 选项 3-4 对应**记忆**（0-2 分）

---

**第 2 轮 — 技能与 Hooks**（header: "自动化"）

"你已经做过以下哪些？请选择所有适用的。"
选项：
1. "安装并使用过自动调用的技能" — 一个根据其描述自动触发、无需手动 /command 调用的技能
2. "控制过技能调用行为" — 在 SKILL.md frontmatter 中使用过 `disable-model-invocation`、`user-invocable` 或 `context: fork` 配合 agent 字段
3. "设置过 PreToolUse 或 PostToolUse hook" — 配置过一个在工具执行前/后运行的 hook（例如命令验证器、自动格式化器）
4. "使用过高级 hook 功能" — 配置过 prompt 类型 hook、SKILL.md 中的组件作用域 hook、HTTP hook，或带有自定义 JSON 输出（updatedInput、systemMessage）的 hook

**第 2 轮评分：**
- 选项 1-2 对应**技能**（0-2 分）
- 选项 3-4 对应**Hooks**（0-2 分）

---

**第 3 轮 — MCP 与子代理**（header: "集成"）

"你已经做过以下哪些？请选择所有适用的。"
选项：
1. "连接过 MCP 服务器并使用过其工具" — 例如用于 PR/Issue 的 GitHub MCP、用于查询的数据库 MCP 或任何外部数据源
2. "使用过高级 MCP 功能" — 项目作用域 .mcp.json、OAuth 认证、带 @mentions 的 MCP 资源、工具搜索或 `claude mcp serve`
3. "创建或配置过自定义子代理" — 在 .claude/agents/ 中定义过代理，配置了自定义工具、模型或权限
4. "使用过高级子代理功能" — Worktree 隔离、持久化代理记忆、Ctrl+B 后台任务、`Task(agent_name)` 代理允许列表或代理团队

**第 3 轮评分：**
- 选项 1-2 对应**MCP**（0-2 分）
- 选项 3-4 对应**子代理**（0-2 分）

---

**第 4 轮 — 检查点与高级功能**（header: "高级用户"）

"你已经做过以下哪些？请选择所有适用的。"
选项：
1. "使用过检查点进行安全实验" — 创建过检查点，使用过 Esc+Esc 或 /rewind，恢复过代码和/或对话，或使用过汇总选项
2. "使用过规划模式或扩展思考" — 通过 /plan、Shift+Tab 或 --permission-mode plan 激活过规划；使用 Alt+T/Option+T 切换过扩展思考
3. "配置过权限模式" — 通过 CLI 标志、键盘快捷键或设置使用过 acceptEdits、plan、dontAsk 或 bypassPermissions 模式
4. "使用过远程/桌面/网页功能" — 使用过 `claude remote-control`、`claude --remote`、`/teleport`、`/desktop` 或 `claude -w` 的 worktrees

**第 4 轮评分：**
- 选项 1 对应**检查点**（0-1 分）
- 选项 2-4 对应**高级功能**（0-3 分，封顶 2 分）

---

**第 5 轮 — 插件与 CLI**（header: "精通"）

"你已经做过以下哪些？请选择所有适用的。"
选项：
1. "安装或创建过插件" — 使用过来自市场的打包插件，或创建过带有 plugin.json 清单的 .claude-plugin/ 目录
2. "使用过插件高级功能" — 插件 hooks、插件 MCP 服务器、LSP 配置、插件命名空间命令，或用于测试的 --plugin-dir 标志
3. "在脚本或 CI/CD 中使用过打印模式" — 使用过 `claude -p` 配合 --output-format json、--max-turns、管道输入，或集成到 GitHub Actions / CI 流水线
4. "使用过高级 CLI 功能" — 会话恢复 (-c/-r)、--agents 标志、用于结构化输出的 --json-schema、--fallback-model、--from-pr，或批处理循环

**第 5 轮评分：**
- 选项 1-2 对应**插件**（0-2 分）
- 选项 3-4 对应**CLI**（0-2 分）

---

### 第 3 步：计算并展示结果

#### 3A：快速评估

统计总选择数并确定等级。然后展示：

```markdown
## Claude Code 技能评估结果

### 你的等级：[等级 1：初级 / 等级 2：中级 / 等级 3：高级]

你勾选了 **N/8** 项。

[基于等级的一句话激励总结]

### 你的技能画像

| 领域 | 状态 |
|------|--------|
| 基础 CLI 与会话 | [已掌握/差距] |
| CLAUDE.md 与记忆 | [已掌握/差距] |
| 斜杠命令（内置） | [已掌握/差距] |
| 自定义命令与技能 | [已掌握/差距] |
| MCP 服务器 | [已掌握/差距] |
| Hooks | [已掌握/差距] |
| 子代理 | [已掌握/差距] |
| 打印模式与 CI/CD | [已掌握/差距] |

### 识别到的差距

[对于每个未勾选的项目，提供一行关于学什么以及教程链接的描述]

### 你的个性化学习路径

[输出对应等级的学习路径——见第 4 步]
```

#### 3B：深度评估

从 5 轮中计算每个主题的分数。每个主题得 0-2 分。然后展示：

```markdown
## Claude Code 技能评估结果

### 总体等级：[等级 1 / 等级 2 / 等级 3]

**总分：N/20 分**

[一句话激励总结]

### 你的技能画像

| 功能领域 | 分数 | 掌握度 | 状态 |
|-------------|-------|---------|--------|
| 斜杠命令 | N/2 | [无/基础/熟练] | [学习/复习/已掌握] |
| 记忆 | N/2 | [无/基础/熟练] | [学习/复习/已掌握] |
| 技能 | N/2 | [无/基础/熟练] | [学习/复习/已掌握] |
| Hooks | N/2 | [无/基础/熟练] | [学习/复习/已掌握] |
| MCP | N/2 | [无/基础/熟练] | [学习/复习/已掌握] |
| 子代理 | N/2 | [无/基础/熟练] | [学习/复习/已掌握] |
| 检查点 | N/1 | [无/熟练] | [学习/已掌握] |
| 高级功能 | N/2 | [无/基础/熟练] | [学习/复习/已掌握] |
| 插件 | N/2 | [无/基础/熟练] | [学习/复习/已掌握] |
| CLI | N/2 | [无/基础/熟练] | [学习/复习/已掌握] |

**掌握度说明：** 0 = 无，1 = 基础，2 = 熟练

### 优势领域
[列出得分为 2/2 的主题——这些已掌握]

### 优先差距（下一步学习）
[列出得分为 0 的主题——这些需要首先关注，按依赖关系排序]

### 需要复习的领域
[列出得分为 1/2 的主题——掌握基础但尚未使用高级功能]

### 你的个性化学习路径

[输出针对差距的学习路径——见第 4 步]
```

**深度评估的总体等级计算：**
- 总计 0-6 分 = 等级 1：初级
- 总计 7-13 分 = 等级 2：中级
- 总计 14-20 分 = 等级 3：高级

---

### 第 4 步：生成个性化学习路径

根据评估结果，生成一个针对用户差距的学习路径。不要仅仅重复通用的等级路径——要适应性地调整。

#### 路径生成规则

1. **跳过已掌握的主题**：如果某个主题得分为 2/2，不要将其包含在路径中。
2. **按依赖关系排序**：斜杠命令先于技能，记忆先于子代理，依此类推。依赖关系顺序为：
   - 斜杠命令（无依赖） -> 技能（依赖斜杠命令）
   - 记忆（无依赖） -> 子代理（依赖记忆）
   - CLI 基础（无依赖） -> CLI 精通（依赖所有）
   - 检查点（无依赖）
   - Hooks（依赖斜杠命令）
   - MCP（无依赖） -> 插件（依赖 MCP、技能、Hooks）
   - 高级功能（依赖所有前述项）
3. **对于得分 1/2 的主题**：推荐"深入学习"——链接到他们缺失的具体高级章节。
4. **估算时间**：仅汇总他们需要学习/复习的主题时间。
5. **分组为阶段**：将剩余主题组织为逻辑阶段，每个阶段 2-3 个主题。

#### 路径输出格式

```markdown
### 你的个性化学习路径

**预计时间**：约 N 小时（根据你当前的技能调整）

#### 阶段 1：[阶段名称]（约 N 小时）
[仅当他们在这些领域有差距时]

**[主题名称]** — [从零学习 / 深入学习高级功能]
- 教程：[教程目录链接]
- 重点关注：[他们需要的具体章节/概念]
- 关键练习：[一个具体的练习事项]
- 完成标志：[具体的成功标准]

**[主题名称]** — ...

---

#### 阶段 2：[阶段名称]（约 N 小时）
...

---

### 推荐实践项目

根据你的差距，尝试以下实际练习来巩固学习：

1. **[项目名称]**：[一句话描述，结合 2-3 个差距主题]
2. **[项目名称]**：[一句话描述]
3. **[项目名称]**：[一句话描述]
```

#### 各主题具体建议

当某个主题存在差距时，使用以下具体建议：

**斜杠命令（得分 0）**：
- 教程：[01-slash-commands/](../../../01-slash-commands/)
- 重点关注：内置命令参考、创建你的第一个 SKILL.md、`$ARGUMENTS` 语法
- 关键练习：创建一个 `/optimize` 命令并测试它
- 完成标志：你可以创建一个带有参数和动态上下文的自定义技能

**斜杠命令（得分 1 — 复习）**：
- 重点关注：使用 `` `!`` 反引号语法的动态上下文、`@file` 引用、`disable-model-invocation` 与 `user-invocable` 控制
- 完成标志：你可以创建一个注入实时命令输出并控制自身调用行为的技能

**记忆（得分 0）**：
- 教程：[02-memory/](../../../02-memory/)
- 重点关注：CLAUDE.md 创建、`/init` 和 `/memory` 命令、用于快速更新的 `#` 前缀
- 关键练习：创建一个包含你的编码标准的项目 CLAUDE.md
- 完成标志：Claude 在不同会话间记住你的偏好

**记忆（得分 1 — 复习）**：
- 重点关注：7 级层级和优先级顺序、带有路径特定规则的 .claude/rules/ 目录、`@import` 语法（最大深度 5）、Auto Memory MEMORY.md（200 行限制）
- 完成标志：你为不同目录拥有模块化规则，并理解完整的层级结构

**技能（得分 0）**：
- 教程：[03-skills/](../../../03-skills/)
- 重点关注：SKILL.md 格式、通过 description 字段自动调用、渐进式披露（3 个加载级别）
- 关键练习：安装 code-review 技能并验证它自动触发
- 完成标志：一个技能根据对话上下文自动激活

**技能（得分 1 — 复习）**：
- 重点关注：使用 `agent` 字段的 `context: fork` 进行子代理执行、`disable-model-invocation` 与 `user-invocable`、2% 上下文预算、打包资源（scripts/、references/、assets/）
- 完成标志：你可以创建一个在分叉上下文中在子代理中运行的技能

**Hooks（得分 0）**：
- 教程：[06-hooks/](../../../06-hooks/)
- 重点关注：配置结构（matcher + hooks 数组）、PreToolUse/PostToolUse 事件、退出码（0=成功，2=阻止）、JSON 输入/输出格式
- 关键练习：创建一个验证 Bash 命令的 PreToolUse hook
- 完成标志：一个 hook 在执行前阻止危险命令

**Hooks（得分 1 — 复习）**：
- 重点关注：全部 25 个 hook 事件（包括 PostToolUseFailure、StopFailure、TaskCreated、CwdChanged、FileChanged、PostCompact、Elicitation、ElicitationResult）、4 种 hook 类型（command、http、prompt、agent）、SKILL.md frontmatter 中的组件作用域 hook、带 allowedEnvVars 的 HTTP hook、用于 SessionStart/CwdChanged/FileChanged 的 `CLAUDE_ENV_FILE`
- 完成标志：你可以创建一个基于 prompt 的 Stop hook 和一个技能中的组件作用域 hook

**MCP（得分 0）**：
- 教程：[05-mcp/](../../../05-mcp/)
- 重点关注：`claude mcp add` 命令、传输类型（推荐 HTTP）、GitHub MCP 设置、环境变量展开
- 关键练习：添加 GitHub MCP 服务器并查询 PR
- 完成标志：你可以通过 MCP 查询来自外部服务的实时数据

**MCP（得分 1 — 复习）**：
- 重点关注：项目作用域 .mcp.json（需要团队批准）、OAuth 2.0 认证、使用 `@server:resource` 提及的 MCP 资源、工具搜索（ENABLE_TOOL_SEARCH）、`claude mcp serve`、输出限制（10k/25k/50k）
- 完成标志：你拥有项目 .mcp.json 并理解工具搜索自动模式

**子代理（得分 0）**：
- 教程：[04-subagents/](../../../04-subagents/)
- 重点关注：代理文件格式（.claude/agents/*.md）、内置代理（general-purpose、Plan、Explore）、tools/model/permissionMode 配置
- 关键练习：创建一个 code-reviewer 子代理并测试委派
- 完成标志：Claude 将代码审查委派给你的自定义代理

**子代理（得分 1 — 复习）**：
- 重点关注：Worktree 隔离（`isolation: worktree`）、持久化代理记忆（`memory` 字段与作用域）、后台代理（Ctrl+B/Ctrl+F）、使用 `Task(agent_name)` 的代理允许列表、代理团队（`--teammate-mode`）
- 完成标志：你拥有一个带有持久化记忆在 worktree 隔离中运行的子代理

**检查点（得分 0）**：
- 教程：[08-checkpoints/](../../../08-checkpoints/)
- 重点关注：Esc+Esc 和 /rewind 访问方式、5 个回溯选项（恢复代码+对话、恢复对话、恢复代码、汇总、取消）、限制（bash 文件系统操作不被追踪）
- 关键练习：进行实验性更改，然后回溯恢复
- 完成标志：你可以自信地进行实验，知道可以回溯

**高级功能（得分 0）**：
- 教程：[09-advanced-features/](../../../09-advanced-features/)
- 重点关注：规划模式（/plan 或 Shift+Tab）、权限模式（5 种类型）、扩展思考（Alt+T 切换）
- 关键练习：使用规划模式设计一个功能，然后实现它
- 完成标志：你可以在规划和实现模式之间流畅切换

**高级功能（得分 1 — 复习）**：
- 重点关注：远程控制（`claude remote-control`）、网页会话（`claude --remote`）、桌面切换（`/desktop`）、worktrees（`claude -w`）、任务列表（Ctrl+T）、企业管理设置
- 完成标志：你可以在 CLI、网页和桌面之间切换会话

**插件（得分 0）**：
- 教程：[07-plugins/](../../../07-plugins/)
- 重点关注：插件结构（.claude-plugin/plugin.json）、插件打包内容（commands、agents、MCP、hooks、settings）、从市场安装
- 关键练习：安装一个插件并探索其组件
- 完成标志：你理解何时使用插件 vs 独立组件

**插件（得分 1 — 复习）**：
- 重点关注：创建 plugin.json 清单、插件 hooks（hooks/hooks.json）、LSP 配置（.lsp.json）、`${CLAUDE_PLUGIN_ROOT}` 变量、用于测试的 --plugin-dir、市场发布
- 完成标志：你可以为你的团队创建并测试一个插件

**CLI（得分 0）**：
- 教程：[10-cli/](../../../10-cli/)
- 重点关注：交互模式 vs 打印模式、`claude -p` 配合管道、`--output-format json`、会话管理（-c/-r）
- 关键练习：将文件通过管道传给 `claude -p` 并获取 JSON 输出
- 完成标志：你可以在脚本中非交互式地使用 Claude

**CLI（得分 1 — 复习）**：
- 重点关注：带 JSON 配置的 --agents 标志、用于结构化输出的 --json-schema、--fallback-model、--from-pr、--strict-mcp-config、使用 for 循环的批处理、`claude mcp serve`
- 完成标志：你拥有一个使用 Claude 生成结构化 JSON 输出的 CI/CD 脚本

---

### 第 5 步：提供后续操作

展示结果后，询问用户接下来想做什么：

使用 AskUserQuestion，选项如下：
- **开始学习** — "现在帮我开始学习路径中的第一个主题"
- **深入一个差距** — "详细解释我的一个差距领域，让我可以在这里学习"
- **实践项目** — "设置一个覆盖我差距领域的实践项目"
- **重新评估** — "我想重新参加测验（可能是另一种模式）"

如果选择**开始学习**：阅读第一个差距教程的 README.md，并带领用户完成第一个练习。
如果选择**深入一个差距**：询问哪个差距主题，然后阅读相关教程的 README.md 并用示例解释关键概念。
如果选择**实践项目**：设计一个小项目，结合 2-3 个他们的差距主题，提供具体步骤。
如果选择**重新评估**：回到第 1 步。

## 错误处理

### 用户在一轮中未选择任何项目
该轮主题视为 0 分。继续下一轮。

### 用户在所有轮次中均未选择任何项目
分配等级 1：初级。鼓励从头开始。输出完整的等级 1 路径。

### 用户想重新参加
从第 1 步重新运行，进行全新评估。

### 用户不同意他们的等级
认可他们的偏好。询问他们认同哪个等级。展示该选择等级的路径，并附带他们可能遗漏的主题的先决条件检查。

### 用户询问特定主题
如果用户在评估期间说了类似"告诉我关于 hooks 的信息"或"我想学习 MCP"，请注意。展示结果后，无论分数如何，在个性化学习路径中突出显示该主题。

## 验证

### 触发测试套件

**应该触发：**
- "assess my level"
- "take the quiz"
- "find my level"
- "where should I start"
- "what level am I"
- "learning path quiz"
- "self-assessment"
- "what should I learn next"
- "check my skills"
- "skill check"
- "level up"
- "how good am I at Claude Code"
- "evaluate my Claude Code knowledge"

**不应触发：**
- "review my code"
- "create a skill"
- "help me with MCP"
- "explain slash commands"
- "what is a checkpoint"
