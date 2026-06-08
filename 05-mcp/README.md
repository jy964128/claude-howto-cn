<picture>
  <source media="(prefers-color-scheme: dark)" srcset="../resources/logos/claude-howto-logo-dark.svg">
  <img alt="Claude How To" src="../resources/logos/claude-howto-logo.svg">
</picture>

# MCP（模型上下文协议）

本文件夹包含 MCP 服务器配置及其与 Claude Code 配合使用的全面文档和示例。

## 概述

MCP（模型上下文协议）是 Claude 访问外部工具、API 和实时数据源的标准化方式。与 Memory 不同，MCP 提供对变化数据的实时访问。

主要特征：
- 实时访问外部服务
- 实时数据同步
- 可扩展架构
- 安全认证
- 基于工具的交互

## MCP 架构

```mermaid
graph TB
    A["Claude"]
    B["MCP Server"]
    C["External Service"]

    A -->|Request: list_issues| B
    B -->|Query| C
    C -->|Data| B
    B -->|Response| A

    A -->|Request: create_issue| B
    B -->|Action| C
    C -->|Result| B
    B -->|Response| A

    style A fill:#e1f5fe,stroke:#333,color:#333
    style B fill:#f3e5f5,stroke:#333,color:#333
    style C fill:#e8f5e9,stroke:#333,color:#333
```

## MCP 生态系统

```mermaid
graph TB
    A["Claude"] -->|MCP| B["Filesystem<br/>MCP Server"]
    A -->|MCP| C["GitHub<br/>MCP Server"]
    A -->|MCP| D["Database<br/>MCP Server"]
    A -->|MCP| E["Slack<br/>MCP Server"]
    A -->|MCP| F["Google Docs<br/>MCP Server"]

    B -->|File I/O| G["Local Files"]
    C -->|API| H["GitHub Repos"]
    D -->|Query| I["PostgreSQL/MySQL"]
    E -->|Messages| J["Slack Workspace"]
    F -->|Docs| K["Google Drive"]

    style A fill:#e1f5fe,stroke:#333,color:#333
    style B fill:#f3e5f5,stroke:#333,color:#333
    style C fill:#f3e5f5,stroke:#333,color:#333
    style D fill:#f3e5f5,stroke:#333,color:#333
    style E fill:#f3e5f5,stroke:#333,color:#333
    style F fill:#f3e5f5,stroke:#333,color:#333
    style G fill:#e8f5e9,stroke:#333,color:#333
    style H fill:#e8f5e9,stroke:#333,color:#333
    style I fill:#e8f5e9,stroke:#333,color:#333
    style J fill:#e8f5e9,stroke:#333,color:#333
    style K fill:#e8f5e9,stroke:#333,color:#333
```

## MCP 安装方法

Claude Code 支持多种传输协议用于 MCP 服务器连接：

### HTTP 传输（推荐）

```bash
# 基本 HTTP 连接
claude mcp add --transport http notion https://mcp.notion.com/mcp

# 带认证头的 HTTP 连接
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"
```

### Stdio 传输（本地）

用于本地运行的 MCP 服务器：

```bash
# 本地 Node.js 服务器
claude mcp add --transport stdio myserver -- npx @myorg/mcp-server

# 带环境变量
claude mcp add --transport stdio myserver --env KEY=value -- npx server
```

#### Stdio 服务器的 `CLAUDE_PROJECT_DIR`（v2.1.139+）

每个 MCP stdio 服务器启动时，其环境中已预设 `CLAUDE_PROJECT_DIR=<仓库根目录的绝对路径>`——这与 hooks 使用的约定相同。插件和项目的 `.mcp.json` 文件可以在 `command`、`args` 和 `env` 值中引用 `${CLAUDE_PROJECT_DIR}`，替换在 `execve()` 之前完成：

```json
{
  "mcpServers": {
    "repo-tools": {
      "type": "stdio",
      "command": "node",
      "args": ["${CLAUDE_PROJECT_DIR}/.claude/mcp/repo-tools.js"],
      "env": {
        "REPO_ROOT": "${CLAUDE_PROJECT_DIR}"
      }
    }
  }
}
```

当你的 stdio 服务器需要读取相对于项目根目录的文件（无论 Claude Code 从何处启动）时，请使用此功能。

### SSE 传输（已弃用）

服务器发送事件传输已被 `http` 取代，但仍受支持：

```bash
claude mcp add --transport sse legacy-server https://example.com/sse
```

### Windows 特别说明

在原生 Windows（非 WSL）上，对 npx 命令使用 `cmd /c`：

```bash
claude mcp add --transport stdio my-server -- cmd /c npx -y @some/package
```

### OAuth 2.0 认证

Claude Code 支持对需要 OAuth 2.0 的 MCP 服务器进行认证。连接到启用 OAuth 的服务器时，Claude Code 会处理整个认证流程：

```bash
# 连接到启用 OAuth 的 MCP 服务器（交互式流程）
claude mcp add --transport http my-service https://my-service.example.com/mcp

# 为非交互式设置预配置 OAuth 凭据
claude mcp add --transport http my-service https://my-service.example.com/mcp \
  --client-id "your-client-id" \
  --client-secret "your-client-secret" \
  --callback-port 8080
```

