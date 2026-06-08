# 代码异味（Code Smells）目录

基于 Martin Fowler《重构》（第 2 版）的代码异味全面参考指南。代码异味是深层问题的症状——它们表明你的代码设计可能存在问题。

> "代码异味是一种表面迹象，通常对应着系统中更深层次的问题。" —— Martin Fowler

---

## 膨胀型异味（Bloaters）

代表某些东西变得过大以至于难以有效处理的代码异味。

### 过长方法（Long Method）

**特征：**
- 方法超过 30-50 行
- 需要滚动才能看到整个方法
- 存在多层嵌套
- 用注释解释各段代码的作用

**为什么不好：**
- 难以理解
- 难以隔离测试
- 修改会产生意外的副作用
- 重复逻辑隐藏在其中

**重构手段：**
- 提取方法（Extract Method）
- 以查询取代临时变量（Replace Temp with Query）
- 引入参数对象（Introduce Parameter Object）
- 以方法对象取代方法（Replace Method with Method Object）
- 分解条件表达式（Decompose Conditional）

**示例（重构前）：**
```javascript
function processOrder(order) {
  // Validate order (20 lines)
  if (!order.items) throw new Error('No items');
  if (order.items.length === 0) throw new Error('Empty order');
  // ... more validation

  // Calculate totals (30 lines)
  let subtotal = 0;
  for (const item of order.items) {
    subtotal += item.price * item.quantity;
  }
  // ... tax, shipping, discounts

  // Send notifications (20 lines)
  // ... email logic
}
```

**示例（重构后）：**
```javascript
function processOrder(order) {
  validateOrder(order);
  const totals = calculateOrderTotals(order);
  sendOrderNotifications(order, totals);
  return { order, totals };
}
```

---

### 过大类（Large Class）

**特征：**
- 类拥有大量实例变量（>7-10 个）
- 类拥有大量方法（>15-20 个）
- 类名模糊（Manager、Handler、Processor）
- 方法未使用全部实例变量

**为什么不好：**
- 违反单一职责原则
- 难以测试
- 修改会波及不相关的功能
- 难以复用部分代码

**重构手段：**
- 提取类（Extract Class）
- 提取子类（Extract Subclass）
- 提取接口（Extract Interface）

**检测指标：**
```
代码行数 > 300
方法数量 > 15
字段数量 > 10
```

---

### 基本类型偏执（Primitive Obsession）

**特征：**
- 用基本类型表示领域概念（用字符串表示邮箱，用整数表示金额）
- 用基本类型数组而非对象
- 用字符串常量表示类型码
- 存在魔数/魔法字符串

**为什么不好：**
- 缺乏类型级别的校验
- 逻辑散落在代码库各处
- 容易传入错误的值
- 丢失了领域概念

**重构手段：**
- 以对象取代基本类型（Replace Primitive with Object）
- 以类取代类型码（Replace Type Code with Class）
- 以子类取代类型码（Replace Type Code with Subclasses）
- 以 State/Strategy 取代类型码（Replace Type Code with State/Strategy）

**示例（重构前）：**
```javascript
const user = {
  email: 'john@example.com',     // Just a string
  phone: '1234567890',           // Just a string
  status: 'active',              // Magic string
  balance: 10050                 // Cents as integer
};
```

**示例（重构后）：**
```javascript
const user = {
  email: new Email('john@example.com'),
  phone: new PhoneNumber('1234567890'),
  status: UserStatus.ACTIVE,
  balance: Money.cents(10050)
};
```

---

### 过长参数列表（Long Parameter List）

**特征：**
- 方法有 4 个以上参数
- 参数总是成组出现
- 用布尔标志改变方法行为
- 频繁传入 null/undefined

**为什么不好：**
- 难以正确调用
- 参数顺序容易混淆
- 表明方法做了太多事
- 难以添加新参数

**重构手段：**
- 引入参数对象（Introduce Parameter Object）
- 保持对象完整（Preserve Whole Object）
- 以方法调用取代参数（Replace Parameter with Method Call）
- 移除标志参数（Remove Flag Argument）

