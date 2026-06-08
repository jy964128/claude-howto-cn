# 重构目录

精选重构技术目录，源自 Martin Fowler《重构：改善既有代码的设计》（第 2 版）。每种重构包含动机、分步操作步骤和示例。

> "重构由其操作步骤定义——即执行变更所遵循的精确步骤序列。" — Martin Fowler

---

## 如何使用本目录

1. **识别坏味道**，使用代码坏味道参考
2. **找到匹配的重构手法**，在本目录中查找
3. **按照操作步骤**逐步执行
4. **每步之后进行测试**，确保行为得以保留

**黄金法则**：如果任何步骤超过 10 分钟，将其分解为更小的步骤。

---

## 最常用的重构手法

### 提炼函数（Extract Method）

**何时使用**：函数过长、重复代码、需要为某个概念命名

**动机**：将一段代码片段转化为一个函数，函数名解释其用途。

**操作步骤**：
1. 创建一个新函数，以它做什么（而非怎么做）命名
2. 将代码片段复制到新函数中
3. 扫描片段中使用的局部变量
4. 将局部变量作为参数传递（或在函数内声明）
5. 适当处理返回值
6. 将原片段替换为对新函数的调用
7. 测试

**重构前**：
```javascript
function printOwing(invoice) {
  let outstanding = 0;

  console.log("***********************");
  console.log("**** Customer Owes ****");
  console.log("***********************");

  // Calculate outstanding
  for (const order of invoice.orders) {
    outstanding += order.amount;
  }

  // Print details
  console.log(`name: ${invoice.customer}`);
  console.log(`amount: ${outstanding}`);
}
```

**重构后**：
```javascript
function printOwing(invoice) {
  printBanner();
  const outstanding = calculateOutstanding(invoice);
  printDetails(invoice, outstanding);
}

function printBanner() {
  console.log("***********************");
  console.log("**** Customer Owes ****");
  console.log("***********************");
}

function calculateOutstanding(invoice) {
  return invoice.orders.reduce((sum, order) => sum + order.amount, 0);
}

function printDetails(invoice, outstanding) {
  console.log(`name: ${invoice.customer}`);
  console.log(`amount: ${outstanding}`);
}
```

---

### 内联函数（Inline Method）

**何时使用**：函数体与其名称一样清晰、过度委托

**动机**：当函数没有增加价值时，移除不必要的间接层。

**操作步骤**：
1. 检查函数不是多态的
2. 找到该函数的所有调用点
3. 将每个调用替换为函数体
4. 每次替换后测试
5. 移除函数定义

**重构前**：
```javascript
function getRating(driver) {
  return moreThanFiveLateDeliveries(driver) ? 2 : 1;
}

function moreThanFiveLateDeliveries(driver) {
  return driver.numberOfLateDeliveries > 5;
}
```

**重构后**：
```javascript
function getRating(driver) {
  return driver.numberOfLateDeliveries > 5 ? 2 : 1;
}
```

---

### 提炼变量（Extract Variable）

**何时使用**：复杂的表达式难以理解

**动机**：为复杂表达式的一部分命名。

**操作步骤**：
1. 确保表达式没有副作用
2. 声明一个不可变变量
3. 将其设置为表达式（或部分表达式）的结果
4. 将原表达式替换为变量
5. 测试

**重构前**：
```javascript
return order.quantity * order.itemPrice -
  Math.max(0, order.quantity - 500) * order.itemPrice * 0.05 +
  Math.min(order.quantity * order.itemPrice * 0.1, 100);
```

**重构后**：
```javascript
const basePrice = order.quantity * order.itemPrice;
const quantityDiscount = Math.max(0, order.quantity - 500) * order.itemPrice * 0.05;
const shipping = Math.min(basePrice * 0.1, 100);
return basePrice - quantityDiscount + shipping;
```

---

### 内联变量（Inline Variable）

**何时使用**：变量名没有比表达式本身传达更多信息

**动机**：移除不必要的间接层。

**操作步骤**：
1. 检查右侧表达式没有副作用
2. 如果变量不是不可变的，将其改为不可变并测试
3. 找到第一个引用并替换为表达式
4. 测试
5. 对所有引用重复
6. 移除声明和赋值
7. 测试

