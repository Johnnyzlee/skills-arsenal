# Skills Arsenal

个人 Agent Skill 军火库。分类存放、统一管理、一处修改全局生效。

**架构一句话**:仓库是真身,`scripts/sync.sh` 把 skill 软链到所有 Agent。改仓库 = 改全部 7 个 Agent。

## 仓库全景图

```
                    ┌──────────────────────────────────────────────┐
                    │            GitHub 仓库(唯一事实源)             │
                    │     github.com/Johnnyzlee/skills-arsenal      │
                    └──────────────────────────────────────────────┘
                                      │ git clone / pull
                                      ▼
              ┌──────────────────────────────────────────────────┐
              │              ~/skills-arsenal(本地真身)          │
              └──────────────────────────────────────────────────┘
                                      │ ./scripts/sync.sh(软链)
                                      ▼
     ┌─────────┬──────────┬─────────┬────────┬─────────┬────────┬──────────┐
     ▼         ▼          ▼         ▼        ▼         ▼        ▼          ▼
  opencode   Claude     Codex      Zed     Hermes   Cursor   ~/.agents   (新 Agent)
  ~/.config  ~/.claude  ~/.codex   ~/.config ~/.hermes ~/.cursor  ~/.agents  加入列表
  /opencode  /skills    /skills    /zed     /skills   /skills  /skills    即自动同步
  /skills                           /skills

  ┌─────────────────────────────────────────────────────────────────────────┐
  │  仓库目录结构                                                            │
  │                                                                         │
  │  skills-arsenal/                                                        │
  │  ├── standards/                         ← 元规范(怎么造 skill)          │
  │  │   └── skill-authoring-standard/      ← 编写/维护 skill 的规范        │
  │  │                                                                      │
  │  ├── coding/                            ← 编程开发                      │
  │  │   ├── prose-standard/                ← 注释/文档写作标准             │
  │  │   └── trim-cot-leakage/              ← 思维链残留清理                │
  │  │                                                                      │
  │  ├── web-search/                        ← 网络检索                      │
  │  │   ├── agent-reach/                   ← 全网调研(13 平台)             │
  │  │   └── zhihu/                         ← 知乎搜索/热榜/直答            │
  │  │                                                                      │
  │  ├── research/                          ← 学术研究                      │
  │  │   ├── literature-management/                                         │
  │  │   │   └── zotero/                    ← Zotero 文献管理               │
  │  │   ├── scientific-figures/                                            │
  │  │   │   └── academic-figures-drawer/   ← 科研绘图(draw.io)             │
  │  │   └── academic-writing/              ← 学术写作(准备中)               │
  │  │                                                                      │
  │  ├── writing/ · life/                   ← 待扩充分类                    │
  │  ├── scripts/                                                           │
  │  │   ├── sync.sh                        ← 同步:仓库 → 所有 Agent       │
  │  │   └── setup.sh                       ← 新电脑一键安装                │
  │  ├── README.md                          ← 本文件(给人看)                │
  │  └── AGENTS.md                          ← 维护手册(给 Agent 看)         │
  └─────────────────────────────────────────────────────────────────────────┘

  共 7 个 skill,全部软链到 7 个 Agent(检测到已安装的才同步)
```

## Skill 一览