**示例（重构前）：**
```javascript
function createUser(firstName, lastName, email, phone,
                    street, city, state, zip,
                    isAdmin, isActive, createdBy) {
  // ...
}
```

**示例（重构后）：**
```javascript
function createUser(personalInfo, address, options) {
  // personalInfo: { firstName, lastName, email, phone }
  // address: { street, city, state, zip }
  // options: { isAdmin, isActive, createdBy }
}
```

---

### 数据泥团（Data Clumps）

**特征：**
- 相同的 3 个以上字段反复一起出现
- 参数总是一起传递
- 类中存在本应属于一组的字段子集

**为什么不好：**
- 重复的处理逻辑
- 缺少抽象
- 难以扩展
- 表明存在隐藏的类

**重构手段：**
- 提取类（Extract Class）
- 引入参数对象（Introduce Parameter Object）
- 保持对象完整（Preserve Whole Object）

**示例：**
```javascript
// Data clump: (x, y, z) coordinates
function movePoint(x, y, z, dx, dy, dz) { }
function scalePoint(x, y, z, factor) { }
function distanceBetween(x1, y1, z1, x2, y2, z2) { }

// Extract Point3D class
class Point3D {
  constructor(x, y, z) { }
  move(delta) { }
  scale(factor) { }
  distanceTo(other) { }
}
```

---

## 面向对象滥用型异味（Object-Orientation Abusers）

表明不完整或错误使用面向对象原则的异味。

### Switch 语句（Switch Statements）

**特征：**
- 冗长的 switch/case 或 if/else 链
- 相同的 switch 出现在多处
- 基于类型码的 switch
- 添加新分支需要到处修改

**为什么不好：**
- 违反开闭原则
- 修改会波及所有 switch 出现的地方
- 难以扩展
- 通常表明缺少多态

**重构手段：**
- 以多态取代条件表达式（Replace Conditional with Polymorphism）
- 以子类取代类型码（Replace Type Code with Subclasses）
- 以 State/Strategy 取代类型码（Replace Type Code with State/Strategy）

**示例（重构前）：**
```javascript
function calculatePay(employee) {
  switch (employee.type) {
    case 'hourly':
      return employee.hours * employee.rate;
    case 'salaried':
      return employee.salary / 12;
    case 'commissioned':
      return employee.sales * employee.commission;
  }
}
```

**示例（重构后）：**
```javascript
class HourlyEmployee {
  calculatePay() {
    return this.hours * this.rate;
  }
}

class SalariedEmployee {
  calculatePay() {
    return this.salary / 12;
  }
}
```

---

### 临时字段（Temporary Field）

**特征：**
- 实例变量仅在某些方法中使用
- 字段被有条件地设置
- 针对特定情况的复杂初始化

**为什么不好：**
- 令人困惑——字段存在但可能为 null
- 难以理解对象状态
- 表明隐藏了条件逻辑

**重构手段：**
- 提取类（Extract Class）
- 引入 Null 对象（Introduce Null Object）
- 用局部变量取代临时字段（Replace Temp Field with Local）

---

### 被拒绝的遗赠（Refused Bequest）

**特征：**
- 子类不使用继承的方法/数据
- 子类重写方法但什么都不做
- 为代码复用而使用继承，而非 IS-A 关系

**为什么不好：**
- 错误的抽象
- 违反里氏替换原则
- 误导性的继承层次

**重构手段：**
- 方法/字段下移（Push Down Method/Field）
- 以委托取代子类（Replace Subclass with Delegate）
- 以委托取代继承（Replace Inheritance with Delegation）

---

### 异曲同工的类（Alternative Classes with Different Interfaces）

**特征：**
- 两个类做相似的事情
- 相同概念却用不同的方法名
- 本可以互换使用

**为什么不好：**
- 重复的实现
- 没有公共接口
- 难以互相切换

**重构手段：**
- 重命名方法（Rename Method）
- 搬移方法（Move Method）
- 提取超类（Extract Superclass）
- 提取接口（Extract Interface）

---

## 变更阻碍型异味（Change Preventers）

使修改变得困难的异味——修改一处需要改动许多其他地方。

### 发散式变化（Divergent Change）

