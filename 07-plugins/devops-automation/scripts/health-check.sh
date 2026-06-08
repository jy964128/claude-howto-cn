```bash
#!/bin/bash

echo "🏥 系统健康检查"
echo "===================="

ENV=${1:-production}

# 检查 API
echo -n "API: "
if curl -sf http://api.$ENV.example.com/health > /dev/null; then
  echo "✅ 正常"
else
  echo "❌ 异常"
fi

# 检查数据库
echo -n "数据库: "
if pg_isready -h db.$ENV.example.com > /dev/null 2>&1; then
  echo "✅ 正常"
else
  echo "❌ 异常"
fi

# 检查 Pods
echo -n "Kubernetes Pods: "
PODS_READY=$(kubectl get pods -n $ENV --no-headers | grep "Running" | wc -l)
PODS_TOTAL=$(kubectl get pods -n $ENV --no-headers | wc -l)
echo "$PODS_READY/$PODS_TOTAL 就绪"

echo "===================="
```
