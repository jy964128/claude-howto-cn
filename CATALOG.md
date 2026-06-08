<picture>
  <source media="(prefers-color-scheme: dark)" srcset="resources/logos/claude-howto-logo-dark.svg">
  <img alt="Claude How To" src="resources/logos/claude-howto-logo.svg">
</picture>

# Claude Code 功能目录

> Claude Code 所有功能的快速参考指南：命令、智能体、技能、插件和钩子。

**导航**：[命令](#斜杠命令) | [权限模式](#权限模式) | [子智能体](#子智能体) | [技能](#技能) | [插件](#插件) | [MCP 服务器](#mcp-服务器) | [钩子](#钩子) | [记忆](#记忆文件) | [新功能](#新功能-2026-年-5-月)

---

## 摘要

| 功能 | 内置 | 示例 | 总计 | 参考 |
|---------|----------|----------|-------|-----------|
| **斜杠命令** | 60+ | 8 | 68+ | [01-slash-commands/](01-slash-commands/) |
| **子智能体** | 6 | 11 | 17 | [04-subagents/](04-subagents/) |
| **技能** | 9 个内置 | 6 | 15 | [03-skills/](03-skills/) |
| **插件** | - | 3 | 3 | [07-plugins/](07-plugins/) |
| **MCP 服务器** | 1 | 8 | 9 | [05-mcp/](05-mcp/) |
| **钩子** | 29 个事件 | 8 | 8 | [06-hooks/](06-hooks/) |
| **记忆** | 7 种类型 | 3 | 3 | [02-memory/](02-memory/) |
| **总计** | **103** | **47** | **125** | |

---

## 斜杠命令

命令是用户调用的快捷方式，用于执行特定操作。

### 内置命令

| 命令 | 描述 | 使用场景 |
|---------|-------------|-------------|
| `/help` | 显示帮助信息 | 入门，学习命令 |
| `/btw` | 临时附带问题——不污染主上下文 | 快速偏离主题的问题 |
| `/chrome` | 配置 Chrome 集成 | 浏览器自动化 |
| `/clear` | 清除对话历史 | 重新开始，减少上下文 |
| `/diff` | 交互式差异查看器 | 审查更改 |
| `/config` | 查看/编辑配置 | 自定义行为 |
| `/status` | 显示会话状态 | 检查当前状态 |
| `/agents` | 列出可用智能体 | 查看委托选项 |
| `/skills` | 列出可用技能 | 查看自动调用能力 |
| `/hooks` | 列出已配置钩子 | 调试自动化 |
| `/insights` | 分析会话模式 | 会话优化 |
| `/install-slack-app` | 安装 Claude Slack 应用 | Slack 集成 |
| `/keybindings` | 自定义键盘快捷键 | 按键自定义 |
| `/mcp` | 列出 MCP 服务器 | 检查外部集成 |
| `/memory` | 查看已加载的记忆文件 | 调试上下文加载 |
| `/mobile` | 生成移动端二维码 | 移动端访问 |
| `/passes` | 查看使用通行证 | 订阅信息 |
| `/plugin` | 管理插件 | 安装/移除扩展 |
| `/plan` | 进入计划模式 | 复杂实现 |
| `/proactive` | `/loop` 的别名（v2.1.105） | 同 `/loop` |
| `/recap` | 返回会话时显示会话摘要 | 离开后获取已完成内容的上下文 |
| `/rewind` | 回退到检查点 | 撤销更改，探索替代方案 |
| `/checkpoint` | 管理检查点 | 保存/恢复状态 |
| `/cost` | 打开 `/usage` 费用标签页的快捷别名（v2.1.118+） | 监控支出 |
| `/context` | 显示上下文窗口使用情况 | 管理对话长度 |
| `/export` | 导出对话 | 保存参考 |
| `/usage-credits` | 配置额外用量限制（v2.1.144 从 `/extra-usage` 重命名；旧名称仍作为别名有效） | 速率限制管理 |
| `/feedback` | 提交反馈或错误报告 | 报告问题 |
| `/login` | 向 Anthropic 认证 | 访问功能 |
| `/logout` | 退出登录 | 切换账户 |
| `/sandbox` | 切换沙箱模式 | 安全的命令执行 |
| `/doctor` | 运行诊断 | 排查问题 |
| `/reload-plugins` | 重新加载已安装的插件 | 插件管理 |
| `/reload-skills` | 无需重启即可重新扫描技能目录（v2.1.152） | 技能管理 |
| `/workflows` | 查看运行中和已完成的动态工作流运行（v2.1.154） | 多智能体编排 |
| `/release-notes` | 显示发布说明 | 查看新功能 |
| `/remote-control` | 启用远程控制 | 远程访问 |
| `/permissions` | 管理权限 | 控制访问 |
| `/session` | 管理会话 | 多会话工作流 |
| `/rename` | 重命名当前会话 | 组织会话 |
| `/resume` | 恢复之前的会话 | 继续工作 |
| `/todo` | 查看/管理待办列表 | 追踪任务 |
| `/tui` | 切换全屏 TUI（文本用户界面）模式 | 全屏/tmux 中无闪烁渲染 |
| `/tasks` | 查看后台任务 | 监控异步操作 |
| `/copy` | 复制上一条回复到剪贴板 | 快速分享输出 |
| `/teleport` | 将会话传输到另一台机器 | 远程继续工作 |
| `/desktop` | 打开 Claude 桌面应用 | 切换到桌面界面 |
| `/theme` | 更改颜色主题 | 自定义外观 |
| `/usage` | 用量/费用/统计的规范命令（v2.1.118 合并了 `/cost` 和 `/stats`） | 监控配额和费用 |
| `/focus` | 切换专注视图（无干扰输出显示） | 在长任务中减少视觉噪音 |
| `/fork` | 分叉当前对话 | 探索替代方案 |
| `/stats` | 打开 `/usage` 统计标签页的快捷别名（v2.1.118+） | 查看会话指标 |
| `/statusline` | 配置状态栏 | 自定义状态显示 |
| `/stickers` | 查看会话贴纸 | 趣味奖励 |
| `/fast` | 切换快速输出模式 | 加速响应 |
| `/terminal-setup` | 配置终端集成 | 设置终端功能 |
| `/undo` | `/rewind` 的别名（v2.1.108） | 同 `/rewind` |
| `/upgrade` | 检查更新 | 版本管理 |
| `/team-onboarding` | 从项目的 Claude Code 使用情况生成队友入职指南 | 新队友入职（v2.1.101） |
| `/ultraplan` | 将计划任务交给计划模式下的 Claude Code Web 会话 | 重型计划卸载（研究预览，v2.1.91+） |
| `/ultrareview` | 对你的当前更改运行云端多智能体代码审查 | 跨多智能体的深度合并前审查（v2.1.112） |
| `/less-permission-prompts` | 扫描对话记录并为常用只读工具提出优先允许列表 | 减少项目中的重复权限提示（v2.1.112） |

### 自定义命令（示例）

| 命令 | 描述 | 使用场景 | 范围 | 安装 |
|---------|-------------|-------------|-------|--------------|
| `/optimize` | 分析代码优化 | 性能改进 | 项目 | `cp 01-slash-commands/optimize.md .claude/commands/` |
| `/pr` | 准备 Pull Request | 提交 PR 前 | 项目 | `cp 01-slash-commands/pr.md .claude/commands/` |
| `/generate-api-docs` | 生成 API 文档 | 文档化 API | 项目 | `cp 01-slash-commands/generate-api-docs.md .claude/commands/` |
| `/commit` | 创建带上下文的 git 提交 | 提交更改 | 用户 | `cp 01-slash-commands/commit.md .claude/commands/` |
| `/push-all` | 暂存、提交和推送 | 快速部署 | 用户 | `cp 01-slash-commands/push-all.md .claude/commands/` |
| `/doc-refactor` | 重构文档结构 | 改进文档 | 项目 | `cp 01-slash-commands/doc-refactor.md .claude/commands/` |
| `/setup-ci-cd` | 设置 CI/CD 流水线 | 新项目 | 项目 | `cp 01-slash-commands/setup-ci-cd.md .claude/commands/` |
| `/unit-test-expand` | 扩展测试覆盖率 | 改进测试 | 项目 | `cp 01-slash-commands/unit-test-expand.md .claude/commands/` |

> **范围**：`用户` = 个人工作流（`~/.claude/commands/`），`项目` = 团队共享（`.claude/commands/`）

---

## 权限模式

Claude Code 支持 6 种权限模式，控制工具使用的授权方式。

| 模式 | 描述 | 使用场景 |
|------|-------------|-------------|
| `default` | 每次工具调用都提示 | 标准交互使用 |
| `acceptEdits` | 自动接受文件编辑，其他提示 | 受信任的编辑工作流 |
| `plan` | 仅只读工具，无写入 | 计划和探索 |
| `auto` | 接受所有工具而不提示 | 完全自主操作（研究预览） |
| `bypassPermissions` | 跳过所有权限检查 | CI/CD、无头环境 |
| `dontAsk` | 跳过需要权限的工具 | 非交互式脚本 |

---

## 子智能体

具有隔离上下文的专业 AI 助手，用于特定任务。

### 内置子智能体

| 智能体 | 描述 | 工具 | 模型 | 使用场景 |
|-------|-------------|-------|-------|-------------|
| **general-purpose** | 多步骤任务、研究 | 所有工具 | 继承模型 | 复杂研究、多文件任务 |
| **Plan** | 实现计划 | Read、Glob、Grep、Bash | 继承模型 | 架构设计、计划 |
| **Explore** | 代码库探索 | Read、Glob、Grep | Haiku 4.5 | 快速搜索、理解代码 |
| **Bash** | 命令执行 | Bash | 继承模型 | Git 操作、终端任务 |
| **statusline-setup** | 状态栏配置 | Bash、Read、Write | Sonnet 4.6 | 配置状态栏显示 |
| **Claude Code Guide** | 帮助和文档 | Read、Glob、Grep | Haiku 4.5 | 获取帮助、学习功能 |

### 自定义子智能体（示例）

| 智能体 | 描述 | 使用场景 | 安装 |
|-------|-------------|-------------|--------------|
| `code-reviewer` | 全面代码质量 | 代码审查会话 | `cp 04-subagents/code-reviewer.md .claude/agents/` |
| `test-engineer` | 测试策略和覆盖率 | 测试计划 | `cp 04-subagents/test-engineer.md .claude/agents/` |
| `documentation-writer` | 技术文档 | API 文档、指南 | `cp 04-subagents/documentation-writer.md .claude/agents/` |
| `secure-reviewer` | 安全审查 | 安全审计 | `cp 04-subagents/secure-reviewer.md .claude/agents/` |
| `implementation-agent` | 完整功能实现 | 功能开发 | `cp 04-subagents/implementation-agent.md .claude/agents/` |
| `debugger` | 根因分析 | Bug 调查 | `cp 04-subagents/debugger.md .claude/agents/` |
| `data-scientist` | SQL 查询、数据分析 | 数据任务 | `cp 04-subagents/data-scientist.md .claude/agents/` |
| `clean-code-reviewer` | 整洁代码原则审查 | 可维护性审查 | `cp 04-subagents/clean-code-reviewer.md .claude/agents/` |
| `performance-optimizer` | 性能分析与调优 | 瓶颈调查 | `cp 04-subagents/performance-optimizer.md .claude/agents/` |

---

## 技能

带有指令、脚本和模板的自动调用能力。

| 技能 | 描述 | 自动调用触发 | 安装 |
|-------|-------------|-------------------|--------------|
| `code-review-specialist` | 全面代码审查 | "审查这段代码"、"检查质量" | `cp -r 03-skills/code-review-specialist .claude/skills/` |
| `brand-voice` | 品牌一致性检查 | 编写营销文案 | `cp -r 03-skills/brand-voice .claude/skills/` |
| `doc-generator` | API 文档生成器 | "生成文档"、"文档化 API" | `cp -r 03-skills/doc-generator .claude/skills/` |
| `refactor` | 系统化代码重构（Martin Fowler） | "重构这个"、"清理代码" | `cp -r 03-skills/refactor ~/.claude/skills/` |

### 内置技能

| 技能 | 描述 | 自动调用触发 |
|-------|-------------|-------------------|
| `/batch` | 对多个文件运行提示 | 批量操作 |
| `/claude-api` | 使用 Claude API 构建应用 | API 开发 |
| `/debug` | 调试失败的测试/错误 | 调试会话 |
| `/fewer-permission-prompts` | 扫描记录并提出允许列表 | 减少重复权限提示 |
| `/loop` | 按间隔运行提示 | 定期任务 |
| `/run` | 启动项目应用查看更改 | 验证实际应用中的更改 |
| `/code-review` | 审查当前差异中的正确性错误 | 编码后、提交 PR 前 |
| `/simplify` | 仅清理审查（复用/简化/效率） | 整理代码而不查找错误 |
| `/verify` | 构建、运行和观察应用以确认修复 | 端到端验证修复 |

---

## 插件

命令、智能体、MCP 服务器和钩子的打包集合。

| 插件 | 描述 | 组件 | 安装 |
|--------|-------------|------------|--------------|
| `pr-review` | PR 审查工作流 | 3 命令、3 智能体、GitHub MCP | `/plugin install pr-review` |
| `devops-automation` | 部署和监控 | 4 命令、3 智能体、K8s MCP | `/plugin install devops-automation` |
| `documentation` | 文档生成套件 | 4 命令、3 智能体、模板 | `/plugin install documentation` |

---

## MCP 服务器

用于外部工具和 API 访问的模型上下文协议服务器。

| 服务器 | 描述 | 安装 |
|--------|-------------|--------------|
| **GitHub** | PR 管理、Issues、代码 | `claude mcp add github -- npx -y @modelcontextprotocol/server-github` |
| **数据库** | SQL 查询、数据访问 | `claude mcp add db -- npx -y @modelcontextprotocol/server-postgres` |
| **文件系统** | 高级文件操作 | `claude mcp add fs -- npx -y @modelcontextprotocol/server-filesystem` |
| **Memory** | 持久化记忆 | 在设置中配置 |
| **Context7** | 库文档查找 | 内置 |

---

## 钩子

在 Claude Code 事件上执行 Shell 命令的事件驱动自动化。

包含 29 个事件，涵盖 PreToolUse、PostToolUse、SessionStart、UserPromptSubmit、Notification、SubagentStart、Stop 等。

配置示例：
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "command": "~/.claude/hooks/validate-bash.py"
    }]
  }
}
```

---

## 记忆文件

跨会话自动加载的持久化上下文。

| 类型 | 位置 | 范围 |
|------|----------|-------|
| **托管策略** | 组织管理 | 组织 |
| **项目** | `./CLAUDE.md` | 项目（团队） |
| **项目规则** | `.claude/rules/` | 项目（团队） |
| **用户** | `~/.claude/CLAUDE.md` | 用户（个人） |
| **用户规则** | `~/.claude/rules/` | 用户（个人） |
| **本地** | `./CLAUDE.local.md` | 本地（git 忽略） |
| **自动记忆** | 自动 | 会话 |

---

## 一键安装

```bash
mkdir -p .claude/{commands,agents,skills} ~/.claude/{hooks,skills}
cp 01-slash-commands/*.md .claude/commands/ && \
cp 02-memory/project-CLAUDE.md ./CLAUDE.md && \
cp -r 03-skills/* ~/.claude/skills/ && \
cp 04-subagents/*.md .claude/agents/ && \
cp 06-hooks/*.sh ~/.claude/hooks/ && \
chmod +x ~/.claude/hooks/*.sh
```

---

**最后更新**：2026 年 6 月 2 日
**Claude Code 版本**：2.1.160
**兼容模型**：Claude Sonnet 4.6、Claude Opus 4.8、Claude Haiku 4.5