**特征：**
- 一个类因多种不同的原因被修改
- 不同领域的变更都会触发对同一类的编辑
- 类是"上帝类"

**为什么不好：**
- 违反单一职责原则
- 变更频率高
- 容易产生合并冲突

**重构手段：**
- 提取类（Extract Class）
- 提取超类（Extract Superclass）
- 提取子类（Extract Subclass）

**示例：**
一个 `User` 类因以下原因被修改：
- 认证更改
- 个人资料更改
- 账单更改
- 通知更改

→ 提取为：`AuthService`、`ProfileService`、`BillingService`、`NotificationService`

---

### 霰弹式修改（Shotgun Surgery）

**特征：**
- 一个修改需要在多个类中编辑
- 一个小功能需要触及 10 个以上文件
- 修改分散在各处，难以全部找到

**为什么不好：**
- 容易遗漏某处
- 高耦合
- 修改容易出错

**重构手段：**
- 搬移方法（Move Method）
- 搬移字段（Move Field）
- 内联类（Inline Class）

**检测方法：**
关注：添加一个字段需要在 >5 个文件中修改。

---

### 平行继承体系（Parallel Inheritance Hierarchies）

**特征：**
- 在一个继承体系中创建子类，就需要在另一个体系中创建对应子类
- 类名前缀匹配（如 `DatabaseOrder`、`DatabaseProduct`）

**为什么不好：**
- 双倍的维护工作
- 继承体系之间的耦合
- 容易忘记其中一侧

**重构手段：**
- 搬移方法（Move Method）
- 搬移字段（Move Field）
- 消除其中一个继承体系

---

## 可有可无型异味（Dispensables）

一些不必要的、应该被移除的东西。

### 注释（过多）（Comments (Excessive)）

**特征：**
- 注释解释代码做了什么
- 被注释掉的代码
- 永远存在的 TODO/FIXME
- 注释中的道歉语

**为什么不好：**
- 注释会撒谎（与代码不同步）
- 代码应该是自解释的
- 死代码造成困惑

**重构手段：**
- 提取方法（Extract Method）（方法名已说明用途）
- 重命名（Rename）（无需注释即可清晰表达）
- 删除被注释掉的代码
- 引入断言（Introduce Assertion）

**好的注释 vs 不好的注释：**
```javascript
// BAD: Explaining what
// Loop through users and check if active
for (const user of users) {
  if (user.status === 'active') { }
}

// GOOD: Explaining why
// Active users only - inactive are handled by cleanup job
const activeUsers = users.filter(u => u.isActive);
```

---

### 重复代码（Duplicate Code）

**特征：**
- 相同的代码出现在多处
- 只有微小差异的相似代码
- 复制粘贴模式

**为什么不好：**
- Bug 修复需要在多处进行
- 存在不一致的风险
- 代码库臃肿

**重构手段：**
- 提取方法（Extract Method）
- 提取类（Extract Class）
- 方法上移（Pull Up Method）（在继承体系中）
- 塑造模板方法（Form Template Method）

**检测规则：**
任何重复 3 次以上的代码都应该被提取。

---

### 冗赘类（Lazy Class）

**特征：**
- 类做的事情不足以证明其存在
- 没有附加值的包装类
- 过度工程化的产物

**为什么不好：**
- 维护开销
- 不必要的间接层
- 增加了复杂度却没有收益

**重构手段：**
- 内联类（Inline Class）
- 折叠继承体系（Collapse Hierarchy）

---

### 死代码（Dead Code）

**特征：**
- 不可达代码
- 未使用的变量/方法/类
- 被注释掉的代码
- 不可能条件后的代码

**为什么不好：**
- 造成困惑
- 维护负担
- 拖慢理解速度

**重构手段：**
- 删除死代码（Remove Dead Code）
- 安全删除（Safe Delete）

**检测方法：**
```bash
# Look for unused exports
# Look for unreferenced functions
# IDE "unused" warnings
```

---

### 过度通用（Speculative Generality）

**特征：**
- 只有一个子类的抽象类
- "为未来使用"而存在的未使用参数
- 只做委托的方法
- 为单一用例构建的"框架"

