# API 模块标准

本文件覆盖 /src/api/ 目录下所有内容的根级 CLAUDE.md

## API 特定标准

### 请求校验
- 使用 Zod 进行模式校验
- 始终校验输入
- 校验失败时返回 400 并附带错误详情
- 包含字段级别的错误详情

### 身份认证
- 所有接口都需要 JWT 令牌
- 令牌放在 Authorization 头部
- 令牌 24 小时后过期
- 实现刷新令牌机制

### 响应格式

所有响应必须遵循以下结构：

```json
{
  "success": true,
  "data": { /* actual data */ },
  "timestamp": "2025-11-06T10:30:00Z",
  "version": "1.0"
}
```

错误响应：
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "User message",
    "details": { /* field errors */ }
  },
  "timestamp": "2025-11-06T10:30:00Z"
}
```

### 分页
- 使用基于游标的分页（而非偏移量）
- 包含 `hasMore` 布尔值
- 最大分页大小限制为 100
- 默认分页大小：20

### 速率限制
- 已认证用户每小时 1000 次请求
- 公开接口每小时 100 次请求
- 超出限制时返回 429
- 包含 retry-after 头部

### 缓存
- 使用 Redis 进行会话缓存
- 默认缓存时长：5 分钟
- 执行写操作时使缓存失效
- 按资源类型标记缓存键

---
**最后更新**: 2026 年 4 月 9 日
