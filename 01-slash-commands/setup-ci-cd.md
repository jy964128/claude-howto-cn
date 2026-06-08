```markdown
---
name: 配置 CI/CD 流水线
description: 实现 pre-commit 钩子和 GitHub Actions 以保障质量
tags: ci-cd, devops, automation
---

# 配置 CI/CD 流水线

实现全面的 DevOps 质量关卡，适配项目类型：

1. **分析项目**：检测语言、框架、构建系统和现有工具链
2. **配置 pre-commit 钩子**，使用语言专用工具：
   - 格式化：Prettier/Black/gofmt/rustfmt 等
   - 代码检查：ESLint/Ruff/golangci-lint/Clippy 等
   - 安全审计：Bandit/gosec/cargo-audit/npm audit 等
   - 类型检查：TypeScript/mypy/flow（如适用）
   - 测试：运行相关测试套件
3. **创建 GitHub Actions 工作流**（.github/workflows/）：
   - 在 push/PR 时同步执行 pre-commit 检查
   - 多版本/多平台矩阵（如适用）
   - 构建与测试验证
   - 部署步骤（如需要）
4. **验证流水线**：本地测试，创建测试 PR，确认所有检查通过

使用免费/开源工具。尊重现有配置。保持执行速度。

---

**最后更新**：2026 年 4 月 9 日
```
