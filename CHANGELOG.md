# 更新日志

## [v2.1.160] — 2026-06-02

### 同步至 Claude Code v2.1.160

将教程覆盖范围更新至 Claude Code v2.1.160 版本。中间的
v2.1.156 同步（Claude Opus 4.8，#129）已应用于文档但未单独
记录；本条从那时起继续，覆盖 v2.1.157–v2.1.160
的变更。此范围内没有破坏性更改——新增内容为少量
新的 CLI/功能界面以及常规的页脚版本号更新。第三方提供商的
自动模式为**可选加入**，而非新的默认行为。

### 新增

- **`claude plugin init <name>` (v2.1.157)** — 直接在
  `.claude/skills` 中创建新插件脚手架；放置于此的插件现在可自动加载，无需
  市场。文档见 `10-cli/README.md`、`07-plugins/README.md` 和
  `CATALOG.md`。
- **Bedrock / Vertex / Foundry 上的自动模式 (v2.1.158)** — 自动模式现在
  可在三个第三方提供商上用于 Opus 4.7/4.8，通过
  `CLAUDE_CODE_ENABLE_AUTO_MODE=1` 环境变量**可选加入**。文档见
  `09-advanced-features/README.md`、`10-cli/README.md` 和 `CATALOG.md`。
- **`EnterWorktree` 会话中切换 (v2.1.157)** — `EnterWorktree`
  工具现在可以在会话内在 Claude 管理的工作树之间切换，且
  已完成的工作树保持解锁状态，以便 `git worktree remove`/`prune` 可以
  清理它们。文档见 `09-advanced-features/README.md`。

### 行为变更

- **`acceptEdits` 写入安全提示 (v2.1.160)** — 即使在 `acceptEdits`
  模式下，Claude Code 现在在写入 shell 启动文件（`.zshenv`、
  `.zlogin`、`.bash_login`、`~/.config/git/`）和会执行代码的构建配置
  （`.npmrc`、`.yarnrc*`、`bunfig.toml`、`.bazelrc`、`.pre-commit-config.yaml`、
  `.devcontainer/`）之前会提示确认，否则这些文件可能导致意外的命令
  执行。文档见 `09-advanced-features/README.md`。
- **动态工作流触发关键词 `workflow` → `ultracode` (v2.1.160)** — 裸
  词 "workflow" 不再触发生成动态工作流运行；触发
  关键词现在为 `ultracode`。记录于 `09-advanced-features/README.md`。

### 移除

- **`CLAUDE_CODE_OPUS_4_6_FAST_MODE_OVERRIDE` 现已成为空操作 (v2.1.160)** — 该
  环境变量已被移除，现在无效。`10-cli/README.md` 中环境变量表的
  措辞已从 "removed 2026-06-01" 更新为
  "Removed (no-op as of v2.1.160)"。

### 文档

- 修复了 `README.md` 中三处内部不一致的版本字符串（徽章和
  FAQ 文本滞留在 `2.1.145` / `v2.1.150`），并规范化了一个过期的 Sources
  链接。
- 将所有英文文档的元数据页脚统一更新至 **v2.1.160 / June 2, 2026**，以
  实现一致的同步。

## [v2.1.150] — 2026-05-25

### 同步至 Claude Code v2.1.150

将教程覆盖范围从 Claude Code v2.1.145 更新至 v2.1.150（2026 年 5 月 23 日
发布）。自上次同步以来，Anthropic 发布了五个补丁（v2.1.146 至 v2.1.150）。
最重要的变更是**将内置的 `/simplify`
技能重命名为 `/code-review`**（v2.1.146）——纯重命名，**无别名**，因此
旧名称不再有效。由于本仓库也附带了自己的本地
code-review 技能，因此目录被重命名为 `code-review-specialist`，以
避免遮蔽新的内置技能。其他亮点：`/usage` 现在按类别
细分费用，后台会话可以用 `Ctrl+T` 固定，
Markdown 渲染器支持 GFM 任务列表复选框，并新增了
`allowAllClaudeAiMcps` 托管设置。此次同步还追更了
四个模块的 README（`04-subagents`、`05-mcp`、`07-plugins`、
`09-advanced-features`），它们之前仍停留在 v2.1.143。

### 行为变更

- **`/simplify` 重命名为 `/code-review` (v2.1.146)**：内置的审查
  技能现在通过 `/code-review` 调用，并可接受可选的 effort 级别
  （例如 `/code-review high`）；传递 `--comment` 可将发现结果作为内联
  GitHub PR 评论发布（v2.1.147）。旧的 `/simplify` 名称不再有效——
  没有别名。已在 `01-slash-commands/README.md`、
  `03-skills/README.md`、`CATALOG.md`、`QUICK_REFERENCE.md` 和
  `claude_concepts_guide.md` 中更新。

### 变更

- **将仓库本地的 `code-review` 技能重命名为 `code-review-specialist`**，
  以避免与新的内置 `/code-review` 冲突。目录
  `03-skills/code-review/` → `03-skills/code-review-specialist/`，所有
  安装命令、目录树和交叉引用已在
  `README.md`、`QUICK_REFERENCE.md`、`INDEX.md`、`CATALOG.md`、
  `LEARNING-ROADMAP.md`、`claude_concepts_guide.md` 和 `03-skills/README.md` 中更新。
  添加了一条说明，解释了冲突以及如何避免遮蔽
  内置技能。

### 新增

- **`/usage` 按类别费用明细 (v2.1.149)** — 费用视图现在
  按类别（技能、子代理、插件和
  每个 MCP 服务器的费用）细分支出。文档见 `CATALOG.md` 和
  `claude_concepts_guide.md`。
- **固定的后台会话 — `Ctrl+T` (v2.1.147)** — 在
  `claude agents` 中固定一个会话可使其在空闲时保持活动状态，原地重启以应用
  Claude Code 更新，并在内存压力下仅
  在非固定会话之后才释放。文档见 `10-cli/README.md`。
- **GFM 任务列表复选框渲染 (v2.1.149)** — Markdown 渲染器现在
  将 `- [ ]` / `- [x]` 渲染为复选框。文档见
  `09-advanced-features/README.md`。
