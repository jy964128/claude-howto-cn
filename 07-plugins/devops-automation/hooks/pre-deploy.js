```javascript
#!/usr/bin/env node

/**
 * 预部署钩子
 * 在部署前验证环境和前置条件
 */

async function preDeploy() {
  console.log('正在运行预部署检查...');

  const { execSync } = require('child_process');

  // 检查是否已安装 kubectl
  try {
    execSync('which kubectl', { stdio: 'pipe' });
  } catch (error) {
    console.error('❌ 未找到 kubectl。请安装 Kubernetes CLI。');
    process.exit(1);
  }

  // 检查是否已连接到集群
  try {
    execSync('kubectl cluster-info', { stdio: 'pipe' });
  } catch (error) {
    console.error('❌ 未连接到 Kubernetes 集群');
    process.exit(1);
  }

  console.log('✅ 预部署检查已通过');
}

preDeploy().catch(error => {
  console.error('预部署钩子失败：', error);
  process.exit(1);
});
```
