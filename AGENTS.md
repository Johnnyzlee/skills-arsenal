# AGENTS.md — Skills Arsenal Maintenance Guide

本文件是 Agent 维护本仓库的唯一权威指南。**任何对本仓库的修改,先读本文件。**

## 仓库架构

```
本仓库(真身)               各 Agent 目录(软链/路牌)
~/skills-arsenal/  ──sync.sh──►  opencode / claude / agents / codex / zed / hermes / cursor
        │
        └── push ──► github.com/Johnnyzlee/skills-arsenal
```

- **仓库是真身**:skill 源文件只存在于本仓库。
- **路牌不可改**:各 Agent skills 目录里只有软链,指向仓库。绝不直接在路牌目录建真身或手工改软链,一切通过 `scripts/sync.sh`。
- **GitHub 是备份与分发**:唯一事实源,支持多电脑同步。

## 目录结构

```
skills-arsenal/
├── coding/                          # 编程开发
│   ├── prose-standard/              #   注释/文档写作标准
│   ├── trim-cot-leakage/            #   思维链残留清理
│   ├── code-review/                 #   代码评审规范
│   ├── pre-push-checks/             #   推送前最小检查
│   └── find-simplifications/        #   代码简化审计
├── web-search/                      # 网络检索
│   ├── agent-reach/                 #   全网调研
│   └── zhihu/                       #   知乎
├── research/                        # 学术研究
│   ├── literature-management/       #   文献管理
│   │   └── zotero/
│   ├── scientific-figures/          #   科研绘图
│   │   └── academic-figures-drawer/
│   └── academic-writing/            #   学术写作(规划中)
├── standards/                       # 元规范
│   └── skill-authoring-standard/    #   如何写 skill
├── scripts/
│   ├── sync.sh                      #   软链同步
│   └── setup.sh                     #   新电脑一键安装
├── AGENTS.md                        #   本文件(面向维护者)
└── README.md                        #   面向使用者
```

**分类规则**:顶层分类 + 可嵌套子分类;每个 skill 是含 `SKILL.md` 的目录;分类目录内不放散文件(空的规划分类可放 README.md 说明)。**skill 名必须全局唯一**。

## Skill 格式

每个 skill 是目录:`<分类>/<skill-name>/SKILL.md`(可选 `references/`、`scripts/`、`agents/`)。

### frontmatter 强制要求

```yaml
---
name: <全小写连字符,必须与目录名一致>
published: true|false
description: >
  触发描述:中英双语,以触发场景开头,MUST USE 表明何时必用,NOT for 划清边界。
---
```

### 上线状态(强制)

每个 skill 通过 `published` 字段控制是否进入各 Agent:

- **`published: false`(草稿/未上线)**:sync.sh 不为其建立软链;若目标目录已有指向仓库的旧软链,自动移除。内容仍在仓库(有 git 历史),但任何 Agent 都看不到、不会触发。
- **`published: true`(已上线)**:sync.sh 正常建立软链,各 Agent 可用。
- **新增 skill 默认 `published: false`**:先本地打磨、评审、真实使用验证,确认成熟后再翻成 `true` 并重跑 sync。
- **改上线状态**:修改 SKILL.md 的 `published` 字段 → 跑 `./scripts/sync.sh` → 提交推送(状态变更随代码一起进 git)。
- sync.sh 的 `--dry-run` 会预览"将上线/将下线"的变更;SKILLS_TARGET_DIR 单工具同步同样遵守该字段。

### 来源记录(强制)

每个 skill 必须可追溯来源,便于日后检查上游更新:

- **蒸馏自外部仓库**:SKILL.md 末尾注明原仓库名、原文件路径、许可证、原文链接(如 `dsh-prose-standard` 的做法)。
- **直接搬运的外部 skill**:在 SKILL.md frontmatter 加 `metadata.source: <原仓库 URL>`,README 的 skill 一览"原始仓库"列同步登记。
- **无原仓库**(如官方分发、依赖 MCP):在 README 表格注明"无公开仓库/官方分发",不写编造的链接。
- **README 维护**:skill 一览表的"原始仓库"列必须与 SKILL.md 来源一致;每次新增/更新 skill 都要核对这一列。
- **更新检查**:有原仓库的 skill,升级前先访问原仓库确认是否有新版本;蒸馏 skill 在原作者重大更新时评估是否重新吸收。

### 正文写作纪律(详见 standards/skill-authoring-standard)

