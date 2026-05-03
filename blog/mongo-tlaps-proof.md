---
title: 我们让 Agent 自动写出了 6000 行 TLAPS 证明
---

<style>
body {
  max-width: 860px;
  margin: 48px auto;
  padding: 0 24px;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "PingFang SC", "Microsoft YaHei", Arial, sans-serif;
  line-height: 1.75;
  color: #222;
}

a {
  color: #2c3e50;
  font-weight: 600;
}

code {
  background: #f3f4f6;
  padding: 2px 5px;
  border-radius: 4px;
}

.back-link {
  display: inline-block;
  margin-bottom: 24px;
}
</style>

<a class="back-link" href="/">返回主页</a>

# 我们让 Agent 自动写出了 6000 行 TLAPS 证明

最近我们在分布式协议形式化验证上推进了一步：在此前分布式协议归纳不变式自动推导工作的基础上，我们进一步借助 agentic harness，实现了 TLAPS 证明脚本的自动化生成。

更具体地说，对于 MongoLoglessDynamicRaft 这个级别的协议，我们已经能够把链条打通到：

```text
自动生成归纳不变式 -> 自动书写 TLAPS 证明 -> 证明安全性质
```

这里最值得强调的一点是：TLAPS 证明部分没有插入任何协议特定的人工提示或手写 lemma。Agent 看到的是协议、归纳不变式、证明目标和通用证明反馈；之后，它通过反复推进 proof obligation，最终写出了完整证明。

这份证明草稿总共 6308 行 TLAPS 代码，全部由 agent 生成。

证明文件链接：

[MongoLoglessDynamicRaft_IndAuto_ProofDraft.tla](https://weining-cao.github.io/files/MongoLoglessDynamicRaft_IndAuto_ProofDraft.tla)

## 背景：为什么这件事难

分布式协议的安全性证明通常有两层困难：先找到足够强的归纳不变式，再把这个不变式写成机械化证明。前者解决“应该证明什么”，后者解决“如何让证明器检查通过”。这次结果是在自动生成归纳不变式之后，继续自动生成 TLAPS 能检查的证明脚本。

## 这次做了什么

这次实验的目标协议是 MongoLoglessDynamicRaft。它不是一个玩具协议：它包含动态配置、term、server state、配置传播等机制，已经足够体现真实分布式协议证明中的结构复杂度。

我们首先使用此前工作自动得到 MongoLoglessDynamicRaft 的归纳不变式。随后，我们把协议、归纳不变式和证明目标交给一个 agentic harness，让 agent 自动完成 TLAPS 证明书写。

整个 TLAPS 证明生成过程可以概括为三步：

1. 前提插入：agent 根据当前 proof obligation，识别需要显式引入的协议定义、类型约束、动作前提和已知不变式。
2. 证明骨架搭建：agent 按 action 和 clause 搭建证明骨架，将归纳证明拆成可逐步推进的局部证明任务。
3. Obligation 推进：agent 调用 TLAPS 检查当前证明，读取失败信息，再针对未完成的 obligation 补充更细粒度的中间步骤，直到证明通过。

重要的是，这个过程不是为 MongoLoglessDynamicRaft 手写的一套证明策略。Harness 并不包含该协议的特殊知识，也没有人工塞入“这里应该用某个协议专属 lemma”之类的信息。Agent 依靠通用的证明反馈循环，一步步把证明补齐。

## 结果

最终生成的证明文件是一个完整的 TLAPS proof draft：

```text
MongoLoglessDynamicRaft_IndAuto_ProofDraft.tla
```

文件总计 6308 行。它从基础事实、动作 frame 条件、配置版本关系、primed invariant 引入规则，一直推进到归纳不变式保持性和安全性质证明。

这里关键的不是某一个局部证明步骤有多复杂，而是 agent 能够持续生成并修复大量证明步骤，把它们组织成一个完整、可检查的 TLAPS 证明文件。

## 还没有解决什么

目前我们证明的是 MongoLoglessDynamicRaft 这个级别上，从归纳不变式自动生成到 TLAPS 证明自动生成的链条。不同协议的状态空间、动作结构、不变式形态和证明风格都可能不同。后续还需要在更多协议上检验这种方法的稳定性，尤其是更复杂日志结构、更强 liveness 需求，以及需要更深组合推理的协议。

从工程角度看，目前还有两个现实问题：token 消耗仍然偏高，证明状态也还需要更充分地持久化和复用。接下来我打算进一步优化 harness 脚本和相关持久化内容，让 agent 不必每轮都重新理解全部上下文，而是能在结构化的证明状态上继续推进。