| 功能 | 描述 |
|---------|-------------|
| **交互式 OAuth** | 使用 `/mcp` 触发基于浏览器的 OAuth 流程 |
| **预配置 OAuth 客户端** | 为常用服务（如 Notion、Stripe 等）内置 OAuth 客户端（v2.1.30+） |
| **预配置凭据** | `--client-id`、`--client-secret`、`--callback-port` 标志用于自动化设置 |
| **令牌存储** | 令牌安全地存储在系统钥匙串中 |
| **提级认证** | 支持对特权操作进行提级认证 |
| **发现缓存** | OAuth 发现元数据被缓存以加快重连速度 |
| **元数据覆盖** | `.mcp.json` 中的 `oauth.authServerMetadataUrl` 用于覆盖默认的 OAuth 元数据发现 |

#### 覆盖 OAuth 元数据发现

如果你的 MCP 服务器在标准 OAuth 元数据端点（`/.well-known/oauth-authorization-server`）上返回错误，但暴露了可用的 OIDC 端点，你可以告诉 Claude Code 从特定 URL 获取 OAuth 元数据。在服务器配置的 `oauth` 对象中设置 `authServerMetadataUrl`：

```json
{
  "mcpServers": {
    "my-server": {
      "type": "http",
      "url": "https://mcp.example.com/mcp",
      "oauth": {
        "authServerMetadataUrl": "https://auth.example.com/.well-known/openid-configuration"
      }
    }
  }
}
```

URL 必须使用 `https://`。此选项需要 Claude Code v2.1.64 或更高版本。

### Claude.ai MCP 连接器

在你的 Claude.ai 账户中配置的 MCP 服务器会自动在 Claude Code 中可用。这意味着你通过 Claude.ai 网页界面设置的任何 MCP 连接都将无需额外配置即可访问。

Claude.ai MCP 连接器在 `--print` 模式下也可用（v2.1.83+），支持非交互式和脚本化使用。

> **启动说明（v2.1.117+）：** 当同时配置了本地和 claude.ai MCP 服务器时，并发连接是默认行为（之前是串行的），从而在使用多个服务器时降低启动延迟。

要在 Claude Code 中禁用 Claude.ai MCP 服务器，将 `ENABLE_CLAUDEAI_MCP_SERVERS` 环境变量设置为 `false`：

```bash
ENABLE_CLAUDEAI_MCP_SERVERS=false claude
```

> **注意：** 此功能仅适用于使用 Claude.ai 账户登录的用户。

## MCP 设置流程

```mermaid
sequenceDiagram
    participant User
    participant Claude as Claude Code
    participant Config as Config File
    participant Service as External Service

    User->>Claude: Type /mcp
    Claude->>Claude: List available MCP servers
    Claude->>User: Show options
    User->>Claude: Select GitHub MCP
    Claude->>Config: Update configuration
    Config->>Claude: Activate connection
    Claude->>Service: Test connection
    Service-->>Claude: Authentication successful
    Claude->>User: ✅ MCP connected!
```

### `/mcp` 命令

在会话中输入 `/mcp` 可列出已连接的服务器、触发 OAuth 流程并检查连接状态。

- 自 **v2.1.121** 起，MCP 在遇到瞬时错误时最多重试初始连接 3 次。
- 自 **v2.1.128** 起，`/mcp` 会显示每个已连接服务器的**工具数量**，并对报告**0 个工具**的服务器进行视觉标记，使配置错误的服务器一目了然。

## MCP 工具搜索

当 MCP 工具描述超过上下文窗口的 10% 时，Claude Code 会自动启用工具搜索，以高效选择合适的工具，而不会使模型上下文过载。

| 设置 | 值 | 描述 |
|---------|-------|-------------|
| `ENABLE_TOOL_SEARCH` | `auto`（默认） | 当工具描述超过上下文的 10% 时自动启用 |
| `ENABLE_TOOL_SEARCH` | `auto:<N>` | 在自定义阈值（`N` 个工具）时自动启用 |
| `ENABLE_TOOL_SEARCH` | `true` | 无论工具数量多少始终启用 |
| `ENABLE_TOOL_SEARCH` | `false` | 禁用；完整发送所有工具描述 |

> **注意：** 工具搜索需要 Sonnet 4 或更高版本，或 Opus 4 或更高版本。Haiku 模型不支持工具搜索。

### 按服务器绕过工具搜索（v2.1.121+）

如果某个 MCP 服务器的工具在每个回合都需要，将其配置标记为 `"alwaysLoad": true` 可跳过工具搜索延迟并保持其工具始终可用：

```json
{
  "mcpServers": {
    "always-on-tool": {
      "command": "node",
      "args": ["./tools/always.js"],
      "alwaysLoad": true
    }
  }
}
```

请谨慎使用——每个始终加载的工具都会消耗上下文，而这些上下文本可用于工具搜索以呈现更相关的工具。