---

### 重命名变量（Rename Variable）

**何时使用**：名称不能清晰地传达其用途

**动机**：好的命名对代码整洁至关重要。

**操作步骤**：
1. 如果变量被广泛使用，考虑先将其封装
2. 找到所有引用
3. 修改每个引用
4. 测试

**提示**：
- 使用揭示意图的名称
- 避免缩写
- 使用领域术语

```javascript
// Bad
const d = 30;
const x = users.filter(u => u.a);

// Good
const daysSinceLastLogin = 30;
const activeUsers = users.filter(user => user.isActive);
```

---

### 改变函数声明（Change Function Declaration）

**何时使用**：函数名没有解释其用途、参数需要变更

**动机**：好的函数名使代码自文档化。

**操作步骤（简单方式）**：
1. 移除不需要的参数
2. 更改名称
3. 添加需要的参数
4. 测试

**操作步骤（迁移方式——用于复杂变更）**：
1. 如果要移除参数，确保它没有被使用
2. 创建具有期望声明的新函数
3. 让旧函数调用新函数
4. 测试
5. 将调用者改为使用新函数
6. 每次修改后测试
7. 移除旧函数

**重构前**：
```javascript
function circum(radius) {
  return 2 * Math.PI * radius;
}
```

**重构后**：
```javascript
function circumference(radius) {
  return 2 * Math.PI * radius;
}
```

---

### 封装变量（Encapsulate Variable）

**何时使用**：从多个地方直接访问数据

**动机**：为数据操作提供清晰的访问点。

**操作步骤**：
1. 创建 getter 和 setter 函数
2. 找到所有引用
3. 将读取替换为 getter
4. 将写入替换为 setter
5. 每次变更后测试
6. 限制变量的可见性

**重构前**：
```javascript
let defaultOwner = { firstName: "Martin", lastName: "Fowler" };

// Used in many places
spaceship.owner = defaultOwner;
```

**重构后**：
```javascript
let defaultOwnerData = { firstName: "Martin", lastName: "Fowler" };

function defaultOwner() { return defaultOwnerData; }
function setDefaultOwner(arg) { defaultOwnerData = arg; }

spaceship.owner = defaultOwner();
```

---

### 引入参数对象（Introduce Parameter Object）

**何时使用**：多个参数经常一起出现

**动机**：将自然属于一起的数据归组。

**操作步骤**：
1. 为归组的参数创建一个新的类/结构
2. 测试
3. 使用「改变函数声明」添加新对象
4. 测试
5. 对于组中的每个参数，从函数中移除它并使用新对象
6. 每次操作后测试

**重构前**：
```javascript
function amountInvoiced(startDate, endDate) { ... }
function amountReceived(startDate, endDate) { ... }
function amountOverdue(startDate, endDate) { ... }
```

**重构后**：
```javascript
class DateRange {
  constructor(start, end) {
    this.start = start;
    this.end = end;
  }
}

function amountInvoiced(dateRange) { ... }
function amountReceived(dateRange) { ... }
function amountOverdue(dateRange) { ... }
```

---

### 函数组合成类（Combine Functions into Class）

**何时使用**：多个函数操作相同的数据

**动机**：将函数与它们操作的数据归组在一起。

**操作步骤**：
1. 对公共数据应用「封装记录」
2. 将每个函数移入类中
3. 每次移动后测试
4. 将数据参数替换为类字段的使用

**重构前**：
```javascript
function base(reading) { ... }
function taxableCharge(reading) { ... }
function calculateBaseCharge(reading) { ... }
```

**重构后**：
```javascript
class Reading {
  constructor(data) { this._data = data; }

  get base() { ... }
  get taxableCharge() { ... }
  get calculateBaseCharge() { ... }
}
```

---

### 拆分阶段（Split Phase）

**何时使用**：代码处理两种不同的事情

**动机**：将代码分离为清晰的阶段，有明确的边界。

**操作步骤**：
1. 为第二个阶段创建第二个函数
2. 测试
3. 在阶段之间引入中间数据结构
4. 测试
5. 将第一个阶段提取到自己的函数中
6. 测试

