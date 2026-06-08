<picture>
  <source media="(prefers-color-scheme: dark)" srcset="resources/logos/claude-howto-logo-dark.svg">
  <img alt="Claude How To" src="resources/logos/claude-howto-logo.svg">
</picture>

# Claude Code 示例 — 完整索引

本文档提供按功能类型组织的所有示例文件的完整索引。

## 统计摘要

- **文件总数**：100+ 个文件
- **类别**：10 个功能类别
- **插件**：3 个完整插件
- **技能**：6 个完整技能
- **钩子**：8 个示例钩子
- **即用型**：所有示例

---

## 01. 斜杠命令（10 个文件）

常用工作流的用户调用快捷方式。

| 文件 | 描述 | 用例 |
|------|-------------|----------|
| `optimize.md` | 代码优化分析器 | 查找性能问题 |
| `pr.md` | Pull Request 准备 | PR 工作流自动化 |
| `generate-api-docs.md` | API 文档生成器 | 生成 API 文档 |
| `commit.md` | 提交消息助手 | 标准化提交 |
| `setup-ci-cd.md` | CI/CD 流水线设置 | DevOps 自动化 |
| `push-all.md` | 推送所有更改 | 快速推送工作流 |
| `unit-test-expand.md` | 扩展单元测试覆盖率 | 测试自动化 |
| `doc-refactor.md` | 文档重构 | 文档改进 |
| `pr-slash-command.png` | 截图示例 | 可视化参考 |
| `README.md` | 文档 | 设置和使用指南 |

**安装路径**：`.claude/commands/`

**使用**：`/optimize`、`/pr`、`/generate-api-docs`、`/commit`、`/setup-ci-cd`、`/push-all`、`/unit-test-expand`、`/doc-refactor`

---

## 02. 记忆（6 个文件）

持久化上下文和项目标准。

| 文件 | 描述 | 范围 | 位置 |
|------|-------------|-------|----------|
| `project-CLAUDE.md` | 团队项目标准 | 项目级 | `./CLAUDE.md` |
| `directory-api-CLAUDE.md` | API 特定规则 | 目录级 | `./src/api/CLAUDE.md` |
| `personal-CLAUDE.md` | 个人偏好 | 用户级 | `~/.claude/CLAUDE.md` |
| `memory-saved.png` | 截图：记忆已保存 | - | 可视化参考 |
| `memory-ask-claude.png` | 截图：询问 Claude | - | 可视化参考 |
| `README.md` | 文档 | - | 参考 |

**安装**：复制到相应位置

**使用**：由 Claude 自动加载

---

## 03. 技能（16 个文件）

带脚本和模板的自动调用能力。

（完整目录树和技能描述，包括代码审查、品牌语调、文档生成、重构、Claude MD、博客草稿等技能）

**安装路径**：`~/.claude/skills/` 或 `.claude/skills/`

---

## 04. 子智能体（9 个文件）

具有自定义能力的专业 AI 助手。

（包含 code-reviewer、test-engineer、documentation-writer、secure-reviewer、implementation-agent、debugger、data-scientist、clean-code-reviewer 等）

**安装路径**：`.claude/agents/`

---

## 05. MCP 协议（5 个文件）

外部工具和 API 集成。

（包含 GitHub、数据库、文件系统、多服务器配置）

**安装路径**：`.mcp.json`（项目范围）或 `~/.claude.json`（用户范围）

---

## 06. 钩子（9 个文件）

自动执行的事件驱动自动化脚本。

（包含代码格式化、预提交测试、安全扫描、命令日志、提示验证、团队通知、上下文追踪等）

**钩子类型**（5 种类型，29 个事件）：
- 工具钩子：PreToolUse、PostToolUse、PostToolUseFailure、PostToolBatch、PermissionRequest、PermissionDenied
- 会话钩子：SessionStart、Setup、SessionEnd、Stop、StopFailure、SubagentStart、SubagentStop
- 任务钩子：UserPromptSubmit、UserPromptExpansion、TaskCompleted、TaskCreated、TeammateIdle
- 生命周期钩子：ConfigChange、CwdChanged、FileChanged、PreCompact、PostCompact、WorktreeCreate、WorktreeRemove、Notification、InstructionsLoaded、Elicitation、ElicitationResult

---

## 07. 插件（3 个完整插件，27 个文件）

功能的打包集合。

### PR 审查插件（10 个文件）
- 功能：安全分析、测试覆盖率、性能影响
- 命令：`/review-pr`、`/check-security`、`/check-tests`
- 安装：`/plugin install pr-review`