## 动态工具更新

Claude Code 支持 MCP `list_changed` 通知。当 MCP 服务器动态添加、删除或修改其可用工具时，Claude Code 会接收更新并自动调整其工具列表——无需重新连接或重启。

## MCP 应用

MCP Apps 是首个官方 MCP 扩展，使 MCP 工具调用能够返回直接在聊天界面中渲染的交互式 UI 组件。MCP 服务器不再只返回纯文本响应，而是可以提供丰富的仪表板、表单、数据可视化和多步骤工作流——所有这些都在对话中内联显示，无需离开对话。

## MCP 信息获取

MCP 服务器可以通过交互式对话框向用户请求结构化输入（v2.1.49+）。这允许 MCP 服务器在工作流中请求额外信息——例如，提示确认、从选项列表中选择或填写必填字段——为 MCP 服务器交互增加了互动性。

## 工具描述和指令上限

自 v2.1.84 起，Claude Code 对每个 MCP 服务器的工具描述和指令强制执行 **2 KB 上限**。这可以防止单个服务器使用过于冗长的工具定义消耗过多上下文，从而减少上下文膨胀并保持交互效率。

## MCP 提示词作为斜杠命令

MCP 服务器可以暴露提示词，在 Claude Code 中显示为斜杠命令。提示词使用以下命名约定访问：

```
/mcp__<server>__<prompt>
```

例如，如果名为 `github` 的服务器暴露了一个名为 `review` 的提示词，你可以通过 `/mcp__github__review` 调用它。

## 服务器去重

当同一个 MCP 服务器在多个作用域（本地、项目、用户）中定义时，本地配置优先。这允许你用本地自定义覆盖项目级或用户级的 MCP 设置，而不会产生冲突。

## 最近的生命周期修复（v2.1.136）

v2.1.136 修复了两个长期存在的 MCP 生命周期 bug——如果你使用多服务器设置，值得升级：

- **MCP 服务器在 `/clear` 后保持连接**：通过 `.mcp.json`、插件或 claude.ai 连接器配置的服务器在 VS Code、JetBrains 或 Agent SDK 中执行 `/clear` 后不再消失。早期版本会静默丢弃它们并需要重启。
- **OAuth 刷新令牌并发刷新修复**：当多个服务器同时竞争刷新时，多服务器 OAuth 设置不再丢失刷新令牌。这消除了影响多个 OAuth 保护的 MCP 服务器设置的"每天早上都必须重新认证"的问题。

## 通过 @ 提及引用 MCP 资源

你可以在提示词中使用 `@` 提及语法直接引用 MCP 资源：

```
@server-name:protocol://resource/path
```

例如，引用特定的数据库资源：

```
@database:postgres://mydb/users
```

这允许 Claude 获取并将 MCP 资源内容作为对话上下文的一部分内联包含。

## MCP 作用域

MCP 配置可以存储在不同作用域中，具有不同的共享级别：

| 作用域 | 位置 | 描述 | 共享对象 | 需要批准 |
|-------|----------|-------------|-------------|------------------|
| **本地**（默认） | `~/.claude.json`（项目路径下） | 仅当前用户、当前项目私有（旧版本中称为 `project`） | 仅你自己 | 否 |
| **项目** | `.mcp.json` | 签入 git 仓库 | 团队成员 | 是（首次使用） |
| **用户** | `~/.claude.json` | 跨所有项目可用（旧版本中称为 `global`） | 仅你自己 | 否 |

### 使用项目作用域

在 `.mcp.json` 中存储项目特定的 MCP 配置：

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.github.com/mcp"
    }
  }
}
```

团队成员在首次使用项目 MCP 时会看到批准提示。

## MCP 配置管理

### 添加 MCP 服务器

```bash
# 添加基于 HTTP 的服务器
claude mcp add --transport http github https://api.github.com/mcp

# 添加本地 stdio 服务器
claude mcp add --transport stdio database -- npx @company/db-server

# 列出所有 MCP 服务器
claude mcp list

# 获取特定服务器的详细信息
claude mcp get github

# 删除 MCP 服务器
claude mcp remove github

# 重置项目特定的批准选择
claude mcp reset-project-choices

# 从 Claude Desktop 导入
claude mcp add-from-claude-desktop
```

## 可用 MCP 服务器表

| MCP 服务器 | 用途 | 常用工具 | 认证 | 实时 |
|------------|---------|--------------|------|-----------|
| **Filesystem** | 文件操作 | read、write、delete | 操作系统权限 | ✅ 是 |
| **GitHub** | 仓库管理 | list_prs、create_issue、push | OAuth | ✅ 是 |
| **Slack** | 团队沟通 | send_message、list_channels | Token | ✅ 是 |
| **Database** | SQL 查询 | query、insert、update | 凭据 | ✅ 是 |
| **Google Docs** | 文档访问 | read、write、share | OAuth | ✅ 是 |
| **Asana** | 项目管理 | create_task、update_status | API Key | ✅ 是 |
| **Stripe** | 支付数据 | list_charges、create_invoice | API Key | ✅ 是 |
| **Memory** | 持久化记忆 | store、retrieve、delete | 本地 | ❌ 否 |

## 实际示例

### 示例 1：GitHub MCP 配置

**文件：** `.mcp.json`（项目根目录）

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

**可用的 GitHub MCP 工具：**

#### Pull Request 管理
- `list_prs` - 列出仓库中的所有 PR
- `get_pr` - 获取 PR 详情，包括 diff
- `create_pr` - 创建新 PR
- `update_pr` - 更新 PR 描述/标题
- `merge_pr` - 合并 PR 到主分支
- `review_pr` - 添加评审评论

**示例请求：**
```
/mcp__github__get_pr 456

