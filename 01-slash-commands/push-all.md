翻译完成。以下是完整的简体中文译文：

---

```markdown
---
description: 暂存所有更改，创建提交并推送到远程仓库（请谨慎使用）
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git push:*), Bash(git diff:*), Bash(git log:*), Bash(git pull:*)
---

# 提交并推送所有内容

⚠️ **警告**：暂存所有更改、提交并推送到远程仓库。仅当确信所有更改属于同一次提交时使用。

## 工作流程

### 1. 分析更改
并行执行：
- `git status` — 显示已修改/已添加/已删除/未跟踪的文件
- `git diff --stat` — 显示更改统计信息
- `git log -1 --oneline` — 显示最近的提交，了解提交信息风格

### 2. 安全检查

**❌ 如果检测到以下内容，立即停止并警告：**
- 机密信息：`.env*`、`*.key`、`*.pem`、`credentials.json`、`secrets.yaml`、`id_rsa`、`*.p12`、`*.pfx`、`*.cer`
- API 密钥：任何包含真实值的 `*_API_KEY`、`*_SECRET`、`*_TOKEN` 变量（而非占位符，如 `your-api-key`、`xxx`、`placeholder`）
- 大文件：`>10MB` 且未使用 Git LFS
- 构建产物：`node_modules/`、`dist/`、`build/`、`__pycache__/`、`*.pyc`、`.venv/`
- 临时文件：`.DS_Store`、`thumbs.db`、`*.swp`、`*.tmp`

**API 密钥验证：**
检查修改的文件中是否存在以下模式：
```bash
OPENAI_API_KEY=sk-proj-xxxxx  # ❌ 检测到真实密钥！
AWS_SECRET_KEY=AKIA...         # ❌ 检测到真实密钥！
STRIPE_API_KEY=sk_live_...    # ❌ 检测到真实密钥！

# ✅ 可接受的占位符：
API_KEY=your-api-key-here
SECRET_KEY=placeholder
TOKEN=xxx
API_KEY=<your-key>
SECRET=${YOUR_SECRET}
```

**✅ 验证以下内容：**
- `.gitignore` 是否已正确配置
- 没有合并冲突
- 分支正确（如果是 main/master 则警告）
- API 密钥仅为占位符

### 3. 请求确认

显示摘要：
```
📊 更改摘要：
- X 个文件已修改，Y 个已添加，Z 个已删除
- 总计：+AAA 行新增，-BBB 行删除

🔒 安全：✅ 无机密信息 | ✅ 无大文件 | ⚠️ [警告信息]
🌿 分支：[名称] → origin/[名称]

我将执行：git add . → commit → push

输入 'yes' 继续，或 'no' 取消。
```

**在继续之前等待明确输入 "yes"。**

### 4. 执行（确认后）

按顺序执行：
```bash
git add .
git status  # 验证暂存结果
```

### 5. 生成提交信息

分析更改并创建约定式提交信息：

**格式：**
```
[类型]：简要摘要（最多 72 个字符）

- 关键更改 1
- 关键更改 2
- 关键更改 3
```

**类型：** `feat`、`fix`、`docs`、`style`、`refactor`、`test`、`chore`、`perf`、`build`、`ci`

**示例：**
```
docs: Update concept README files with comprehensive documentation

- Add architecture diagrams and tables
- Include practical examples
- Expand best practices sections
```

### 6. 提交并推送

```bash
git commit -m "$(cat <<'EOF'
[生成的提交信息]
EOF
)"
git push  # 如果失败：先执行 git pull --rebase，然后再 git push
git log -1 --oneline --decorate  # 验证
```

### 7. 确认成功

```
✅ 已成功推送到远程仓库！

提交：[哈希值] [提交信息]
分支：[分支名称] → origin/[分支名称]
更改文件数：X（+新增行数，-删除行数）
```

## 错误处理

- **git add 失败**：检查权限、锁定文件，验证仓库是否已初始化
- **git commit 失败**：修复 pre-commit 钩子，检查 git 配置（user.name/email）
- **git push 失败**：
  - 非快进：`git pull --rebase && git push`
  - 无远程分支：`git push -u origin [分支名称]`
  - 受保护的分支：改用 PR 工作流程

## 适用场景

✅ **适合使用：**
- 多文件文档更新
- 包含测试和文档的功能开发
- 跨文件的 Bug 修复
- 项目范围的格式化/重构
- 配置更改

❌ **不适合使用：**
- 不确定将要提交什么内容
- 包含机密/敏感数据
- 未经审查的受保护分支
- 存在合并冲突
- 希望保留细粒度的提交历史
- Pre-commit 钩子执行失败

## 替代方案

如果用户需要更多控制，建议：
1. **选择性暂存**：审查/暂存特定文件
2. **交互式暂存**：使用 `git add -p` 进行补丁选择
3. **PR 工作流程**：创建分支 → 推送 → 创建 PR（使用 `/pr` 命令）

**⚠️ 请记住**：推送前务必审查更改。如有疑问，使用单独的 git 命令以获得更多控制。

---
**最后更新**：2026 年 4 月 9 日
```

---

所有代码块、YAML frontmatter、HTML 标签、URL 和代码示例均保持完全不变，仅翻译了英文自然语言文本。如需保存到文件中，请授予写入权限。
