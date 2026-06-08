# 📚 Claude Code 详细学习计划

> 基于 [claude-howto](https://github.com/luongnv89/claude-howto) 教程体系，针对 vmark 项目实战场景定制。
>
> **前提条件**：已安装 Claude Code 2.1+，已克隆 claude-howto 仓库。
> **总学时**：约 11-13 小时，分三周完成。

---

## 目录

1. [第 0 步：水平自测](#第-0-步水平自测)
2. [第一周：基础提效（3 小时）](#第一周基础提效3-小时)
3. [第二周：自动化工作流（5 小时）](#第二周自动化工作流5-小时)
4. [第三周：高级能力（5 小时）](#第三周高级能力5-小时)
5. [vmark 实战路线图](#vmark-实战路线图)
6. [每日学习清单](#每日学习清单)
7. [进度追踪表](#进度追踪表)

---

## 第 0 步：水平自测

在 Claude Code 中运行：

```
/self-assessment
```

选择 **Quick 模式**（2 分钟），回答 8 道自测题：

| 自测题 | 我的答案 |
|--------|---------|
| 能启动 Claude Code 并进行对话 (`claude`) | ☐ |
| 创建或编辑过 CLAUDE.md 文件 | ☐ |
| 使用过至少 3 个内置斜杠命令 | ☐ |
| 创建过自定义斜杠命令或技能 (SKILL.md) | ☐ |
| 配置过 MCP 服务器（如 GitHub、数据库） | ☐ |
| 在 ~/.claude/settings.json 中配置过钩子 | ☐ |
| 创建或使用过自定义子智能体 | ☐ |
| 使用过打印模式 (`claude -p`) 进行脚本或 CI/CD | ☐ |

**根据勾选数定位起点：**

| 勾选数 | 水平 | 从哪开始 | 预计学时 |
|--------|------|---------|---------|
| 0-2 | 🟢 初级 | [第一周](#第一周基础提效3-小时) | ~3h |
| 3-5 | 🔵 中级 | [第二周](#第二周自动化工作流5-小时) | ~5h |
| 6-8 | 🔴 高级 | [第三周](#第三周高级能力5-小时) | ~5h |

---

## 第一周：基础提效（3 小时）

> **目标**：熟练使用斜杠命令和记忆，日常编码效率翻倍
> **关键词**：快捷操作、持久化上下文、安全实验、CLI 基础

---

### 第 1 天（30 分钟）— 斜杠命令

**学习内容**：用户手动调用的快捷方式，存储在 `.claude/commands/*.md`

**阅读**：`claude-howto/01-slash-commands/README.md`

**动手练习**：

```bash
# 1. 创建命令目录
mkdir -p .claude/commands

# 2. 安装常用命令
cp claude-howto/01-slash-commands/optimize.md .claude/commands/
cp claude-howto/01-slash-commands/pr.md .claude/commands/
cp claude-howto/01-slash-commands/commit.md .claude/commands/

# 3. 在 Claude Code 中测试
# /optimize        → 分析代码性能瓶颈
# /pr              → 准备 Pull Request
# /commit          → 自动生成规范的 commit message
```

**vmark 实战**：
```
/optimize              → 分析 src/stores/ 中的 Zustand store 性能
/commit                → 生成符合 conventional commits 格式的提交信息
```

**✅ 验收标准**：
- [ ] 成功调用 `/optimize` 命令
- [ ] 理解斜杠命令存储位置和格式

---

### 第 2 天（45 分钟）— 项目记忆

**学习内容**：跨会话的持久化上下文，Claude 自动加载

**阅读**：`claude-howto/02-memory/README.md`

**动手练习**：

```bash
# 1. 安装项目记忆模板
cp claude-howto/02-memory/project-CLAUDE.md ./CLAUDE.md

# 2. 针对 vmark 编辑 CLAUDE.md
# 参考 claude-howto/02-memory/project-CLAUDE.md 的结构，
# 填入 vmark 的实际信息
```

**vmark 专属 CLAUDE.md 要点**：

```markdown
# CLAUDE.md — vmark 项目记忆

## 技术栈
- 前端：React 19, Zustand v5, Tailwind v4, shadcn/ui v4
- 后端：Rust, Tauri v2
- 测试：Vitest v4
- 包管理：pnpm

## 关键命令
- 质量关卡：pnpm check:all
- 单元测试：pnpm test
- 类型检查：pnpm typecheck

## 编码规范
- 文件不超过 300 行
- Zustand store 不准解构，使用 selectors
- 回调中使用 useXStore.getState()
- 所有用户可见字符串使用 t() 或 t!() 国际化
- TDD 强制：新行为必须先写失败测试
```

**✅ 验收标准**：
- [ ] CLAUDE.md 已创建并包含 vmark 技术栈信息
- [ ] Claude 对话中能自动参照项目规范

---

### 第 3 天（30 分钟）— CLI 基础

**学习内容**：交互模式 vs 打印模式、管道输入、JSON 输出

**阅读**：`claude-howto/10-cli/README.md`

**动手练习**：

```bash
# 1. 打印模式（非交互，适合 CI/CD）
claude -p "分析 vmark 项目架构"

# 2. 管道输入
cat src-tauri/src/lib.rs | claude -p "解释这个文件的职责"

# 3. JSON 输出（供脚本消费）
claude -p --output-format json "列出 src/ 下所有模块及其用途"

# 4. 指定模型
claude --model haiku -p "快速总结 README.md"     # 又快又便宜
claude --model opus -p "审查认证模块的安全性"     # 深度分析
```

**vmark 实战**：
```bash
# 快速代码审查
git diff HEAD~1 | claude -p "审查这些变更，重点检查 TDD 和 i18n"

# 日志分析
cat tauri.log | claude -p "解释这些错误日志"
```

**✅ 验收标准**：
- [ ] 使用过交互模式和打印模式
- [ ] 成功通过管道传递文件给 Claude 分析
- [ ] 理解 `--model` 和 `--output-format` 参数

---

### 第 4 天（45 分钟）— 检查点

**学习内容**：会话快照、回退、安全实验

**阅读**：`claude-howto/08-checkpoints/README.md`

**动手练习**：

```
1. 在 Claude Code 中对代码做一次实验性修改
2. 修改后觉得不满意
3. 按 Esc+Esc 或输入 /rewind
4. 从菜单选择：
   - 恢复代码和对话
   - 恢复对话
   - 恢复代码
   - 从这里总结
   - 算了
```

**vmark 实战场景**：
- 尝试不同的 Tauri IPC 架构方案，不行就回退
- 比较两种 Zustand store 拆分的优劣
- A/B 测试不同 UI 布局

**✅ 验收标准**：
- [ ] 成功创建并回退到检查点
- [ ] 理解何时使用检查点进行安全实验

---

### 第 5 天（30 分钟）— 复习 + 测验

```
# 在 Claude Code 中运行
/lesson-quiz slash-commands
/lesson-quiz memory
/lesson-quiz cli
/lesson-quiz checkpoints
```

**全部通过 → 进入第二周！**

---

## 第二周：自动化工作流（5 小时）

> **目标**：让 Claude 自动执行代码审查、质量检查等重复工作
> **关键词**：自动触发、事件驱动、外部集成、任务委托

---

### 第 6 天（1 小时）— 技能系统

**学习内容**：自动调用的可复用能力，带 YAML 前置元数据

**阅读**：`claude-howto/03-skills/README.md`

**动手练习**：

```bash
# 1. 安装代码审查技能（个人）
cp -r claude-howto/03-skills/code-review-specialist ~/.claude/skills/

# 2. 安装重构技能
cp -r claude-howto/03-skills/refactor ~/.claude/skills/

# 3. 安装文档生成技能
cp -r claude-howto/03-skills/doc-generator ~/.claude/skills/

# 4. 验证安装
# 在 Claude Code 中运行
/skills
```

**测试自动调用**：
```
在 Claude Code 中说：
"Review this code for security issues"    → code-review-specialist 自动触发
"Refactor the settings store"             → refactor 自动触发
"Generate API docs for the auth module"   → doc-generator 自动触发
```

**vmark 实战**：
- 每次代码审查前，Claude 自动使用 `code-review-specialist`
- 重构 Zustand store 时，`refactor` 技能提供系统化方法

**✅ 验收标准**：
- [ ] 至少一个技能安装成功
- [ ] 技能在相关请求时自动触发
- [ ] 理解 SKILL.md 的 frontmatter 结构

---

### 第 7 天（1 小时）— 钩子系统

**学习内容**：事件驱动的自动化，5 种类型，29 个事件

**阅读**：`claude-howto/06-hooks/README.md`

**动手练习**：

```bash
# 1. 创建钩子目录
mkdir -p ~/.claude/hooks

# 2. 安装示例钩子
cp claude-howto/06-hooks/format-code.sh ~/.claude/hooks/
cp claude-howto/06-hooks/pre-commit.sh ~/.claude/hooks/
cp claude-howto/06-hooks/security-scan.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh
```

**配置 ~/.claude/settings.json**：

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [{
          "type": "command",
          "command": "~/.claude/hooks/format-code.sh"
        }]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [{
          "type": "command",
          "command": "~/.claude/hooks/security-scan.sh"
        }]
      }
    ]
  }
}
```

**5 种钩子类型**：

| 类型 | 用途 | 示例 |
|------|------|------|
| `command` | 执行 Shell 命令 | 代码格式化、安全检查 |
| `http` | 调用外部 API | 发送 Slack 通知 |
| `mcp_tool` | 调用 MCP 工具 | 触发 GitHub Action |
| `prompt` | 注入提示文本 | 在每个响应前添加提醒 |
| `agent` | 启动子智能体 | 自动委托安全审查 |

**vmark 实战**：参考 vmark 已有的 `.claude/hooks/gha-tdd-guard.mjs`，增强：
- 写入 `.tsx` 文件前自动检查是否有对应测试文件
- 写入 Rust 文件前自动运行 `cargo fmt`

**✅ 验收标准**：
- [ ] 至少配置了一个钩子
- [ ] 钩子在对应事件触发时正确执行
- [ ] 理解 5 种钩子类型的区别

---

### 第 8 天（1 小时）— MCP 集成

**学习内容**：模型上下文协议，实时访问外部工具和 API

**阅读**：`claude-howto/05-mcp/README.md`

**动手练习**：

```bash
# 1. 设置 GitHub MCP
export GITHUB_TOKEN="your_github_token"
claude mcp add github -- npx -y @modelcontextprotocol/server-github

# 2. 验证连接
# 在 Claude Code 中：
/mcp                            → 查看已连接的 MCP 服务器
/mcp__github__list_prs          → 列出 vmark 的 PR

# 3. 查看 MCP 配置示例
cat claude-howto/05-mcp/github-mcp.json
cat claude-howto/05-mcp/multi-mcp.json
```

**vmark 实战**：
- GitHub MCP：在 Claude Code 中直接查看/管理 vmark 的 PR 和 Issue
- 已有 Tauri MCP：vmark 已配置 `tauri-plugin-mcp-bridge`（端口 9323）

**✅ 验收标准**：
- [ ] GitHub MCP 连接成功
- [ ] 能从 Claude Code 中查询 GitHub 数据
- [ ] 理解 MCP 的配置方式（项目 `.mcp.json` vs 用户 `~/.claude.json`）

---

### 第 9 天（1.5 小时）— 子智能体

**学习内容**：具隔离上下文的专业 AI 助手，自动委托

**阅读**：`claude-howto/04-subagents/README.md`

**动手练习**：

```bash
# 1. 安装子智能体
mkdir -p .claude/agents
cp claude-howto/04-subagents/code-reviewer.md .claude/agents/
cp claude-howto/04-subagents/test-engineer.md .claude/agents/
cp claude-howto/04-subagents/secure-reviewer.md .claude/agents/
cp claude-howto/04-subagents/implementation-agent.md .claude/agents/
cp claude-howto/04-subagents/debugger.md .claude/agents/

# 2. 查看已安装的智能体
/agents
```

**测试自动委托**：
```
"Review the security of the auth module"    → secure-reviewer 自动触发
"Write tests for the settings store"        → test-engineer 自动触发
"Debug the IME input issue"                 → debugger 自动触发
```

**vmark 实战**：

| 场景 | 委托智能体 | 预期效果 |
|------|-----------|---------|
| 安全审计 | secure-reviewer | 检查 Tauri IPC 权限、XSS 风险 |
| 测试覆盖 | test-engineer | 检查 Zustand store 的 Vitest 覆盖 |
| 代码质量 | code-reviewer | 检查 300 行限制、DRY 违规 |
| 调试 | debugger | 根因分析 Tauri MCP 连接问题 |

**✅ 验收标准**：
- [ ] 至少 3 个子智能体安装成功
- [ ] Claude 自动委托给合适的子智能体
- [ ] 理解子智能体的配置字段（name, description, model, tools, effort）

---

### 第 10 天（30 分钟）— 复习 + 测验

```
/lesson-quiz skills
/lesson-quiz hooks
/lesson-quiz mcp
/lesson-quiz subagents
```

**全部通过 → 进入第三周！**

---

## 第三周：高级能力（5 小时）

> **目标**：掌握计划模式、插件系统、CI/CD 集成，成为团队工具建设者
> **关键词**：系统化规划、权限控制、团队分发、流水线自动化

---

### 第 11 天（1.5 小时）— 高级功能上篇

**学习内容**：计划模式、权限控制、扩展思考、后台任务

**阅读**：`claude-howto/09-advanced-features/README.md`

**动手练习**：

```bash
# 1. 计划模式
/plan 为 vmark 添加 Markdown 导出 PDF 功能
# Claude 会输出：需求分析 → 架构方案 → 任务分解 → 风险评估

# 2. 权限模式
claude --permission-mode plan "分析 vmark 的安全性"            # 只读分析
claude --permission-mode acceptEdits "重构 settings store"    # 自动接受编辑
claude --permission-mode auto "实现暗色主题切换"              # 全自动

# 3. 扩展思考
# 按 Alt+T (macOS: Option+T) 切换深度推理模式

# 4. 后台任务
# 在 Claude Code 中：让测试在后台运行
"Run pnpm check:all in background and report when done"
```

**6 种权限模式**：

| 模式 | 行为 | 适用场景 |
|------|------|---------|
| `default` | 每次工具调用都询问 | 日常交互 |
| `acceptEdits` | 自动接受文件编辑 | 信任的编辑工作流 |
| `plan` | 仅只读，不修改 | 分析和规划 |
| `auto` | 全自动，后台安全分类器 | 自主开发 |
| `dontAsk` | 跳过需要权限的操作 | 非交互脚本 |
| `bypassPermissions` | 跳过所有检查 | CI/CD（需 `--dangerously-skip-permissions`） |

**✅ 验收标准**：
- [ ] 成功使用计划模式规划一个功能
- [ ] 尝试过至少 3 种权限模式
- [ ] 了解扩展思考和后台任务

---

### 第 12 天（1.5 小时）— 高级功能下篇

**学习内容**：动态工作流、定时任务、Chrome 集成、远程控制、键盘自定义

```bash
# 1. 动态工作流 (v2.1.154)
# 在 Claude Code 中说："创建一个工作流来审查 vmark 的所有 Zustand stores"
# 用 /workflows 查看运行状态

# 2. 定时任务
/loop 10m "检查 vmark CI 状态"
# 或使用 CronCreate 工具创建持久化定时任务

# 3. Chrome 集成
# 用于 vmark 的 Web 前端 E2E 测试
claude --chrome "测试 vmark 编辑器的 Markdown 渲染"

# 4. 远程控制
claude --remote                         # 启动 WebSocket 远程控制

# 5. 键盘自定义
/keybindings                             # 自定义快捷键
```

**✅ 验收标准**：
- [ ] 了解动态工作流的概念
- [ ] 尝试过定时任务或循环命令
- [ ] 知道远程控制和 Chrome 集成的用途

---

### 第 13 天（1.5 小时）— 插件系统

**学习内容**：完整的插件结构，包含命令、智能体、MCP、钩子

**阅读**：`claude-howto/07-plugins/README.md`

**动手练习**：

```bash
# 1. 安装插件
/plugin install pr-review
/plugin install documentation
/plugin install devops-automation

# 2. 测试插件命令
/review-pr                → 完整 PR 审查
/check-security           → 安全检查
/check-tests              → 测试覆盖检查
/generate-api-docs        → 生成 API 文档

# 3. 研究插件结构
ls -R claude-howto/07-plugins/pr-review/
# 理解 plugin.json 清单、commands/agents/hooks/mcp 的组织方式
```

**插件结构**：
```
my-plugin/
├── .claude-plugin/
│   └── plugin.json        # 插件清单
├── commands/              # 斜杠命令
├── agents/                # 子智能体
├── skills/                # 技能
├── mcp/                   # MCP 配置
├── hooks/                 # 钩子脚本
└── scripts/               # 工具脚本
```

**vmark 实战**：考虑将 vmark 的 `.claude/` 配置打包为插件，方便团队其他成员一键安装。

**✅ 验收标准**：
- [ ] 至少安装并使用了 1 个插件
- [ ] 理解插件的目录结构
- [ ] 知道如何用 plugin.json 定义插件

---

### 第 14 天（1 小时）— CLI 大师级

**学习内容**：CI/CD 集成、批量处理、会话管理

**阅读**：`claude-howto/10-cli/README.md`（进阶部分）

**动手练习**：

```bash
# 1. CI/CD 集成脚本
claude -p "审查以下代码变更" --permission-mode dontAsk --max-turns 3

# 2. JSON 输出 + jq 处理
claude -p --output-format json "列出所有测试文件及其覆盖范围" > test-report.json
cat test-report.json | jq '.result'

# 3. 批量处理
for file in src/stores/*.ts; do
  claude -p --output-format json "分析这个 store: $(cat $file)" > "${file%.ts}.analysis.json"
done

# 4. 会话管理
claude -c                                       # 继续最近会话
claude -r "feature-auth" "继续实现登录功能"       # 恢复指定会话
```

**vmark 实战**：创建 GitHub Actions 工作流，在 PR 时自动运行 Claude Code 审查：

```yaml
# .github/workflows/claude-review.yml
- name: Claude Code Review
  run: |
    git diff origin/main | claude -p \
      --permission-mode dontAsk \
      --output-format json \
      "审查这些变更，重点关注 TDD 合规、i18n 覆盖和安全风险" \
      > claude-review.json
```

**✅ 验收标准**：
- [ ] 成功用 `claude -p` 完成自动化任务
- [ ] 了解 JSON 输出的处理方式
- [ ] 掌握会话恢复和管理

---

### 第 15 天（30 分钟）— 最终测验

```
/self-assessment                  → 对比初次得分
/lesson-quiz advanced
/lesson-quiz plugins
/lesson-quiz cli
```

---

## vmark 实战路线图

将 claude-howto 特性直接应用到 vmark 项目：

| 优先级 | vmark 场景 | 使用的 Claude Code 特性 | 具体做法 |
|--------|-----------|----------------------|---------|
| 🔴 高 | PR 代码审查 | 斜杠命令 + 子智能体 + MCP | 安装 pr-review 插件，每次 PR 前运行 `/review-pr` |
| 🔴 高 | TDD 强制执行 | 钩子（PreToolUse） | 增强现有 `gha-tdd-guard.mjs`，写入源文件前检查测试 |
| 🔴 高 | 项目记忆 | CLAUDE.md | 将 vmark 技术栈、编码规范、i18n 规则写入 CLAUDE.md |
| 🟡 中 | 安全审计 | 子智能体（secure-reviewer） | 定期对 Tauri IPC 和认证模块运行安全审查 |
| 🟡 中 | 文档生成 | 技能 + 插件 | 安装 documentation 插件，自动生成 API 文档 |
| 🟡 中 | 重构辅助 | 技能（refactor） | 重构 Zustand store 时自动触发系统化方法 |
| 🟢 低 | CI/CD 集成 | CLI 打印模式 | 在 GitHub Actions 中集成 `claude -p` 代码审查 |
| 🟢 低 | 定时监控 | 定时任务 | `/loop 30m` 检查 CI 状态 |
| 🟢 低 | 团队入职 | 插件 | 将 vmark 的 `.claude/` 配置打包为插件 |

**建议顺序**：先安装 pr-review 插件（5 分钟即可用），再逐步完善 CLAUDE.md 和钩子。

---

## 每日学习清单

### 🟢 第一周（每天约 40 分钟）

| 天 | 主题 | 阅读 | 动手 | 测验 |
|----|------|------|------|------|
| 1 | 斜杠命令 | 15 min | 10 min | 5 min |
| 2 | 项目记忆 | 15 min | 20 min | 10 min |
| 3 | CLI 基础 | 10 min | 15 min | 5 min |
| 4 | 检查点 | 15 min | 20 min | 10 min |
| 5 | 复习周测 | — | — | 30 min |

### 🔵 第二周（每天约 1 小时）

| 天 | 主题 | 阅读 | 动手 | 测验 |
|----|------|------|------|------|
| 6 | 技能系统 | 20 min | 30 min | 10 min |
| 7 | 钩子系统 | 20 min | 30 min | 10 min |
| 8 | MCP 集成 | 15 min | 35 min | 10 min |
| 9 | 子智能体 | 20 min | 50 min | 20 min |
| 10 | 复习周测 | — | — | 30 min |

### 🔴 第三周（每天约 1 小时）

| 天 | 主题 | 阅读 | 动手 | 测验 |
|----|------|------|------|------|
| 11 | 高级功能（上） | 20 min | 50 min | 20 min |
| 12 | 高级功能（下） | 15 min | 45 min | 30 min |
| 13 | 插件系统 | 20 min | 50 min | 20 min |
| 14 | CLI 大师级 | 15 min | 30 min | 15 min |
| 15 | 最终测评 | — | — | 30 min |

---

## 进度追踪表

### 🟢 第一周：基础提效

| 里程碑 | 计划日期 | 完成日期 | 状态 |
|--------|---------|---------|------|
| 1A: 安装 `/optimize` 命令 | ___ | ___ | ⬜ |
| 1A: 安装 `/commit` 命令 | ___ | ___ | ⬜ |
| 1A: 安装 `/pr` 命令 | ___ | ___ | ⬜ |
| 1A: 阅读 `01-slash-commands/README.md` | ___ | ___ | ⬜ |
| 2A: 复制 `02-memory/project-CLAUDE.md` | ___ | ___ | ⬜ |
| 2A: 编辑 CLAUDE.md 填入 vmark 信息 | ___ | ___ | ⬜ |
| 2A: 阅读 `02-memory/README.md` | ___ | ___ | ⬜ |
| 3: 使用 `claude -p` 打印模式 | ___ | ___ | ⬜ |
| 3: 使用管道输入 | ___ | ___ | ⬜ |
| 3: 阅读 `10-cli/README.md` | ___ | ___ | ⬜ |
| 4: 创建并回退检查点 | ___ | ___ | ⬜ |
| 4: 阅读 `08-checkpoints/README.md` | ___ | ___ | ⬜ |
| 5: `/lesson-quiz slash-commands` | ___ | ___ | ⬜ |
| 5: `/lesson-quiz memory` | ___ | ___ | ⬜ |
| 5: `/lesson-quiz cli` | ___ | ___ | ⬜ |
| 5: `/lesson-quiz checkpoints` | ___ | ___ | ⬜ |
| **🏁 第一周完成** | ___ | ___ | ⬜ |

### 🔵 第二周：自动化工作流

| 里程碑 | 计划日期 | 完成日期 | 状态 |
|--------|---------|---------|------|
| 6: 安装 code-review-specialist 技能 | ___ | ___ | ⬜ |
| 6: 安装 refactor 技能 | ___ | ___ | ⬜ |
| 6: 阅读 `03-skills/README.md` | ___ | ___ | ⬜ |
| 7: 配置 PreToolUse 钩子 | ___ | ___ | ⬜ |
| 7: 配置 PostToolUse 钩子 | ___ | ___ | ⬜ |
| 7: 阅读 `06-hooks/README.md` | ___ | ___ | ⬜ |
| 8: 连接 GitHub MCP | ___ | ___ | ⬜ |
| 8: 测试 `/mcp__github__list_prs` | ___ | ___ | ⬜ |
| 8: 阅读 `05-mcp/README.md` | ___ | ___ | ⬜ |
| 9: 安装 code-reviewer 子智能体 | ___ | ___ | ⬜ |
| 9: 安装 test-engineer 子智能体 | ___ | ___ | ⬜ |
| 9: 安装 secure-reviewer 子智能体 | ___ | ___ | ⬜ |
| 9: 阅读 `04-subagents/README.md` | ___ | ___ | ⬜ |
| 10: `/lesson-quiz skills` | ___ | ___ | ⬜ |
| 10: `/lesson-quiz hooks` | ___ | ___ | ⬜ |
| 10: `/lesson-quiz mcp` | ___ | ___ | ⬜ |
| 10: `/lesson-quiz subagents` | ___ | ___ | ⬜ |
| **🏁 第二周完成** | ___ | ___ | ⬜ |

### 🔴 第三周：高级能力

| 里程碑 | 计划日期 | 完成日期 | 状态 |
|--------|---------|---------|------|
| 11: 使用 `/plan` 规划功能 | ___ | ___ | ⬜ |
| 11: 尝试至少 3 种权限模式 | ___ | ___ | ⬜ |
| 11: 阅读 `09-advanced-features/README.md` | ___ | ___ | ⬜ |
| 12: 尝试动态工作流 | ___ | ___ | ⬜ |
| 12: 尝试定时任务 `/loop` | ___ | ___ | ⬜ |
| 12: 了解 Chrome/Remote/Desktop | ___ | ___ | ⬜ |
| 13: 安装 pr-review 插件 | ___ | ___ | ⬜ |
| 13: 安装 documentation 插件 | ___ | ___ | ⬜ |
| 13: 阅读 `07-plugins/README.md` | ___ | ___ | ⬜ |
| 14: 编写 CI/CD 脚本 | ___ | ___ | ⬜ |
| 14: 批量处理 + JSON 输出 | ___ | ___ | ⬜ |
| 14: 阅读 `10-cli/README.md`（进阶） | ___ | ___ | ⬜ |
| 15: `/self-assessment` 最终测评 | ___ | ___ | ⬜ |
| 15: `/lesson-quiz advanced` | ___ | ___ | ⬜ |
| 15: `/lesson-quiz plugins` | ___ | ___ | ⬜ |
| **🏁 第三周完成** | ___ | ___ | ⬜ |

---

## 📖 参考资料

| 资源 | 路径 |
|------|------|
| 完整指南 | `claude-howto/README.md` |
| 功能目录 | `claude-howto/CATALOG.md` |
| 快速参考 | `claude-howto/QUICK_REFERENCE.md` |
| 完整索引 | `claude-howto/INDEX.md` |
| 学习路线图 | `claude-howto/LEARNING-ROADMAP.md` |
| 风格指南 | `claude-howto/STYLE_GUIDE.md` |
| 官方文档 | https://code.claude.com/docs/en/overview |
| MCP 协议 | https://modelcontextprotocol.io |

---

> **最后更新**：2026 年 6 月 8 日
> **Claude Code 兼容版本**：2.1+
> **基于**：[claude-howto v2.1.160](https://github.com/luongnv89/claude-howto)
