```javascript
#!/usr/bin/env node

/**
 * 预审钩子
 * 在开始 PR 审阅之前运行，确保满足前提条件
 */

async function preReview() {
  console.log('正在运行预审检查...');

  // 检查是否为 git 仓库
  const { execSync } = require('child_process');
  try {
    execSync('git rev-parse --git-dir', { stdio: 'pipe' });
  } catch (error) {
    console.error('❌ 不是 git 仓库');
    process.exit(1);
  }

  // 检查是否有未提交的更改
  try {
    const status = execSync('git status --porcelain', { encoding: 'utf-8' });
    if (status.trim()) {
      console.warn('⚠️  警告：检测到未提交的更改');
    }
  } catch (error) {
    console.error('❌ 检查 git 状态失败');
    process.exit(1);
  }

  console.log('✅ 预审检查通过');
}

preReview().catch(error => {
  console.error('预审钩子失败：', error);
  process.exit(1);
});
```
