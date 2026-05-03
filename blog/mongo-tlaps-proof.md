---
title: Agent-Generated TLAPS Proof for MongoLoglessDynamicRaft
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

<a class="back-link" href="/">Back to homepage</a>

# Agent-Generated TLAPS Proof for MongoLoglessDynamicRaft

This note archives the generated TLAPS proof draft for `MongoLoglessDynamicRaft`, a TLA+ model of a dynamic-configuration Raft-style protocol.

The proof artifact is available here:

[MongoLoglessDynamicRaft_IndAuto_ProofDraft.tla](https://weining-cao.github.io/files/MongoLoglessDynamicRaft_IndAuto_ProofDraft.tla)

The current artifact contains 6308 lines of TLAPS proof text. It was produced through an agentic proof-generation and repair workflow: the agent repeatedly inspected TLAPS feedback, refined proof obligations, added intermediate facts, and expanded failing proof leaves until the draft no longer contained `TODO` or `OMITTED` placeholders.

The proof is intentionally explicit. Large parts of the file come from preservation obligations for invariant clauses such as `StrConj_8`, `StrConj_10`, `StrConj_11`, and `StrConj_13`, where TLAPS often requires detailed case splits, quantified witnesses, and frame reasoning.
