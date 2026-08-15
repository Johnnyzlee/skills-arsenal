---
name: skill-authoring-standard
description: >
  MUST USE when the user asks to 写/新建/创建/添加/修改/优化/审查/重构 a skill,
  SKILL.md, or 个人 skill 仓库维护任务 (add a new skill, write a skill, improve
  a skill, review my skills, fix a skill that doesn't trigger, why isn't my
  skill being invoked)。

  Also use when 把外部 skill 蒸馏/吸收到本仓库 (absorb, distill, port a skill
  from another repo), or when 修改本仓库 standards/ 下的规范本身。
---

# Skill 编写规范

本规范定义"什么样的 skill 是好 skill",以及编写和维护 skill 的标准流程。它吸收了
deepseek-harness 开源 skills 体系的写作纪律,落地为个人可维护的版本。

**本规范是指导原则,不是僵化清单。** 好的 skill 应该让 Agent 在触发后不需要怀疑自己该做什么。

## 一、触发是 skill 的生命线

一个写得好但永远不被触发的 skill 等于不存在。触发靠 `description`:

1. **description 用触发词开头**,写明"何时 MUST USE",覆盖用户可能的不同说法:
   - 场景(写注释、调研、翻译、写 PR……)
   - 同义说法(研究/查/搜/看看)
   - 触发此 skill 的关键词(URL、平台名、术语)
2. **中英双语都写**,因为你的对话中英混杂。
3. **宁可过度触发**:description 宁可宽,不可窄。被误触发一次,胜过该触发时没触发。
4. **避免过度承诺**:description 里写的触发条件,正文必须真的覆盖。

## 二、SKILL.md 的结构

```
skill-name/
├── SKILL.md          # 唯一必需文件,frontmatter + 正文
├── references/       # 详细参考(示例、分类表、冗长材料),SKILL.md 里链接引用
├── scripts/          # 配套脚本
└── agents/           # 子 agent 配置(一般用不到)
```

- **SKILL.md 保持精简**:正文聚焦"做什么、怎么做、何时停",详细例子放 references/。
  SKILL.md 每次触发都会被读入上下文,太长会稀释注意力。
- **一个文件一个主题**:skill 越聚焦越可靠。任务相关但独立的流程,拆成另一个 skill 或放 references/。
- **必要的边界声明**:如果 skill 只覆盖部分场景(比如"只做 X,不写 Y"),显式写出
  边界,类似 "This is guidance, not a script"——这会改变 Agent 的调用方式。

## 三、正文写作纪律(蒸馏自 DeepSeek prose 标准)

### 保留完整命题

写流程、要求、注释时,每个事实的构成部分都要保留:

- 主体和动作(谁做什么)
- 条件和时序(何时、在什么前提下)
- 情态(must / may / never)
- 否定保证和例外(什么情况下不成立)
- 所有权、副作用、失败模式、后果

删词、删修饰、删重复可以,**但每个事实必须存活**。字数变少不是目的,是结果。

### 一个事实只有一个家

同一份知识只在一个地方完整解释(术语表、规范、references/),其他地方用链接。
两个地方各写一半、细节对不上的文档,比一个简洁的文档差得多。

### 注释描述契约,不描述过程

写注释/JSDoc 时:描述代码表达不了的**非显然契约和理由**(不变量、时序、所有权、
安全边界、意外行为)。不写流程复述("先 X 再 Y")、不写测试讲解、不写修改历史。

### 写当前状态,不写变更历史

文档和注释描述"现在是什么",不描述"以前怎样、这次改了什么"。
变更故事放 commit message、PR 描述、changelog。

### 反"思维链残留"

正文里不允许出现这些痕迹(详见 coding/trim-cot-leakage 的 8 类分类):
- 死引用("见 design 第 7 条决定")、会话内编号、未提交稿件的 §N
- 变更叙述("之前是这样、这次改为")、版本戳("v1""这一版")
- 评审对白("评审时说……")、防御式自证("这个转换是安全的,因为……")

判定标准一句话:**"HEAD 处的读者,不接触任何会话记录、PR 评论、未提交草稿,
能否理解并验证这句话?"** 不能,就是泄漏。

### 给出示例,不给模板

写"要求"时配 1-2 个正反例(❌ 反例 / ✅ 正例),比十条抽象规则有效。
示例放在 references/examples.md,正文引用链接。

## 四、编写流程

1. **先想清楚触发场景**:这个 skill 解决什么问题?用户会怎么说?放在哪个分类目录?
2. **起草 SKILL.md**:frontmatter + 正文,遵循上文纪律。正文用中文写(你的维护语言),
   术语保留英文原文。references/ 里的材料可以用英文。
3. **自审**:通读一遍,用"HEAD 读者测试"检查每个句子。
4. **同步**:`./scripts/sync.sh` 建立软链。
5. **验证**:确认 opencode 能发现它——检查 `~/.config/opencode/skills/<name>/SKILL.md`
   存在且内容是最新的。
6. **提交**:commit + push 到 GitHub。commit message 说明新增/修改内容和来源。

## 五、从外部吸收 skill 的流程

DeepSeek Harness 这类开源 skill 体系值得借鉴,但不能照搬(往往绑定对方仓库的
专用命令、内部路径、工程体系)。吸收流程:

1. **通读原文**,标出三类内容:
   - **通用思想**(写作纪律、判定标准、方法论)→ 蒸馏进自己的 skill
   - **可复用流程**(不依赖对方仓库的步骤)→ 改写适配
   - **绑定内容**(专用命令、内部路径、对方体系)→ 丢弃或改写
2. **蒸馏**:用自己的话写,配自己的例子,去掉所有对方仓库专属引用。
3. **标注来源**:SKILL.md 末尾注明改编自哪个仓库、哪个文件(保留对方许可证声明)。
4. **不贪多**:一次吸收一个思想,落地成可用的 skill,胜过囤积一堆半成品。

## 六、维护规范

- **每个 skill 都要有主人意识**:skill 是活的,用着发现不触发、误触发、流程不对,
  立即修。
- **决策要记录**:对 skill 做了重要取舍(比如"故意不覆盖 X 场景"),写进该 skill
  的 SKILL.md,不要只记在脑子里。
- **定期复盘**:新 skill 上线用两周后,回头检查 description 触发质量、正文是否
  准确反映实际用法。
