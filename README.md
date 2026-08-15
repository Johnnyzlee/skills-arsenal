# Skills Arsenal — 我的个人 Skill 仓库

我自己的 skill 军火库。分类存放,通过同步脚本链接到 opencode 等 Agent 工具,托管在 GitHub 持续维护。

## 目录结构

```
skills-arsenal/
├── coding/       # 编程开发
├── research/     # 信息调研
├── writing/      # 写作与文档
├── life/         # 生活效率
├── standards/    # 元规范(如何写 skill 本身)
├── scripts/      # 工具脚本
└── README.md     # 本文件
```

## Skill 清单

### standards/ — 元规范

| Skill | 用途 | 来源 |
|---|---|---|
| skill-authoring-standard | 编写/维护高质量 skill 的规范:触发词、结构、CoT 泄漏、文档纪律 | 蒸馏自 DeepSeek Harness `.agents/skills` 体系 |

### coding/ — 编程开发

| Skill | 用途 | 来源 |
|---|---|---|
| prose-standard | 注释/JSDoc/文档的文字标准:保留完整命题、按位置分类的必需覆盖 | 蒸馏自 `dsh-prose-standard` |
| trim-cot-leakage | 清理"思维链残留"文字:死引用、变更叙述、评审对白等 8 类 | 蒸馏自 `dsh-trim-cot-leakage` |

### research/ — 信息调研

| Skill | 用途 | 来源 |
|---|---|---|
| *(agent-reach / zhihu / zotero 已在其他目录维护,见下方"外部已登记 skill")* | | |

### writing/ · life/ — 待扩充

空分类,未来放入写作、生活类 skill。

## 外部已登记 skill

以下 skill 真实家在其他目录(通常是软链进 `~/.config/opencode/skills/`),本仓库不托管、不覆盖,仅登记索引:

| Skill | 真实位置 |
|---|---|
| agent-reach | `~/.agents/skills/agent-reach` |
| zhihu | `~/.codex/skills/zhihu` |
| zotero | `~/.agents/skills/zotero` |

## 使用方式

```sh
# 1. 首次使用:把仓库里的 skill 软链到 opencode 目录
./scripts/sync.sh

# 2. 以后每次新增/修改 skill 后,重跑一次
./scripts/sync.sh
```

同步脚本只管理本仓库拥有的 skill(按仓库内目录逐个建立软链),**不会删除** opencode 目录里其他来源的 skill,也不会碰外部已登记的软链。

## 维护规范

- **每新增一个 skill**,放在正确的分类目录下,目录名 = skill 名,内含 `SKILL.md`
- **SKILL.md 格式**:frontmatter 必须有 `name`(全小写连字符)和 `description`(触发词要具体,中英双语都写,以 MUST USE 开头强调何时必须用)
- **skill 内容遵循** `standards/skill-authoring-standard/SKILL.md` 的规范
- **改完重跑** `./scripts/sync.sh`,提交推送 GitHub
- **来源标注**:从外部吸收的 skill 在 README 清单里注明来源,蒸馏的要在 SKILL.md 里注明出处

## 灵感的来源

本仓库的元规范和两个成品 skill 蒸馏自 [deepseek-ai/deepseek-harness](https://github.com/deepseek-ai/deepseek-harness) 开源的 `.agents/skills` 体系(其仓库内含 11 个内部工程 skill 和 Agent Notes 决策记录系统)。原始内容绑定 DeepSeek 内部工程,直接照搬不可用,但其中的写作纪律、CoT 泄漏判定、决策记录思想值得吸收,本仓库是这些思想的个人化落地。

## 许可证

本仓库中的蒸馏 skill 改编自 MIT 许可的 deepseek-harness 仓库,保留 MIT 声明(见各 SKILL.md 末尾)。
