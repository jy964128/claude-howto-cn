<picture>
  <source media="(prefers-color-scheme: dark)" srcset="../../resources/logos/claude-howto-logo-dark.svg">
  <img alt="Claude How To" src="../../resources/logos/claude-howto-logo.svg">
</picture>

# PR 审核插件

完整的 PR 审核工作流，包含安全检查、测试覆盖和文档检查。

## 功能特性

✅ 安全分析
✅ 测试覆盖率检查
✅ 文档验证
✅ 代码质量评估
✅ 性能影响分析

## 安装

```bash
/plugin install pr-review
```

## 包含内容

### 斜杠命令
- `/review-pr` - 全面的 PR 审核
- `/check-security` - 安全专项审核
- `/check-tests` - 测试覆盖率分析

### 子代理
- `security-reviewer` - 安全漏洞检测
- `test-checker` - 测试覆盖率分析
- `performance-analyzer` - 性能影响评估

### MCP 服务器
- GitHub 集成，用于获取 PR 数据

### 钩子
- `pre-review.js` - 审核前验证

## 使用方法

### 基础 PR 审核
```
/review-pr
```

### 仅安全检查
```
/check-security
```

### 测试覆盖率检查
```
/check-tests
```

## 系统要求

- Claude Code 1.0+
- GitHub 访问权限
- Git 仓库

## 配置

设置你的 GitHub 令牌：
```bash
export GITHUB_TOKEN="your_github_token"
```

## 工作流示例

```
用户：/review-pr

Claude：
1. 运行审核前钩子（验证 git 仓库）
2. 通过 GitHub MCP 获取 PR 数据
3. 将安全审核委派给 security-reviewer 子代理
4. 将测试检查委派给 test-checker 子代理
5. 将性能分析委派给 performance-analyzer 子代理
6. 综合所有发现
7. 提供全面的审核报告

结果：
✅ 安全：未发现严重问题
⚠️  测试：覆盖率为 65%，建议达到 80% 以上
✅ 性能：无显著影响
📝 建议：为边界情况添加测试
```

---

**最后更新**：2026 年 6 月 2 日
**Claude Code 版本**：2.1.160
**来源**：
- https://code.claude.com/docs/en/plugins
- https://github.com/anthropics/claude-code/releases/tag/v2.1.131
- https://github.com/anthropics/claude-code/releases/tag/v2.1.138
**兼容模型**：Claude Sonnet 4.6、Claude Opus 4.8、Claude Haiku 4.5
