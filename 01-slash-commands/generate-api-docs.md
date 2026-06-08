---
description: 从源代码创建全面的 API 文档
---

# API 文档生成器

通过以下步骤生成 API 文档：

1. 扫描 `/src/api/` 中的所有文件
2. 提取函数签名和 JSDoc 注释
3. 按端点/模块进行组织
4. 创建包含示例的 Markdown 文档
5. 包含请求/响应结构
6. 添加错误文档

输出格式：
- 在 `/docs/api.md` 中生成 Markdown 文件
- 为所有端点提供 curl 示例
- 添加 TypeScript 类型

---
**最后更新**：2026 年 4 月 9 日
