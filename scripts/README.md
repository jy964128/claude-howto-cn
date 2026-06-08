<picture>
  <source media="(prefers-color-scheme: dark)" srcset="../resources/logos/claude-howto-logo-dark.svg">
  <img alt="Claude How To" src="../resources/logos/claude-howto-logo.svg">
</picture>

# 构建脚本

本目录包含两个生成器，用于将教程 Markdown 文件转换为可分发的格式：

- [**EPUB 构建器**](#epub-构建器脚本) — `build_epub.py`
- [**静态网站构建器**](#静态网站构建器) — `build_website.py`

两者都将 `.md` 文件视为唯一数据源——编辑 Markdown 后重新运行相应脚本即可重新生成输出。

---

# EPUB 构建器脚本

从 Claude How-To Markdown 文件构建 EPUB 电子书。

## 功能特性

- 按文件夹结构组织章节（01-slash-commands、02-memory 等）
- 通过 Kroki.io API 将 Mermaid 图表渲染为 PNG 图片
- 异步并发获取——所有图表并行渲染
- 从项目 Logo 生成封面图片
- 将内部 Markdown 链接转换为 EPUB 章节引用
- 严格错误模式——任何图表无法渲染时构建失败

## 环境要求

- Python 3.10+
- [uv](https://github.com/astral-sh/uv)
- 需要网络连接以渲染 Mermaid 图表

## 快速开始

```bash
# 最简单的方式——uv 会处理一切
uv run scripts/build_epub.py
```

## 开发环境设置

```bash
# 创建虚拟环境
uv venv

# 激活并安装依赖
source .venv/bin/activate
uv pip install -r requirements-dev.txt

# 运行测试
pytest scripts/tests/ -v

# 运行脚本
python scripts/build_epub.py
```

## 命令行选项

```
usage: build_epub.py [-h] [--root ROOT] [--output OUTPUT] [--verbose]
                     [--timeout TIMEOUT] [--max-concurrent MAX_CONCURRENT]

options:
  -h, --help            显示此帮助信息并退出
  --root, -r ROOT       根目录（默认：仓库根目录）
  --output, -o OUTPUT   输出路径（默认：claude-howto-guide.epub）
  --verbose, -v         启用详细日志输出
  --timeout TIMEOUT     API 超时时间，单位秒（默认：30）
  --max-concurrent N    最大并发请求数（默认：10）
```

## 示例

```bash
# 构建并显示详细输出
uv run scripts/build_epub.py --verbose

# 自定义输出位置
uv run scripts/build_epub.py --output ~/Desktop/claude-guide.epub

# 限制并发请求数（遇到速率限制时使用）
uv run scripts/build_epub.py --max-concurrent 5
```

## 输出

在仓库根目录下创建 `claude-howto-guide.epub` 文件。

EPUB 包含：
- 带有项目 Logo 的封面图片
- 含嵌套节节目录
- 所有转换为 EPUB 兼容 HTML 的 Markdown 内容
- 渲染为 PNG 图片的 Mermaid 图表

## 运行测试

```bash
# 使用虚拟环境
source .venv/bin/activate
pytest scripts/tests/ -v

# 或直接使用 uv
uv run --with pytest --with pytest-asyncio \
    --with ebooklib --with markdown --with beautifulsoup4 \
    --with httpx --with pillow --with tenacity \
    pytest scripts/tests/ -v
```

## 依赖

通过 PEP 723 内联脚本元数据管理：

| 包名 | 用途 |
|---------|---------|
| `ebooklib` | EPUB 生成 |
| `markdown` | Markdown 到 HTML 的转换 |
| `beautifulsoup4` | HTML 解析 |
| `httpx` | 异步 HTTP 客户端 |
| `pillow` | 封面图片生成 |
| `tenacity` | 重试逻辑 |

## 故障排查

**构建失败并报网络错误**：检查网络连接和 Kroki.io 状态。尝试使用 `--timeout 60`。

**速率限制**：使用 `--max-concurrent 3` 减少并发请求数。

**缺少 Logo**：如果找不到 `claude-howto-logo.png`，脚本将生成仅含文字的封面。

---

# 静态网站构建器

从 EPUB 构建所用的相同 Markdown 文件生成一个优雅、移动端友好的静态网站。网站是渲染后的视图；`.md` 文件仍然是唯一数据源。

## 功能特性

- 每个 Markdown 源文件对应一个 HTML 页面——内部 `.md` 链接会被重写为站点上对应的页面
- 引用非 Markdown 仓库文件（模板、脚本、JSON）的链接会转换为指向 github.com 上源文件的 GitHub blob URL
- Mermaid 图表通过 `mermaid.min.js` 在客户端渲染，该文件从构建好的站点本地提供（运行时无需 CDN）
- Tailwind CSS 使用独立 CLI（Go 二进制文件，无需 Node.js）编译，并从构建好的站点本地提供——响应式布局，包含侧边栏导航、页内目录、深色模式切换以及上/下页导航
- Inter 和 JetBrains Mono 字体与 CSS 一同自托管——页面加载时无第三方请求
- 遵循 EPUB 课程顺序（`01-` … `10-` 加上顶层文档）
- 可作为纯静态文件托管——专为部署到 GitHub Pages 设计

## 快速开始

```bash
# 将英文网站构建到 ./site/ 目录
uv run scripts/build_website.py

# 本地预览
python -m http.server --directory site 8080
# 然后打开 http://localhost:8080
```

## 命令行选项

```
usage: build_website.py [-h] [--root ROOT] [--output OUTPUT]
                        [--lang {en,vi,zh,ja,uk}] [--repo-url REPO_URL]
                        [--branch BRANCH] [--verbose]

options:
  --root, -r ROOT       源文件根目录（默认：仓库根目录）
  --output, -o OUTPUT   输出目录（默认：<repo>/site）
  --lang LANG           要构建的语言：en | vi | zh | ja | uk
  --repo-url URL        用于 blob 链接的 GitHub 仓库（默认：luongnv89/claude-howto）
  --branch BRANCH       用于 blob 链接的分支（默认：main）
  --verbose, -v         启用详细日志输出
```

## GitHub Pages 部署

仓库自带一个工作流文件 `.github/workflows/pages.yml`，该工作流在每次推送到 `main` 分支（且有任何 `.md` 或生成器文件变更时）时构建网站，并通过 `actions/deploy-pages` 发布。在仓库设置中启用 GitHub Pages，选择 **Source: GitHub Actions** 即可激活。

## 架构

`build_website.py` 复用了 `build_epub.py` 中的章节排序逻辑，并在 `scripts/website_templates/` 下提供了 HTML 模板：

- `page.html.j2` — 每个页面的 Jinja2 模板，包含侧边栏导航、目录、上/下页
- `tailwind.config.js`、`tailwind.input.css` — Tailwind 独立 CLI 的配置文件与入口 CSS；CLI 会扫描构建好的 HTML 并生成仅包含实际使用工具类的 `site/assets/tailwind.css`
- `site.css` — 一小层站点特定样式加上 Pygments 主题

Tailwind CLI 二进制文件、Mermaid 包和字体文件在首次构建时下载到 `scripts/.vendor-cache/`（已被 gitignore 忽略）——详见 `scripts/vendor_assets.py`。

标题锚点使用 `check_cross_references.heading_to_anchor` 中的精确算法生成，因此 pre-commit 钩子验证通过的 `#anchor` 链接在渲染后的网站上能正确解析。
