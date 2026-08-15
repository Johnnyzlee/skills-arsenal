# AGENTS.md — Skills Arsenal 维护手册

本文件是 Agent 维护本仓库的唯一权威指南。**修改本仓库任何内容前,先读本文件。**

## 仓库是什么

Skills Arsenal 是用户的个人 Agent Skill 军火库:

- **仓库是真身**:所有 skill 的源文件只存在于 `~/skills-arsenal/`(本仓库),并通过 `scripts/sync.sh` 软链到各 Agent 的 skills 目录。
- **Agent 只读路牌**:opencode / Claude Code / Codex / Zed / Hermes / Cursor / `~/.agents` 的 skills 目录里都是软链,指向仓库真身。**绝不直接修改路牌,绝不在路牌目录创建真身。**
- **GitHub 是备份与分发**:`Johnnyzlee/skills-arsenal`(公开)。

## 目录结构

```
skills-arsenal/
├── coding/       # 编程开发类 skill
├── research/     # 信息调研类 skill
├── writing/      # 写作类 skill(未使用)
├── life/         # 生活类 skill(未使用)
├── standards/    # 元规范类 skill(如何写 skill 本身)
├── scripts/      # 工具脚本(sync.sh)
├── README.md     # 面向使用者的索引(只登记,不解释维护细节)
└── AGENTS.md     # 本文件:面向维护者的指南
```

**分类规则**:每个 skill 按主题放入一个分类目录,目录名 = skill 名,内含 `SKILL.md`。分类目录下只有 skill 子目录,不放散文件。

## Skill 的组成与格式

每个 skill 是一个目录,包含:

```
<分类>/<skill-name>/
├── SKILL.md          # 必需。frontmatter + 正文
├── references/       # 可选。长参考材料(SKILL.md 中链接引用)
├── scripts/          # 可选。配套脚本
└── agents/           # 可选。子 agent 配置(一般不用)
```

### SKILL.md frontmatter 强制要求

```yaml
---
name: <全小写连字符,与目录名一致>
description: >
  触发描述。以触发场景开头,覆盖中英文同义说法,写明何时 MUST USE 和 NOT for。
---
```

- `name` 必须与目录名、软链名完全一致。
- `description` 是触发生命线,宁宽勿窄,中英双语,具体到场景和关键词。
- 蒸馏自外部仓库的 skill,末尾必须有来源标注(仓库名 + 文件路径 + 许可证)。

### 正文写作纪律

按 `standards/skill-authoring-standard/SKILL.md` 执行,要点:

- **保留完整命题**:删除修饰与重复可以,但每个事实成分(主体/条件/情态/否定保证/副作用/后果)必须存活。
- **一个事实一个家**:完整解释只放一处,其余链接。
- **注释/文档写契约,不写过程**:不写"先 X 再 Y"、不写变更历史("之前是/现在改为")、不写评审对白。
- **无思维链残留**:正文必须通过"HEAD 读者测试"——读者不接触任何会话记录即可理解并验证每句话(判定标准详见 `coding/trim-cot-leakage/SKILL.md`)。
- **显式声明边界**:skill 只覆盖部分场景时,写清 "本 skill 是指导,不是清单" 之类边界,改变 Agent 的调用方式。

## 标准工作流

### 1. 新增一个 skill

1. 在对应分类目录建 `<skill-name>/SKILL.md`,遵循上文格式与写作纪律。
2. 需要新分类时,在仓库根建新分类目录;分类只增不减。
3. 运行 `./scripts/sync.sh` 建立/更新软链。
4. 验证:确认各 Agent 的 skills 目录中出现对应软链,且指向仓库路径。
5. `git add -A && git commit && git push`(commit 规范见下)。

### 2. 修改一个 skill

1. 只修改仓库内真身文件。
2. 软链是即时的,无需重新 sync;**除非**仓库路径发生变化(重命名/移动目录),才需要重跑 sync。
3. 改完 `git commit && git push`。

### 3. 删除一个 skill

1. 删除仓库内对应目录。
2. 运行 `./scripts/sync.sh` —— 注意:脚本**不会删除**已存在的软链!需手动清理各 Agent 目录里的残留软链:
   ```sh
   for d in ~/.config/opencode/skills ~/.claude/skills ~/.agents/skills ~/.codex/skills ~/.config/zed/skills ~/.hermes/skills ~/.cursor/skills; do
     rm -f "$d/<skill-name>"
   done
   ```
3. 更新 `README.md` 的 skill 清单,提交推送。

### 4. 重命名/移动一个 skill

1. 移动仓库内目录。
2. 重跑 `./scripts/sync.sh`(它会检测旧软链指向失效并更新)。
3. 提交推送。