- **`allowAllClaudeAiMcps` 托管设置 (v2.1.149)** — 允许在
  组织范围内加载 claude.ai 云端 MCP 连接器。文档见
  `05-mcp/README.md`。

### 移除

- **Stop/SubagentStop 钩子输入字段 `background_tasks` 和 `session_crons`**
  — 已从 `06-hooks/README.md` 和 `resources.md` 中移除。这些字段来自
  v2.1.145 发布说明，但未在官方钩子
  参考页面中列出；移除以保持文档与已发布的
  参考一致。

### 文档

- 将四个模块 README 从 v2.1.143 追更至 v2.1.150：
  `04-subagents/README.md`、`05-mcp/README.md`、`07-plugins/README.md`、
  `09-advanced-features/README.md`。
- 将所有英文文档的元数据页脚统一更新至 **v2.1.150 / May 25, 2026**，以
  实现一致的同步。

## [v2.1.145] — 2026-05-20

### 同步至 Claude Code v2.1.145

将教程覆盖范围从 Claude Code v2.1.143 更新至 v2.1.145（2026 年 5 月 19 日
发布）。自上次同步以来，Anthropic 发布了两个补丁（v2.1.144 和 v2.1.145）。
亮点：`/extra-usage` 重命名为 `/usage-credits`，`/model`
默认变为仅限当前会话，三个新的内置技能（`/run`、`/verify`、
`/run-skill-generator`），Stop/SubagentStop 钩子输入字段
`background_tasks` 和 `session_crons`，用于脚本编写的 `claude agents --json`，
以及关闭裸环境变量 Bash 自动批准漏洞的安全修复。
此次同步还追更了六个根级参考文档
（`LEARNING-ROADMAP.md`、`QUICK_REFERENCE.md`、`INDEX.md`、`resources.md`、
`claude_concepts_guide.md`、`STYLE_GUIDE.md`），它们在
v2.1.143 同步中被遗漏，仍停留在 v2.1.138。

### 新增

- `/usage-credits` 斜杠命令 (v2.1.144) — 替代 `/extra-usage` 作为
  主要名称；`/extra-usage` 仍作为别名可用。文档见
  `01-slash-commands/README.md` 和 `CATALOG.md`。
- 三个新的内置技能 (v2.1.145) — `/run`（启动项目的应用以
  查看变更运行情况），`/verify`（构建、运行并观察应用以
  确认修复有效），`/run-skill-generator`（通过生成每个项目的技能来教 `/run`/`/verify` 如何
  处理特定项目）。文档见
  `03-skills/README.md`、`CATALOG.md` 和 `QUICK_REFERENCE.md`。将
  规范的内置技能数量提升至 **9** 个。
- Stop/SubagentStop 钩子输入字段 `background_tasks` 和 `session_crons`
  (v2.1.145) — 钩子作者可以读取这些字段，以决定是否在后台工作
  或计划任务仍待处理时阻止停止。文档见
  `06-hooks/README.md`。
- `claude agents --json` (v2.1.145) — 将代理列表打印为机器可读
  JSON，用于脚本编写（状态栏、会话选择器、tmux-resurrect）。
  文档见 `10-cli/README.md`。
- 摘要表中缺失的五行钩子事件 — `Setup`、
  `UserPromptExpansion`、`PermissionDenied`、`PostToolBatch`（叙述中
  已声称 "29 events"；`CATALOG.md`、
  `claude_concepts_guide.md` 和 `INDEX.md` 中的摘要表仅列出了 25 个）。

### 行为变更

- **`/model` 默认仅限当前会话 (v2.1.144)**：选择模型现在
  仅应用于当前会话；选择后按 `d` 可将该
  选择设为未来会话的新默认值。文档见
  `01-slash-commands/README.md`。
- **Bash 裸环境变量自动批准已关闭 (v2.1.145 安全修复)**：当
  仅 `FOO=bar` 在允许列表中时，`FOO=bar somecommand` 形式的
  命令不再被自动批准。通过覆盖完整命令的
  `Bash(...)`  权限规则显式重新允许此类命令。文档见
  `06-hooks/README.md`。
- **`context: fork` 无限循环修复 (v2.1.145)**：使用
  `context: fork` 的技能在极少数情况下可能触发无限重新调用循环。
  作为说明记录在 `03-skills/README.md` 中。

### 文档

- 将六个根级参考文档从 v2.1.138 追更至 v2.1.145：
  `LEARNING-ROADMAP.md`、`QUICK_REFERENCE.md`、`INDEX.md`、`resources.md`、
  `claude_concepts_guide.md`、`STYLE_GUIDE.md`。
- 修复了内置技能列表不一致的问题 — `CATALOG.md`、`QUICK_REFERENCE.md` 和
  `03-skills/README.md` 之前列出了三个不同的 5 项列表；
  统一为规范的 9 项（`/batch`、`/claude-api`、`/debug`、
  `/fewer-permission-prompts`、`/loop`、`/run`、`/run-skill-generator`、
  `/simplify`、`/verify`）。`QUICK_REFERENCE.md` 的单元格还错误地
  将 `/voice` 和 `/browse` 列为内置技能——两者都不是内置的。
- 将 `QUICK_REFERENCE.md` 和 `resources.md` 中的
  "New Features (March 2026)" 重命名为 "New Features (May 2026)"，以与仓库其余部分保持一致。
- 将 `README.md` 中的版本徽章从 `2.1.138` 更新至 `2.1.145`，并
  更新了正文中的两处 "latest: v2.1.138" 声明。
- 将 STYLE_GUIDE 示例元数据页脚从 `2.1.97` 更新至 `2.1.145`，
  以便贡献者复制当前版本。

## [v2.1.143] — 2026-05-19

### 同步至 Claude Code v2.1.143

将教程覆盖范围从 Claude Code v2.1.138 更新至 v2.1.143（2026 年 5 月 15 日
发布）。自上次同步以来，Anthropic 发布了五个补丁（v2.1.139–v2.1.143）。
亮点：`/goal` 和 `/scroll-speed` 斜杠命令，带有完整调度标志集的 `claude
agents` 代理视图（研究预览版），Stop
钩子安全上限，钩子 exec 形式（`args`），PostToolUse 的 `continueOnBlock`，
钩子 `terminalSequence` 输出，快速模式默认使用 Opus 4.7，
Windows 上 Bedrock/Vertex/Foundry 默认使用 PowerShell，以及
`worktree.bgIsolation` 设置。

