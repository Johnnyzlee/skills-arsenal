---
published: false
name: pre-push-checks
description: >
  MUST USE when 推送/提交前 deciding which checks to run — push 之前跑什么检查,
  提交前要验证什么,这个改动需要测试吗,准备提交/推送代码,claim checks pass。
  也用于:选择最小范围的测试,而不是无脑跑全量。

  NOT for: 已经由仓库钩子(lint/typecheck)自动执行的部分,不要重复跑。
---

# 推送前最小检查

提交/推送代码前,选择**覆盖本次改动的最小相关检查**,而不是反射式跑全量测试套件。

**核心哲学**:每个行为改动需要"如果它回归,一定会失败"的那个最窄测试。加更宽的检查,只有当 diff 真的触及那个面。全量覆盖是 CI 的事,不是本地的事。

## 第一步:确认改动范围

```sh
git status --short --branch
git diff --stat HEAD          # 已暂存 + 未暂存的改动
```

明确本次改了什么文件、哪些包、哪层(代码/文档/配置/构建)。

## 第二步:按改动类型选检查

| 改了什么 | 最小检查 |
|---|---|
| 单个包/模块的行为 | 该包对应的测试文件或测试名,`vitest run packages/<pkg>/tests/<behavior>.spec.ts` |
| 跨包共享契约 | 相邻依赖包的测试 |
| 文档、注释、README | 文档相关检查(链接、格式);文档改了代码没改则无需跑测试 |
| 用户可见输出(CLI 文案、错误信息、UI 文本) | 覆盖该输出的快照测试 |
| 包清单、导出、构建配置 | 构建命令 + 相关 hygiene 检查 |
| 依赖真实服务/Agent 的行为 | 有凭据时跑对应 e2e;**绝不打印密钥** |

## 第三步:不要做的事

- **不重复已通过的检查**:pre-commit 钩子已跑 lint/typecheck,提交前不必再跑一遍相同命令。
- **不用 `--passWithNoTests`、不降低覆盖率阈值**来让检查"显得通过"。
- **不用缩小 `--coverage.include` 掩盖未覆盖的受影响文件**。
- **找不到相关测试时不硬凑**:用 `vitest related <src/文件>` 借助依赖图发现候选,然后读一遍确认它真的覆盖这个行为。

## 失败处理

- 相关检查失败:停下来修复或说明原因,**不要"先推上去赌 CI 不同"**。
- 看起来是环境问题:记录确切命令、失败项、平台差异;确认非平台相关的证据;能修跨平台不确定性问题就修。

## 历史重写推送(force-push)

- 允许对分支 rebase(含评审后),但发布用 `--force-with-lease=<branch>:<observed-oid>`;**绝不裸 `--force`**。
- 推送前 fetch 远程分支,记录确切 OID;并发更新会让 lease 机制安全中止。
- 重写后:重新 fetch 头部,重新核对评审线程、批准、CI 状态——重写前的 commit 哈希和评论锚点不再是有效证据。

## 推送后

```sh
gh pr checks        # 查看远程 CI
```

CI 中 pending 就报 pending;失败先查是不是分支问题,再怀疑环境。

## 边界

- 只在你真的准备推送/宣称"检查通过"时使用;日常开发迭代中不需要。
- 用户明确要求"跑全量"时才跑全量;CI 失败诊断时跑全量。

---

*改编自 deepseek-ai/deepseek-harness 的 `dsh-pre-push-checks`(MIT License),已去除仓库绑定内容并本地化。原文:https://github.com/deepseek-ai/deepseek-harness/blob/master/.agents/skills/dsh-pre-push-checks/SKILL.md*