### 5. 变更后自检清单

- [ ] SKILL.md frontmatter 完整(`name` 与目录一致,`description` 双语可触发)
- [ ] 正文通过 HEAD 读者测试,无思维链残留
- [ ] 无 `vendor/`、`.git/`、临时文件被提交
- [ ] 仓库内无空目录残留(分类目录留空可以,skill 目录留空不行)
- [ ] `sync.sh` 已运行,各 Agent 软链状态与仓库一致
- [ ] 新增 skill 已登记到 README 清单

## 多电脑工作流

仓库以 GitHub 为唯一事实源,支持任意台电脑共用同一套 skill。

### 新电脑首次安装

```sh
curl -fsSL https://raw.githubusercontent.com/Johnnyzlee/skills-arsenal/main/scripts/setup.sh | bash
```

等价于:clone 仓库到 `~/skills-arsenal` → 运行 `scripts/sync.sh` 建立本机软链。

### 日常同步

所有电脑共享同一仓库,任何一台的改动 `git push` 后,其他电脑:

```sh
cd ~/skills-arsenal && git pull --ff-only && ./scripts/sync.sh
```

### 多电脑协作规则

- **一台电脑一个视角**:仓库是唯一事实源;新 skill 在哪台电脑上发现,就在那台电脑上加进仓库并 push,其他电脑 pull 即获得。
- **软链是本机私有的**:软链内容(指向哪些 Agent 目录)由每台电脑的 `sync.sh` 各自建立,不提交、不共享。
- **电脑间不直接传文件**:只在各电脑与 GitHub 之间 push/pull,避免副本分歧。
- **pull 前先提交**:改动会冲突;执行 `git pull` 前先 `git status` 确认工作区干净,或先 commit 自己的改动。
- **冲突处理**:同一 skill 在两台电脑都被修改时,git 会要求解决冲突——保留两边内容合并,不丢弃任何一版(除非用户确认)。
- **新电脑缺依赖**:某些 skill 依赖本机工具(如 zotero 需要 Zotero 桌面、zhihu 需要对应 CLI)。skill 本体照常同步,依赖缺失时 skill 的正文会说明,不影响其他 skill。

## Git 提交规范

- **提交信息**:`<type>: <中文或英文摘要>`
  - `feat:` 新增 skill / 新能力;`fix:` 修正;`docs:` README/AGENTS 改动;`chore:` 脚本、结构等
- 提交信息简洁描述变更内容与原因,不写废话。
- 每次变更一个逻辑单元一个提交,不混提交。
- 蒸馏来源变化时,在提交信息中注明来源仓库。

## 边界:本仓库不管理的内容

以下内容**绝不**迁入本仓库:

- **第三方 skill**(如 awesome-copilot 的 28 个):保持原位,由原渠道更新,仅在 README 登记。
- **Hermes 自管 skill**(16 组合/112 个):Hermes 自身维护,不搬、不蒸馏(除非用户明确要求蒸馏某一个)。
- **firefox-tab-manager**:Firefox 插件配套 skill,codex/hermes 各有独立副本,不搬。
- **各 Agent 的内置 skill**(如 Cursor 的 `skills-cursor/`、codex 的 `.system/`):只读不碰。

如果用户要求"移植/吸收"外部 skill,流程是**蒸馏**(读方法论 → 用自己的话重写 → 标注来源),不是复制。

## 同步脚本细节

`scripts/sync.sh` 的行为契约(修改脚本时保持这些性质):

- 遍历仓库内各分类下的含 `SKILL.md` 的目录,在目标 Agent 目录建立软链。
- 目标目录列表:opencode / claude / agents / codex / zed / hermes / cursor。
- **只建不删**:绝不删除目标目录中任何已有内容(软链或真身),遇到同名的非本仓库来源软链,以仓库为准更新指向;遇到真实目录则警告跳过。
- 支持 `--dry-run` 预览。
- 支持 `SKILLS_TARGET_DIR` 环境变量覆盖目标(单工具同步)。
- 幂等:重复运行无副作用。

## 常见问题

**Q: 某个 Agent 里 skill 没生效?**
先确认软链存在且指向仓库:某 Agent 需要重启/重新加载才会扫描 skills。再看 frontmatter 是否合法(name/description 缺失会导致该 Agent 跳过)。

**Q: 改了仓库,某 Agent 还是旧内容?**
软链指向的是目录,内容即时生效,无需 sync。确认该 Agent 是否缓存了 skill 列表(重启即可)。

**Q: 两个 skill 在某个 Agent 里同名冲突?**
本仓库 skill 名必须全局唯一;与第三方 skill 撞名时,本仓库优先(更新软链指向),但应在 README 注明冲突。