# 返回：
Title: Add dark mode support
Author: @alice
Description: Implements dark theme using CSS variables
Status: OPEN
Reviewers: @bob, @charlie
```

#### Issue 管理
- `list_issues` - 列出所有 issue
- `get_issue` - 获取 issue 详情
- `create_issue` - 创建新 issue
- `close_issue` - 关闭 issue
- `add_comment` - 为 issue 添加评论

#### 仓库信息
- `get_repo_info` - 仓库详情
- `list_files` - 文件树结构
- `get_file_content` - 读取文件内容
- `search_code` - 在代码库中搜索

#### 提交操作
- `list_commits` - 提交历史
- `get_commit` - 特定提交详情
- `create_commit` - 创建新提交

**设置：**
```bash
export GITHUB_TOKEN="your_github_token"
# 或使用 CLI 直接添加：
claude mcp add --transport stdio github -- npx @modelcontextprotocol/server-github
```

### 配置中的环境变量展开

MCP 配置支持带后备默认值的环境变量展开。`${VAR}` 和 `${VAR:-default}` 语法适用于以下字段：`command`、`args`、`env`、`url` 和 `headers`。

```json
{
  "mcpServers": {
    "api-server": {
      "type": "http",
      "url": "${API_BASE_URL:-https://api.example.com}/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}",
        "X-Custom-Header": "${CUSTOM_HEADER:-default-value}"
      }
    },
    "local-server": {
      "command": "${MCP_BIN_PATH:-npx}",
      "args": ["${MCP_PACKAGE:-@company/mcp-server}"],
      "env": {
        "DB_URL": "${DATABASE_URL:-postgresql://localhost/dev}"
      }
    }
  }
}
```

变量在运行时展开：
- `${VAR}` - 使用环境变量，若未设置则报错
- `${VAR:-default}` - 使用环境变量，若未设置则回退到默认值

### 示例 2：数据库 MCP 设置

**配置：**

```json
{
  "mcpServers": {
    "database": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-database"],
      "env": {
        "DATABASE_URL": "postgresql://user:pass@localhost/mydb"
      }
    }
  }
}
```

**使用示例：**

```markdown
User: Fetch all users with more than 10 orders

Claude: I'll query your database to find that information.

# Using MCP database tool:
SELECT u.*, COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id
HAVING COUNT(o.id) > 10
ORDER BY order_count DESC;

# Results:
- Alice: 15 orders
- Bob: 12 orders
- Charlie: 11 orders
```

**设置：**
```bash
export DATABASE_URL="postgresql://user:pass@localhost/mydb"
# 或使用 CLI 直接添加：
claude mcp add --transport stdio database -- npx @modelcontextprotocol/server-database
```

### 示例 3：多 MCP 工作流

**场景：每日报告生成**

```markdown
# Daily Report Workflow using Multiple MCPs

## Setup
1. GitHub MCP - fetch PR metrics
2. Database MCP - query sales data
3. Slack MCP - post report
4. Filesystem MCP - save report

## Workflow

### Step 1: Fetch GitHub Data
/mcp__github__list_prs completed:true last:7days

Output:
- Total PRs: 42
- Average merge time: 2.3 hours
- Review turnaround: 1.1 hours

### Step 2: Query Database
SELECT COUNT(*) as sales, SUM(amount) as revenue
FROM orders
WHERE created_at > NOW() - INTERVAL '1 day'

Output:
- Sales: 247
- Revenue: $12,450

### Step 3: Generate Report
Combine data into HTML report

### Step 4: Save to Filesystem
Write report.html to /reports/

### Step 5: Post to Slack
Send summary to #daily-reports channel

Final Output:
✅ Report generated and posted
📊 47 PRs merged this week
💰 $12,450 in daily sales
```

**设置：**
```bash
export GITHUB_TOKEN="your_github_token"
export DATABASE_URL="postgresql://user:pass@localhost/mydb"
export SLACK_TOKEN="your_slack_token"
# 通过 CLI 添加每个 MCP 服务器或在 .mcp.json 中配置它们
```

### 示例 4：文件系统 MCP 操作

**配置：**

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "/home/user/projects"]
    }
  }
}
```

**可用操作：**

