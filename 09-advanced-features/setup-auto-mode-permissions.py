```python
#!/usr/bin/env python3
"""
setup-auto-mode-permissions.py

将一套保守的安全权限基线写入 ~/.claude/settings.json，
用于 Claude Code。默认权限集面向只读和本地检查；
通过可选标志可以扩展允许列表，涵盖编辑、测试执行、git
写操作、包安装以及 GitHub CLI 写操作。

用法：
    python3 setup-auto-mode-permissions.py
    python3 setup-auto-mode-permissions.py --dry-run
    python3 setup-auto-mode-permissions.py --include-edits --include-tests
"""

from __future__ import annotations

import argparse
import json
import tempfile
from pathlib import Path
from typing import Iterable

SETTINGS_PATH = Path.home() / ".claude" / "settings.json"

# 核心基线：只读检查和低风险本地 shell 命令。
CORE_PERMISSIONS = [
    "Read(*)",
    "Glob(*)",
    "Grep(*)",
    "Agent(*)",
    "Skill(*)",
    "WebSearch(*)",
    "WebFetch(*)",
    "Bash(ls:*)",
    "Bash(pwd:*)",
    "Bash(which:*)",
    "Bash(echo:*)",
    "Bash(cat:*)",
    "Bash(head:*)",
    "Bash(tail:*)",
    "Bash(wc:*)",
    "Bash(sort:*)",
    "Bash(uniq:*)",
    "Bash(find:*)",
    "Bash(dirname:*)",
    "Bash(basename:*)",
    "Bash(realpath:*)",
    "Bash(file:*)",
    "Bash(stat:*)",
    "Bash(diff:*)",
    "Bash(md5sum:*)",
    "Bash(sha256sum:*)",
    "Bash(date:*)",
    "Bash(env:*)",
    "Bash(printenv:*)",
    "Bash(git status:*)",
    "Bash(git log:*)",
    "Bash(git diff:*)",
    "Bash(git branch:*)",
    "Bash(git show:*)",
    "Bash(git rev-parse:*)",
    "Bash(git remote -v:*)",
    "Bash(git remote get-url:*)",
    "Bash(git stash list:*)",
]

# 可选但仍为本地操作：文件编辑和任务记录。
EDITING_PERMISSIONS = [
    "Edit(*)",
    "Write(*)",
    "NotebookEdit(*)",
    "TaskCreate(*)",
    "TaskUpdate(*)",
]

# 可选的开发/测试命令。这些命令仍然可以执行任意项目脚本，
# 因此保持为可选加入，而非默认基线的一部分。
TEST_AND_BUILD_PERMISSIONS = [
    "Bash(npm test:*)",
    "Bash(cargo test:*)",
    "Bash(go test:*)",
    "Bash(pytest:*)",
    "Bash(python3 -m pytest:*)",
    "Bash(make:*)",
    "Bash(cmake:*)",
]

# 可选的本地 git 写操作。历史重写命令不包含在
# 默认基线中，因为它们容易被误用。
GIT_WRITE_PERMISSIONS = [
    "Bash(git add:*)",
    "Bash(git commit:*)",
    "Bash(git checkout:*)",
    "Bash(git switch:*)",
    "Bash(git stash:*)",
    "Bash(git tag:*)",
]

# 可选的依赖/包管理命令。这些命令有意被排除在
# 默认基线之外，因为它们可以执行项目钩子或获取代码。
PACKAGE_MANAGER_PERMISSIONS = [
    "Bash(npm ci:*)",
    "Bash(npm install:*)",
    "Bash(pip install:*)",
    "Bash(pip3 install:*)",
]

# 可选的 GitHub CLI 写访问。
GITHUB_WRITE_PERMISSIONS = [
    "Bash(gh pr create:*)",
]

# 可选的额外 GitHub CLI 读访问。
GITHUB_READ_PERMISSIONS = [
    "Bash(gh pr view:*)",
    "Bash(gh pr list:*)",
    "Bash(gh issue view:*)",
    "Bash(gh issue list:*)",
    "Bash(gh repo view:*)",
]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="使用保守的权限基线初始化 Claude Code 设置。"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="预览将要添加的规则，而不写入 settings.json",
    )
    parser.add_argument(
        "--include-edits",
        action="store_true",
        help="添加文件编辑权限（Edit/Write/NotebookEdit/TaskCreate/TaskUpdate）",
    )
    parser.add_argument(
        "--include-tests",
        action="store_true",
        help="添加本地构建/测试命令，如 pytest、cargo test 和 make",
    )
    parser.add_argument(
        "--include-git-write",
        action="store_true",
        help="添加本地 git 变更命令，如 add、commit、checkout 和 stash",
    )
    parser.add_argument(
        "--include-packages",
        action="store_true",
        help="添加包安装命令，如 npm ci、npm install 和 pip install",
    )
    parser.add_argument(
        "--include-gh-write",
        action="store_true",
        help="添加 GitHub CLI 写权限，如 gh pr create",
    )
    parser.add_argument(
        "--include-gh-read",
        action="store_true",
        help="添加 GitHub CLI 读权限，如 gh pr view 和 gh repo view",
    )
    return parser.parse_args()


def load_settings(path: Path) -> dict:
    if not path.exists():
        return {}

    try:
        with path.open() as f:
            settings = json.load(f)
    except json.JSONDecodeError as exc:
        raise SystemExit(f"{path} 中的 JSON 无效：{exc}") from exc

    if not isinstance(settings, dict):
        raise SystemExit(f"期望 {path} 包含一个 JSON 对象。")

    return settings


def build_permissions(args: argparse.Namespace) -> list[str]:
    permissions = list(CORE_PERMISSIONS)

    if args.include_edits:
        permissions.extend(EDITING_PERMISSIONS)

    if args.include_tests:
        permissions.extend(TEST_AND_BUILD_PERMISSIONS)

    if args.include_git_write:
        permissions.extend(GIT_WRITE_PERMISSIONS)

    if args.include_packages:
        permissions.extend(PACKAGE_MANAGER_PERMISSIONS)

    if args.include_gh_write:
        permissions.extend(GITHUB_WRITE_PERMISSIONS)

    if args.include_gh_read:
        permissions.extend(GITHUB_READ_PERMISSIONS)

    return permissions


def append_unique(existing: list, new_items: Iterable[str]) -> list[str]:
    seen = set(existing)
    added: list[str] = []
    for item in new_items:
        if item not in seen:
            existing.append(item)
            seen.add(item)
            added.append(item)
    return added


def atomic_write_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(
        "w",
        encoding="utf-8",
        dir=str(path.parent),
        delete=False,
    ) as tmp:
        json.dump(payload, tmp, indent=2)
        tmp.write("\n")
        tmp_path = Path(tmp.name)

    tmp_path.replace(path)


def main() -> None:
    args = parse_args()
    permissions_to_add = build_permissions(args)

    settings = load_settings(SETTINGS_PATH)
    permissions = settings.setdefault("permissions", {})

    if not isinstance(permissions, dict):
        raise SystemExit("期望 permissions 为一个 JSON 对象。")

    allow = permissions.setdefault("allow", [])
    if not isinstance(allow, list):
        raise SystemExit("期望 permissions.allow 为一个 JSON 数组。")

    added = append_unique(allow, permissions_to_add)

    if not added:
        print("无需添加——所有选定的规则已存在。")
        return

    print(f"{'将添加' if args.dry_run else '正在添加'} {len(added)} 条规则：")
    for rule in added:
        print(f"  + {rule}")

    if args.dry_run:
        print("\n试运行——未写入任何更改。")
        return

    atomic_write_json(SETTINGS_PATH, settings)
    print(f"\n完成。已将 {len(added)} 条规则添加到 {SETTINGS_PATH}")


if __name__ == "__main__":
    main()
```
