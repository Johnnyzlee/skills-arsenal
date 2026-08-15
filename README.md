# Skills Arsenal

个人 Agent Skill 军火库。分类存放、统一管理、一处修改全局生效。

**架构一句话**:仓库是真身,`scripts/sync.sh` 把 skill 软链到所有 Agent。改仓库 = 改全部 7 个 Agent。

## Skill 一览

### standards — 元规范

| Skill | 用途 |
|---|---|
| [skill-authoring-standard](standards/skill-authoring-standard/SKILL.md) | 编写/维护高质量 skill 的规范:触发词、结构、写作纪律 |

### coding — 编程开发

| Skill | 用途 |
|---|---|
| [prose-standard](coding/prose-standard/SKILL.md) | 注释/JSDoc/文档写作标准:保留完整命题、按位置分类的必需覆盖 |
| [trim-cot-leakage](coding/trim-cot-leakage/SKILL.md) | 清理"思维链残留"文字:死引用、变更叙述、评审对白等 8 类 |

### research — 信息调研

| Skill | 用途 |
|---|---|
| **web-search** | |
| [agent-reach](research/web-search/agent-reach/SKILL.md) | 全网调研:13 平台多后端路由(小红书/推特/B站/Reddit/V2EX/LinkedIn/YouTube/GitHub 等) |
| [zhihu](research/web-search/zhihu/SKILL.md) | 知乎搜索/热榜/直答/创作管理 |
| **literature-management** | |
| [zotero](research/literature-management/zotero/SKILL.md) | Zotero 文献库管理:检索/元数据/全文/注释/引用 |

### 规划中的分类

- `research/scientific-figures/` — 科研绘图(学术绘图 skill 暂由 TokenTracker 管理,未入仓库)
- `research/academic-writing/` — 学术写作

## 已同步的 Agent

| Agent | 目录 |
|---|---|
| opencode | `~/.config/opencode/skills/` |
| Claude Code | `~/.claude/skills/` |
| 通用 agents(`~/.agents`,Zed + opencode 读取) | `~/.agents/skills/` |
| Codex | `~/.codex/skills/` |
| Zed | `~/.config/zed/skills/` |
| Hermes | `~/.hermes/skills/` |
| Cursor | `~/.cursor/skills/` |

## 快速开始

```sh
# 新电脑一条命令装好(克隆 + 检测本机 Agent + 建软链)
curl -fsSL https://raw.githubusercontent.com/Johnnyzlee/skills-arsenal/main/scripts/setup.sh | bash

# 手动方式
git clone https://github.com/Johnnyzlee/skills-arsenal.git
cd skills-arsenal
./scripts/sync.sh            # 建立/更新全部软链
./scripts/sync.sh --dry-run  # 只预览
SKILLS_TARGET_DIR=~/.claude/skills ./scripts/sync.sh  # 只同步单个 Agent
```

## 多电脑同步

所有电脑共用同一套 skill(GitHub 为唯一事实源):

```sh
cd ~/skills-arsenal && git pull --ff-only && ./scripts/sync.sh
```

任何电脑上新增/修改的 skill,`git push` 后其他电脑 pull 即获得。

## 维护

**维护本仓库(新增/修改/删除 skill、提交规范、边界规则)请让 Agent 先读 [AGENTS.md](AGENTS.md)。**

要点速览:

- 只改仓库内真身,不直接动任何 Agent 的软链
- 修改内容即时生效;只有新增/移动/删除 skill 才需要重跑 `sync.sh`
- 提交规范:`feat:` 新增 / `fix:` 修正 / `docs:` 文档 / `chore:` 脚本结构