- **保留完整命题**:删修饰不删事实;每个事实成分(主体/条件/情态/否定保证/副作用/后果)必须存活。
- **一个事实一个家**:完整解释只放一处,其余链接。
- **写契约不写过程**:不写"先 X 再 Y"、不写变更历史、不写评审对白。
- **无思维链残留**:读者只看 HEAD 即能理解并验证每句话(判定标准见 coding/trim-cot-leakage)。
- **显式边界**:只覆盖部分场景时写清"本 skill 是指导,不是清单"。

## 标准工作流

### 新增 skill

1. 在对应分类建 `<skill-name>/SKILL.md`(需要新分类先建分类目录)。
2. `./scripts/sync.sh` 建软链。
3. 验证:目标目录出现指向仓库的软链。
4. `git add -A && git commit && git push`。

### 修改 skill

1. 只改仓库内真身文件;内容修改即时全局生效,无需重跑 sync。
2. **移动/重命名才需重跑** `./scripts/sync.sh`。
3. 提交推送。

### 删除 skill

1. 删除仓库内目录。
2. `./scripts/sync.sh` **不会删除已存在的软链**,需手动清理各 Agent 目录残留:
   ```sh
   for d in ~/.config/opencode/skills ~/.claude/skills ~/.agents/skills ~/.codex/skills ~/.config/zed/skills ~/.hermes/skills ~/.cursor/skills; do
     rm -f "$d/<skill-name>"
   done
   ```
3. 更新 README 清单,提交推送。

### 变更后自检

- [ ] frontmatter 完整,name 与目录一致,description 双语可触发
- [ ] 正文通过 HEAD 读者测试,无思维链残留
- [ ] 无 `.DS_Store`、临时文件、嵌套 `.git`、软链被提交
- [ ] 无空 skill 目录残留(空分类目录可以,需含说明)
- [ ] 已登记到 README 清单

## Git 提交规范

- 格式:`<type>: <摘要>`(type: `feat` 新增 / `fix` 修正 / `docs` 文档 / `chore` 脚本结构)
- 一个逻辑单元一个提交;来源变化时在摘要注明来源仓库。
- **绝不允许提交**:软链、`.DS_Store`、任何指向仓库外路径的内容。

## 同步脚本契约(修改脚本时保持)

- 遍历仓库内所有 `SKILL.md`(递归,支持任意层级),在目标目录建软链。
- 目标:opencode / claude / agents / codex / zed / hermes / cursor。
- **只建不删**:不删除目标目录任何已有内容;同名真实目录警告跳过;同名异源软链更新指向。
- **工具探测**:每个目标配检测条件(命令 / App / 配置目录),未安装的工具跳过。
- 支持 `--dry-run`、`SKILLS_TARGET_DIR` 单工具同步;幂等。
- **安全防护**:脚本必须验证 `REPO_DIR` 含 `AGENTS.md`,否则拒绝执行(防止误扫文件系统)。

## 多电脑工作流

- GitHub 是唯一事实源;新电脑:`curl -fsSL https://raw.githubusercontent.com/Johnnyzlee/skills-arsenal/main/scripts/setup.sh | bash`
- 日常同步:任一电脑 push 后,其他电脑 `git pull --ff-only && ./scripts/sync.sh`
- 软链是本机私有(各自建立),不提交不共享;电脑间不直接传文件。
- `git pull` 前先确认工作区干净;冲突时合并两边内容,不丢弃任何一版(除非用户确认)。
- 新电脑缺依赖工具(如 Zotero 桌面、zhihu CLI):skill 本体照常同步,依赖缺失时 skill 正文会说明。

## 边界:本仓库不管理的内容

- 第三方 skill(awesome-copilot 的 28 个、TokenTracker 的 academic-figures-drawer 等):保持原位由原渠道管理,**绝不迁入本仓库**。
- Hermes 自管 skill(16 组合/112 个):Hermes 自身维护。
- firefox-tab-manager:Firefox 插件配套,codex/hermes 各有独立副本。
- 各 Agent 内置 skill(Cursor `skills-cursor/`、codex `.system/` 等):只读不碰。
- 用户要求吸收外部 skill 时,流程是**蒸馏**(读方法论 → 自己的话重写 → 标注来源),不是复制。

## 常见问题

**某 Agent 里 skill 没生效?** 软链存在且指向仓库?该 Agent 是否需重启才扫描?frontmatter 是否合法?

**改了仓库某 Agent 还是旧内容?** 软链指向目录,内容即时生效;确认该 Agent 是否缓存列表(重启即可)。

**skill 被误建到某目录?** 只允许指向 `~/skills-arsenal/` 的软链存在;其余一律是误建,删除并检查是否有人工操作绕过 sync.sh。
