# AGENTS.md 写作 —— 资源清单

> 状态:准备中。以下是搜集到的高质量来源,按权威度排序。
> 每个来源标注:内容概要、适合场景、收录理由。

## 一、官方权威来源

| # | 来源 | 链接 | 内容与价值 |
|---|---|---|---|
| 1 | **agents.md 官方规范**(agents.md) | https://agents.md/ | **AGENTS.md 格式的事实标准**。定义:AGENTS.md 是"给 coding agent 的 README",提供 build/test/约定等 agent 需要的上下文;声明被 60k+ 开源项目使用,兼容 Codex、Zed、opencode、Cursor、Gemini CLI 等 20+ 工具。**必读首选。** |
| 2 | **OpenAI 官方:Introducing AGENTS.md** | https://openai.com/index/introducing-agents-md/ | OpenAI 发布 AGENTS.md 规范的官方公告(与 agents.md 同一标准)。说明动机:agent 需要"稳定的、可预测的指令位置"。含官方示例。 |
| 3 | **Anthropic 官方:Codex/Claude 的 agent 指南** | https://code.claude.com/docs/en/agent-instructions(Claude Code 官方文档) | Claude Code 对 agent 指令(CLAUDE.md)的官方说明:如何组织、什么内容该放。生态头部玩家的官方实践。 |
| 4 | **GitHub 官方:Copilot 仓库指令文档** | https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions | GitHub Copilot 对"仓库级 agent 指令"的官方文档(说明文件命名、优先级、最佳实践)。GitHub 官方视角,与 AGENTS.md 直接相关。 |

## 二、权威工具生态文档(说明 AGENTS.md 如何被消费)

| # | 来源 | 链接 | 内容与价值 |
|---|---|---|---|
| 5 | **GitHub Skills 生态(awesome-copilot)** | https://github.com/github/awesome-copilot | GitHub 官方 Copilot skill 合集。虽然是 skill 不是 AGENTS.md,但其 SKILL.md 的组织方式(触发词、结构)是"给 agent 写指令"的最佳范例。 |
| 6 | **Zed 官方:Agent Skills 文档** | https://zed.dev/docs/ai/skills | Zed 对 agent 指令系统的官方文档。说明了"agent 实际如何读取指令目录",对理解 AGENTS.md 的消费方式有帮助。 |

## 三、社区与参考

| # | 来源 | 链接 | 内容与价值 |
|---|---|---|---|
| 7 | **anthropics/skills 官方仓库** | https://github.com/anthropics/skills | Anthropic 官方 skills 仓库,含大量高质量 skill 范例(可参考其写作风格)。 |
| 8 | **awesome-copilot 中的 instructions 子集** | https://github.com/github/awesome-copilot/tree/main/instructions | awesome-copilot 仓库里的 instructions 集合,展示了项目级 agent 指令的多种写法。 |

## 收录标准(以后更新资源时遵守)

- 优先官方文档;其次社区公认经典(star 数、被引用次数)
- 注明每个来源"适合什么场景"(标准定义 / 生态视角 / 范例)
- 链接失效时更新,不保留死链

## 综合时要注意的要点(预判)

1. **定位**:AGENTS.md = "给 agent 的 README",与人类 README 分开、互补
2. **内容优先级**:构建/测试命令 > 代码约定 > 任务相关指令 > 边界规则
3. **简洁性**:agent 每次会话都可能读,冗长会稀释注意力(与我们的 prose-standard 一致)
4. **跨工具兼容**:agents.md 规范声明被 20+ 工具支持,写法要"规范优先、工具特性靠后"
5. **维护性**:AGENTS.md 要跟随仓库演进持续更新(陈旧指令比没有更糟)