**重构前**：
```javascript
function priceOrder(product, quantity, shippingMethod) {
  const basePrice = product.basePrice * quantity;
  const discount = Math.max(quantity - product.discountThreshold, 0)
    * product.basePrice * product.discountRate;
  const shippingPerCase = (basePrice > shippingMethod.discountThreshold)
    ? shippingMethod.discountedFee : shippingMethod.feePerCase;
  const shippingCost = quantity * shippingPerCase;
  return basePrice - discount + shippingCost;
}
```

**重构后**：
```javascript
function priceOrder(product, quantity, shippingMethod) {
  const priceData = calculatePricingData(product, quantity);
  return applyShipping(priceData, shippingMethod);
}

function calculatePricingData(product, quantity) {
  const basePrice = product.basePrice * quantity;
  const discount = Math.max(quantity - product.discountThreshold, 0)
    * product.basePrice * product.discountRate;
  return { basePrice, quantity, discount };
}

function applyShipping(priceData, shippingMethod) {
  const shippingPerCase = (priceData.basePrice > shippingMethod.discountThreshold)
    ? shippingMethod.discountedFee : shippingMethod.feePerCase;
  const shippingCost = priceData.quantity * shippingPerCase;
  return priceData.basePrice - priceData.discount + shippingCost;
}
```

---

## 搬移特性

### 搬移函数（Move Method）

**何时使用**：函数使用另一个类的特性多于它自己的类

**动机**：将函数放在它们使用最多的数据旁边。

**操作步骤**：
1. 检查该方法在其类中使用的所有程序元素
2. 检查方法是否多态
3. 将方法复制到目标类
4. 为新上下文进行调整
5. 使原方法委托给目标
6. 测试
7. 考虑移除原方法

---

### 搬移字段（Move Field）

**何时使用**：字段被另一个类使用得更多

**动机**：将数据与使用它的函数放在一起。

**操作步骤**：
1. 如果尚未封装，先封装该字段
2. 测试
3. 在目标中创建字段
4. 更新引用以使用目标字段
5. 测试
6. 移除原始字段

---

### 将语句搬移到函数中（Move Statements into Function）

**何时使用**：相同的代码总是与某个函数调用一起出现

**动机**：通过将重复代码移入函数来消除重复。

**操作步骤**：
1. 如果尚未提取，先将重复代码提取为一个函数
2. 将语句搬移到该函数中
3. 测试
4. 如果调用者不再需要独立的语句，将其移除

---

### 将语句搬移到调用者（Move Statements to Callers）

**何时使用**：公共行为在不同调用者之间有所变化

**动机**：当行为需要不同时，将其移出函数。

**操作步骤**：
1. 对要搬移的代码使用「提炼函数」
2. 对原函数使用「内联函数」
3. 移除现在内联的调用
4. 将提取的代码移入每个调用者
5. 测试

---

## 重新组织数据

### 以对象取代基本类型（Replace Primitive with Object）

**何时使用**：数据项需要比简单值更多的行为

**动机**：将数据与其行为一起封装。

**操作步骤**：
1. 应用「封装变量」
2. 创建一个简单的值类
3. 修改 setter 以创建新实例
4. 修改 getter 以返回值
5. 测试
6. 向新类添加更丰富的行为

**重构前**：
```javascript
class Order {
  constructor(data) {
    this.priority = data.priority; // string: "high", "rush", etc.
  }
}

// Usage
if (order.priority === "high" || order.priority === "rush") { ... }
```

**重构后**：
```javascript
class Priority {
  constructor(value) {
    if (!Priority.legalValues().includes(value))
      throw new Error(`Invalid priority: ${value}`);
    this._value = value;
  }

  static legalValues() { return ['low', 'normal', 'high', 'rush']; }
  get value() { return this._value; }

  higherThan(other) {
    return Priority.legalValues().indexOf(this._value) >
           Priority.legalValues().indexOf(other._value);
  }
}

// Usage
if (order.priority.higherThan(new Priority("normal"))) { ... }
```

---

### 以查询取代临时变量（Replace Temp with Query）

**何时使用**：临时变量存储表达式的结果

**动机**：通过将表达式提取为函数，使代码更清晰。

**操作步骤**：
1. 检查变量仅被赋值一次
2. 将赋值的右侧提取为一个函数
3. 将对临时变量的引用替换为函数调用
4. 测试
5. 移除临时变量声明和赋值