### 新增

- `/goal <statement>` 斜杠命令 (v2.1.139) — 注册一个会话级别的
  完成条件，并带有一个实时覆盖面板，显示已用时间、轮次
  计数和 token 使用量。文档见 `01-slash-commands/README.md` 并
  在 `10-cli/README.md` 中交叉引用。
- `/scroll-speed <±N>` 斜杠命令 (v2.1.139) — 调整 TUI 实时预览
  滚动速度；每台机器持久保存。文档见
  `01-slash-commands/README.md`。
- `claude agents` 代理视图（研究预览版，v2.1.139），带有调度标志
  `--cwd` (v2.1.141)、`--add-dir`、`--settings`、`--mcp-config`、
  `--plugin-dir`、`--permission-mode`、`--model`、`--effort`、
  `--dangerously-skip-permissions` (v2.1.142)。文档见
  `10-cli/README.md`。
- `claude plugin details <name>` (v2.1.139) — 完整的插件清单以及
  预计的每轮次/每次调用 token 费用估算。LSP 服务器
  在 v2.1.142 中添加到详情面板。文档见 `07-plugins/README.md`。
- `/plugin` 浏览面板中的市场上下文费用预估 (v2.1.143)。
  文档见 `07-plugins/README.md`。
- 钩子 **exec 形式** (`args: string[]`, v2.1.139) — 直接 `execve()` 生成，
  无需 shell 解析；与 shell 形式的 `command`
  字段互斥。文档见 `06-hooks/README.md`。
- PostToolUse 上的钩子 `continueOnBlock: true` 字段 (v2.1.139) — 将
  被阻止的工具结果作为 `tool_result` 返回给 Claude，而不是中止
  本轮。文档见 `06-hooks/README.md`。
- 钩子 `terminalSequence` JSON 输出字段 (v2.1.141) — 发送原始 OSC 转义
  序列，用于桌面通知、窗口标题和铃声。文档见
  `06-hooks/README.md`。
- `worktree.bgIsolation: "none"` 设置 (v2.1.143) — 后台会话
  直接编辑当前工作副本，而不是隔离的工作树。
  文档见 `09-advanced-features/README.md`。
- `CLAUDE_PROJECT_DIR` 现在传递到每个 MCP stdio 服务器的环境
  (v2.1.139)，并且在插件
  和项目 `.mcp.json` 的 `command`/`args`/`env` 字段中支持 `${CLAUDE_PROJECT_DIR}` 替换。文档见
  `05-mcp/README.md`。
- 子代理 OTEL 头 `x-claude-code-agent-id` 和
  `x-claude-code-parent-agent-id` (v2.1.139)，作为
  `claude_code.llm_request` OTEL 跨度的
  `agent_id` / `parent_agent_id` 属性暴露。文档见 `04-subagents/README.md`。
- `CLAUDE_CODE_OPUS_4_6_FAST_MODE_OVERRIDE=1` (v2.1.142) — 将快速模式
  锁定回 Opus 4.6，因为 v2.1.142 默认切换为 Opus 4.7。文档见
  `10-cli/README.md`。
- `CLAUDE_CODE_USE_POWERSHELL_TOOL=0` 和
  `CLAUDE_CODE_POWERSHELL_RESPECT_EXECUTION_POLICY=1` (v2.1.143) — 退出
  默认启用的 PowerShell 工具，或使其遵循系统执行
  策略而非 `-ExecutionPolicy Bypass`。文档见
  `09-advanced-features/README.md`。
- `CLAUDE_CODE_STOP_HOOK_BLOCK_CAP` (v2.1.143) — 覆盖 Stop 钩子的 8 次连续
  阻止安全上限（设为 `0` 禁用）。文档见
  `06-hooks/README.md` 和 `09-advanced-features/README.md`。
- `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1` (v2.1.141) — 强制插件安装通过
  HTTPS 克隆 GitHub 插件源，适用于没有 SSH 密钥的 CI 运行器。
  文档见 `07-plugins/README.md`。
- `ANTHROPIC_WORKSPACE_ID` (v2.1.141) — 将联合工作负载身份
  令牌限定到特定工作区。文档见 `09-advanced-features/README.md`。
- 根级 `SKILL.md` 插件模式 (v2.1.142) — 仅有
  顶级 `SKILL.md`（无 `skills/` 子目录）的插件作为单个
  技能呈现。文档见 `07-plugins/README.md`。
- 插件营销名称 **Routines** 用于 `/schedule`（Anthropic 博客，
  2026-05-14）— 在 `09-advanced-features/README.md` 中作为一行说明
  呈现；CLI 界面保持为 `/schedule`。

### 行为变更

- **快速模式默认切换为 Opus 4.7 (v2.1.142)**：`/fast` 现在默认运行 Opus
  4.7（之前为 Opus 4.6）。设置 `CLAUDE_CODE_OPUS_4_6_FAST_MODE_OVERRIDE=1`
  可切换回去。
- **Windows 上 Bedrock/Vertex/Foundry 默认启用 PowerShell 工具
  (v2.1.143)**：Claude Code 使用 `-ExecutionPolicy Bypass` 调用 PowerShell。
  通过 `CLAUDE_CODE_POWERSHELL_RESPECT_EXECUTION_POLICY=1`（遵循
  系统策略）或 `CLAUDE_CODE_USE_POWERSHELL_TOOL=0`（禁用该工具）退出。
- **设置 API 密钥认证时，远程控制、`/schedule`、claude.ai MCP 连接器和通知
  偏好设置自动禁用 (v2.1.139)**：设置
  `ANTHROPIC_API_KEY`、`ANTHROPIC_AUTH_TOKEN` 或 `apiKeyHelper` 会禁用所有
  四个 claude.ai 桥接界面，即使 claude.ai 登录也处于活动状态。