<table>
  <thead>
    <tr>
      <th colspan="2">分类</th>
      <th>Skill</th>
      <th>用途</th>
      <th>原始仓库</th>
      <th>参考资源</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="3">standards</td>
      <td>—</td>
      <td><a href="standards/skill-authoring-standard/SKILL.md">skill-authoring-standard</a></td>
      <td>编写/维护高质量 skill 的规范:触发词、结构、写作纪律</td>
      <td>—</td>
      <td><a href="https://github.com/deepseek-ai/deepseek-harness">deepseek-ai/deepseek-harness</a>(蒸馏)</td>
    </tr>
    <tr>
      <td>—</td>
      <td>readme-writing(准备中)</td>
      <td>README 写作规范</td>
      <td>—</td>
      <td><a href="https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes">GitHub 官方:About READMEs</a> · <a href="https://www.makeareadme.com/">Make a README</a> · <a href="https://github.com/RichardLitt/standard-readme">standard-readme</a> · <a href="https://github.com/matiassingers/awesome-readme">Awesome README</a></td>
    </tr>
    <tr>
      <td>—</td>
      <td>agents-md-writing(准备中)</td>
      <td>AGENTS.md 写作规范</td>
      <td>—</td>
      <td><a href="https://agents.md/">agents.md 官方规范</a> · <a href="https://openai.com/index/introducing-agents-md/">OpenAI 公告</a> · <a href="https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions">GitHub Copilot 仓库指令</a> · <a href="https://code.claude.com/docs/en/agent-instructions">Claude Code 文档</a> · <a href="https://zed.dev/docs/ai/skills">Zed Skills 文档</a></td>
    </tr>
    <tr>
      <td rowspan="2">coding</td>
      <td>—</td>
      <td><a href="coding/prose-standard/SKILL.md">prose-standard</a></td>
      <td>注释/JSDoc/文档写作标准:保留完整命题、按位置分类的必需覆盖</td>
      <td>—</td>
      <td><a href="https://github.com/deepseek-ai/deepseek-harness">deepseek-ai/deepseek-harness</a>(蒸馏自 <code>dsh-prose-standard</code>)</td>
    </tr>
    <tr>
      <td>—</td>
      <td><a href="coding/trim-cot-leakage/SKILL.md">trim-cot-leakage</a></td>
      <td>清理"思维链残留"文字:死引用、变更叙述、评审对白等 8 类</td>
      <td>—</td>
      <td><a href="https://github.com/deepseek-ai/deepseek-harness">deepseek-ai/deepseek-harness</a>(蒸馏自 <code>dsh-trim-cot-leakage</code>)</td>
    </tr>
    <tr>
      <td rowspan="2">web-search</td>
      <td>—</td>
      <td><a href="web-search/agent-reach/SKILL.md">agent-reach</a></td>
      <td>全网调研:13 平台多后端路由(小红书/推特/B站/Reddit/V2EX/LinkedIn/YouTube/GitHub 等)</td>
      <td><a href="https://github.com/Panniantong/Agent-Reach">Panniantong/Agent-Reach</a></td>
      <td>—</td>
    </tr>
    <tr>
      <td>—</td>
      <td><a href="web-search/zhihu/SKILL.md">zhihu</a></td>
      <td>知乎搜索/热榜/直答/创作管理</td>
      <td>—</td>
      <td>知乎官方分发(<a href="https://developer-cdn.zhihu.com/zhihu-cli/releases/stable/manifest.json">manifest</a>)</td>
    </tr>
    <tr>
      <td rowspan="3">research</td>
      <td>literature-management</td>
      <td><a href="research/literature-management/zotero/SKILL.md">zotero</a></td>
      <td>Zotero 文献库管理:检索/元数据/全文/注释/引用</td>
      <td>—</td>
      <td><a href="https://github.com/54yyyu/zotero-mcp">54yyyu/zotero-mcp</a>(v0.9.1)</td>
    </tr>
    <tr>
      <td>scientific-figures</td>
      <td><a href="research/scientific-figures/academic-figures-drawer/SKILL.md">academic-figures-drawer</a></td>
      <td>科研绘图:论文配图、框架图、流程图(draw.io)</td>
      <td><a href="https://github.com/M1n-n9/academic-figures-drawer">M1n-n9/academic-figures-drawer</a></td>
      <td>—</td>
    </tr>
    <tr>
      <td>academic-writing</td>
      <td>academic-writing(准备中)</td>
      <td>学术写作规范</td>
      <td>—</td>
      <td>—</td>
    </tr>
  </tbody>
</table>

> **更新检查**:有原始仓库的 skill,升级前先看原仓库是否发布了新版本;蒸馏/本地化的 skill 在原作者有重大更新时,决定是否重新吸收(流程见 AGENTS.md)。

## 已同步的 Agent

| Agent | 目录 | 说明 |
|---|---|---|
| opencode | `~/.config/opencode/skills/` | |
| Claude Code | `~/.claude/skills/` | |
| Codex | `~/.codex/skills/` | |
| Zed | `~/.config/zed/skills/` | |
| Hermes | `~/.hermes/skills/` | |
| Cursor | `~/.cursor/skills/` | |
| 通用 agents | `~/.agents/skills/` | 跨 agent 目录,Zed + opencode 官方都会读取 |

`sync.sh` 会先检测本机装了哪些 Agent,只对已安装的建立软链;新 Agent 加入列表后自动同步。

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