**重构前**：
```javascript
const basePrice = this._quantity * this._itemPrice;
if (basePrice > 1000) {
  return basePrice * 0.95;
} else {
  return basePrice * 0.98;
}
```

**重构后**：
```javascript
get basePrice() {
  return this._quantity * this._itemPrice;
}

// In the method
if (this.basePrice > 1000) {
  return this.basePrice * 0.95;
} else {
  return this.basePrice * 0.98;
}
```

---

## 简化条件逻辑

### 分解条件表达式（Decompose Conditional）

**何时使用**：复杂的条件（if-then-else）语句

**动机**：通过提取条件和动作，使意图清晰。

**操作步骤**：
1. 对条件应用「提炼函数」
2. 对 then 分支应用「提炼函数」
3. 对 else 分支（如果存在）应用「提炼函数」

**重构前**：
```javascript
if (!aDate.isBefore(plan.summerStart) && !aDate.isAfter(plan.summerEnd)) {
  charge = quantity * plan.summerRate;
} else {
  charge = quantity * plan.regularRate + plan.regularServiceCharge;
}
```

**重构后**：
```javascript
if (isSummer(aDate, plan)) {
  charge = summerCharge(quantity, plan);
} else {
  charge = regularCharge(quantity, plan);
}

function isSummer(date, plan) {
  return !date.isBefore(plan.summerStart) && !date.isAfter(plan.summerEnd);
}

function summerCharge(quantity, plan) {
  return quantity * plan.summerRate;
}

function regularCharge(quantity, plan) {
  return quantity * plan.regularRate + plan.regularServiceCharge;
}
```

---

### 合并条件表达式（Consolidate Conditional Expression）

**何时使用**：多个条件产生相同结果

**动机**：明确这些条件是一个单一检查。

**操作步骤**：
1. 验证条件中没有副作用
2. 使用 `and` 或 `or` 合并条件
3. 考虑对合并后的条件应用「提炼函数」

**重构前**：
```javascript
if (employee.seniority < 2) return 0;
if (employee.monthsDisabled > 12) return 0;
if (employee.isPartTime) return 0;
```

**重构后**：
```javascript
if (isNotEligibleForDisability(employee)) return 0;

function isNotEligibleForDisability(employee) {
  return employee.seniority < 2 ||
         employee.monthsDisabled > 12 ||
         employee.isPartTime;
}
```

---

### 以卫语句取代嵌套条件表达式（Replace Nested Conditional with Guard Clauses）

**何时使用**：深层嵌套的条件使流程难以跟踪

**动机**：对特殊情况使用卫语句提前返回，保持正常流程清晰。

**操作步骤**：
1. 找到特殊情况的条件
2. 用提前返回的卫语句替换它们
3. 每次变更后测试

**重构前**：
```javascript
function payAmount(employee) {
  let result;
  if (employee.isSeparated) {
    result = { amount: 0, reasonCode: "SEP" };
  } else {
    if (employee.isRetired) {
      result = { amount: 0, reasonCode: "RET" };
    } else {
      result = calculateNormalPay(employee);
    }
  }
  return result;
}
```

**重构后**：
```javascript
function payAmount(employee) {
  if (employee.isSeparated) return { amount: 0, reasonCode: "SEP" };
  if (employee.isRetired) return { amount: 0, reasonCode: "RET" };
  return calculateNormalPay(employee);
}
```

---

### 以多态取代条件表达式（Replace Conditional with Polymorphism）

**何时使用**：基于类型的 switch/case、因类型而异的条件逻辑

**动机**：让对象处理自己的行为。

**操作步骤**：
1. 创建类层次结构（如果尚不存在）
2. 使用工厂函数创建对象
3. 将条件逻辑移入超类方法
4. 为每种情况创建子类方法
5. 移除原始条件

**重构前**：
```javascript
function plumages(birds) {
  return birds.map(b => plumage(b));
}

function plumage(bird) {
  switch (bird.type) {
    case 'EuropeanSwallow':
      return "average";
    case 'AfricanSwallow':
      return (bird.numberOfCoconuts > 2) ? "tired" : "average";
    case 'NorwegianBlueParrot':
      return (bird.voltage > 100) ? "scorched" : "beautiful";
    default:
      return "unknown";
  }
}
```