- **Stop 钩子阻止循环上限为连续 8 次阻止 (v2.1.143)**：
  在连续 8 次后，会话以警告结束，防止有问题的 Stop 钩子
  永久循环会话。通过
  `CLAUDE_CODE_STOP_HOOK_BLOCK_CAP` 覆盖。
- **`subagent_type` 匹配现在不区分大小写和分隔符 (v2.1.140)**：
  `code-reviewer`、`Code Reviewer` 和 `code_reviewer` 都解析为
  相同的代理。文档见 `04-subagents/README.md`。

### 变更

- 根参考文档（`README.md`、`CATALOG.md`）从 `28 hook
  events` 更新为 `29 hook events` — 在 `Setup` 钩子于 v2.1.138 落地后，与 `06-hooks/README.md` 和
  `LEARNING-ROADMAP.md` 一致。

### 译者注意事项

- 教程翻译（`vi/`、`ja/`、`uk/`、`zh/`）跟随英文；同步
  本轮在模块 README 和上述 CHANGELOG 中的更改。页脚
  必须反映 `Last Updated: May 19, 2026` 和 `Claude Code Version: 2.1.143`。

## [v2.1.138] — 2026-05-09

### 同步至 Claude Code v2.1.138

将教程覆盖范围从 Claude Code v2.1.131 更新至 v2.1.138（2026 年 5 月 9 日
发布）。自上次同步以来，Anthropic 在 v2.1.132 和 v2.1.138 之间发布了七个补丁。

### 新增（英文文档）

- `worktree.baseRef` 设置 (v2.1.133) — 控制 `claude --worktree`
  是从 `origin/<default>`（`"fresh"`，默认）还是本地 `HEAD`
  （`"head"`）分支。**行为变更**：`"fresh"` 默认恢复了 v2.1.128
  的行为，因此依赖 v2.1.128 后本地 `HEAD` 分支的用户必须
  手动选择加入。文档见 `09-advanced-features/README.md`。
- `autoMode.hard_deny` 管理密钥 (v2.1.136) — 分类器规则数组，
  无论推断的用户意图如何，都阻止某类操作。用于
  绝对不能以自动模式运行的操作（例如 `rm -rf /`，推送到
  受保护分支的强制推送）。与 `soft_deny` 不同，hard-deny 规则对分类器而言不可协商。
  文档见 `09-advanced-features/README.md`。
- `parentSettingsBehavior` 管理密钥 (v2.1.133+，管理员级别) — 控制
  SDK 的 `managedSettings` 如何与父进程设置合并。
  `"first-wins"` 保持现有优先级；`"merge"` 深度合并值。
  文档见 `09-advanced-features/README.md`。
- `Setup` 钩子事件 — 初始环境设置（每次会话一次）；用于
  配置工具或安装依赖。将记录的钩子事件
  总数从 28 增加到 29。文档见 `06-hooks/README.md`。
- 钩子输入 JSON 中的 `effort.level` 字段 (v2.1.133) — 将活动
  的 effort 级别（`low`/`medium`/`high`/`xhigh`/`max`）暴露给钩子。文档见
  `06-hooks/README.md`。
- Bash 子进程中的 `CLAUDE_CODE_SESSION_ID` 环境变量
  (v2.1.132) — 与钩子输入
  JSON 中的 `session_id` 字段匹配的会话 UUID，用于关联 bash 日志与钩子遥测。文档见
  `06-hooks/README.md`。
- Bash 子进程中的 `CLAUDE_EFFORT` 环境变量 (v2.1.133) —
  活动的 effort 级别，与钩子输入 JSON 中的 `effort.level` 匹配。文档见
  `06-hooks/README.md`。
- `sandbox.bwrapPath` 和 `sandbox.socatPath` 设置 (v2.1.133+, Linux/WSL)
  — 将 Claude Code 指向 `bubblewrap` 和
  `socat` 的非标准安装位置。默认为 `$PATH` 查找。文档见
  `09-advanced-features/README.md`。
- `CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN` 环境变量 (v2.1.132)。
  文档见 `09-advanced-features/README.md`。
- `CLAUDE_CODE_ENABLE_FEEDBACK_SURVEY_FOR_OTEL` 环境变量
  (v2.1.136) — 为捕获 OpenTelemetry 数据的组织重新启用会话质量调查；
  在 OTEL 部署中默认关闭。
  文档见 `09-advanced-features/README.md`。

### 变更

- **行为变更**：计划模式现在无条件阻止所有文件写入
  (v2.1.136)，包括在 `permissions.allow` 中存在匹配的 `Edit(...)` 规则
  时。之前，宽松的 `Edit(...)` 规则可能会让
  写入在计划模式中通过；该绕过已被关闭。依赖
  旧行为的工作流必须在编辑前退出计划模式 (`Shift+Tab`)。
  文档见 `09-advanced-features/README.md`。
- 插件带空格的斜杠命令（例如 `/myplugin review`）现在解析为
  `/myplugin:review`。插件 `skills` 配置条目不再隐藏
  默认的 `skills/` 目录——两者合并。文档见
  `07-plugins/README.md`。
- MCP 服务器现在在 `/clear` 后持续存在 (v2.1.132+)。文档见
  `05-mcp/README.md`。
- 子代理通过 Skill 工具发现项目、用户和插件技能
  (v2.1.133)。文档见 `04-subagents/README.md`。
- 恢复计划模式会话时，`--permission-mode` 现在得到遵守
  (v2.1.132)。文档见 `09-advanced-features/README.md`。
- `CronList` 输出现在包括限定符和计划的提示
  正文 (v2.1.136)，因此您可以审计每个 cron 将运行什么而不需要
  打开它。文档见 `09-advanced-features/README.md`。

### 修复

- OAuth 刷新令牌并发刷新竞争条件。
- INDEX.md 计数漂移：Skills 28 → 16、Plugins 40 → 27、Hooks scripts
  8 → 9（从 markdown 内容树重新计数）。新的总数反映了
  仅 `.md` 的方法论，将计数范围限定为教程内容而非
  构建产物和配置。
