```markdown
# 项目配置

## 项目概览
- **名称**：电商平台
- **技术栈**：Node.js、PostgreSQL、React 18、Docker
- **团队规模**：5 名开发者
- **截止日期**：2025 年 Q4

## 架构
@docs/architecture.md
@docs/api-standards.md
@docs/database-schema.md

## 开发规范

### 代码风格
- 使用 Prettier 进行格式化
- 使用 ESLint 搭配 airbnb 配置
- 最大行长度：100 个字符
- 使用 2 空格缩进

### 命名约定
- **文件**：kebab-case（user-controller.js）
- **类**：PascalCase（UserService）
- **函数/变量**：camelCase（getUserById）
- **常量**：UPPER_SNAKE_CASE（API_BASE_URL）
- **数据库表**：snake_case（user_accounts）

### Git 工作流
- 分支命名：`feature/描述` 或 `fix/描述`
- 提交信息：遵循 conventional commits 规范
- 合并前必须提交 PR
- 所有 CI/CD 检查必须通过
- 至少需要 1 人审批

### 测试要求
- 最低 80% 代码覆盖率
- 所有关键路径必须有测试
- 使用 Jest 进行单元测试
- 使用 Cypress 进行 E2E 测试
- 测试文件名：`*.test.ts` 或 `*.spec.ts`

### API 规范
- 仅使用 RESTful 端点
- JSON 请求/响应
- 正确使用 HTTP 状态码
- API 端点版本化：`/api/v1/`
- 所有端点需附带示例文档

### 数据库
- 使用迁移管理 schema 变更
- 禁止硬编码凭据
- 使用连接池
- 开发环境开启查询日志
- 需要定期备份

### 部署
- 基于 Docker 的部署
- Kubernetes 编排
- 蓝绿部署策略
- 失败时自动回滚
- 部署前先执行数据库迁移

## 常用命令

| 命令 | 用途 |
|---------|---------|
| `npm run dev` | 启动开发服务器 |
| `npm test` | 运行测试套件 |
| `npm run lint` | 检查代码风格 |
| `npm run build` | 构建生产版本 |
| `npm run migrate` | 运行数据库迁移 |

## 团队联系人
- 技术负责人：Sarah Chen（@sarah.chen）
- 产品经理：Mike Johnson（@mike.j）
- DevOps：Alex Kim（@alex.k）

## 已知问题与变通方案
- 高峰时段 PostgreSQL 连接池限制为 20
- 变通方案：实现查询排队
- Safari 14 与 async generator 存在兼容性问题
- 变通方案：使用 Babel 转译器

## 相关项目
- 分析仪表板：`/projects/analytics`
- 移动应用：`/projects/mobile`
- 管理后台：`/projects/admin`

---
**最后更新**：2026 年 4 月 9 日
```