**为什么不好：**
- 没有收益的复杂度
- YAGNI（You Ain't Gonna Need It，你不会需要它）
- 更难理解

**重构手段：**
- 折叠继承体系（Collapse Hierarchy）
- 内联类（Inline Class）
- 移除参数（Remove Parameter）
- 重命名方法（Rename Method）

---

## 耦合型异味（Couplers）

代表类之间过度耦合的异味。

### 依恋情节（Feature Envy）

**特征：**
- 方法使用另一个类的数据比使用自身的数据更多
- 对另一个对象有大量的 getter 调用
- 数据和行为分离

**为什么不好：**
- 行为放在了错误的位置
- 封装性差
- 难以维护

**重构手段：**
- 搬移方法（Move Method）
- 搬移字段（Move Field）
- 提取方法（Extract Method）（然后搬移）

**示例（重构前）：**
```javascript
class Order {
  getDiscountedPrice(customer) {
    // Uses customer data heavily
    if (customer.loyaltyYears > 5) {
      return this.price * customer.discountRate;
    }
    return this.price;
  }
}
```

**示例（重构后）：**
```javascript
class Customer {
  getDiscountedPriceFor(price) {
    if (this.loyaltyYears > 5) {
      return price * this.discountRate;
    }
    return price;
  }
}
```

---

### 过度亲密（Inappropriate Intimacy）

**特征：**
- 类互相访问对方的私有部分
- 双向引用
- 子类对父类了解太多

**为什么不好：**
- 高耦合
- 修改会级联传播
- 难以在不影响对方的情况下修改

**重构手段：**
- 搬移方法（Move Method）
- 搬移字段（Move Field）
- 将双向关联改为单向（Change Bidirectional to Unidirectional）
- 提取类（Extract Class）
- 隐藏委托关系（Hide Delegate）

---

### 消息链（Message Chains）

**特征：**
- 过长的方法调用链：`a.getB().getC().getD().getValue()`
- 客户端依赖于导航结构
- "火车残骸"式代码

**为什么不好：**
- 脆弱——任何结构变化都会打断链条
- 违反迪米特法则（Law of Demeter）
- 与结构耦合

**重构手段：**
- 隐藏委托关系（Hide Delegate）
- 提取方法（Extract Method）
- 搬移方法（Move Method）

**示例：**
```javascript
// Bad: Message chain
const managerName = employee.getDepartment().getManager().getName();

// Better: Hide delegation
const managerName = employee.getManagerName();
```

---

### 中间人（Middle Man）

**特征：**
- 类只是将调用委托给另一个类
- 一半的方法都是委托方法
- 没有附加价值

**为什么不好：**
- 不必要的间接层
- 维护开销
- 架构令人困惑

**重构手段：**
- 移除中间人（Remove Middle Man）
- 内联方法（Inline Method）

---

## 异味严重程度指南

| 严重程度 | 描述 | 处理方式 |
|----------|-------------|--------|
| **严重（Critical）** | 阻碍开发，导致 Bug | 立即修复 |
| **高（High）** | 显著的维护负担 | 在当前迭代中修复 |
| **中（Medium）** | 明显但可管理 | 近期规划修复 |
| **低（Low）** | 轻微不便 | 有机会时修复 |

---

## 快速检测清单

浏览代码时使用此清单：

- [ ] 有任何方法 > 30 行？
- [ ] 有任何类 > 300 行？
- [ ] 有任何方法参数 > 4 个？
- [ ] 有任何重复的代码块？
- [ ] 有任何基于类型码的 switch/case？
- [ ] 有任何未使用的代码？
- [ ] 有任何方法大量使用另一个类的数据？
- [ ] 有任何过长的方法调用链？
- [ ] 有任何注释在解释"做了什么"而非"为什么"？
- [ ] 有任何应该作为对象的基本类型？

---

## 延伸阅读

- Fowler, M. (2018). *Refactoring: Improving the Design of Existing Code*（第 2 版）
- Kerievsky, J. (2004). *Refactoring to Patterns*
- Feathers, M. (2004). *Working Effectively with Legacy Code*