- `CATALOG.md` (v2.1.118 → v2.1.138) 和
  `claude_concepts_guide.md` (v2.1.117 → v2.1.138) 中的过期源 URL。移除了概念指南中重复
  的旧版页脚。

### 翻译维护者注意事项

`vi/`、`zh/`、`uk/` 和 `ja/` 本地化树由社区维护，
可能滞后于英文源。同步翻译的贡献者应对照
本次发布中更新的英文文件进行差异比较。

## [v2.1.131] — 2026-05-06

### 同步至 Claude Code v2.1.131

将教程覆盖范围从 Claude Code v2.1.126 更新至 v2.1.131（2026 年 5 月 6 日
发布）。自上次同步以来，Anthropic 发布了 v2.1.128、v2.1.129 和 v2.1.131；
v2.1.127 和 v2.1.130 被跳过，从未公开发布。

### 新增（英文文档）

- `--plugin-url <url>` 标志 (v2.1.129) — 从
  URL 获取插件 `.zip` 存档以供当前会话使用。可重复使用。文档见
  `07-plugins/README.md`。
- `CLAUDE_CODE_FORCE_SYNC_OUTPUT` 环境变量 (v2.1.129) — 为自动检测遗漏的终端
  （例如 Emacs `eat`）强制同步输出。
  文档见 `10-cli/README.md` 和 `09-advanced-features/README.md`。
- `CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE` 环境变量 (v2.1.129) — 为
  Homebrew/WinGet 安装启用后台升级（通常不
  自动更新）。文档见 `10-cli/README.md` 和
  `09-advanced-features/README.md`。
- `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY` 环境变量 (v2.1.129) — 需要
  选择加入 `/v1/models` 网关发现（参见变更）。文档见
  `10-cli/README.md`。
- `disableRemoteControl` 设置 (v2.1.128) — 管理员可以通过托管/策略范围阻止
  `claude remote-control` 和 `/remote-control`。
  文档见 `09-advanced-features/README.md`。
- `--plugin-dir` 接受 `.zip` 存档 (v2.1.128) — 与目录
  输入并列。文档见 `07-plugins/README.md`。
- `skillOverrides` 接受 `"name-only"` 和 `"user-invocable-only"`
  (v2.1.129) — 除了之前的 `"on"`/`"off"`。文档见
  `03-skills/README.md`。

### 变更

- **行为变更**：网关 `/v1/models` 发现现在是**可选加入**
  (v2.1.129)。之前 (v2.1.126)，设置 `ANTHROPIC_BASE_URL` 会自动
  从网关的 `/v1/models` 端点填充 `/model`。从 v2.1.129 起，
  用户必须额外设置 `CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1`；
  没有该环境变量，`/model` 回退到内置的静态列表。
  文档见 `10-cli/README.md`。
- `/mcp` 显示每个服务器的工具数量，并可视化标记报告 0
  个工具的服务器 (v2.1.128)。文档见 `05-mcp/README.md`。
- 裸 `/color`（无参数）随机选择会话颜色 (v2.1.128)；显式的
  `/color <name|hex>` 继续设置特定颜色。文档见
  `01-slash-commands/README.md`。
- `--channels` 标志现在可与 API 密钥（控制台）认证一起使用
  (v2.1.128)。早期版本需要 Pro/Max OAuth。文档见
  `09-advanced-features/README.md`。
- Ctrl+R 历史记录选择器默认显示**所有项目中的所有提示**
  (v2.1.129)。在选择器内按 Ctrl+S 将范围缩小到当前
  项目。文档见 `09-advanced-features/README.md`。
- `/context` 不再将其 ASCII 可视化转储到对话中
  (v2.1.129)。可视化仅在 UI 中显示；每次
  调用不再消耗约 1.6k token。文档见 `09-advanced-features/README.md`。
- 拖放中的超大图像自动降采样 (v2.1.128) — 早期
  版本直接拒绝图像。

### 修复

- Windows 上的 VS Code 扩展激活 (v2.1.131)。
- Mantle 端点认证 (v2.1.131)。
- 1 小时提示缓存 TTL 不再被截断为 5 分钟 (v2.1.129)。
- stdin 负载大于 10 MB 时崩溃 (v2.1.128)。

### 翻译维护者注意事项

`vi/`、`zh/`、`uk/` 和 `ja/` 本地化树由社区维护，
可能滞后于英文源。同步翻译的贡献者应对照
本次发布中更新的英文文件进行差异比较。

## [v2.1.126] — 2026-05-02

### 同步至 Claude Code v2.1.126

将教程覆盖范围从 Claude Code v2.1.119 更新至 v2.1.126（2026 年 5 月 1 日发布）。
v2.1.120 在首次发布当天（2026-04-24）被回滚，但在修复了最初报告的回归问题后
于 2026-04-28 成功重新发布。
v2.1.124 和 v2.1.125 被 Anthropic 跳过，从未发布。

### 新增（英文文档）

- `claude project purge [path]` 子命令 (v2.1.126) — 删除项目的所有 Claude Code
  状态（转录记录、任务、调试日志、文件编辑历史、
  提示历史、`~/.claude.json` 条目）。支持 `--dry-run`、`-y/--yes`、
  `-i/--interactive`、`--all`。文档见 `10-cli/README.md`。
- `claude plugin prune` 子命令 (v2.1.121) — 移除孤立的自动安装
  插件依赖；`plugin uninstall --prune` 级联执行。文档见
  `07-plugins/README.md`。
- `claude ultrareview [target]` 子命令 (v2.1.120) — 从 CI/脚本
  非交互式运行 `/ultrareview`，将结果打印到 stdout，成功/失败
  时退出 0/1；支持 `--json` 和 `--timeout <minutes>`。文档见
  `10-cli/README.md`。
- `${CLAUDE_EFFORT}` 占位符可在技能内容中使用 (v2.1.120) —
  解析为当前的 effort 级别。文档见 `03-skills/README.md`。
- `alwaysLoad` MCP 服务器配置选项 (v2.1.121) — 当为 `true` 时，来自
  该服务器的所有工具跳过工具搜索延迟。文档见 `05-mcp/README.md`。
- `PostToolUse.hookSpecificOutput.updatedToolOutput` 现在适用于所有工具
  (v2.1.121)，之前仅限 MCP。文档见 `06-hooks/README.md`。