| 操作 | 命令 | 用途 |
|-----------|---------|---------|
| 列出文件 | `ls ~/projects` | 显示目录内容 |
| 读取文件 | `cat src/main.ts` | 读取文件内容 |
| 写入文件 | `create docs/api.md` | 创建新文件 |
| 编辑文件 | `edit src/app.ts` | 修改文件 |
| 搜索 | `grep "async function"` | 在文件中搜索 |
| 删除 | `rm old-file.js` | 删除文件 |

**设置：**
```bash
# 使用 CLI 直接添加：
claude mcp add --transport stdio filesystem -- npx @modelcontextprotocol/server-filesystem /home/user/projects
```

## MCP 与 Memory：决策矩阵

```mermaid
graph TD
    A["需要外部数据？"]
    A -->|否| B["使用 Memory"]
    A -->|是| C["数据是否频繁变化？"]
    C -->|否/很少| B
    C -->|是/经常| D["使用 MCP"]

    B -->|存储| E["偏好设置<br/>上下文<br/>历史记录"]
    D -->|访问| F["实时 API<br/>数据库<br/>服务"]

    style A fill:#fff3e0,stroke:#333,color:#333
    style B fill:#e1f5fe,stroke:#333,color:#333
    style C fill:#fff3e0,stroke:#333,color:#333
    style D fill:#f3e5f5,stroke:#333,color:#333
    style E fill:#e8f5e9,stroke:#333,color:#333
    style F fill:#e8f5e9,stroke:#333,color:#333
```

## 请求/响应模式

```mermaid
sequenceDiagram
    participant App as Claude
    participant MCP as MCP Server
    participant DB as Database

    App->>MCP: Request: "SELECT * FROM users WHERE id=1"
    MCP->>DB: Execute query
    DB-->>MCP: Result set
    MCP-->>App: Return parsed data
    App->>App: Process result
    App->>App: Continue task

    Note over MCP,DB: 实时访问<br/>无缓存
```

## 环境变量

将敏感凭据存储在环境变量中：

```bash
# ~/.bashrc 或 ~/.zshrc
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxx"
export DATABASE_URL="postgresql://user:pass@localhost/mydb"
export SLACK_TOKEN="xoxb-xxxxxxxxxxxxx"
```

然后在 MCP 配置中引用它们：

```json
{
  "env": {
    "GITHUB_TOKEN": "${GITHUB_TOKEN}"
  }
}
```

## Claude 作为 MCP 服务器（`claude mcp serve`）

Claude Code 本身可以作为 MCP 服务器供其他应用程序使用。这使得外部工具、编辑器和自动化系统能够通过标准 MCP 协议利用 Claude 的能力。

```bash
# 在 stdio 上启动 Claude Code 作为 MCP 服务器
claude mcp serve
```

其他应用程序可以像连接任何基于 stdio 的 MCP 服务器一样连接到此服务器。例如，在另一个 Claude Code 实例中将 Claude Code 添加为 MCP 服务器：

```bash
claude mcp add --transport stdio claude-agent -- claude mcp serve
```

这对于构建一个 Claude 实例编排另一个的多智能体工作流非常有用。

## 托管 MCP 配置（企业版）

对于企业部署，IT 管理员可以通过 `managed-mcp.json` 配置文件强制执行 MCP 服务器策略。此文件对组织范围内允许或阻止哪些 MCP 服务器提供独占控制。

**位置：**
- macOS：`/Library/Application Support/ClaudeCode/managed-mcp.json`
- Linux：`~/.config/ClaudeCode/managed-mcp.json`
- Windows：`%APPDATA%\ClaudeCode\managed-mcp.json`

**功能：**
- `allowedMcpServers` -- 允许的服务器的白名单
- `deniedMcpServers` -- 禁止的服务器的黑名单
- `allowAllClaudeAiMcps` -- 允许在组织范围内加载 claude.ai 云端 MCP 连接器的托管设置（v2.1.149+）
- 支持按服务器名称、命令和 URL 模式匹配
- 在用户配置之前强制执行组织范围的 MCP 策略
- 防止未经授权的服务器连接

**示例配置：**

```json
{
  "allowedMcpServers": [
    {
      "serverName": "github",
      "serverUrl": "https://api.github.com/mcp"
    },
    {
      "serverName": "company-internal",
      "serverCommand": "company-mcp-server"
    }
  ],
  "deniedMcpServers": [
    {
      "serverName": "untrusted-*"
    },
    {
      "serverUrl": "http://*"
    }
  ]
}
```

> **注意：** 当 `allowedMcpServers` 和 `deniedMcpServers` 同时匹配某个服务器时，拒绝规则优先。

## 插件提供的 MCP 服务器

插件可以捆绑自己的 MCP 服务器，在安装插件时自动可用。插件提供的 MCP 服务器可以通过两种方式定义：

1. **独立的 `.mcp.json`** -- 将 `.mcp.json` 文件放在插件根目录中
2. **内联在 `plugin.json` 中** -- 直接在插件清单中定义 MCP 服务器

使用 `${CLAUDE_PLUGIN_ROOT}` 变量引用相对于插件安装目录的路径：

