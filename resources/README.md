<picture>
  <source media="(prefers-color-scheme: dark)" srcset="logos/claude-howto-logo-dark.svg">
  <img alt="Claude How To" src="logos/claude-howto-logo.svg">
</picture>

# Claude How To - 品牌资源

Claude How To 项目的完整 Logo、图标和 Favicon 集合。所有资源均采用 V3.0 设计：一个带有代码尖括号（`>`）符号的指南针，象征在代码中的引导式导航——使用黑/白/灰色调，辅以亮绿色（#22C55E）作为强调色。

## 目录结构

```
resources/
├── logos/
│   ├── claude-howto-logo.svg       # 主 Logo - 浅色模式 (520×120px)
│   └── claude-howto-logo-dark.svg  # 主 Logo - 深色模式 (520×120px)
├── icons/
│   ├── claude-howto-icon.svg       # 应用图标 - 浅色模式 (256×256px)
│   └── claude-howto-icon-dark.svg  # 应用图标 - 深色模式 (256×256px)
└── favicons/
    ├── favicon-16.svg              # Favicon - 16×16px
    ├── favicon-32.svg              # Favicon - 32×32px（主 favicon）
    ├── favicon-64.svg              # Favicon - 64×64px
    ├── favicon-128.svg             # Favicon - 128×128px
    └── favicon-256.svg             # Favicon - 256×256px
```

`assets/logo/` 中的附加资源：
```
assets/logo/
├── logo-full.svg       # 标志 + 文字商标（横向）
├── logo-mark.svg       # 仅指南针符号 (120×120px)
├── logo-wordmark.svg   # 仅文字
├── logo-icon.svg       # 应用图标 (512×512, 圆角)
├── favicon.svg         # 16×16 优化版
├── logo-white.svg      # 深色背景用的白色版本
└── logo-black.svg      # 黑色单色版本
```

## 资源概览

### 设计理念（V3.0）

**指南针与代码尖括号** — 引导与代码相交融：
- **指南针圆环** = 导航，找到你的方向
- **北方指针（绿色）** = 方向，学习路径上的进步
- **南方指针（黑色）** = 根基，扎实的基础
- **`>` 尖括号** = 终端提示符、代码、CLI 上下文
- **刻度标记** = 精确性，结构化的学习

### Logo

**文件**：
- `logos/claude-howto-logo.svg`（浅色模式）
- `logos/claude-howto-logo-dark.svg`（深色模式）

**规格**：
- **尺寸**：520×120 px
- **用途**：带文字商标的主标题/品牌 Logo
- **使用场景**：
  - 网站标题
  - README 徽章
  - 营销物料
  - 印刷材料
- **格式**：SVG（完全可缩放）
- **模式**：浅色（白色背景）和深色（#0A0A0A 背景）

### 图标

**文件**：
- `icons/claude-howto-icon.svg`（浅色模式）
- `icons/claude-howto-icon-dark.svg`（深色模式）

**规格**：
- **尺寸**：256×256 px
- **用途**：应用图标、头像、缩略图
- **使用场景**：
  - 应用图标
  - 个人资料头像
  - 社交媒体缩略图
  - 文档页眉
- **格式**：SVG（完全可缩放）
- **模式**：浅色（白色背景）和深色（#0A0A0A 背景）

**设计元素**：
- 带有四方位和间方位刻度标记的指南针圆环
- 绿色北方指针（方向/引导）
- 黑色南方指针（基础）
- 中心的 `>` 代码尖括号（终端/CLI）
- 绿色中心点强调

### Favicon

针对网页使用优化的多个尺寸版本：

| 文件 | 尺寸 | DPI | 用途 |
|------|------|-----|-------|
| `favicon-16.svg` | 16×16 px | 1x | 浏览器标签页（旧版浏览器） |
| `favicon-32.svg` | 32×32 px | 1x | 标准浏览器 favicon |
| `favicon-64.svg` | 64×64 px | 1x-2x | 高 DPI 显示器 |
| `favicon-128.svg` | 128×128 px | 2x | Apple 触摸图标、书签 |
| `favicon-256.svg` | 256×256 px | 4x | 现代浏览器、PWA 图标 |

**优化说明**：
- 16px：极简几何图形 — 仅包含圆环、指针和尖括号
- 32px：增加四方位刻度标记
- 64px+：完整细节，包含间方位刻度标记
- 所有版本均与主图标保持视觉一致性
- SVG 格式确保在任何尺寸下都清晰显示

## HTML 集成

### 基础 Favicon 设置