- `ANTHROPIC_BEDROCK_SERVICE_TIER` 环境变量 (v2.1.122) — 选择
  Bedrock 服务层级（`default`、`flex`、`priority`）。文档见
  `10-cli/README.md` 环境变量表。
- `--dangerously-skip-permissions` 扩展路径覆盖 (v2.1.121, v2.1.126)
  — 现在绕过对 `.claude/skills/`、`.claude/agents/`、
  `.claude/commands/`、`.claude/`、`.git/`、`.vscode/`、shell 配置文件写入的提示。
  灾难性删除命令（`rm -rf /` 等）仍然会提示。文档见
  `09-advanced-features/README.md` 权限模式部分。
- OAuth 代码粘贴回退 (v2.1.126) — 当浏览器回调无法到达
  localhost（WSL2、SSH、容器）时，`claude auth login` 接受粘贴到终端的 OAuth
  代码。文档见 `10-cli/README.md`。
- 输入筛选 `/skills` 菜单 (v2.1.121)。文档见 `03-skills/README.md`。
- `AI_AGENT` 环境变量 (v2.1.120) — 在子进程上设置，以便 `gh` 可以
  将流量归因于 Claude Code。文档见 `10-cli/README.md` 环境变量
  表。

### 变更

- `--from-pr` (v2.1.119) 和 `/resume` PR-URL 搜索 (v2.1.122) 现在都
  支持 GitHub、GitHub Enterprise、GitLab 和 Bitbucket URL。
- Windows：不再需要 Git for Windows / Git Bash (v2.1.120) — Claude
  Code 在没有 Git Bash 时使用 PowerShell 作为 shell 工具。从 v2.1.126 起，
  当启用 PowerShell 工具时，PowerShell 是主要 shell。检测
  扩展到通过 Microsoft Store、不带 PATH 的 MSI 或
  `.NET global tool` 安装的 PowerShell 7。文档见 `09-advanced-features/README.md` 平台
  说明。
- 当 `ANTHROPIC_BASE_URL` 指向 Anthropic 兼容网关时，
  `/model` 选择器现在从网关的 `/v1/models` 端点列出模型
  (v2.1.126)。文档见 `10-cli/README.md`。
- `--dangerously-skip-permissions` 不再对写入更广泛
  允许列表（参见新增）进行提示。灾难性删除仍然会提示。
- 图像粘贴自动降采样 (v2.1.126) — 大于 2000px 的图像
  在粘贴时降采样；历史记录中超大图像自动移除并
  重试请求。（仅作为安全/UX 说明与教程相关。）

### 安全

- 修复了当更高优先级托管设置源缺少 `sandbox` 块时，
  `allowManagedDomainsOnly` / `allowManagedReadPathsOnly` 被忽略的问题
  (v2.1.126)。

### 翻译维护者注意事项

`vi/`、`zh/`、`uk/` 和 `ja/` 本地化树由社区维护，
可能滞后于英文源。同步翻译的贡献者应对照
本次发布中更新的英文文件进行差异比较。

## [v2.4.0] — 2026-04-27

### 同步至 Claude Code v2.1.119

将教程覆盖范围从 Claude Code v2.1.112 更新至 v2.1.119（2026 年 4 月 23 日发布）。
v2.1.120 于 4 月 24 日发布，当天因回归问题短暂回滚，
并于 4 月 28 日带着修复重新发布——它现在是正常发布线的一部分。
后续的 v2.1.126（2026 年 5 月 1 日）是下一个稳定目标，已在上面的
v2.1.126 条目中涵盖。

### 新增（英文文档）

- 原生二进制打包说明 (v2.1.113) — CLI 现在提供按平台的原生二进制文件
- 原生 macOS/Linux 构建上的 `bfs`/`ugrep` Glob/Grep 替换脚注 (v2.1.117)
- 带示例的 `mcp_tool` 钩子类型 (v2.1.118)
- PostToolUse / PostToolUseFailure 输入上的 `duration_ms` 字段 (v2.1.119)
- `prUrlTemplate` 设置 (v2.1.119) 和扩展的 `--from-pr` 提供商列表（GitLab、Bitbucket）
- `cleanupPeriodDays` 扩展范围（检查点 + 任务 + shell 快照 + 备份，v2.1.117）
- 每个生命周期事件上的插件市场强制执行 (v2.1.117) 和 `hostPattern`/`pathPattern` 正则表达式 (v2.1.119)
- 新的环境变量：`DISABLE_UPDATES`、`CLAUDE_CODE_HIDE_CWD`、`CLAUDE_CODE_FORK_SUBAGENT`、`OTEL_LOG_TOOL_DETAILS`、`ENABLE_TOOL_SEARCH` Vertex 可选加入
- 新的斜杠命令：`/btw`、带自定义主题的 `/theme`
- `/usage` 规范命令（合并 `/cost` + `/stats`，v2.1.118）
- 分叉子代理 (`CLAUDE_CODE_FORK_SUBAGENT=1`，v2.1.117)
- 自动模式 `"$defaults"` 令牌 (v2.1.118)
- `wslInheritsWindowsSettings` 托管策略 (v2.1.118)
- Vim 可视 / 可视行模式 (v2.1.118)
- `claude install [version]` 和 `claude plugin tag` 子命令

### 变更

- 文档托管迁移：`docs.anthropic.com/en/docs/claude-code/*` → `code.claude.com/docs/en/*`
- Opus 4.7 effort 级别：自 2026-04-16 发布以来，`xhigh` 现在是 Claude Code 的默认值；Opus 4.7 原生上下文窗口确认为 1M（v2.1.117 修复了 `/context` 将其误计为 200K）
- 对于使用 Opus 4.6 / Sonnet 4.6 的 Pro/Max 订阅者，默认 effort 从 `medium` 提升到 `high` (v2.1.117)
- `STYLE_GUIDE.md` 源 URL 从 Claude Apps 文章更新为 `code.claude.com/docs/en/changelog`

### 弃用（已追踪，未移除）