```json
{
  "mcpServers": {
    "plugin-tools": {
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/dist/mcp-server.js"],
      "env": {
        "CONFIG_PATH": "${CLAUDE_PLUGIN_ROOT}/config.json"
      }
    }
  }
}
```

## 子智能体作用域的 MCP

MCP 服务器可以使用 `mcpServers:` 键在智能体的 frontmatter 中内联定义，将其作用域限制为特定子智能体而非整个项目。当某个智能体需要访问工作流中其他智能体不需要的特定 MCP 服务器时，这非常有用。

```yaml
---
mcpServers:
  my-tool:
    type: http
    url: https://my-tool.example.com/mcp
---

You are an agent with access to my-tool for specialized operations.
```

子智能体作用域的 MCP 服务器仅在该智能体的执行上下文中可用，不会与父智能体或同级智能体共享。

## MCP 输出限制

Claude Code 对 MCP 工具输出强制执行限制以防止上下文溢出：

| 限制 | 阈值 | 行为 |
|-------|-----------|----------|
| **警告** | 10,000 个 token | 显示输出过大的警告 |
| **默认最大值** | 25,000 个 token | 超过此限制的输出将被截断 |
| **磁盘持久化** | 50,000 个字符 | 超过 50K 字符的工具结果将持久化到磁盘 |

最大输出限制可通过 `MAX_MCP_OUTPUT_TOKENS` 环境变量配置：

```bash
# 将最大输出提高到 50,000 个 token
export MAX_MCP_OUTPUT_TOKENS=50000
```

## 通过代码执行解决上下文膨胀

随着 MCP 采用的规模扩大，连接到数十个服务器、拥有数百或数千个工具会产生一个重大挑战：**上下文膨胀**。这可以说是 MCP 规模化中最严重的问题，而 Anthropic 的工程团队提出了一个优雅的解决方案——使用代码执行代替直接工具调用。