**重构后**：
```javascript
class Bird {
  get plumage() { return "unknown"; }
}

class EuropeanSwallow extends Bird {
  get plumage() { return "average"; }
}

class AfricanSwallow extends Bird {
  get plumage() {
    return (this.numberOfCoconuts > 2) ? "tired" : "average";
  }
}

class NorwegianBlueParrot extends Bird {
  get plumage() {
    return (this.voltage > 100) ? "scorched" : "beautiful";
  }
}

function createBird(data) {
  switch (data.type) {
    case 'EuropeanSwallow': return new EuropeanSwallow(data);
    case 'AfricanSwallow': return new AfricanSwallow(data);
    case 'NorwegianBlueParrot': return new NorwegianBlueParrot(data);
    default: return new Bird(data);
  }
}
```

---

### 引入特例（空对象）（Introduce Special Case / Null Object）

**何时使用**：对特殊情况反复进行空值检查

**动机**：返回一个处理特殊情况的对象。

**操作步骤**：
1. 创建具有预期接口的特例类
2. 添加 isSpecialCase 检查
3. 引入工厂方法
4. 将空值检查替换为特例对象的使用
5. 测试

**重构前**：
```javascript
const customer = site.customer;
// ... many places checking
if (customer === "unknown") {
  customerName = "occupant";
} else {
  customerName = customer.name;
}
```

**重构后**：
```javascript
class UnknownCustomer {
  get name() { return "occupant"; }
  get billingPlan() { return registry.defaultPlan; }
}

// Factory method
function customer(site) {
  return site.customer === "unknown"
    ? new UnknownCustomer()
    : site.customer;
}

// Usage - no null checks needed
const customerName = customer.name;
```

---

## 重构 API

### 将查询函数和修改函数分离（Separate Query from Modifier）

**何时使用**：函数既返回值又有副作用

**动机**：明确哪些操作有副作用。

**操作步骤**：
1. 创建一个新的查询函数
2. 复制原函数的返回逻辑
3. 修改原函数返回 void
4. 替换使用返回值的调用
5. 测试

**重构前**：
```javascript
function alertForMiscreant(people) {
  for (const p of people) {
    if (p === "Don") {
      setOffAlarms();
      return "Don";
    }
    if (p === "John") {
      setOffAlarms();
      return "John";
    }
  }
  return "";
}
```

**重构后**：
```javascript
function findMiscreant(people) {
  for (const p of people) {
    if (p === "Don") return "Don";
    if (p === "John") return "John";
  }
  return "";
}

function alertForMiscreant(people) {
  if (findMiscreant(people) !== "") setOffAlarms();
}
```

---

### 参数化函数（Parameterize Function）

**何时使用**：多个函数做类似的事情，但使用不同的值

**动机**：通过添加参数来消除重复。

**操作步骤**：
1. 选择一个函数
2. 为变化的字面量添加参数
3. 修改函数体使用该参数
4. 测试
5. 将调用者改为使用参数化版本
6. 移除现在不再使用的函数

**重构前**：
```javascript
function tenPercentRaise(person) {
  person.salary = person.salary * 1.10;
}

function fivePercentRaise(person) {
  person.salary = person.salary * 1.05;
}
```

**重构后**：
```javascript
function raise(person, factor) {
  person.salary = person.salary * (1 + factor);
}

// Usage
raise(person, 0.10);
raise(person, 0.05);
```

---

### 移除标记参数（Remove Flag Argument）

**何时使用**：布尔参数改变函数行为

**动机**：通过独立的函数使行为显式化。

**操作步骤**：
1. 为每个标记值创建显式函数
2. 将每个调用替换为适当的新函数
3. 每次变更后测试
4. 移除原函数

**重构前**：
```javascript
function bookConcert(customer, isPremium) {
  if (isPremium) {
    // premium booking logic
  } else {
    // regular booking logic
  }
}

bookConcert(customer, true);
bookConcert(customer, false);
```