- `includeCoAuthoredBy` 设置 → 使用 `attribution.commit` / `attribution.pr`
- `voiceEnabled` 设置 → 使用 `voice.enabled`

### 翻译维护者注意事项

`vi/`、`zh/` 和 `uk/` 本地化树由社区维护，可能滞后于英文源。同步翻译的贡献者应对照本次发布中更新的英文文件进行差异比较。

## v2.1.112 — 2026-04-16

### 亮点

- 将所有英语教程与 Claude Code v2.1.112 和新的 Opus 4.7 模型 (`claude-opus-4-7`) 同步，包括新的 `xhigh` effort 级别（Opus 4.7 上的默认值，介于 `high` 和 `max` 之间），两个新的内置斜杠命令（`/ultrareview`、`/less-permission-prompts`），自动模式对于使用 Opus 4.7 的 Max 订阅者不再需要 `--enable-auto-mode`，Windows 上的 PowerShell 工具，"Auto (match terminal)" 主题，以及以提示命名的计划文件。所有 18 个英文文档页脚更新至 Claude Code v2.1.112。@Luong NGUYEN

### 功能

- 在所有模块、根文档、示例和参考中添加完整的乌克兰语 (uk) 本地化 (039dde2) @Evgenij I

### Bug 修复

- 修正 pre-tool-check.sh 钩子协议错误 (bce7cf8) @yarlinghe
- 将有问题的 mermaid 示例改为文本块以通过 CI (b8a7b1f) @Evgenij I
- 修复乌克兰语 claude_concepts_guide.md 目录中的 CP1251 编码 (d970cc6) @Evgenij I
- 将存根乌克兰语 README 替换为完整翻译，修复断开的锚点 (f6d73e2) @Evgenij I
- 在所有页脚中将 Claude Code 版本更正为 2.1.97 (63a1416) @Luong NGUYEN
- 应用 2026-04-09 文档准确性更新 (e015f39) @Luong NGUYEN

### 文档

- 同步至 Claude Code v2.1.112（Opus 4.7、`xhigh` effort、`/ultrareview`、`/less-permission-prompts`、PowerShell 工具、Auto-match-terminal 主题）@Luong NGUYEN
- 同步至 Claude Code v2.1.110（TUI、推送通知、会话回顾）(15f0085) @Luong NGUYEN
- 同步至 Claude Code v2.1.101，包含 `/team-onboarding`、`/ultraplan`、Monitor 工具 (2deba3a) @Luong NGUYEN
- 将越南语文档与英文源同步 (561c6cb) @Thiên Toán
- 在所有文件中更新最后更新日期和 Claude Code 版本 (7f2e773) @Luong NGUYEN
- 向语言切换器添加乌克兰语链接 (9c224ff) @Luong NGUYEN
- 移除贡献者部分 (f07313d) @Luong NGUYEN
- 将 GitHub 指标更新至 21,800+ stars、2,585+ forks (4f55374) @Luong NGUYEN

**完整变更日志**：https://github.com/luongnv89/claude-howto/compare/v2.3.0...v2.1.112

---

## v2.3.0 — 2026-04-07

### 功能

- 按语言构建和发布 EPUB 产物 (90e9c30) @Thiên Toán
- 向 06-hooks 添加缺失的 pre-tool-check.sh 钩子 (b511ed1) @JiayuWang
- 在 zh/ 目录中添加中文翻译 (89e89d4) @Luong NGUYEN
- 添加 performance-optimizer 子代理和 dependency-check 钩子 (f53d080) @qk

### Bug 修复

- Windows Git Bash 兼容性 + stdin JSON 协议 (2cbb10c) @Luong NGUYEN
- 更正 08-checkpoints 中的 autoCheckpoint 配置文档 (749c79f) @JiayuWang
- 嵌入 SVG 图像而不是用占位符替换 (1b16709) @Thiên Toán
- memory README 中的嵌套代码围栏渲染 (ce24423) @Zhaoshan Duan
- 应用 squash 合并中遗漏的审查修复 (34259ca) @Luong NGUYEN
- 使钩子脚本与 Windows Git Bash 兼容并使用 stdin JSON 协议 (107153d) @binyu li

### 文档

- 将所有教程与最新 Claude Code 文档同步（2026 年 4 月）(72d3b01) @Luong NGUYEN
- 向语言切换器添加中文语言链接 (6cbaa4d) @Luong NGUYEN
- 添加英语和越南语之间的语言切换器 (100c45e) @Luong NGUYEN
- 添加 GitHub #1 Trending 徽章 (0ca8c37) @Luong NGUYEN
- 引入 cc-context-stats 用于上下文区域监控 (d41b335) @Luong NGUYEN
- 引入 luongnv89/skills 集合和 luongnv89/asm 技能管理器 (7e3c0b6) @Luong NGUYEN
- 更新 README 统计数据以反映当前 GitHub 指标（5,900+ stars、690+ forks）(5001525) @Luong NGUYEN
- 更新 README 统计数据以反映当前 GitHub 指标（3,900+ stars、460+ forks）(9cb92d6) @Luong NGUYEN

### 重构

- 将 Kroki HTTP 依赖替换为本地 mmdc 渲染 (e76bbe4) @Luong NGUYEN
- 将质量检查移至 pre-commit，CI 作为第二道关卡 (6d1e0ae) @Luong NGUYEN
- 缩小自动模式权限基线 (2790fb2) @Luong NGUYEN
- 将自动适配钩子替换为一次性权限设置脚本 (995a5d6) @Luong NGUYEN

### 其他

- 左移质量关卡 — 将 mypy 添加到 pre-commit，修复 CI 失败 (699fb39) @Luong NGUYEN
- 添加越南语 (Tiếng Việt) 本地化 (a70777e) @Thiên Toán

**完整变更日志**：https://github.com/luongnv89/claude-howto/compare/v2.2.0...v2.3.0

---

## v2.2.0 — 2026-03-26

### 文档