> **来源**：[Code Execution with MCP: Building More Efficient Agents](https://www.anthropic.com/engineering/code-execution-with-mcp) — Anthropic 工程博客

### 问题：两个 token 浪费来源

**1. 工具定义使上下文窗口过载**

大多数 MCP 客户端会预先加载所有工具定义。当连接到数千个工具时，模型在读取用户请求之前就必须处理数十万个 token。

**2. 中间结果消耗额外 token**

每个中间工具结果都通过模型的上下文传递。考虑将会议记录从 Google Drive 传输到 Salesforce——完整的记录会**两次**流经上下文：一次在读取时，另一次在写入目标时。一次 2 小时的会议记录可能意味着 50,000+ 的额外 token。

```mermaid
graph LR
    A["模型"] -->|"工具调用: getDocument"| B["MCP 服务器"]
    B -->|"完整记录 (50K token)"| A
    A -->|"工具调用: updateRecord<br/>(重新发送完整记录)"| B
    B -->|"确认"| A

    style A fill:#ffcdd2,stroke:#333,color:#333
    style B fill:#f3e5f5,stroke:#333,color:#333
```

### 解决方案：MCP 工具作为代码 API

与将工具定义和结果通过上下文窗口传递不同，智能体**编写代码**将 MCP 工具作为 API 调用。代码在沙箱化的执行环境中运行，只有最终结果返回给模型。

```mermaid
graph LR
    A["模型"] -->|"编写代码"| B["代码执行<br/>环境"]
    B -->|"直接调用工具"| C["MCP 服务器"]
    C -->|"数据留在<br/>执行环境中"| B
    B -->|"仅最终结果<br/>(最少 token)"| A

    style A fill:#c8e6c9,stroke:#333,color:#333
    style B fill:#e1f5fe,stroke:#333,color:#333
    style C fill:#f3e5f5,stroke:#333,color:#333
```

#### 工作原理

MCP 工具以类型化函数的文件树形式呈现：

```
servers/
├── google-drive/
│   ├── getDocument.ts
│   └── index.ts
├── salesforce/
│   ├── updateRecord.ts
│   └── index.ts
└── ...
```

每个工具文件包含一个类型化包装器：

```typescript
// ./servers/google-drive/getDocument.ts
import { callMCPTool } from "../../../client.js";

interface GetDocumentInput {
  documentId: string;
}

interface GetDocumentResponse {
  content: string;
}

export async function getDocument(
  input: GetDocumentInput
): Promise<GetDocumentResponse> {
  return callMCPTool<GetDocumentResponse>(
    'google_drive__get_document', input
  );
}
```

然后智能体编写代码来编排工具：

```typescript
import * as gdrive from './servers/google-drive';
import * as salesforce from './servers/salesforce';

// 数据直接在工具之间流动——永不通过模型
const transcript = (
  await gdrive.getDocument({ documentId: 'abc123' })
).content;

await salesforce.updateRecord({
  objectType: 'SalesMeeting',
  recordId: '00Q5f000001abcXYZ',
  data: { Notes: transcript }
});
```

**结果：Token 使用量从约 150,000 降至约 2,000——减少了 98.7%。**

### 主要优势

| 优势 | 描述 |
|---------|-------------|
| **渐进式披露** | 智能体浏览文件系统，仅加载所需的工具定义，而非预先加载所有工具 |
| **上下文高效的结果** | 数据在执行环境中过滤/转换后再返回给模型 |
| **强大的控制流** | 循环、条件和错误处理在代码中运行，无需通过模型往返 |
| **隐私保护** | 中间数据（PII、敏感记录）留在执行环境中；永不进入模型上下文 |
| **状态持久化** | 智能体可以将中间结果保存到文件并构建可重用的技能函数 |

#### 示例：过滤大型数据集

```typescript
// 不使用代码执行——所有 10,000 行流经上下文
// TOOL CALL: gdrive.getSheet(sheetId: 'abc123')
//   -> 在上下文中返回 10,000 行

// 使用代码执行——在执行环境中过滤
const allRows = await gdrive.getSheet({ sheetId: 'abc123' });
const pendingOrders = allRows.filter(
  row => row["Status"] === 'pending'
);
console.log(`Found ${pendingOrders.length} pending orders`);
console.log(pendingOrders.slice(0, 5)); // 只有 5 行到达模型
```

#### 示例：无往返循环

```typescript
// 轮询部署通知——完全在代码中运行
let found = false;
while (!found) {
  const messages = await slack.getChannelHistory({
    channel: 'C123456'
  });
  found = messages.some(
    m => m.text.includes('deployment complete')
  );
  if (!found) await new Promise(r => setTimeout(r, 5000));
}
console.log('Deployment notification received');
```

### 需要权衡的因素

代码执行引入了自身的复杂性。运行智能体生成的代码需要：

- 一个**安全的沙箱化执行环境**，具有适当的资源限制
- 对执行的代码进行**监控和日志记录**
- 与直接工具调用相比，额外的**基础设施开销**

这些优势——降低 token 成本、更低的延迟、改进的工具组合——应该与这些实施成本相权衡。对于只有少数 MCP 服务器的智能体，直接工具调用可能更简单。对于规模化的智能体（数十个服务器、数百个工具），代码执行是一个显著的改进。

### MCPorter：一个 MCP 工具组合的运行时

[MCPorter](https://github.com/steipete/mcporter) 是一个 TypeScript 运行时和 CLI 工具包，使调用 MCP 服务器变得实用而无需样板代码——并通过选择性工具暴露和类型化包装器帮助减少上下文膨胀。

**它解决的问题：** MCPorter 允许你按需发现、检查和调用特定工具，而不是预先从所有 MCP 服务器加载所有工具定义——保持你的上下文精简。

**主要功能：**

| 功能 | 描述 |
|---------|-------------|
| **零配置发现** | 从 Cursor、Claude、Codex 或本地配置自动发现 MCP 服务器 |
| **类型化工具客户端** | `mcporter emit-ts` 生成 `.d.ts` 接口和即用型包装器 |
| **可组合的 API** | `createServerProxy()` 将工具暴露为驼峰命名法的方法，并带有 `.text()`、`.json()`、`.markdown()` 辅助方法 |
| **CLI 生成** | `mcporter generate-cli` 将任何 MCP 服务器转换为独立的 CLI，支持 `--include-tools` / `--exclude-tools` 过滤 |
| **参数隐藏** | 可选参数默认保持隐藏，减少模式冗长 |

**安装：**

```bash
npx mcporter list          # 无需安装——即时发现服务器
pnpm add mcporter          # 添加到项目
brew install steipete/tap/mcporter  # macOS 通过 Homebrew
```

**示例——在 TypeScript 中组合工具：**

```typescript
import { createRuntime, createServerProxy } from "mcporter";

const runtime = await createRuntime();
const gdrive = createServerProxy(runtime, "google-drive");
const salesforce = createServerProxy(runtime, "salesforce");

// 数据在工具之间流动而不通过模型上下文
const doc = await gdrive.getDocument({ documentId: "abc123" });
await salesforce.updateRecord({
  objectType: "SalesMeeting",
  recordId: "00Q5f000001abcXYZ",
  data: { Notes: doc.text() }
});
```

**示例——CLI 工具调用：**

```bash
# 直接调用特定工具
npx mcporter call linear.create_comment issueId:ENG-123 body:'Looks good!'

# 列出可用的服务器和工具
npx mcporter list
```

MCPorter 通过提供将 MCP 工具作为类型化 API 调用的运行时基础设施，补充了上述代码执行方法——使将中间数据排除在模型上下文之外变得简单直接。

## 最佳实践

### 安全注意事项

#### 应该做的 ✅
- 为所有凭据使用环境变量
- 定期轮换 token 和 API 密钥（建议每月一次）
- 尽可能使用只读 token
- 将 MCP 服务器访问范围限制在所需的最小范围
- 监控 MCP 服务器使用情况和访问日志
- 可用时对外部服务使用 OAuth
- 对 MCP 请求实施速率限制
- 在生产环境使用前测试 MCP 连接
- 记录所有活跃的 MCP 连接
- 保持 MCP 服务器包更新

#### 不应该做的 ❌
- 不要在配置文件中硬编码凭据
- 不要将 token 或密钥提交到 git
- 不要在团队聊天或电子邮件中共享 token
- 不要为团队项目使用个人 token
- 不要授予不必要的权限
- 不要忽略认证错误
- 不要公开暴露 MCP 端点
- 不要以 root/admin 权限运行 MCP 服务器
- 不要在日志中缓存敏感数据
- 不要禁用认证机制

### 配置最佳实践

1. **版本控制**：将 `.mcp.json` 保留在 git 中，但使用环境变量存储密钥
2. **最小权限**：为每个 MCP 服务器授予所需的最小权限
3. **隔离**：尽可能在不同的进程中运行不同的 MCP 服务器
4. **监控**：记录所有 MCP 请求和错误以用于审计追踪
5. **测试**：在部署到生产环境前测试所有 MCP 配置

### 性能建议

- 在应用程序级别缓存频繁访问的数据
- 使用具体的 MCP 查询以减少数据传输
- 监控 MCP 操作的响应时间
- 考虑对外部 API 进行速率限制
- 执行多个操作时使用批处理

## 安装说明

### 前提条件
- 已安装 Node.js 和 npm
- 已安装 Claude Code CLI
- 外部服务的 API token/凭据

### 分步设置

1. **使用 CLI 添加你的第一个 MCP 服务器**（示例：GitHub）：
```bash
claude mcp add --transport stdio github -- npx @modelcontextprotocol/server-github
```

   或在项目根目录创建 `.mcp.json` 文件：
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

2. **设置环境变量：**
```bash
export GITHUB_TOKEN="your_github_personal_access_token"
```

3. **测试连接：**
```bash
claude /mcp
```

4. **使用 MCP 工具：**
```bash
/mcp__github__list_prs
/mcp__github__create_issue "Title" "Description"
```

### 特定服务的安装

**GitHub MCP：**
```bash
npm install -g @modelcontextprotocol/server-github
```

**数据库 MCP：**
```bash
npm install -g @modelcontextprotocol/server-database
```

**文件系统 MCP：**
```bash
npm install -g @modelcontextprotocol/server-filesystem
```

**Slack MCP：**
```bash
npm install -g @modelcontextprotocol/server-slack
```

## 故障排除

### MCP 服务器未找到
```bash
# 验证 MCP 服务器已安装
npm list -g @modelcontextprotocol/server-github

# 如果缺失则安装
npm install -g @modelcontextprotocol/server-github
```

### 认证失败
```bash
# 验证环境变量已设置
echo $GITHUB_TOKEN

# 如有需要重新导出
export GITHUB_TOKEN="your_token"

# 验证 token 具有正确的权限
# 在 https://github.com/settings/tokens 检查 GitHub token 作用域
```

### 连接超时
- 检查网络连接：`ping api.github.com`
- 验证 API 端点可访问
- 检查 API 的速率限制
- 尝试在配置中增加超时时间
- 检查防火墙或代理问题

### MCP 服务器崩溃
- 检查 MCP 服务器日志：`~/.claude/logs/`
- 验证所有环境变量已设置
- 确保正确的文件权限
- 尝试重新安装 MCP 服务器包
- 检查同一端口上是否有冲突的进程

## 相关概念

### Memory 与 MCP
- **Memory**：存储持久、不变的数据（偏好设置、上下文、历史记录）
- **MCP**：访问实时、变化的数据（API、数据库、实时服务）

### 何时使用每种
- **使用 Memory**：用户偏好设置、对话历史、学习的上下文
- **使用 MCP**：当前 GitHub issue、实时数据库查询、实时数据

### 与其他 Claude 功能的集成
- 将 MCP 与 Memory 结合以获得丰富的上下文
- 在提示词中使用 MCP 工具以获得更好的推理
- 利用多个 MCP 进行复杂的工作流

## 其他资源

- [官方 MCP 文档](https://code.claude.com/docs/en/mcp)
- [MCP 协议规范](https://modelcontextprotocol.io/specification)
- [MCP GitHub 仓库](https://github.com/modelcontextprotocol/servers)
- [可用 MCP 服务器](https://github.com/modelcontextprotocol/servers)
- [MCPorter](https://github.com/steipete/mcporter) — 无需样板代码调用 MCP 服务器的 TypeScript 运行时和 CLI
- [使用 MCP 进行代码执行](https://www.anthropic.com/engineering/code-execution-with-mcp) — Anthropic 关于解决上下文膨胀的工程博客
- [Claude Code CLI 参考](https://code.claude.com/docs/en/cli-reference)
- [Claude API 文档](https://docs.anthropic.com)

---

**最后更新**：2026年6月2日
**Claude Code 版本**：2.1.160
**来源**：
- https://code.claude.com/docs/en/mcp
- https://code.claude.com/docs/en/changelog
- https://github.com/anthropics/claude-code/releases/tag/v2.1.117
- https://github.com/anthropics/claude-code/releases/tag/v2.1.139
**兼容模型**：Claude Sonnet 4.6、Claude Opus 4.8、Claude Haiku 4.5
