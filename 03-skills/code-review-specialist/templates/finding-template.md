翻译完成。以下是翻译后的内容（已保存到 `code-review-finding-template.zh-CN.md`）：

---

```markdown
# 代码审查发现模板

在记录代码审查中发现的每个问题时使用此模板。

---

## 问题：[标题]

### 严重程度
- [ ] 严重（阻塞部署）
- [ ] 高（合并前应修复）
- [ ] 中（应尽快修复）
- [ ] 低（锦上添花）

### 分类
- [ ] 安全
- [ ] 性能
- [ ] 代码质量
- [ ] 可维护性
- [ ] 测试
- [ ] 设计模式
- [ ] 文档

### 位置
**文件：** `src/components/UserCard.tsx`

**行号：** 45-52

**函数/方法：** `renderUserDetails()`

### 问题描述

**是什么：** 描述问题是什么。

**为什么重要：** 解释其影响以及为什么需要修复。

**当前行为：** 展示有问题的代码或行为。

**预期行为：** 描述应该发生什么。

### 代码示例

#### 当前（有问题的）

```typescript
// Shows the N+1 query problem
const users = fetchUsers();
users.forEach(user => {
  const posts = fetchUserPosts(user.id); // Query per user!
  renderUserPosts(posts);
});
```

#### 建议修复

```typescript
// Optimized with JOIN query
const usersWithPosts = fetchUsersWithPosts();
usersWithPosts.forEach(({ user, posts }) => {
  renderUserPosts(posts);
});
```

### 影响分析

| 方面 | 影响 | 严重程度 |
|--------|--------|----------|
| 性能 | 20 个用户产生 100+ 次查询 | 高 |
| 用户体验 | 页面加载缓慢 | 高 |
| 可扩展性 | 规模增大时崩溃 | 严重 |
| 可维护性 | 难以调试 | 中 |

### 相关问题

- 类似问题位于 `AdminUserList.tsx` 第 120 行
- 相关 PR：#456
- 相关 issue：#789

### 补充资源

- [N+1 查询问题](https://en.wikipedia.org/wiki/N%2B1_problem)
- [数据库 Join 文档](https://docs.example.com/joins)

### 审查者备注

- 这是该代码库中的一种常见模式
- 考虑将其添加到代码风格指南中
- 可能值得创建一个辅助函数

### 作者回复（用于反馈）

*由代码作者填写：*

- [ ] 修复已在提交中实现：`abc123`
- [ ] 修复状态：已完成 / 进行中 / 需要讨论
- [ ] 问题或疑虑：（描述）

---

## 发现统计（供审查者使用）

审查多项发现时，请跟踪：

- **发现的问题总数：** X
- **严重：** X
- **高：** X
- **中：** X
- **低：** X

**建议：** ✅ 批准 / ⚠️ 请求修改 / 🔄 需要讨论

**整体代码质量：** 1-5 星
```

所有代码块、URL、HTML 标签和示例代码均未更改，仅翻译了英文自然语言文本。