**重构后**：
```javascript
function bookPremiumConcert(customer) {
  // premium booking logic
}

function bookRegularConcert(customer) {
  // regular booking logic
}

bookPremiumConcert(customer);
bookRegularConcert(customer);
```

---

## 处理继承关系

### 函数上移（Pull Up Method）

**何时使用**：多个子类中有相同的方法

**动机**：消除类层次结构中的重复。

**操作步骤**：
1. 检查方法确保它们完全相同
2. 检查签名相同
3. 在超类中创建新方法
4. 从一个子类复制方法体
5. 删除一个子类的方法，测试
6. 删除其他子类的方法，逐一测试

---

### 函数下移（Push Down Method）

**何时使用**：行为仅与部分子类相关

**动机**：将方法放在它被使用的地方。

**操作步骤**：
1. 将方法复制到需要它的每个子类
2. 从超类中移除方法
3. 测试
4. 从不需要它的子类中移除
5. 测试

---

### 以委托取代子类（Replace Subclass with Delegate）

**何时使用**：继承被错误使用，需要更多灵活性

**动机**：在适当的时候，优先使用组合而非继承。

**操作步骤**：
1. 为委托创建空类
2. 在宿主类中添加持有委托的字段
3. 为委托创建构造函数，从宿主调用
4. 将特性搬移到委托
5. 每次搬移后测试
6. 用委托取代继承

---

## 提炼类（Extract Class）

**何时使用**：大类有多个职责

**动机**：拆分大类以维持单一职责。

**操作步骤**：
1. 决定如何拆分职责
2. 创建新类
3. 将字段从原类搬移到新类
4. 测试
5. 将方法从原类搬移到新类
6. 每次搬移后测试
7. 检查并重命名两个类
8. 决定如何暴露新类

**重构前**：
```javascript
class Person {
  get name() { return this._name; }
  set name(arg) { this._name = arg; }
  get officeAreaCode() { return this._officeAreaCode; }
  set officeAreaCode(arg) { this._officeAreaCode = arg; }
  get officeNumber() { return this._officeNumber; }
  set officeNumber(arg) { this._officeNumber = arg; }

  get telephoneNumber() {
    return `(${this._officeAreaCode}) ${this._officeNumber}`;
  }
}
```

**重构后**：
```javascript
class Person {
  constructor() {
    this._telephoneNumber = new TelephoneNumber();
  }
  get name() { return this._name; }
  set name(arg) { this._name = arg; }
  get telephoneNumber() { return this._telephoneNumber.toString(); }
  get officeAreaCode() { return this._telephoneNumber.areaCode; }
  set officeAreaCode(arg) { this._telephoneNumber.areaCode = arg; }
}

class TelephoneNumber {
  get areaCode() { return this._areaCode; }
  set areaCode(arg) { this._areaCode = arg; }
  get number() { return this._number; }
  set number(arg) { this._number = arg; }
  toString() { return `(${this._areaCode}) ${this._number}`; }
}
```

---

## 快速参考：坏味道到重构映射

| 代码坏味道 | 主要重构手法 | 替代方案 |
|------------|-------------------|-------------|
| 过长函数 | 提炼函数 | 以查询取代临时变量 |
| 重复代码 | 提炼函数 | 函数上移 |
| 过大的类 | 提炼类 | 提炼子类 |
| 过长参数列表 | 引入参数对象 | 保持对象完整 |
| 依恋情结 | 搬移函数 | 提炼函数 + 搬移 |
| 数据泥团 | 提炼类 | 引入参数对象 |
| 基本类型偏执 | 以对象取代基本类型 | 以子类取代类型码 |
| Switch 语句 | 以多态取代条件表达式 | 以子类取代类型码 |
| 临时字段 | 提炼类 | 引入空对象 |
| 过长的消息链 | 隐藏委托关系 | 提炼函数 |
| 中间人 | 移除中间人 | 内联函数 |
| 发散式变化 | 提炼类 | 拆分阶段 |
| 霰弹式修改 | 搬移函数 | 内联类 |
| 死代码 | 删除死代码 | - |
| 夸夸其谈的通用性 | 折叠继承体系 | 内联类 |

---

## 进一步阅读

- Fowler, M. (2018). *重构：改善既有代码的设计*（第 2 版）
- 在线目录：https://refactoring.com/catalog/
