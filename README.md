# Skills Arsenal — 我的个人 Skill 仓库

个人 Agent Skill 军火库:分类存放、统一管理、一处修改全局生效。

**架构一句话**:仓库是真身,`scripts/sync.sh` 把 skill 软链到所有 Agent 的 skills 目录。改仓库 = 改全部 7 个 Agent。

## 已同步的 Agent

| Agent | 目录 |
|---|---|
| opencode | `~/.config/opencode/skills/` |
| Claude Code | `~/.claude/skills/` |
| 通用 agents | `~/.agents/skills/` |
| Codex | `~/.codex/skills/` |
| Zed | `~/.config/zed/skills/` |
| Hermes | `~/.hermes/skills/` |
| Cursor | `~/.cursor/skills/` |

## Skill 清单

### standards/ — 元规范

| Skill | 用途 | 来源 |
|---|---|---|
| skill-authoring-standard | 编写/维护高质量 skill 的规范:触发词、结构、CoT 泄漏、文档纪律 | 蒸馏自 DeepSeek Harness |

### coding/ — 编程开发

| Skill | 用途 | 来源 |
|---|---|---|
| prose-standard | 注释/JSDoc/文档写作标准:保留完整命题、按位置分类的必需覆盖 | 蒸馏自 `dsh-prose-standard` |
| trim-cot-leakage | 清理"思维链残留"文字:死引用、变更叙述、评审对白等 8 类 | 蒸馏自 `dsh-trim-cot-leakage` |

### research/ — 信息调研

| Skill | 用途 | 来源 |
|---|---|---|
| agent-reach | 全网调研:13 平台多后端路由(小红书/推特/B站/Reddit/V2EX/LinkedIn/YouTube/GitHub 等) | 个人 skill |
| zhihu | 知乎搜索/热榜/直答/创作管理(v0.3.0) | 个人 skill |
| zotero | Zotero 文献库管理:检索/元数据/全文/注释/引用 | 个人 skill |

### writing/ · life/ — 待扩充

空分类,未来放入写作、生活类 skill。

## 快速开始

```sh
# 新电脑一条命令装好(克隆 + 建软链)
curl -fsSL https://raw.githubusercontent.com/Johnnyzlee/skills-arsenal/main/scripts/setup.sh | bash

# 或手动
git clone https://github.com/Johnnyzlee/skills-arsenal.git
cd skills-arsenal
./scripts/sync.sh          # 建立/更新全部软链
./scripts/sync.sh --dry-run  # 只预览不修改
SKILLS_TARGET_DIR=~/.claude/skills ./scripts/sync.sh  # 只同步单个 Agent
```

### 多电脑同步

仓库以 GitHub 为唯一事实源,所有电脑共用同一套 skill:

```sh
# 在任意电脑上更新到最新
cd ~/skills-arsenal && git pull --ff-only && ./scripts/sync.sh
```

一台电脑上新增/修改的 skill,`git push` 后其他电脑 pull 即获得。

## 目录结构

```
skills-arsenal/
├── coding/       # 编程开发
├── research/     # 信息调研
├── writing/      # 写作与文档(待扩充)
├── life/         # 生活效率(待扩充)
├── standards/    # 元规范(如何写 skill 本身)
├── scripts/      # 工具脚本
├── AGENTS.md     # Agent 维护手册(新增/修改/删除 skill 的标准流程)
└── README.md     # 本文件
```

## 外部已登记 skill(第三方,不入仓库)

以下 skill 来自第三方渠道,保持原位由原渠道更新,本仓库只登记索引、不托管、不覆盖:

| Skill | 来源渠道 | 数量 | 说明 |
|---|---|---|---|
| copilot-*、github-*、codeql、dependabot、gitmoji 等 | `github/awesome-copilot`(GitHub 官方 Copilot skill 合集) | 28 | 装在 opencode 目录,`gh skill update --all` 手动更新 |
| academic-figures-drawer | `M1n-n9/academic-figures-drawer`(独立开发者) | 1 | git 克隆,opencode 目录 |
| pr-screenshots | 未知 | 1 | 空目录占位 |
| firefox-tab-manager | Firefox 插件 "Agent Bridge" 配套 | 2 | codex 与 hermes 各一份独立副本,各归各工具 |
| Hermes 内置 skill(apple、github、research、security 等) | Hermes skills hub | 16 组合 / 112 个 | 由 Hermes 自己管理,未搬动 |

## 维护

**维护本仓库(新增/修改/删除 skill、提交规范、边界规则)请让 Agent 先读 [AGENTS.md](AGENTS.md)**——它是唯一的维护权威。

要点速览:

- 只改仓库内真身,不直接动任何 Agent 的软链
- 修改内容即时全局生效;只有新增/移动/删除 skill 才需要重跑 `sync.sh`
- 蒸馏外部 skill 时按 `standards/skill-authoring-standard` 流程,保留来源标注
- 提交规范:`feat:` 新增 / `fix:` 修正 / `docs:` 文档 / `chore:` 脚本结构

## 灵感的来源

本仓库的元规范和两个写作类 skill 蒸馏自 [deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness) 开源的 `.agents/skills` 体系。原始内容绑定 DeepSeek 内部工程不可直接照搬,其中的写作纪律、CoT 泄漏判定、决策记录思想值得吸收,本仓库是这些思想的个人化落地。

## 许可证

本仓库中的蒸馏 skill 改编自 MIT 许可的 deepseek-harness 仓库,保留 MIT 声明(见各 SKILL.md 末尾)。