```html
<!-- 浏览器 favicon -->
<link rel="icon" type="image/svg+xml" href="/resources/favicons/favicon-32.svg">
<link rel="icon" type="image/svg+xml" href="/resources/favicons/favicon-16.svg" sizes="16x16">

<!-- Apple 触摸图标（移动端主屏幕） -->
<link rel="apple-touch-icon" href="/resources/favicons/favicon-128.svg">

<!-- PWA 及现代浏览器 -->
<link rel="icon" type="image/svg+xml" href="/resources/favicons/favicon-256.svg" sizes="256x256">
```

### 完整设置

```html
<head>
  <!-- 主 favicon -->
  <link rel="icon" type="image/svg+xml" href="/resources/favicons/favicon-32.svg" sizes="32x32">
  <link rel="icon" type="image/svg+xml" href="/resources/favicons/favicon-16.svg" sizes="16x16">

  <!-- Apple 触摸图标 -->
  <link rel="apple-touch-icon" href="/resources/favicons/favicon-128.svg">

  <!-- PWA 图标 -->
  <link rel="icon" type="image/svg+xml" href="/resources/favicons/favicon-256.svg" sizes="256x256">

  <!-- Android -->
  <link rel="shortcut icon" href="/resources/favicons/favicon-256.svg">

  <!-- PWA Manifest 引用（若使用 manifest.json） -->
  <meta name="theme-color" content="#000000">
</head>
```

## 色彩方案

### 主色调
- **黑色**：`#000000`（主文字、描边、南指针）
- **白色**：`#FFFFFF`（浅色背景）
- **灰色**：`#6B7280`（辅助文字、次要刻度标记）

### 强调色
- **亮绿色**：`#22C55E`（北指针、中心点、强调线 — 仅用于高亮，绝不作为背景色）

### 深色模式
- **背景色**：`#0A0A0A`（近黑色）

### CSS 变量
```css
--color-primary: #000000;
--color-secondary: #6B7280;
--color-accent: #22C55E;
--color-bg-light: #FFFFFF;
--color-bg-dark: #0A0A0A;
```

### Tailwind 配置
```js
colors: {
  brand: {
    primary: '#000000',
    secondary: '#6B7280',
    accent: '#22C55E',
  }
}
```

### 使用指南
- 将黑色用于主文字和结构元素
- 将灰色用于辅助/支撑元素
- 绿色**仅**用于高亮 — 指针、圆点、强调线
- 绝不要将绿色用作背景色
- 保持 WCAG AA 对比度（最低 4.5:1）

## 设计规范

### Logo 使用
- 在白色或深色（#0A0A0A）背景上使用
- 按比例缩放
- 在 Logo 周围保留足够的留白空间（最小：Logo 高度 / 2）
- 在相应背景下使用提供的浅色/深色变体

### 图标使用
- 使用标准尺寸：16、32、64、128、256px
- 保持指南针的比例
- 按比例缩放

### Favicon 使用
- 根据场景使用适当的尺寸
- 16-32px：浏览器标签页、书签
- 64px：Favicon 网站图标
- 128px+：Apple/Android 主屏幕

## SVG 优化

所有 SVG 文件均为扁平设计，无渐变或滤镜：
- 干净的基于描边的几何图形
- 无嵌入位图
- 优化过的路径
- 响应式 viewBox

针对网页优化的命令：
```bash
# 在保持质量的前提下压缩 SVG
svgo --config='{
  "js2svg": {
    "indent": 2
  },
  "plugins": [
    "convertStyleToAttrs",
    "removeRasterImages"
  ]
}' input.svg -o output.svg
```

## PNG 转换

将 SVG 转换为 PNG 以支持旧版浏览器：

```bash
# 使用 ImageMagick
convert -density 300 -background none favicon-256.svg favicon-256.png

# 使用 Inkscape
inkscape -D -z --file=favicon-256.svg --export-png=favicon-256.png
```

## 无障碍

- 高对比度颜色比（符合 WCAG AA 标准 — 最低 4.5:1）
- 在各种尺寸下均可辨识的简洁几何图形
- 可缩放矢量格式
- 图标中不含文字（文字在文字商标中单独添加）
- 不依赖红绿色区分来传达含义

## 归属声明

这些资源是 Claude How To 项目的一部分。

**许可证**：MIT（参见项目 LICENSE 文件）

## 版本历史

- **v3.0**（2026年2月）：指南针-尖括号设计，黑/白/灰 + 绿色强调色方案
- **v2.0**（2026年1月）：受 Claude 启发的12射线星芒设计，翡翠色系
- **v1.0**（2026年1月）：原始的基于六边形的渐进式图标设计

---

**最后更新**：2026年2月
**当前版本**：3.0（指南针-尖括号）
**所有资源**：可用于生产环境的 SVG，完全可缩放，符合 WCAG AA 无障碍标准