### DevOps 自动化插件（15 个文件）
- 功能：Kubernetes 部署、回滚、监控、事件响应
- 命令：`/deploy`、`/rollback`、`/status`、`/incident`
- 安装：`/plugin install devops-automation`

### 文档插件（14 个文件）
- 功能：API 文档、README 生成、文档同步、验证
- 命令：`/generate-api-docs`、`/generate-readme`、`/sync-docs`、`/validate-docs`
- 安装：`/plugin install documentation`

---

## 08. 检查点和回退（2 个文件）

保存对话状态并探索替代方案。

- **检查点**：对话状态快照
- **回退**：返回之前的检查点
- **分支点**：探索多种方案

---

## 09. 高级功能（3 个文件）

复杂工作流的高级能力。

涵盖：计划模式、扩展思考、后台任务、动态工作流（v2.1.154）、权限模式、无头模式、会话管理、定时任务、Chrome 集成、远程控制、键盘自定义、桌面应用等。

---

## 10. CLI 使用（1 个文件）

命令行界面使用模式和参考。

---

## 按用例快速入门

### 代码质量和审查
```bash
cp 01-slash-commands/optimize.md .claude/commands/
cp 04-subagents/code-reviewer.md .claude/agents/
cp -r 03-skills/code-review-specialist ~/.claude/skills/
# 或安装完整插件
/plugin install pr-review
```

### DevOps 和部署
```bash
/plugin install devops-automation
```

### 文档
```bash
cp 01-slash-commands/generate-api-docs.md .claude/commands/
cp 04-subagents/documentation-writer.md .claude/agents/
cp -r 03-skills/doc-generator ~/.claude/skills/
# 或安装完整插件
/plugin install documentation
```

### 团队标准
```bash
cp 02-memory/project-CLAUDE.md ./CLAUDE.md
```

### 外部集成
```bash
export GITHUB_TOKEN="your_token"
export DATABASE_URL="postgresql://..."
cp 05-mcp/multi-mcp.json .mcp.json
```

### 自动化和验证
```bash
mkdir -p ~/.claude/hooks
cp 06-hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/*.sh
```

---

## 学习路径

### 初学者（第 1 周）
1. ✅ 阅读 `README.md`
2. ✅ 安装 1-2 个斜杠命令
3. ✅ 创建项目记忆文件
4. ✅ 尝试基本命令

### 中级（第 2-3 周）
1. ✅ 设置 GitHub MCP
2. ✅ 安装一个子智能体
3. ✅ 尝试委托任务
4. ✅ 安装一个技能

### 高级（第 4 周起）
1. ✅ 安装完整插件
2. ✅ 创建自定义斜杠命令
3. ✅ 创建自定义子智能体
4. ✅ 创建自定义技能
5. ✅ 构建你自己的插件

---

## 功能覆盖矩阵

| 类别 | 命令 | 智能体 | MCP | 钩子 | 脚本 | 模板 | 文档 | 图片 | 总计 |
|----------|----------|--------|-----|-------|---------|-----------|------|--------|-------|
| **01 斜杠命令** | 8 | - | - | - | - | - | 1 | 1 | **10** |
| **02 记忆** | - | - | - | - | - | 3 | 1 | 2 | **6** |
| **03 技能** | - | - | - | - | 5 | 9 | 1 | - | **28** |
| **04 子智能体** | - | 8 | - | - | - | - | 1 | - | **9** |
| **05 MCP** | - | - | 4 | - | - | - | 1 | - | **5** |
| **06 钩子** | - | - | - | 8 | - | - | 1 | - | **9** |
| **07 插件** | 11 | 9 | 3 | 3 | 3 | 3 | 4 | - | **40** |
| **08 检查点** | - | - | - | - | - | - | 1 | 1 | **2** |
| **09 高级** | - | - | - | - | - | - | 1 | 2 | **3** |
| **10 CLI** | - | - | - | - | - | - | 1 | - | **1** |

---

## 贡献

想添加更多示例？遵循以下结构：
1. 创建相应的子目录
2. 包含带有使用说明的 README.md
3. 遵循命名约定
4. 充分测试
5. 更新本索引

---

**最后更新**：2026 年 6 月 2 日
**Claude Code 版本**：2.1.160
**兼容模型**：Claude Sonnet 4.6、Claude Opus 4.8、Claude Haiku 4.5
**示例总数**：100+ 个文件
**类别**：10 个功能
**钩子**：9 个自动化脚本
**配置示例**：10+ 个场景
**即用型**：所有示例