- 将所有教程和参考与 Claude Code v2.1.84 同步 (f78c094) @luongnv89
  - 将斜杠命令更新至 55+ 内置 + 5 个内置技能，标记 3 个为弃用
  - 将钩子事件从 18 扩展到 25，添加 `agent` 钩子类型（现在 4 种类型）
  - 向高级功能添加自动模式、Channels、语音听写
  - 添加 `effort`、`shell` 技能前置元数据字段；`initialPrompt`、`disallowedTools` 代理字段
  - 添加 WebSocket MCP 传输、启发式、2KB 工具上限
  - 添加插件 LSP 支持、`userConfig`、`${CLAUDE_PLUGIN_DATA}`
  - 更新所有参考文档（CATALOG、QUICK_REFERENCE、LEARNING-ROADMAP、INDEX）
- 将 README 重写为登录页结构指南 (32a0776) @luongnv89

### Bug 修复

- 添加缺失的 cSpell 单词和 README 部分以满足 CI 合规性 (93f9d51) @luongnv89
- 将 `Sandboxing` 添加到 cSpell 字典 (b80ce6f) @luongnv89

**完整变更日志**：https://github.com/luongnv89/claude-howto/compare/v2.1.1...v2.2.0

---

## v2.1.1 — 2026-03-13

### Bug 修复

- 移除导致 CI 链接检查失败的死市场链接 (3fdf0d6) @luongnv89
- 将 `sandboxed` 和 `pycache` 添加到 cSpell 字典 (dc64618) @luongnv89

**完整变更日志**：https://github.com/luongnv89/claude-howto/compare/v2.1.0...v2.1.1

---

## v2.1.0 — 2026-03-13

### 功能

- 添加自适应学习路径，包含自我评估和课程测验技能 (1ef46cd) @luongnv89
  - `/self-assessment` — 跨 10 个功能领域的交互式熟练度测验，提供个性化学习路径
  - `/lesson-quiz [lesson]` — 每课知识检查，包含 8-10 个针对性问题

### Bug 修复

- 更新损坏的 URL、弃用项和过时的引用 (8fe4520) @luongnv89
- 修复 resources 和自我评估技能中的损坏链接 (7a05863) @luongnv89
- 在概念指南中对嵌套代码块使用波浪线围栏 (5f82719) @VikalpP
- 向 cSpell 字典添加缺失的单词 (8df7572) @luongnv89

### 文档

- 第 5 阶段 QA — 修复跨文档的一致性、URL 和术语 (00bbe4c) @luongnv89
- 完成第 3-4 阶段 — 新功能覆盖和参考文档更新 (132de29) @luongnv89
- 将 MCPorter 运行时添加到 MCP 上下文膨胀部分 (ef52705) @luongnv89
- 在 6 个指南中添加缺失的命令、功能和设置 (4bc8f15) @luongnv89
- 基于现有仓库约定添加样式指南 (84141d0) @luongnv89
- 向指南比较表添加自我评估行 (8fe0c96) @luongnv89
- 将 VikalpP 添加到 PR #7 的贡献者列表 (d5b4350) @luongnv89
- 将自我评估和课程测验技能参考添加到 README 和路线图 (d5a6106) @luongnv89

### 新贡献者

- @VikalpP 在 #7 中首次贡献

**完整变更日志**：https://github.com/luongnv89/claude-howto/compare/v2.0.0...v2.1.0

---

## v2.0.0 — 2026-02-01

### 功能

- 将所有文档与 Claude Code 2026 年 2 月功能同步 (487c96d)
  - 跨所有 10 个教程目录和 7 个参考文档更新 26 个文件
  - 添加 **Auto Memory** 文档 — 每个项目的持久学习
  - 添加 **Remote Control**、**Web Sessions** 和 **Desktop App** 文档
  - 添加 **Agent Teams**（实验性多代理协作）文档
  - 添加 **MCP OAuth 2.0**、**Tool Search** 和 **Claude.ai Connectors** 文档
  - 添加子代理的 **Persistent Memory** 和 **Worktree Isolation** 文档
  - 添加 **Background Subagents**、**Task List**、**Prompt Suggestions** 文档
  - 添加 **Sandboxing** 和 **Managed Settings**（企业版）文档
  - 添加 **HTTP Hooks** 和 7 个新钩子事件文档
  - 添加 **Plugin Settings**、**LSP Servers** 和市场更新文档
  - 添加 **Summarize from Checkpoint** 回退选项文档
  - 记录 17 个新的斜杠命令（`/fork`、`/desktop`、`/teleport`、`/tasks`、`/fast` 等）
  - 记录新的 CLI 标志（`--worktree`、`--from-pr`、`--remote`、`--teleport`、`--teammate-mode` 等）
  - 记录用于自动记忆、effort 级别、代理团队等的新环境变量

### 设计

- 将 logo 重新设计为极简调色板的指南针-括号标记 (20779db)

### Bug 修复 / 更正

- 更新模型名称：Sonnet 4.5 → **Sonnet 4.6**，Opus 4.5 → **Opus 4.6**
- 修复权限模式名称：将虚构的 "Unrestricted/Confirm/Read-only" 替换为实际的 `default`/`acceptEdits`/`plan`/`dontAsk`/`bypassPermissions`
- 修复钩子事件：移除虚构的 `PreCommit`/`PostCommit`/`PrePush`，添加真实事件（`SubagentStart`、`WorktreeCreate`、`ConfigChange` 等）
- 修复 CLI 语法：将 `claude-code --headless` 替换为 `claude -p`（打印模式）
- 修复检查点命令：将虚构的 `/checkpoint save/list/rewind/diff` 替换为实际的 `Esc+Esc` / `/rewind` 界面
- 修复会话管理：将虚构的 `/session list/new/switch/save` 替换为真实的 `/resume`/`/rename`/`/fork`
- 修复插件清单格式：迁移 `plugin.yaml` → `.claude-plugin/plugin.json`
- 修复 MCP 配置路径：`~/.claude/mcp.json` → `.mcp.json`（项目）/ `~/.claude.json`（用户）
- 修复文档 URL：`docs.claude.com` → `docs.anthropic.com`；移除虚构的 `plugins.claude.com`
- 移除跨多个文件的虚构配置字段
- 将所有 "Last Updated" 日期更新为 2026 年 2 月

**完整变更日志**：https://github.com/luongnv89/claude-howto/compare/20779db...v2.0.0
