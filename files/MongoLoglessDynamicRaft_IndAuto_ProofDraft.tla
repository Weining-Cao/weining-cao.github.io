---- MODULE MongoLoglessDynamicRaft_IndAuto_ProofDraft ----
EXTENDS MongoLoglessDynamicRaft_InvInput, TLAPS, FiniteSetTheorems

(*
This proof draft was generated from the protocol and invariant input modules.
It is intentionally decomposed by invariant clause and protocol action.
*)

\* Proof assumptions for this benchmark:
\* This proof is carried out under the following assumptions:
AXIOM BenchmarkAssumption_ServerFinite == IsFiniteSet(Server)
AXIOM BenchmarkAssumption_InitTermNat == InitTerm \in Nat
AXIOM BenchmarkAssumption_PrimarySecondaryDistinct == Primary # Secondary

THEOREM Server_Fact_AllSubsetsFinite ==
  \A cfg \in SUBSET Server : IsFiniteSet(cfg)
PROOF
<1>1. TAKE cfg \in SUBSET Server
<1>2. IsFiniteSet(cfg)
  BY <1>1, BenchmarkAssumption_ServerFinite, FS_Subset
<1>3. QED
  BY <1>2

THEOREM ReconfigAction_Fact_Params ==
  ReconfigAction => \E s \in Server, newConfig \in SUBSET Server : Reconfig(s, newConfig)
PROOF
  BY DEF ReconfigAction

THEOREM ReconfigAction_Fact_Updates_ConfigVars ==
  ReconfigAction =>
    \E s \in Server, newConfig \in SUBSET Server :
      /\ Reconfig(s, newConfig)
      /\ configTerm' = [configTerm EXCEPT ![s] = currentTerm[s]]
      /\ configVersion' = [configVersion EXCEPT ![s] = configVersion[s] + 1]
      /\ config' = [config EXCEPT ![s] = newConfig]
PROOF
  BY DEF ReconfigAction, Reconfig

THEOREM ReconfigAction_Fact_Unchanged_TermState ==
  ReconfigAction => UNCHANGED <<currentTerm, state>>
PROOF
  BY DEF ReconfigAction, Reconfig

THEOREM ReconfigAction_Fact_Frame_CurrentTerm ==
  ReconfigAction => currentTerm' = currentTerm
PROOF
  BY ReconfigAction_Fact_Unchanged_TermState

THEOREM ReconfigAction_Fact_Frame_State ==
  ReconfigAction => state' = state
PROOF
  BY ReconfigAction_Fact_Unchanged_TermState

THEOREM Reconfig_Fact_TargetConfigVars ==
  \A s \in Server :
    \A newConfig \in SUBSET Server :
      TypeOK /\ Reconfig(s, newConfig) =>
        /\ config'[s] = newConfig
        /\ configTerm'[s] = currentTerm[s]
        /\ configVersion'[s] = configVersion[s] + 1
PROOF
<1>1. TAKE s \in Server
<1>2. TAKE newConfig \in SUBSET Server
<1>3. ASSUME TypeOK /\ Reconfig(s, newConfig)
      PROVE /\ config'[s] = newConfig
            /\ configTerm'[s] = currentTerm[s]
            /\ configVersion'[s] = configVersion[s] + 1
PROOF
<2>1. config \in [Server -> SUBSET Server]
  BY <1>3 DEF TypeOK
<2>2. configTerm \in [Server -> Nat]
  BY <1>3 DEF TypeOK
<2>3. configVersion \in [Server -> Nat]
  BY <1>3 DEF TypeOK
<2>4. config' = [config EXCEPT ![s] = newConfig]
  BY <1>3 DEF Reconfig
<2>5. configTerm' = [configTerm EXCEPT ![s] = currentTerm[s]]
  BY <1>3 DEF Reconfig
<2>6. configVersion' = [configVersion EXCEPT ![s] = configVersion[s] + 1]
  BY <1>3 DEF Reconfig
<2>7. config'[s] = newConfig
  BY <1>1, <2>1, <2>4
<2>8. configTerm'[s] = currentTerm[s]
  BY <1>1, <2>2, <2>5
<2>9. configVersion'[s] = configVersion[s] + 1
  BY <1>1, <2>3, <2>6
<2>10. QED
  BY <2>7, <2>8, <2>9
<1>4. QED
  BY <1>3

THEOREM Reconfig_Fact_OtherConfigVars ==
  \A s \in Server :
    \A newConfig \in SUBSET Server :
      \A u \in Server :
        TypeOK /\ Reconfig(s, newConfig) /\ u # s =>
          /\ config'[u] = config[u]
          /\ configTerm'[u] = configTerm[u]
          /\ configVersion'[u] = configVersion[u]
PROOF
<1>1. TAKE s \in Server
<1>2. TAKE newConfig \in SUBSET Server
<1>3. TAKE u \in Server
<1>4. ASSUME TypeOK /\ Reconfig(s, newConfig) /\ u # s
      PROVE /\ config'[u] = config[u]
            /\ configTerm'[u] = configTerm[u]
            /\ configVersion'[u] = configVersion[u]
PROOF
<2>1. config \in [Server -> SUBSET Server]
  BY <1>4 DEF TypeOK
<2>2. configTerm \in [Server -> Nat]
  BY <1>4 DEF TypeOK
<2>3. configVersion \in [Server -> Nat]
  BY <1>4 DEF TypeOK
<2>4. config' = [config EXCEPT ![s] = newConfig]
  BY <1>4 DEF Reconfig
<2>5. configTerm' = [configTerm EXCEPT ![s] = currentTerm[s]]
  BY <1>4 DEF Reconfig
<2>6. configVersion' = [configVersion EXCEPT ![s] = configVersion[s] + 1]
  BY <1>4 DEF Reconfig
<2>7. config'[u] = config[u]
  BY <1>3, <1>4, <2>1, <2>4
<2>8. configTerm'[u] = configTerm[u]
  BY <1>3, <1>4, <2>2, <2>5
<2>9. configVersion'[u] = configVersion[u]
  BY <1>3, <1>4, <2>3, <2>6
<2>10. QED
  BY <2>7, <2>8, <2>9
<1>5. QED
  BY <1>4

THEOREM SendConfigAction_Fact_Params ==
  SendConfigAction => \E s \in Server, t \in Server : SendConfig(s, t)
PROOF
  BY DEF SendConfigAction

THEOREM SendConfigAction_Fact_Updates_ConfigVars ==
  SendConfigAction =>
    \E s \in Server, t \in Server :
      /\ SendConfig(s, t)
      /\ configVersion' = [configVersion EXCEPT ![t] = configVersion[s]]
      /\ configTerm' = [configTerm EXCEPT ![t] = configTerm[s]]
      /\ config' = [config EXCEPT ![t] = config[s]]
PROOF
  BY DEF SendConfigAction, SendConfig

THEOREM SendConfigAction_Fact_Unchanged_TermState ==
  SendConfigAction => UNCHANGED <<currentTerm, state>>
PROOF
  BY DEF SendConfigAction, SendConfig

THEOREM SendConfigAction_Fact_Frame_CurrentTerm ==
  SendConfigAction => currentTerm' = currentTerm
PROOF
  BY SendConfigAction_Fact_Unchanged_TermState

THEOREM SendConfigAction_Fact_Frame_State ==
  SendConfigAction => state' = state
PROOF
  BY SendConfigAction_Fact_Unchanged_TermState

THEOREM Next_Fact_ActionCases ==
  Next => ReconfigAction \/ SendConfigAction \/ BecomeLeaderAction \/ UpdateTermsAction
PROOF
  BY DEF Next

THEOREM SendConfig_Fact_TargetPairIsSourcePair ==
  \A s \in Server, t \in Server :
    TypeOK /\ SendConfig(s, t) =>
      /\ configTerm'[t] = configTerm[s]
      /\ configVersion'[t] = configVersion[s]
PROOF
<1>1. TAKE s \in Server, t \in Server
<1>2. ASSUME TypeOK /\ SendConfig(s, t)
      PROVE /\ configTerm'[t] = configTerm[s]
            /\ configVersion'[t] = configVersion[s]
PROOF
<2>1. TypeOK
  BY <1>2
<2>2. configTerm \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>3. configVersion \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>4. configTerm' = [configTerm EXCEPT ![t] = configTerm[s]]
  BY <1>2 DEF SendConfig
<2>5. configVersion' = [configVersion EXCEPT ![t] = configVersion[s]]
  BY <1>2 DEF SendConfig
<2>6. configTerm'[t] = configTerm[s]
  BY <1>1, <2>2, <2>4
<2>7. configVersion'[t] = configVersion[s]
  BY <1>1, <2>3, <2>5
<2>8. QED
  BY <2>6, <2>7
<1>3. QED
  BY <1>2

THEOREM SendConfig_Fact_TargetConfigVars ==
  \A s \in Server, t \in Server :
    TypeOK /\ SendConfig(s, t) =>
      /\ config'[t] = config[s]
      /\ configTerm'[t] = configTerm[s]
      /\ configVersion'[t] = configVersion[s]
PROOF
<1>1. TAKE s \in Server, t \in Server
<1>2. ASSUME TypeOK /\ SendConfig(s, t)
      PROVE /\ config'[t] = config[s]
            /\ configTerm'[t] = configTerm[s]
            /\ configVersion'[t] = configVersion[s]
PROOF
<2>1. TypeOK
  BY <1>2
<2>2. config \in [Server -> SUBSET Server]
  BY <2>1 DEF TypeOK
<2>3. config' = [config EXCEPT ![t] = config[s]]
  BY <1>2 DEF SendConfig
<2>4. config'[t] = config[s]
  BY <1>1, <2>2, <2>3
<2>5. /\ configTerm'[t] = configTerm[s]
       /\ configVersion'[t] = configVersion[s]
  BY <1>2, SendConfig_Fact_TargetPairIsSourcePair
<2>6. QED
  BY <2>4, <2>5
<1>3. QED
  BY <1>2

THEOREM SendConfig_Fact_OtherConfigVars ==
  \A s \in Server, t \in Server, u \in Server :
    TypeOK /\ SendConfig(s, t) /\ u # t =>
      /\ config'[u] = config[u]
      /\ configTerm'[u] = configTerm[u]
      /\ configVersion'[u] = configVersion[u]
PROOF
<1>1. TAKE s \in Server, t \in Server, u \in Server
<1>2. ASSUME TypeOK /\ SendConfig(s, t) /\ u # t
      PROVE /\ config'[u] = config[u]
            /\ configTerm'[u] = configTerm[u]
            /\ configVersion'[u] = configVersion[u]
PROOF
<2>1. TypeOK
  BY <1>2
<2>2. config \in [Server -> SUBSET Server]
  BY <2>1 DEF TypeOK
<2>3. configTerm \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>4. configVersion \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>5. config' = [config EXCEPT ![t] = config[s]]
  BY <1>2 DEF SendConfig
<2>6. configTerm' = [configTerm EXCEPT ![t] = configTerm[s]]
  BY <1>2 DEF SendConfig
<2>7. configVersion' = [configVersion EXCEPT ![t] = configVersion[s]]
  BY <1>2 DEF SendConfig
<2>8. config'[u] = config[u]
  BY <1>1, <1>2, <2>2, <2>5
<2>9. configTerm'[u] = configTerm[u]
  BY <1>1, <1>2, <2>3, <2>6
<2>10. configVersion'[u] = configVersion[u]
  BY <1>1, <1>2, <2>4, <2>7
<2>11. QED
  BY <2>8, <2>9, <2>10
<1>3. QED
  BY <1>2

THEOREM IsNewerConfig_Irreflexive ==
  \A a \in Server : ~ IsNewerConfig(a, a)
PROOF
  BY DEF IsNewerConfig

THEOREM Nat_Geq_Transitive ==
  \A a, b, c \in Nat : a >= b /\ b >= c => a >= c
PROOF
  BY SMT

THEOREM Nat_Geq_Reflexive ==
  \A a \in Nat : a >= a
PROOF
  BY SMT

THEOREM Nat_Leq_Transitive ==
  \A a, b, c \in Nat : a <= b /\ b <= c => a <= c
PROOF
  BY SMT

THEOREM Nat_Succ_Preserves_Gt ==
  \A a, b \in Nat : a > b => a + 1 > b
PROOF
  BY SMT

THEOREM IsNewerConfig_Transitive ==
  TypeOK => \A a, b, c \in Server : IsNewerConfig(a, b) /\ IsNewerConfig(b, c) => IsNewerConfig(a, c)
PROOF
<1>1. ASSUME TypeOK
      PROVE \A a, b, c \in Server : IsNewerConfig(a, b) /\ IsNewerConfig(b, c) => IsNewerConfig(a, c)
PROOF
<2>1. TAKE a \in Server, b \in Server, c \in Server
<2>2. /\ configTerm[a] \in Nat
       /\ configTerm[b] \in Nat
       /\ configTerm[c] \in Nat
       /\ configVersion[a] \in Nat
       /\ configVersion[b] \in Nat
       /\ configVersion[c] \in Nat
  BY <1>1, <2>1 DEF TypeOK
<2>3. ASSUME IsNewerConfig(a, b) /\ IsNewerConfig(b, c)
      PROVE IsNewerConfig(a, c)
PROOF
<3>1. CASE configTerm[a] > configTerm[b]
PROOF
<4>1. CASE configTerm[b] > configTerm[c]
PROOF
<5>1. configTerm[a] > configTerm[c]
  BY <2>2, <3>1, <4>1, SMTT(30)
<5>2. QED
  BY <5>1 DEF IsNewerConfig
<4>2. CASE /\ configTerm[b] = configTerm[c]
           /\ configVersion[b] > configVersion[c]
PROOF
<5>1. configTerm[a] > configTerm[c]
  BY <2>2, <3>1, <4>2, SMTT(30)
<5>2. QED
  BY <5>1 DEF IsNewerConfig
<4>3. QED
  BY <2>3, <4>1, <4>2 DEF IsNewerConfig
<3>2. CASE /\ configTerm[a] = configTerm[b]
           /\ configVersion[a] > configVersion[b]
PROOF
<4>1. CASE configTerm[b] > configTerm[c]
PROOF
<5>1. configTerm[a] > configTerm[c]
  BY <2>2, <3>2, <4>1, SMTT(30)
<5>2. QED
  BY <5>1 DEF IsNewerConfig
<4>2. CASE /\ configTerm[b] = configTerm[c]
           /\ configVersion[b] > configVersion[c]
PROOF
<5>1. configTerm[a] = configTerm[c]
  BY <3>2, <4>2
<5>2. configVersion[a] > configVersion[c]
  BY <2>2, <3>2, <4>2, SMTT(30)
<5>3. QED
  BY <5>1, <5>2 DEF IsNewerConfig
<4>3. QED
  BY <2>3, <4>1, <4>2 DEF IsNewerConfig
<3>3. QED
  BY <2>3, <3>1, <3>2 DEF IsNewerConfig
<2>4. QED
  BY <2>3
<1>2. QED
  BY <1>1

THEOREM IsNewerConfig_Asymmetric ==
  TypeOK => \A a, b \in Server : IsNewerConfig(a, b) => ~ IsNewerConfig(b, a)
PROOF
<1>1. ASSUME TypeOK
      PROVE \A a, b \in Server : IsNewerConfig(a, b) => ~ IsNewerConfig(b, a)
PROOF
<2>1. TAKE a \in Server, b \in Server
<2>2. ASSUME IsNewerConfig(a, b)
      PROVE ~ IsNewerConfig(b, a)
PROOF
<3>1. ASSUME IsNewerConfig(b, a)
      PROVE FALSE
PROOF
<4>1. IsNewerConfig(a, a)
  BY <1>1, <2>1, <2>2, <3>1, IsNewerConfig_Transitive
<4>2. ~ IsNewerConfig(a, a)
  BY <2>1, IsNewerConfig_Irreflexive
<4>3. FALSE
  BY <4>1, <4>2
<4>4. QED
  BY <4>3
<3>2. QED
  BY <3>1
<2>3. QED
  BY <2>2
<1>2. QED
  BY <1>1

THEOREM ConfigDisabled_Primed_Intro ==
  \A i \in Server :
    (\A Q \in Quorums(config'[i]) :
       \E n \in Q :
         NewerConfig(<<configVersion'[n], configTerm'[n]>>,
                     <<configVersion'[i], configTerm'[i]>>))
    => ConfigDisabled(i)'
PROOF
  BY DEF ConfigDisabled, CV

THEOREM OnePrimaryPerTerm_Primed_Intro ==
  (\A s, t \in Server :
     (/\ state'[s] = Primary
      /\ state'[t] = Primary
      /\ currentTerm'[s] = currentTerm'[t]) => s = t)
  => OnePrimaryPerTerm'
PROOF
  BY DEF OnePrimaryPerTerm

THEOREM Safety_Primed_Intro ==
  OnePrimaryPerTerm' => Safety'
PROOF
  BY DEF Safety

THEOREM StrConj_0_Primed_Intro ==
  (\A s \in Server : configVersion'[s] >= 1) => StrConj_0'
PROOF
  BY DEF StrConj_0

THEOREM StrConj_5_Primed_Intro ==
  (\A s \in Server : \E t \in config'[s] : currentTerm'[t] >= configTerm'[s]) => StrConj_5'
PROOF
  BY DEF StrConj_5

THEOREM StrConj_6_Primed_Intro ==
  (\A s \in Server : state'[s] = Primary => configTerm'[s] = currentTerm'[s]) => StrConj_6'
PROOF
  BY DEF StrConj_6

THEOREM StrConj_8_Primed_Intro ==
  (\A s \in Server :
     \A t \in Server :
       QuorumsOverlap(config'[s], config'[t]) \/ ConfigDisabled(s)' \/ ConfigDisabled(t)')
  => StrConj_8'
PROOF
  BY DEF StrConj_8

THEOREM StrConj_10_Primed_Intro ==
  (\A s \in Server :
     \A t \in Server :
       \A Q \in Quorums(config'[s]) :
         \E n \in Q :
           currentTerm'[n] >= currentTerm'[t] \/ IsNewerConfig(n, s)')
  => StrConj_10'
PROOF
  BY DEF StrConj_10, QuorumsAt

THEOREM StrConj_11_Primed_Intro ==
  (\A s \in Server :
     \A t \in Server :
       (configTerm'[s] = configTerm'[t] /\ configVersion'[s] = configVersion'[t]) => config'[s] = config'[t])
  => StrConj_11'
PROOF
  BY DEF StrConj_11

THEOREM StrConj_13_Primed_Intro ==
  (\A s \in Server :
     state'[s] = Primary =>
       \A t \in Server :
         configTerm'[t] # configTerm'[s] \/ configVersion'[t] <= configVersion'[s])
  => StrConj_13'
PROOF
  BY DEF StrConj_13

THEOREM SendConfig_Fact_SourceDisabledImpliesTargetDisabled ==
  \A s \in Server, t \in Server :
    TypeOK /\ SendConfig(s, t) /\ ConfigDisabled(s) => ConfigDisabled(t)'
PROOF
<1>1. TAKE s \in Server, t \in Server
<1>2. ASSUME TypeOK /\ SendConfig(s, t) /\ ConfigDisabled(s)
      PROVE ConfigDisabled(t)'
PROOF
<2>1. TypeOK
  BY <1>2
<2>2. SendConfig(s, t)
  BY <1>2
<2>3. ConfigDisabled(s)
  BY <1>2
<2>4. config \in [Server -> SUBSET Server]
  BY <2>1 DEF TypeOK
<2>5. configTerm \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>6. configVersion \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>7. config' = [config EXCEPT ![t] = config[s]]
  BY <2>2 DEF SendConfig
<2>8. configTerm' = [configTerm EXCEPT ![t] = configTerm[s]]
  BY <2>2 DEF SendConfig
<2>9. configVersion' = [configVersion EXCEPT ![t] = configVersion[s]]
  BY <2>2 DEF SendConfig
<2>10. configTerm'[t] = configTerm[s]
  BY <2>1, <2>2, SendConfig_Fact_TargetPairIsSourcePair
<2>11. configVersion'[t] = configVersion[s]
  BY <2>1, <2>2, SendConfig_Fact_TargetPairIsSourcePair
<2>12. \A Q \in Quorums(config'[t]) :
          \E m \in Q :
            NewerConfig(<<configVersion'[m], configTerm'[m]>>,
                        <<configVersion'[t], configTerm'[t]>>)
PROOF
<3>1. TAKE Q \in Quorums(config'[t])
<3>2. Q \in Quorums(config[s])
  BY <1>1, <2>4, <2>7, <3>1
<3>3. PICK n \in Q : NewerConfig(CV(n), CV(s))
  BY <2>3, <3>2 DEF ConfigDisabled
<3>4. n = t => FALSE
PROOF
<4>1. ASSUME n = t
      PROVE FALSE
PROOF
<5>1. NewerConfig(CV(t), CV(s))
  BY <3>3, <4>1
<5>2. IsNewerConfig(t, s)
  BY <5>1 DEF CV, IsNewerConfig, NewerConfig
<5>3. IsNewerConfig(s, t)
  BY <2>2 DEF SendConfig
<5>4. IsNewerConfig(t, t)
  BY <1>1, <2>1, <5>2, <5>3, IsNewerConfig_Transitive
<5>5. ~ IsNewerConfig(t, t)
  BY <1>1, IsNewerConfig_Irreflexive
<5>6. FALSE
  BY <5>4, <5>5
<5>7. QED
  BY <5>6
<4>2. QED
  BY <4>1
<3>5. n # t
  BY <3>4
<3>6. configTerm'[n] = configTerm[n]
  BY <1>1, <2>4, <2>5, <2>8, <3>2, <3>3, <3>5 DEF Quorums
<3>7. configVersion'[n] = configVersion[n]
  BY <1>1, <2>4, <2>6, <2>9, <3>2, <3>3, <3>5 DEF Quorums
<3>8. NewerConfig(<<configVersion'[n], configTerm'[n]>>, <<configVersion'[t], configTerm'[t]>>)
  BY <2>10, <2>11, <3>3, <3>6, <3>7 DEF CV
<3>9. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[t], configTerm'[t]>>)
  BY <3>3, <3>8
<3>10. QED
  BY <3>9
<2>13. ConfigDisabled(t)'
  BY <1>1, <2>12, ConfigDisabled_Primed_Intro
<2>14. QED
  BY <2>13
<1>3. QED
  BY <1>2

THEOREM SendConfig_Fact_OtherDisabledUnchanged ==
  \A s \in Server, t \in Server, u \in Server :
    TypeOK /\ SendConfig(s, t) /\ u # t /\ ConfigDisabled(u) => ConfigDisabled(u)'
PROOF
<1>1. TAKE s \in Server, t \in Server, u \in Server
<1>2. ASSUME TypeOK /\ SendConfig(s, t) /\ u # t /\ ConfigDisabled(u)
      PROVE ConfigDisabled(u)'
PROOF
<2>1. TypeOK
  BY <1>2
<2>2. SendConfig(s, t)
  BY <1>2
<2>3. u # t
  BY <1>2
<2>4. ConfigDisabled(u)
  BY <1>2
<2>5. config \in [Server -> SUBSET Server]
  BY <2>1 DEF TypeOK
<2>6. configTerm \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>7. configVersion \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>8. config' = [config EXCEPT ![t] = config[s]]
  BY <2>2 DEF SendConfig
<2>9. configTerm' = [configTerm EXCEPT ![t] = configTerm[s]]
  BY <2>2 DEF SendConfig
<2>10. configVersion' = [configVersion EXCEPT ![t] = configVersion[s]]
  BY <2>2 DEF SendConfig
<2>11. configTerm'[t] = configTerm[s]
  BY <2>1, <2>2, SendConfig_Fact_TargetPairIsSourcePair
<2>12. configVersion'[t] = configVersion[s]
  BY <2>1, <2>2, SendConfig_Fact_TargetPairIsSourcePair
<2>13. config'[u] = config[u]
  BY <1>1, <2>5, <2>8, <2>3
<2>14. configTerm'[u] = configTerm[u]
  BY <1>1, <2>6, <2>9, <2>3
<2>15. configVersion'[u] = configVersion[u]
  BY <1>1, <2>7, <2>10, <2>3
<2>16. \A Q \in Quorums(config'[u]) :
          \E m \in Q :
            NewerConfig(<<configVersion'[m], configTerm'[m]>>,
                        <<configVersion'[u], configTerm'[u]>>)
PROOF
<3>1. TAKE Q \in Quorums(config'[u])
<3>2. Q \in Quorums(config[u])
  BY <2>13, <3>1
<3>3. PICK n \in Q : NewerConfig(CV(n), CV(u))
  BY <2>4, <3>2 DEF ConfigDisabled
<3>4. CASE n = t
PROOF
<4>1. IsNewerConfig(t, u)
  BY <3>3, <3>4 DEF CV, IsNewerConfig, NewerConfig
<4>2. IsNewerConfig(s, t)
  BY <2>2 DEF SendConfig
<4>3. IsNewerConfig(s, u)
  BY <1>1, <2>1, <4>1, <4>2, IsNewerConfig_Transitive
<4>4. configTerm'[n] = configTerm[s]
  BY <2>11, <3>4
<4>5. configVersion'[n] = configVersion[s]
  BY <2>12, <3>4
<4>6. NewerConfig(<<configVersion'[n], configTerm'[n]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <2>14, <2>15, <4>3, <4>4, <4>5 DEF CV, IsNewerConfig, NewerConfig
<4>7. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <3>3, <4>6
<4>8. QED
  BY <4>7
<3>5. CASE n # t
PROOF
<4>1. configTerm'[n] = configTerm[n]
  BY <1>1, <2>5, <2>6, <2>9, <3>2, <3>3, <3>5 DEF Quorums
<4>2. configVersion'[n] = configVersion[n]
  BY <1>1, <2>5, <2>7, <2>10, <3>2, <3>3, <3>5 DEF Quorums
<4>3. NewerConfig(<<configVersion'[n], configTerm'[n]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <2>14, <2>15, <3>3, <4>1, <4>2 DEF CV
<4>4. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <3>3, <4>3
<4>5. QED
  BY <4>4
<3>6. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <3>4, <3>5
<3>7. QED
  BY <3>6
<2>17. ConfigDisabled(u)'
  BY <1>1, <2>16, ConfigDisabled_Primed_Intro
<2>18. QED
  BY <2>17
<1>3. QED
  BY <1>2

THEOREM BecomeLeaderAction_Fact_Params ==
  BecomeLeaderAction => \E i \in Server : \E Q \in Quorums(config[i]) : BecomeLeader(i, Q)
PROOF
  BY DEF BecomeLeaderAction

THEOREM BecomeLeaderAction_Fact_Updates_TermStateConfigTerm ==
  BecomeLeaderAction =>
    \E i \in Server : \E Q \in Quorums(config[i]) :
      /\ BecomeLeader(i, Q)
      /\ LET newTerm == currentTerm[i] + 1 IN
           currentTerm' = [s \in Server |-> IF s \in Q THEN newTerm ELSE currentTerm[s]]
      /\ state' = [s \in Server |->
                    IF s = i THEN Primary
                    ELSE IF s \in Q THEN Secondary
                    ELSE state[s]]
      /\ configTerm' = [configTerm EXCEPT ![i] = currentTerm[i] + 1]
PROOF
  BY DEF BecomeLeaderAction, BecomeLeader

THEOREM BecomeLeaderAction_Fact_Unchanged_Config ==
  BecomeLeaderAction => UNCHANGED <<config, configVersion>>
PROOF
  BY DEF BecomeLeaderAction, BecomeLeader

THEOREM BecomeLeaderAction_Fact_Frame_Config ==
  BecomeLeaderAction => config' = config
PROOF
  BY BecomeLeaderAction_Fact_Unchanged_Config

THEOREM BecomeLeaderAction_Fact_Frame_ConfigVersion ==
  BecomeLeaderAction => configVersion' = configVersion
PROOF
  BY BecomeLeaderAction_Fact_Unchanged_Config

THEOREM BecomeLeaderAction_Fact_Derived_QuorumsAt ==
  BecomeLeaderAction => \A s \in Server : Quorums(config'[s]) = QuorumsAt(s)
PROOF
  BY BecomeLeaderAction_Fact_Frame_Config DEF QuorumsAt

THEOREM BecomeLeaderAction_Fact_CurrentTerm_Nondecreasing ==
  TypeOK /\ BecomeLeaderAction => \A n \in Server : currentTerm'[n] >= currentTerm[n]
PROOF
<1>1. SUFFICES ASSUME TypeOK /\ BecomeLeaderAction PROVE \A n \in Server : currentTerm'[n] >= currentTerm[n]
  BY SMT
<1>2. TypeOK
  BY <1>1
<1>3. BecomeLeaderAction
  BY <1>1
<1>4. PICK i \in Server : \E Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <1>3 DEF BecomeLeaderAction
<1>5. PICK Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <1>4
<1>6. currentTerm' = [s \in Server |-> IF s \in Q THEN currentTerm[i] + 1 ELSE currentTerm[s]]
  BY <1>5 DEF BecomeLeader
<1>7. \A n \in Server : currentTerm'[n] >= currentTerm[n]
PROOF
<2>1. TAKE n \in Server
<2>2. CASE n \in Q
PROOF
<3>1. currentTerm'[n] = currentTerm[i] + 1
  BY <1>6, <2>2
<3>2. currentTerm[n] < currentTerm[i] + 1
  BY <1>5, <2>1, <2>2 DEF BecomeLeader, CanVoteForConfig
<3>3. currentTerm'[n] >= currentTerm[n]
  BY <3>1, <3>2
<3>4. QED
  BY <3>3
<2>3. CASE n \notin Q
PROOF
<3>1. currentTerm'[n] = currentTerm[n]
  BY <1>6, <2>3
<3>2. currentTerm[n] \in Nat
  BY <1>2, <2>1 DEF TypeOK
<3>3. currentTerm'[n] >= currentTerm[n]
  BY <3>1, <3>2
<3>4. QED
  BY <3>3
<2>4. QED
  BY <2>2, <2>3
<1>8. QED
  BY <1>1, <1>7

THEOREM BecomeLeader_Fact_NewTerm_Exceeds_AllCurrentTerms ==
  \A i \in Server :
    \A Q \in Quorums(config[i]) :
      \A y \in Server :
        IndAuto /\ BecomeLeader(i, Q) => currentTerm[y] < currentTerm[i] + 1
PROOF
<1>1. TAKE i \in Server
<1>2. TAKE Q \in Quorums(config[i])
<1>3. TAKE y \in Server
<1>4. ASSUME IndAuto /\ BecomeLeader(i, Q)
      PROVE currentTerm[y] < currentTerm[i] + 1
PROOF
<2>1. PICK n \in Q :
        currentTerm[n] >= currentTerm[y] \/ IsNewerConfig(n, i)
  BY <1>1, <1>2, <1>3, <1>4 DEF IndAuto, StrConj_10, QuorumsAt
<2>2. currentTerm[n] < currentTerm[i] + 1
  BY <1>4, <2>1 DEF BecomeLeader, CanVoteForConfig
<2>3. TypeOK
  BY <1>4 DEF IndAuto
<2>4. n \in Server
  BY <1>1, <1>2, <2>1, <2>3 DEF TypeOK, Quorums
<2>5. ~ IsNewerConfig(n, i)
PROOF
<3>1. ASSUME IsNewerConfig(n, i)
      PROVE FALSE
PROOF
<4>1. (/\ configTerm[i] = configTerm[n]
        /\ configVersion[i] = configVersion[n])
      \/ configTerm[i] > configTerm[n]
      \/ /\ configTerm[i] = configTerm[n]
         /\ configVersion[i] > configVersion[n]
  BY <1>4, <2>1 DEF BecomeLeader, CanVoteForConfig, IsNewerOrEqualConfig, IsNewerConfig
<4>2. CASE /\ configTerm[i] = configTerm[n]
           /\ configVersion[i] = configVersion[n]
PROOF
<5>1. FALSE
  BY <3>1, <4>2 DEF IsNewerConfig
<5>2. QED
  BY <5>1
<4>3. CASE configTerm[i] > configTerm[n]
PROOF
<5>1. IsNewerConfig(i, n)
  BY <4>3 DEF IsNewerConfig
<5>2. ~ IsNewerConfig(n, i)
  BY <1>1, <2>3, <2>4, <5>1, IsNewerConfig_Asymmetric
<5>3. FALSE
  BY <3>1, <5>2
<5>4. QED
  BY <5>3
<4>4. CASE /\ configTerm[i] = configTerm[n]
           /\ configVersion[i] > configVersion[n]
PROOF
<5>1. IsNewerConfig(i, n)
  BY <4>4 DEF IsNewerConfig
<5>2. ~ IsNewerConfig(n, i)
  BY <1>1, <2>3, <2>4, <5>1, IsNewerConfig_Asymmetric
<5>3. FALSE
  BY <3>1, <5>2
<5>4. QED
  BY <5>3
<4>5. FALSE
  BY <4>1, <4>2, <4>3, <4>4
<4>6. QED
  BY <4>5
<3>2. QED
  BY <3>1
<2>6. currentTerm[n] >= currentTerm[y]
  BY <2>1, <2>5
<2>7. /\ currentTerm[n] \in Nat
       /\ currentTerm[y] \in Nat
       /\ currentTerm[i] \in Nat
  BY <1>1, <1>3, <2>3, <2>4 DEF TypeOK
<2>8. currentTerm[y] < currentTerm[i] + 1
  BY <2>2, <2>6, <2>7, SMTT(30)
<2>9. QED
  BY <2>8
<1>5. QED
  BY <1>4

THEOREM BecomeLeader_Fact_OtherConfigTerm_DiffersFromNewTerm ==
  \A i \in Server :
    \A Q \in Quorums(config[i]) :
      \A y \in Server :
        IndAuto /\ BecomeLeader(i, Q) /\ y # i => configTerm[y] # currentTerm[i] + 1
PROOF
<1>1. TAKE i \in Server
<1>2. TAKE Q \in Quorums(config[i])
<1>3. TAKE y \in Server
<1>4. ASSUME IndAuto /\ BecomeLeader(i, Q) /\ y # i
      PROVE configTerm[y] # currentTerm[i] + 1
PROOF
<2>1. PICK t \in config[y] : currentTerm[t] >= configTerm[y]
  BY <1>3, <1>4 DEF IndAuto, StrConj_5
<2>2. TypeOK
  BY <1>4 DEF IndAuto
<2>3. t \in Server
  BY <1>3, <2>1, <2>2 DEF TypeOK
<2>4. currentTerm[t] < currentTerm[i] + 1
  BY <1>1, <1>2, <2>3, <1>4, BecomeLeader_Fact_NewTerm_Exceeds_AllCurrentTerms
<2>5. ASSUME configTerm[y] = currentTerm[i] + 1
      PROVE FALSE
PROOF
<3>1. currentTerm[t] >= currentTerm[i] + 1
  BY <2>1, <2>5
<3>2. currentTerm[i] + 1 <= currentTerm[t]
  BY <3>1
<3>3. /\ currentTerm[t] \in Nat
       /\ currentTerm[i] \in Nat
  BY <1>1, <2>2, <2>3 DEF TypeOK
<3>4. currentTerm[t] < currentTerm[t]
  BY <2>4, <3>2, <3>3, SMTT(30)
<3>5. FALSE
  BY <3>4
<3>6. QED
  BY <3>5
<2>6. QED
  BY <2>5
<1>5. QED
  BY <1>4

THEOREM BecomeLeader_Fact_TargetConfigTerm ==
  \A i \in Server :
    \A Q \in Quorums(config[i]) :
      IndAuto /\ BecomeLeader(i, Q) => configTerm'[i] = currentTerm[i] + 1
PROOF
<1>1. TAKE i \in Server
<1>2. TAKE Q \in Quorums(config[i])
<1>3. ASSUME IndAuto /\ BecomeLeader(i, Q)
      PROVE configTerm'[i] = currentTerm[i] + 1
PROOF
<2>1. TypeOK
  BY <1>3 DEF IndAuto
<2>2. configTerm \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>3. configTerm' = [configTerm EXCEPT ![i] = currentTerm[i] + 1]
  BY <1>3 DEF BecomeLeader
<2>4. QED
  BY <1>1, <2>2, <2>3
<1>4. QED
  BY <1>3

THEOREM BecomeLeader_Fact_OtherConfigTerm ==
  \A i \in Server :
    \A Q \in Quorums(config[i]) :
      \A y \in Server :
        IndAuto /\ BecomeLeader(i, Q) /\ y # i => configTerm'[y] = configTerm[y]
PROOF
<1>1. TAKE i \in Server
<1>2. TAKE Q \in Quorums(config[i])
<1>3. TAKE y \in Server
<1>4. ASSUME IndAuto /\ BecomeLeader(i, Q) /\ y # i
      PROVE configTerm'[y] = configTerm[y]
PROOF
<2>1. TypeOK
  BY <1>4 DEF IndAuto
<2>2. configTerm \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>3. configTerm' = [configTerm EXCEPT ![i] = currentTerm[i] + 1]
  BY <1>4 DEF BecomeLeader
<2>4. QED
  BY <1>3, <1>4, <2>2, <2>3
<1>5. QED
  BY <1>4

THEOREM BecomeLeader_Fact_NewTerm_Exceeds_AllConfigTerms ==
  \A i \in Server :
    \A Q \in Quorums(config[i]) :
      \A y \in Server :
        IndAuto /\ BecomeLeader(i, Q) => configTerm[y] < currentTerm[i] + 1
PROOF
<1>1. TAKE i \in Server
<1>2. TAKE Q \in Quorums(config[i])
<1>3. TAKE y \in Server
<1>4. ASSUME IndAuto /\ BecomeLeader(i, Q)
      PROVE configTerm[y] < currentTerm[i] + 1
PROOF
<2>1. PICK t \in config[y] : currentTerm[t] >= configTerm[y]
  BY <1>3, <1>4 DEF IndAuto, StrConj_5
<2>2. TypeOK
  BY <1>4 DEF IndAuto
<2>3. t \in Server
  BY <1>3, <2>1, <2>2 DEF TypeOK
<2>4. currentTerm[t] < currentTerm[i] + 1
  BY <1>1, <1>2, <2>3, <1>4, BecomeLeader_Fact_NewTerm_Exceeds_AllCurrentTerms
<2>5. configTerm[y] \in Nat
  BY <1>3, <2>2 DEF TypeOK
<2>6. /\ currentTerm[t] \in Nat
       /\ currentTerm[i] \in Nat
  BY <1>1, <2>2, <2>3 DEF TypeOK
<2>7. currentTerm[t] <= currentTerm[i]
  BY <2>4, <2>6, SMTT(30)
<2>8. configTerm[y] <= currentTerm[i]
  BY <2>1, <2>7, <2>5, <2>6, SMTT(30)
<2>9. configTerm[y] < currentTerm[i] + 1
  BY <2>5, <2>6, <2>8, SMTT(30)
<2>10. QED
  BY <2>9
<1>5. QED
  BY <1>4

THEOREM BecomeLeader_Fact_LeaderNotDisabled ==
  \A i \in Server :
    \A Q \in Quorums(config[i]) :
      TypeOK /\ BecomeLeader(i, Q) => ~ ConfigDisabled(i)
PROOF
<1>1. TAKE i \in Server
<1>2. TAKE Q \in Quorums(config[i])
<1>3. ASSUME TypeOK /\ BecomeLeader(i, Q)
      PROVE ~ ConfigDisabled(i)
PROOF
<2>1. ASSUME ConfigDisabled(i)
      PROVE FALSE
PROOF
<3>1. PICK n \in Q : NewerConfig(CV(n), CV(i))
  BY <1>2, <2>1 DEF ConfigDisabled
<3>2. IsNewerConfig(n, i)
  BY <3>1 DEF CV, NewerConfig, IsNewerConfig
<3>3. n \in Server
  BY <1>1, <1>2, <1>3, <3>1 DEF TypeOK, Quorums
<3>4. CanVoteForConfig(n, i, currentTerm[i] + 1)
  BY <1>3, <3>1 DEF BecomeLeader
<3>5. (/\ configTerm[i] = configTerm[n]
        /\ configVersion[i] = configVersion[n])
      \/ configTerm[i] > configTerm[n]
      \/ /\ configTerm[i] = configTerm[n]
         /\ configVersion[i] > configVersion[n]
  BY <3>4 DEF CanVoteForConfig, IsNewerOrEqualConfig, IsNewerConfig
<3>6. CASE /\ configTerm[i] = configTerm[n]
           /\ configVersion[i] = configVersion[n]
PROOF
<4>1. FALSE
  BY <3>2, <3>6 DEF IsNewerConfig
<4>2. QED
  BY <4>1
<3>7. CASE configTerm[i] > configTerm[n]
PROOF
<4>1. IsNewerConfig(i, n)
  BY <3>7 DEF IsNewerConfig
<4>2. ~ IsNewerConfig(n, i)
  BY <1>1, <1>3, <3>3, <4>1, IsNewerConfig_Asymmetric
<4>3. FALSE
  BY <3>2, <4>2
<4>4. QED
  BY <4>3
<3>8. CASE /\ configTerm[i] = configTerm[n]
           /\ configVersion[i] > configVersion[n]
PROOF
<4>1. IsNewerConfig(i, n)
  BY <3>8 DEF IsNewerConfig
<4>2. ~ IsNewerConfig(n, i)
  BY <1>1, <1>3, <3>3, <4>1, IsNewerConfig_Asymmetric
<4>3. FALSE
  BY <3>2, <4>2
<4>4. QED
  BY <4>3
<3>9. FALSE
  BY <3>5, <3>6, <3>7, <3>8
<3>10. QED
  BY <3>9
<2>2. QED
  BY <2>1
<1>4. QED
  BY <1>3

THEOREM BecomeLeader_Fact_OtherDisabledPreserved ==
  \A i \in Server :
    \A Q \in Quorums(config[i]) :
      \A y \in Server :
        IndAuto /\ BecomeLeader(i, Q) /\ y # i /\ ConfigDisabled(y) => ConfigDisabled(y)'
PROOF
<1>1. TAKE i \in Server
<1>2. TAKE Q \in Quorums(config[i])
<1>3. TAKE y \in Server
<1>4. ASSUME IndAuto /\ BecomeLeader(i, Q) /\ y # i /\ ConfigDisabled(y)
      PROVE ConfigDisabled(y)'
PROOF
<2>1. config' = config
  BY <1>4 DEF BecomeLeader
<2>2. configVersion' = configVersion
  BY <1>4 DEF BecomeLeader
<2>3. configTerm' = [configTerm EXCEPT ![i] = currentTerm[i] + 1]
  BY <1>4 DEF BecomeLeader
<2>4. TypeOK
  BY <1>4 DEF IndAuto
<2>5. configTerm \in [Server -> Nat]
  BY <2>4 DEF TypeOK
<2>6. configVersion \in [Server -> Nat]
  BY <2>4 DEF TypeOK
<2>7. \A R \in Quorums(config'[y]) :
        \E n \in R :
          NewerConfig(<<configVersion'[n], configTerm'[n]>>,
                      <<configVersion'[y], configTerm'[y]>>)
PROOF
<3>1. TAKE R \in Quorums(config'[y])
<3>2. config'[y] = config[y]
  BY <2>1
<3>3. R \in Quorums(config[y])
  BY <3>1, <3>2
<3>4. PICK n \in R : NewerConfig(CV(n), CV(y))
  BY <1>4, <3>3 DEF ConfigDisabled
<3>5. n \in Server
  BY <1>3, <2>4, <3>3, <3>4 DEF TypeOK, Quorums
<3>6. CASE n = i
PROOF
<4>1. configTerm'[n] = currentTerm[i] + 1
  BY <1>1, <2>3, <2>5, <3>6
<4>2. configVersion'[n] = configVersion[n]
  BY <2>2
<4>3. configTerm'[y] = configTerm[y]
  BY <1>3, <1>4, <2>3, <2>5
<4>4. configVersion'[y] = configVersion[y]
  BY <2>2
<4>5. configTerm[y] < currentTerm[i] + 1
  BY <1>1, <1>2, <1>3, <1>4, BecomeLeader_Fact_NewTerm_Exceeds_AllConfigTerms
<4>6. NewerConfig(<<configVersion'[n], configTerm'[n]>>, <<configVersion'[y], configTerm'[y]>>)
  BY <4>1, <4>2, <4>3, <4>4, <4>5, <3>6 DEF NewerConfig
<4>7. \E m \in R : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[y], configTerm'[y]>>)
  BY <3>4, <4>6
<4>8. QED
  BY <4>7
<3>7. CASE n # i
PROOF
<4>1. configTerm'[n] = configTerm[n]
  BY <2>3, <2>5, <3>5, <3>7
<4>2. configVersion'[n] = configVersion[n]
  BY <2>2
<4>3. configTerm'[y] = configTerm[y]
  BY <1>3, <1>4, <2>3, <2>5
<4>4. configVersion'[y] = configVersion[y]
  BY <2>2
<4>5. NewerConfig(<<configVersion'[n], configTerm'[n]>>, <<configVersion'[y], configTerm'[y]>>)
  BY <3>4, <4>1, <4>2, <4>3, <4>4 DEF CV
<4>6. \E m \in R : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[y], configTerm'[y]>>)
  BY <3>4, <4>5
<4>7. QED
  BY <4>6
<3>8. \E m \in R : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[y], configTerm'[y]>>)
  BY <3>6, <3>7
<3>9. QED
  BY <3>8
<2>8. ConfigDisabled(y)'
  BY <1>3, <2>7, ConfigDisabled_Primed_Intro
<2>9. QED
  BY <2>8
<1>5. QED
  BY <1>4

THEOREM BecomeLeader_Fact_LeaderOverlapOrOtherDisabledPreserved ==
  \A i \in Server :
    \A Q \in Quorums(config[i]) :
      \A y \in Server :
        IndAuto /\ BecomeLeader(i, Q) /\ y # i /\
        (QuorumsOverlap(config[i], config[y]) \/ ConfigDisabled(y)) =>
          QuorumsOverlap(config'[i], config'[y]) \/ ConfigDisabled(y)'
PROOF
<1>1. TAKE i \in Server
<1>2. TAKE Q \in Quorums(config[i])
<1>3. TAKE y \in Server
<1>4. ASSUME IndAuto /\ BecomeLeader(i, Q) /\ y # i /\
              (QuorumsOverlap(config[i], config[y]) \/ ConfigDisabled(y))
      PROVE QuorumsOverlap(config'[i], config'[y]) \/ ConfigDisabled(y)'
PROOF
<2>1. config' = config
  BY <1>4 DEF BecomeLeader
<2>2. CASE QuorumsOverlap(config[i], config[y])
PROOF
<3>1. config'[i] = config[i]
  BY <2>1
<3>2. config'[y] = config[y]
  BY <2>1
<3>3. QuorumsOverlap(config'[i], config'[y])
  BY <2>2, <3>1, <3>2
<3>4. QED
  BY <3>3
<2>3. CASE ConfigDisabled(y)
PROOF
<3>1. IndAuto /\ BecomeLeader(i, Q) /\ y # i /\ ConfigDisabled(y)
  BY <1>4, <2>3
<3>2. ConfigDisabled(y)'
  BY <1>1, <1>2, <1>3, <3>1, BecomeLeader_Fact_OtherDisabledPreserved
<3>3. QED
  BY <3>2
<2>4. QED
  BY <1>4, <2>2, <2>3
<1>5. QED
  BY <1>4

THEOREM BecomeLeader_Fact_OtherOverlapOrOtherDisabledPreserved ==
  \A i \in Server :
    \A Q \in Quorums(config[i]) :
      \A x \in Server :
        IndAuto /\ BecomeLeader(i, Q) /\ x # i /\
        (QuorumsOverlap(config[x], config[i]) \/ ConfigDisabled(x)) =>
          QuorumsOverlap(config'[x], config'[i]) \/ ConfigDisabled(x)'
PROOF
<1>1. TAKE i \in Server
<1>2. TAKE Q \in Quorums(config[i])
<1>3. TAKE x \in Server
<1>4. ASSUME IndAuto /\ BecomeLeader(i, Q) /\ x # i /\
              (QuorumsOverlap(config[x], config[i]) \/ ConfigDisabled(x))
      PROVE QuorumsOverlap(config'[x], config'[i]) \/ ConfigDisabled(x)'
PROOF
<2>1. config' = config
  BY <1>4 DEF BecomeLeader
<2>2. CASE QuorumsOverlap(config[x], config[i])
PROOF
<3>1. config'[x] = config[x]
  BY <2>1
<3>2. config'[i] = config[i]
  BY <2>1
<3>3. QuorumsOverlap(config'[x], config'[i])
  BY <2>2, <3>1, <3>2
<3>4. QED
  BY <3>3
<2>3. CASE ConfigDisabled(x)
PROOF
<3>1. IndAuto /\ BecomeLeader(i, Q) /\ x # i /\ ConfigDisabled(x)
  BY <1>4, <2>3
<3>2. ConfigDisabled(x)'
  BY <1>1, <1>2, <1>3, <3>1, BecomeLeader_Fact_OtherDisabledPreserved
<3>3. QED
  BY <3>2
<2>4. QED
  BY <1>4, <2>2, <2>3
<1>5. QED
  BY <1>4

THEOREM UpdateTermsAction_Fact_Params ==
  UpdateTermsAction => \E s \in Server, t \in Server : UpdateTerms(s, t)
PROOF
  BY DEF UpdateTermsAction

THEOREM UpdateTermsAction_Fact_Updates_TermState ==
  UpdateTermsAction =>
    \E s \in Server, t \in Server :
      /\ UpdateTerms(s, t)
      /\ currentTerm' = [currentTerm EXCEPT ![t] = currentTerm[s]]
      /\ state' = [state EXCEPT ![t] = Secondary]
PROOF
  BY DEF UpdateTermsAction, UpdateTerms, UpdateTermsExpr

THEOREM UpdateTerms_Fact_TargetTermState ==
  \A s \in Server :
    \A t \in Server :
      TypeOK /\ UpdateTerms(s, t) =>
        /\ currentTerm'[t] = currentTerm[s]
        /\ state'[t] = Secondary
PROOF
<1>1. TAKE s \in Server
<1>2. TAKE t \in Server
<1>3. ASSUME TypeOK /\ UpdateTerms(s, t)
      PROVE /\ currentTerm'[t] = currentTerm[s]
            /\ state'[t] = Secondary
PROOF
<2>1. currentTerm \in [Server -> Nat]
  BY <1>3 DEF TypeOK
<2>2. state \in [Server -> {Secondary, Primary}]
  BY <1>3 DEF TypeOK
<2>3. currentTerm' = [currentTerm EXCEPT ![t] = currentTerm[s]]
  BY <1>3 DEF UpdateTerms, UpdateTermsExpr
<2>4. state' = [state EXCEPT ![t] = Secondary]
  BY <1>3 DEF UpdateTerms, UpdateTermsExpr
<2>5. currentTerm'[t] = currentTerm[s]
  BY <1>2, <2>1, <2>3
<2>6. state'[t] = Secondary
  BY <1>2, <2>2, <2>4
<2>7. QED
  BY <2>5, <2>6
<1>4. QED
  BY <1>3

THEOREM UpdateTerms_Fact_OtherTermState ==
  \A s \in Server :
    \A t \in Server :
      \A u \in Server :
        TypeOK /\ UpdateTerms(s, t) /\ u # t =>
          /\ currentTerm'[u] = currentTerm[u]
          /\ state'[u] = state[u]
PROOF
<1>1. TAKE s \in Server
<1>2. TAKE t \in Server
<1>3. TAKE u \in Server
<1>4. ASSUME TypeOK /\ UpdateTerms(s, t) /\ u # t
      PROVE /\ currentTerm'[u] = currentTerm[u]
            /\ state'[u] = state[u]
PROOF
<2>1. currentTerm \in [Server -> Nat]
  BY <1>4 DEF TypeOK
<2>2. state \in [Server -> {Secondary, Primary}]
  BY <1>4 DEF TypeOK
<2>3. currentTerm' = [currentTerm EXCEPT ![t] = currentTerm[s]]
  BY <1>4 DEF UpdateTerms, UpdateTermsExpr
<2>4. state' = [state EXCEPT ![t] = Secondary]
  BY <1>4 DEF UpdateTerms, UpdateTermsExpr
<2>5. currentTerm'[u] = currentTerm[u]
  BY <1>3, <1>4, <2>1, <2>3
<2>6. state'[u] = state[u]
  BY <1>3, <1>4, <2>2, <2>4
<2>7. QED
  BY <2>5, <2>6
<1>5. QED
  BY <1>4

THEOREM UpdateTermsAction_Fact_Unchanged_ConfigVars ==
  UpdateTermsAction => UNCHANGED <<configVersion, configTerm, config>>
PROOF
  BY DEF UpdateTermsAction, UpdateTerms

THEOREM UpdateTermsAction_Fact_Frame_ConfigVersion ==
  UpdateTermsAction => configVersion' = configVersion
PROOF
  BY UpdateTermsAction_Fact_Unchanged_ConfigVars

THEOREM UpdateTermsAction_Fact_Frame_ConfigTerm ==
  UpdateTermsAction => configTerm' = configTerm
PROOF
  BY UpdateTermsAction_Fact_Unchanged_ConfigVars

THEOREM UpdateTermsAction_Fact_Frame_Config ==
  UpdateTermsAction => config' = config
PROOF
  BY UpdateTermsAction_Fact_Unchanged_ConfigVars

THEOREM UpdateTermsAction_Fact_Derived_CV ==
  UpdateTermsAction => \A s \in Server : <<configVersion'[s], configTerm'[s]>> = CV(s)
PROOF
  BY UpdateTermsAction_Fact_Frame_ConfigVersion, UpdateTermsAction_Fact_Frame_ConfigTerm DEF CV

THEOREM UpdateTermsAction_Fact_Derived_QuorumsAt ==
  UpdateTermsAction => \A s \in Server : Quorums(config'[s]) = QuorumsAt(s)
PROOF
  BY UpdateTermsAction_Fact_Frame_Config DEF QuorumsAt

THEOREM UpdateTermsAction_Fact_Frame_IsNewerConfig ==
  UpdateTermsAction => \A a \in Server : \A b \in Server : IsNewerConfig(a, b)' <=> IsNewerConfig(a, b)
PROOF
<1>1. ASSUME UpdateTermsAction
      PROVE \A a \in Server : \A b \in Server : IsNewerConfig(a, b)' <=> IsNewerConfig(a, b)
PROOF
<2>1. configVersion' = configVersion
  BY <1>1, UpdateTermsAction_Fact_Frame_ConfigVersion
<2>2. configTerm' = configTerm
  BY <1>1, UpdateTermsAction_Fact_Frame_ConfigTerm
<2>3. TAKE a \in Server
<2>4. TAKE b \in Server
<2>5. IsNewerConfig(a, b)' <=> IsNewerConfig(a, b)
  BY <2>1, <2>2 DEF IsNewerConfig
<2>6. QED
  BY <2>5
<1>2. QED
  BY <1>1

THEOREM UpdateTermsAction_Fact_CurrentTerm_Nondecreasing ==
  IndAuto /\ UpdateTermsAction => \A n \in Server : currentTerm'[n] >= currentTerm[n]
PROOF
<1>1. SUFFICES ASSUME IndAuto, UpdateTermsAction PROVE \A n \in Server : currentTerm'[n] >= currentTerm[n]
  BY SMT
<1>2. IndAuto
  BY <1>1
<1>3. UpdateTermsAction
  BY <1>1
<1>4. TypeOK
  BY <1>2 DEF IndAuto
<1>5. PICK s \in Server, t \in Server : UpdateTerms(s, t)
  BY <1>3 DEF UpdateTermsAction
<1>6. currentTerm' = [currentTerm EXCEPT ![t] = currentTerm[s]]
  BY <1>5 DEF UpdateTerms, UpdateTermsExpr
<1>7. currentTerm \in [Server -> Nat]
  BY <1>4 DEF TypeOK
<1>8. \A n \in Server : currentTerm'[n] >= currentTerm[n]
PROOF
<2>1. TAKE n \in Server
<2>2. CASE n = t
PROOF
<3>1. currentTerm'[n] = currentTerm[s]
  BY <1>5, <1>6, <1>7, <2>2
<3>2. currentTerm[n] = currentTerm[t]
  BY <2>2
<3>3. currentTerm[s] > currentTerm[t]
  BY <1>5 DEF UpdateTerms, UpdateTermsExpr
<3>4. currentTerm'[n] >= currentTerm[n]
  BY <3>1, <3>2, <3>3
<3>5. QED
  BY <3>4
<2>3. CASE n # t
PROOF
<3>1. currentTerm'[n] = currentTerm[n]
  BY <1>5, <1>6, <1>7, <2>1, <2>3
<3>2. currentTerm[n] \in Nat
  BY <1>7, <2>1
<3>3. currentTerm'[n] >= currentTerm[n]
  BY <3>1, <3>2
<3>4. QED
  BY <3>3
<2>4. QED
  BY <2>2, <2>3
<1>9. QED
  BY <1>1, <1>8

THEOREM TermStateFrame_Preserves_Safety ==
  IndAuto /\ currentTerm' = currentTerm /\ state' = state => Safety'
PROOF
  BY DEF IndAuto, Safety, OnePrimaryPerTerm

THEOREM Init_Fact_ConfigVersion_One ==
  Init => \A s \in Server : configVersion[s] = 1
PROOF
  BY DEF Init

THEOREM Init_Fact_Terms_Equal ==
  Init => \A s \in Server : configTerm[s] = currentTerm[s]
PROOF
  BY DEF Init

THEOREM Init_Fact_CurrentTerm_Uniform ==
  Init => \A s, t \in Server : currentTerm[s] = currentTerm[t]
PROOF
  BY DEF Init

THEOREM Init_Fact_Config_Uniform ==
  Init => \A s, t \in Server : config[s] = config[t]
PROOF
  BY DEF Init

THEOREM Init_Fact_ConfigVersion_Order ==
  Init => \A s, t \in Server : configVersion[t] <= configVersion[s]
PROOF
  BY DEF Init

THEOREM QuorumsOverlap_Fact_Self_IfFinite ==
  \A cfg \in SUBSET Server : IsFiniteSet(cfg) => QuorumsOverlap(cfg, cfg)
PROOF
<1>1. TAKE cfg \in SUBSET Server
<1>2. ASSUME IsFiniteSet(cfg)
      PROVE QuorumsOverlap(cfg, cfg)
PROOF
<2>1. \A qx \in Quorums(cfg), qy \in Quorums(cfg) : qx \cap qy # {}
PROOF
<3>1. TAKE qx \in Quorums(cfg), qy \in Quorums(cfg)
<3>2. qx \subseteq cfg
  BY <3>1 DEF Quorums
<3>3. qy \subseteq cfg
  BY <3>1 DEF Quorums
<3>4. Cardinality(qx) * 2 > Cardinality(cfg)
  BY <3>1 DEF Quorums
<3>5. Cardinality(qy) * 2 > Cardinality(cfg)
  BY <3>1 DEF Quorums
<3>6. IsFiniteSet(qx)
  BY <1>2, <3>2, FS_Subset
<3>7. IsFiniteSet(qy)
  BY <1>2, <3>3, FS_Subset
<3>8. Cardinality(cfg) \in Nat
  BY <1>2, FS_CardinalityType
<3>9. Cardinality(qx) \in Nat
  BY <3>6, FS_CardinalityType
<3>10. Cardinality(qy) \in Nat
  BY <3>7, FS_CardinalityType
<3>11. Cardinality(qx) + Cardinality(qy) > Cardinality(cfg)
  BY <3>4, <3>5, <3>8, <3>9, <3>10
<3>12. qx \cap qy # {}
  BY <1>2, <3>2, <3>3, <3>11, FS_MajoritiesIntersect
<3>13. QED
  BY <3>12
<2>2. QED
  BY <2>1 DEF QuorumsOverlap
<1>3. QED
  BY <1>2

THEOREM QuorumsOverlap_Fact_Self_IfNoQuorums ==
  \A cfg \in SUBSET Server : Quorums(cfg) = {} => QuorumsOverlap(cfg, cfg)
PROOF
<1>1. TAKE cfg \in SUBSET Server
<1>2. ASSUME Quorums(cfg) = {}
      PROVE QuorumsOverlap(cfg, cfg)
PROOF
<2>1. \A qx \in Quorums(cfg), qy \in Quorums(cfg) : qx \cap qy # {}
PROOF
<3>1. TAKE qx \in Quorums(cfg), qy \in Quorums(cfg)
<3>2. qx \cap qy # {}
  BY <1>2, <3>1
<3>3. QED
  BY <3>2
<2>2. QED
  BY <2>1 DEF QuorumsOverlap
<1>3. QED
  BY <1>2

THEOREM Quorums_Fact_MemberSubsetCarrier ==
  \A cfg \in SUBSET Server : \A q \in Quorums(cfg) : q \in SUBSET cfg
PROOF
  BY DEF Quorums

THEOREM Quorums_Fact_MemberIsStrictMajority ==
  \A cfg \in SUBSET Server : \A q \in Quorums(cfg) : Cardinality(q) * 2 > Cardinality(cfg)
PROOF
  BY DEF Quorums

THEOREM QuorumsOverlap_Fact_Self ==
  \A cfg \in SUBSET Server : QuorumsOverlap(cfg, cfg)
PROOF
<1>1. TAKE cfg \in SUBSET Server
<1>2. ASSUME Quorums(cfg) = {}
      PROVE QuorumsOverlap(cfg, cfg)
PROOF
<2>1. Quorums(cfg) = {} => QuorumsOverlap(cfg, cfg)
  BY <1>1, QuorumsOverlap_Fact_Self_IfNoQuorums
<2>2. QED
  BY <1>2, <2>1
<1>3. ASSUME Quorums(cfg) # {}
      PROVE QuorumsOverlap(cfg, cfg)
PROOF
<2>1. PICK q \in Quorums(cfg) : TRUE
  BY <1>3
<2>2. q \in SUBSET cfg
  BY <1>1, <2>1, Quorums_Fact_MemberSubsetCarrier
<2>3. Cardinality(q) * 2 > Cardinality(cfg)
  BY <1>1, <2>1, Quorums_Fact_MemberIsStrictMajority
<2>4. IsFiniteSet(cfg)
  BY <1>1, Server_Fact_AllSubsetsFinite
<2>5. IsFiniteSet(cfg) => QuorumsOverlap(cfg, cfg)
  BY <1>1, QuorumsOverlap_Fact_Self_IfFinite
<2>6. QED
  BY <2>4, <2>5
<1>4. QED
  BY <1>2, <1>3

THEOREM QuorumsOverlap_Fact_Symmetric ==
  \A cfg1 \in SUBSET Server, cfg2 \in SUBSET Server :
    QuorumsOverlap(cfg1, cfg2) => QuorumsOverlap(cfg2, cfg1)
PROOF
<1>1. TAKE cfg1 \in SUBSET Server, cfg2 \in SUBSET Server
<1>2. ASSUME QuorumsOverlap(cfg1, cfg2)
      PROVE QuorumsOverlap(cfg2, cfg1)
PROOF
<2>1. \A q1 \in Quorums(cfg2), q2 \in Quorums(cfg1) : q1 \cap q2 # {}
PROOF
<3>1. TAKE q1 \in Quorums(cfg2), q2 \in Quorums(cfg1)
<3>2. q2 \cap q1 # {}
  BY <1>2, <3>1 DEF QuorumsOverlap
<3>3. q1 \cap q2 # {}
  BY <3>2
<3>4. QED
  BY <3>3
<2>2. QED
  BY <2>1 DEF QuorumsOverlap
<1>3. QED
  BY <1>2

THEOREM Quorums_Fact_MemberNonempty ==
  \A cfg \in SUBSET Server : \A q \in Quorums(cfg) : q # {}
PROOF
<1>1. TAKE cfg \in SUBSET Server
<1>2. TAKE q \in Quorums(cfg)
<1>3. QuorumsOverlap(cfg, cfg)
  BY <1>1, QuorumsOverlap_Fact_Self
<1>4. q \cap q # {}
  BY <1>2, <1>3 DEF QuorumsOverlap
<1>5. q # {}
  BY <1>4
<1>6. QED
  BY <1>5

THEOREM Init_Fact_NonTermTypeOK_Clauses ==
  Init =>
    /\ state \in [Server -> {Secondary, Primary}]
    /\ config \in [Server -> SUBSET Server]
    /\ configVersion \in [Server -> Nat]
PROOF
<1>1. ASSUME Init
      PROVE /\ state \in [Server -> {Secondary, Primary}]
            /\ config \in [Server -> SUBSET Server]
            /\ configVersion \in [Server -> Nat]
PROOF
<2>1. PICK initConfig \in SUBSET Server :
          /\ initConfig # {}
          /\ config = [i \in Server |-> initConfig]
  BY <1>1 DEF Init
<2>2. state \in [Server -> {Secondary, Primary}]
  BY <1>1 DEF Init
<2>3. config \in [Server -> SUBSET Server]
  BY <2>1
<2>4. configVersion \in [Server -> Nat]
  BY <1>1 DEF Init
<2>5. QED
  BY <2>2, <2>3, <2>4
<1>2. QED
  BY <1>1

THEOREM Init_Fact_TermFunctionsAreNat_If_InitTermNat ==
  Init /\ InitTerm \in Nat =>
    /\ currentTerm \in [Server -> Nat]
    /\ configTerm \in [Server -> Nat]
PROOF
<1>1. ASSUME Init /\ InitTerm \in Nat
      PROVE /\ currentTerm \in [Server -> Nat]
            /\ configTerm \in [Server -> Nat]
PROOF
<2>1. Init
  BY <1>1
<2>2. InitTerm \in Nat
  BY <1>1
<2>3. currentTerm = [i \in Server |-> InitTerm]
  BY <2>1 DEF Init
<2>4. configTerm = [i \in Server |-> InitTerm]
  BY <2>1 DEF Init
<2>5. currentTerm \in [Server -> Nat]
  BY <2>2, <2>3
<2>6. configTerm \in [Server -> Nat]
  BY <2>2, <2>4
<2>7. QED
  BY <2>5, <2>6
<1>2. QED
  BY <1>1

THEOREM Init_Implies_TypeOK == Init => TypeOK
PROOF
<1>1. ASSUME Init
      PROVE TypeOK
PROOF
<2>1. /\ state \in [Server -> {Secondary, Primary}]
      /\ config \in [Server -> SUBSET Server]
      /\ configVersion \in [Server -> Nat]
  BY <1>1, Init_Fact_NonTermTypeOK_Clauses
<2>2. InitTerm \in Nat
  BY BenchmarkAssumption_InitTermNat
<2>3. /\ currentTerm \in [Server -> Nat]
      /\ configTerm \in [Server -> Nat]
  BY <1>1, <2>2, Init_Fact_TermFunctionsAreNat_If_InitTermNat
<2>4. QED
  BY <2>1, <2>3 DEF TypeOK
<1>2. QED
  BY <1>1

THEOREM Init_Implies_Safety == Init => Safety
PROOF
<1>1. ASSUME Init
      PROVE Safety
PROOF
<2>1. \A s \in Server, t \in Server :
        (/\ state[s] = Primary
         /\ state[t] = Primary
         /\ currentTerm[s] = currentTerm[t]) => s = t
PROOF
<3>1. TAKE s \in Server, t \in Server
<3>2. state[s] = Secondary
  BY <1>1 DEF Init
<3>3. state[s] # Primary
  BY <3>2, BenchmarkAssumption_PrimarySecondaryDistinct
<3>4. (/\ state[s] = Primary
        /\ state[t] = Primary
        /\ currentTerm[s] = currentTerm[t]) => s = t
  BY <3>3
<3>5. QED
  BY <3>4
<2>2. OnePrimaryPerTerm
  BY <2>1 DEF OnePrimaryPerTerm
<2>3. QED
  BY <2>2 DEF Safety
<1>2. QED
  BY <1>1

THEOREM Init_Implies_StrConj_0 == Init => StrConj_0
PROOF
<1>1. ASSUME Init
      PROVE StrConj_0
PROOF
<2>1. \A s \in Server : configVersion[s] >= 1
PROOF
<3>1. TAKE s \in Server
<3>2. configVersion[s] = 1
  BY <1>1, Init_Fact_ConfigVersion_One
<3>3. configVersion[s] >= 1
  BY <3>2
<3>4. QED
  BY <3>3
<2>2. StrConj_0
  BY <2>1 DEF StrConj_0
<2>3. QED
  BY <2>2
<1>2. QED
  BY <1>1

THEOREM Init_Implies_StrConj_5 == Init => StrConj_5
PROOF
<1>1. ASSUME Init
      PROVE StrConj_5
PROOF
<2>1. PICK initConfig \in SUBSET Server :
          /\ initConfig # {}
          /\ config = [i \in Server |-> initConfig]
  BY <1>1 DEF Init
<2>2. \A s \in Server : \E t \in config[s] : currentTerm[t] >= configTerm[s]
PROOF
<3>1. TAKE s \in Server
<3>2. PICK witness \in initConfig : TRUE
  BY <2>1
<3>3. witness \in Server
  BY <2>1, <3>2
<3>4. witness \in config[s]
  BY <2>1, <3>1, <3>2
<3>5. configTerm[s] = currentTerm[s]
  BY <1>1, Init_Fact_Terms_Equal
<3>6. currentTerm[witness] = currentTerm[s]
  BY <1>1, <3>1, <3>3, Init_Fact_CurrentTerm_Uniform
<3>7. currentTerm[s] \in Nat
  BY <1>1, <3>1, Init_Implies_TypeOK DEF TypeOK
<3>8. currentTerm[witness] >= configTerm[s]
  BY <3>5, <3>6, <3>7
<3>9. \E t \in config[s] : currentTerm[t] >= configTerm[s]
  BY <3>4, <3>8
<3>10. QED
  BY <3>9
<2>3. StrConj_5
  BY <2>2 DEF StrConj_5
<2>4. QED
  BY <2>3
<1>2. QED
  BY <1>1

THEOREM Init_Implies_StrConj_6 == Init => StrConj_6
PROOF
<1>1. ASSUME Init
      PROVE StrConj_6
PROOF
<2>1. \A s \in Server : state[s] = Primary => configTerm[s] = currentTerm[s]
PROOF
<3>1. TAKE s \in Server
<3>2. configTerm[s] = currentTerm[s]
  BY <1>1, Init_Fact_Terms_Equal
<3>3. state[s] = Primary => configTerm[s] = currentTerm[s]
  BY <3>2
<3>4. QED
  BY <3>3
<2>2. StrConj_6
  BY <2>1 DEF StrConj_6
<2>3. QED
  BY <2>2
<1>2. QED
  BY <1>1

THEOREM Init_Implies_StrConj_8 == Init => StrConj_8
PROOF
<1>1. ASSUME Init
      PROVE StrConj_8
PROOF
<2>1. PICK initConfig \in SUBSET Server :
          /\ initConfig # {}
          /\ config = [i \in Server |-> initConfig]
  BY <1>1 DEF Init
<2>2. \A s \in Server, t \in Server :
        QuorumsOverlap(config[s], config[t]) \/ ConfigDisabled(s) \/ ConfigDisabled(t)
PROOF
<3>1. TAKE s \in Server, t \in Server
<3>2. config[s] = initConfig
  BY <2>1, <3>1
<3>3. config[t] = initConfig
  BY <2>1, <3>1
<3>4. QuorumsOverlap(config[s], config[t])
  BY <2>1, <3>2, <3>3, QuorumsOverlap_Fact_Self
<3>5. QED
  BY <3>4
<2>3. StrConj_8
  BY <2>2 DEF StrConj_8
<2>4. QED
  BY <2>3
<1>2. QED
  BY <1>1

THEOREM Init_Implies_StrConj_10 == Init => StrConj_10
PROOF
<1>1. ASSUME Init
      PROVE StrConj_10
PROOF
<2>1. PICK initConfig \in SUBSET Server :
          /\ initConfig # {}
          /\ config = [i \in Server |-> initConfig]
  BY <1>1 DEF Init
<2>2. \A s \in Server, t \in Server :
        \A Q \in QuorumsAt(s) :
          \E n \in Q : currentTerm[n] >= currentTerm[t] \/ IsNewerConfig(n, s)
PROOF
<3>1. TAKE s \in Server, t \in Server
<3>2. TAKE Q \in QuorumsAt(s)
<3>3. Q \in Quorums(initConfig)
  BY <2>1, <3>1, <3>2 DEF QuorumsAt
<3>4. Q # {}
  BY <2>1, <3>3, Quorums_Fact_MemberNonempty
<3>5. PICK n \in Q : TRUE
  BY <3>4
<3>6. n \in Server
  BY <3>3, <3>5 DEF Quorums
<3>7. currentTerm[n] = currentTerm[t]
  BY <1>1, <3>1, <3>6, Init_Fact_CurrentTerm_Uniform
<3>8. currentTerm[t] \in Nat
  BY <1>1, <3>1, Init_Implies_TypeOK DEF TypeOK
<3>9. currentTerm[n] >= currentTerm[t]
  BY <3>7, <3>8
<3>10. currentTerm[n] >= currentTerm[t] \/ IsNewerConfig(n, s)
  BY <3>9
<3>11. \E n \in Q : currentTerm[n] >= currentTerm[t] \/ IsNewerConfig(n, s)
  BY <3>5, <3>10
<3>12. QED
  BY <3>11
<2>3. StrConj_10
  BY <2>2 DEF StrConj_10
<2>4. QED
  BY <2>3
<1>2. QED
  BY <1>1

THEOREM Init_Implies_StrConj_11 == Init => StrConj_11
PROOF
<1>1. ASSUME Init
      PROVE StrConj_11
PROOF
<2>1. PICK initConfig \in SUBSET Server :
          /\ initConfig # {}
          /\ config = [i \in Server |-> initConfig]
  BY <1>1 DEF Init
<2>2. \A s \in Server, t \in Server :
        (configTerm[s] = configTerm[t] /\ configVersion[s] = configVersion[t]) => config[s] = config[t]
PROOF
<3>1. TAKE s \in Server, t \in Server
<3>2. config[s] = config[t]
  BY <1>1, Init_Fact_Config_Uniform
<3>3. (configTerm[s] = configTerm[t] /\ configVersion[s] = configVersion[t]) => config[s] = config[t]
  BY <3>2
<3>4. QED
  BY <3>3
<2>3. StrConj_11
  BY <2>2 DEF StrConj_11
<2>4. QED
  BY <2>3
<1>2. QED
  BY <1>1

THEOREM Init_Implies_StrConj_13 == Init => StrConj_13
PROOF
<1>1. ASSUME Init
      PROVE StrConj_13
PROOF
<2>1. PICK initConfig \in SUBSET Server :
          /\ initConfig # {}
          /\ config = [i \in Server |-> initConfig]
  BY <1>1 DEF Init
<2>2. \A s \in Server :
        state[s] = Primary =>
          \A t \in Server : configTerm[t] # configTerm[s] \/ configVersion[t] <= configVersion[s]
PROOF
<3>1. TAKE s \in Server
<3>2. \A t \in Server : configVersion[t] <= configVersion[s]
  BY <1>1, Init_Fact_ConfigVersion_Order
<3>3. \A t \in Server : configTerm[t] # configTerm[s] \/ configVersion[t] <= configVersion[s]
PROOF
<4>1. TAKE t \in Server
<4>2. configVersion[t] <= configVersion[s]
  BY <3>2
<4>3. configTerm[t] # configTerm[s] \/ configVersion[t] <= configVersion[s]
  BY <4>2
<4>4. QED
  BY <4>3
<3>4. state[s] = Primary => \A t \in Server : configTerm[t] # configTerm[s] \/ configVersion[t] <= configVersion[s]
  BY <3>3
<3>5. QED
  BY <3>4
<2>3. StrConj_13
  BY <2>2 DEF StrConj_13
<2>4. QED
  BY <2>3
<1>2. QED
  BY <1>1

THEOREM ReconfigAction_Preserves_TypeOK == IndAuto /\ ReconfigAction => TypeOK'
PROOF
<1>1. ASSUME IndAuto /\ ReconfigAction
      PROVE TypeOK'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. ReconfigAction
  BY <1>1
<2>3. PICK s \in Server, newConfig \in SUBSET Server : Reconfig(s, newConfig)
  BY <2>2 DEF ReconfigAction
<2>4. configTerm' = [configTerm EXCEPT ![s] = currentTerm[s]]
  BY <2>3 DEF Reconfig
<2>5. configVersion' = [configVersion EXCEPT ![s] = configVersion[s] + 1]
  BY <2>3 DEF Reconfig
<2>6. config' = [config EXCEPT ![s] = newConfig]
  BY <2>3 DEF Reconfig
<2>7. TypeOK
  BY <2>1 DEF IndAuto
<2>8. currentTerm' = currentTerm
  BY <2>2, ReconfigAction_Fact_Frame_CurrentTerm
<2>9. state' = state
  BY <2>2, ReconfigAction_Fact_Frame_State
<2>10. TypeOK'
  BY <2>3, <2>4, <2>5, <2>6, <2>7, <2>8, <2>9 DEF TypeOK
<2>11. QED
  BY <2>10
<1>2. QED
  BY <1>1

THEOREM ReconfigAction_Preserves_Safety == IndAuto /\ ReconfigAction => Safety'
PROOF
<1>1. ASSUME IndAuto /\ ReconfigAction
      PROVE Safety'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. ReconfigAction
  BY <1>1
<2>3. currentTerm' = currentTerm
  BY <2>2, ReconfigAction_Fact_Frame_CurrentTerm
<2>4. state' = state
  BY <2>2, ReconfigAction_Fact_Frame_State
<2>5. Safety'
  BY <2>1, <2>3, <2>4, TermStateFrame_Preserves_Safety
<2>6. QED
  BY <2>5
<1>2. QED
  BY <1>1

THEOREM ReconfigAction_Preserves_StrConj_0 == IndAuto /\ ReconfigAction => StrConj_0'
PROOF
<1>1. ASSUME IndAuto /\ ReconfigAction
      PROVE StrConj_0'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. ReconfigAction
  BY <1>1
<2>3. PICK s \in Server, newConfig \in SUBSET Server : Reconfig(s, newConfig)
  BY <2>2 DEF ReconfigAction
<2>4. configVersion' = [configVersion EXCEPT ![s] = configVersion[s] + 1]
  BY <2>3 DEF Reconfig
<2>5. \A x \in Server : configVersion'[x] >= 1
PROOF
<3>1. TAKE x \in Server
<3>2. TypeOK
  BY <2>1 DEF IndAuto
<3>3. configVersion \in [Server -> Nat]
  BY <3>2 DEF TypeOK
<3>4. configVersion[s] \in Nat
  BY <3>3
<3>5. configVersion[s] >= 1
  BY <2>1 DEF IndAuto, StrConj_0
<3>6. CASE x = s
PROOF
<4>1. configVersion'[x] = configVersion[s] + 1
  BY <2>4, <3>3, <3>6
<4>2. configVersion[s] + 1 >= 1
  BY <3>4, <3>5
<4>3. configVersion'[x] >= 1
  BY <4>1, <4>2
<4>4. QED
  BY <4>3
<3>7. CASE x # s
PROOF
<4>1. configVersion'[x] = configVersion[x]
  BY <2>4, <3>3, <3>7
<4>2. configVersion[x] >= 1
  BY <2>1 DEF IndAuto, StrConj_0
<4>3. configVersion'[x] >= 1
  BY <4>1, <4>2
<4>4. QED
  BY <4>3
<3>8. configVersion'[x] >= 1
  BY <3>6, <3>7
<3>9. QED
  BY <3>8
<2>6. StrConj_0'
  BY <2>5, StrConj_0_Primed_Intro
<2>7. QED
  BY <2>6
<1>2. QED
  BY <1>1

THEOREM ReconfigAction_Preserves_StrConj_5 == IndAuto /\ ReconfigAction => StrConj_5'
PROOF
<1>1. ASSUME IndAuto /\ ReconfigAction
      PROVE StrConj_5'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. ReconfigAction
  BY <1>1
<2>3. PICK s \in Server, newConfig \in SUBSET Server : Reconfig(s, newConfig)
  BY <2>2 DEF ReconfigAction
<2>4. configTerm' = [configTerm EXCEPT ![s] = currentTerm[s]]
  BY <2>3 DEF Reconfig
<2>5. config' = [config EXCEPT ![s] = newConfig]
  BY <2>3 DEF Reconfig
<2>6. \A x \in Server : \E t \in config'[x] : currentTerm'[t] >= configTerm'[x]
PROOF
<3>1. TAKE x \in Server
<3>2. currentTerm' = currentTerm
  BY <2>2, ReconfigAction_Fact_Frame_CurrentTerm
<3>3. TypeOK
  BY <2>1 DEF IndAuto
<3>4. config \in [Server -> SUBSET Server]
  BY <3>3 DEF TypeOK
<3>5. configTerm \in [Server -> Nat]
  BY <3>3 DEF TypeOK
<3>6. currentTerm[s] \in Nat
  BY <2>3, <3>3 DEF TypeOK
<3>7. CASE x = s
PROOF
<4>1. s \in newConfig
  BY <2>3 DEF Reconfig
<4>2. s \in config'[x]
  BY <2>5, <3>4, <3>7, <4>1
<4>3. configTerm'[x] = currentTerm[s]
  BY <2>4, <3>5, <3>7
<4>4. currentTerm'[s] = currentTerm[s]
  BY <3>2
<4>5. currentTerm'[s] >= configTerm'[x]
  BY <3>6, <4>3, <4>4
<4>6. \E t \in config'[x] : currentTerm'[t] >= configTerm'[x]
  BY <4>2, <4>5
<4>7. QED
  BY <4>6
<3>8. CASE x # s
PROOF
<4>1. PICK witness \in config[x] : currentTerm[witness] >= configTerm[x]
  BY <2>1 DEF IndAuto, StrConj_5
<4>2. witness \in config'[x]
  BY <2>5, <3>4, <3>8, <4>1
<4>3. currentTerm'[witness] = currentTerm[witness]
  BY <3>2
<4>4. configTerm'[x] = configTerm[x]
  BY <2>4, <3>5, <3>8
<4>5. currentTerm'[witness] >= configTerm'[x]
  BY <4>1, <4>3, <4>4
<4>6. \E t \in config'[x] : currentTerm'[t] >= configTerm'[x]
  BY <4>2, <4>5
<4>7. QED
  BY <4>6
<3>9. \E t \in config'[x] : currentTerm'[t] >= configTerm'[x]
  BY <3>7, <3>8
<3>10. QED
  BY <3>9
<2>7. StrConj_5'
  BY <2>6, StrConj_5_Primed_Intro
<2>8. QED
  BY <2>7
<1>2. QED
  BY <1>1

THEOREM ReconfigAction_Preserves_StrConj_6 == IndAuto /\ ReconfigAction => StrConj_6'
PROOF
<1>1. ASSUME IndAuto /\ ReconfigAction
      PROVE StrConj_6'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. ReconfigAction
  BY <1>1
<2>3. PICK s \in Server, newConfig \in SUBSET Server : Reconfig(s, newConfig)
  BY <2>2 DEF ReconfigAction
<2>4. UNCHANGED <<currentTerm, state>>
  BY <2>3 DEF Reconfig
<2>5. configTerm' = [configTerm EXCEPT ![s] = currentTerm[s]]
  BY <2>3 DEF Reconfig
<2>6. \A x \in Server : state'[x] = Primary => configTerm'[x] = currentTerm'[x]
PROOF
<3>1. TAKE x \in Server
<3>2. currentTerm' = currentTerm
  BY <2>2, ReconfigAction_Fact_Frame_CurrentTerm
<3>3. state' = state
  BY <2>2, ReconfigAction_Fact_Frame_State
<3>4. TypeOK
  BY <2>1 DEF IndAuto
<3>5. configTerm \in [Server -> Nat]
  BY <3>4 DEF TypeOK
<3>6. CASE x = s
PROOF
<4>1. configTerm'[x] = currentTerm[s]
  BY <2>5, <3>5, <3>6
<4>2. currentTerm'[x] = currentTerm[s]
  BY <3>2, <3>6
<4>3. state'[x] = Primary => configTerm'[x] = currentTerm'[x]
  BY <4>1, <4>2
<4>4. QED
  BY <4>3
<3>7. CASE x # s
PROOF
<4>1. configTerm'[x] = configTerm[x]
  BY <2>5, <3>5, <3>7
<4>2. currentTerm'[x] = currentTerm[x]
  BY <3>2
<4>3. state'[x] = state[x]
  BY <3>3
<4>4. state[x] = Primary => configTerm[x] = currentTerm[x]
  BY <2>1 DEF IndAuto, StrConj_6
<4>5. state'[x] = Primary => configTerm'[x] = currentTerm'[x]
  BY <4>1, <4>2, <4>3, <4>4
<4>6. QED
  BY <4>5
<3>8. state'[x] = Primary => configTerm'[x] = currentTerm'[x]
  BY <3>6, <3>7
<3>9. QED
  BY <3>8
<2>7. StrConj_6'
  BY <2>6, StrConj_6_Primed_Intro
<2>8. QED
  BY <2>7
<1>2. QED
  BY <1>1

THEOREM Reconfig_Fact_CurrentTerm_Maximal ==
  \A s \in Server, newConfig \in SUBSET Server, y \in Server :
    IndAuto /\ Reconfig(s, newConfig) => currentTerm[s] >= currentTerm[y]
PROOF
<1>1. TAKE s \in Server, newConfig \in SUBSET Server, y \in Server
<1>2. ASSUME IndAuto /\ Reconfig(s, newConfig)
      PROVE currentTerm[s] >= currentTerm[y]
PROOF
<2>1. ConfigIsCommitted(s)
  BY <1>2 DEF Reconfig
<2>2. PICK Q \in QuorumsAt(s) :
        \A t \in Q :
          /\ configVersion[s] = configVersion[t]
          /\ configTerm[s] = configTerm[t]
          /\ currentTerm[t] = currentTerm[s]
  BY <2>1 DEF ConfigIsCommitted
<2>3. PICK n \in Q :
        currentTerm[n] >= currentTerm[y]
        \/ configTerm[n] > configTerm[s]
        \/ /\ configTerm[n] = configTerm[s]
           /\ configVersion[n] > configVersion[s]
  BY <1>2, <2>2 DEF IndAuto, StrConj_10, QuorumsAt, IsNewerConfig
<2>4. configTerm[n] = configTerm[s]
  BY <2>2, <2>3
<2>5. configVersion[n] = configVersion[s]
  BY <2>2, <2>3
<2>6. currentTerm[n] = currentTerm[s]
  BY <2>2, <2>3
<2>7. CASE currentTerm[n] >= currentTerm[y]
PROOF
<3>1. currentTerm[s] >= currentTerm[y]
  BY <2>6, <2>7
<3>2. QED
  BY <3>1
<2>8. CASE configTerm[n] > configTerm[s]
PROOF
<3>1. FALSE
  BY <2>4, <2>8
<3>2. currentTerm[s] >= currentTerm[y]
  BY <3>1
<3>3. QED
  BY <3>2
<2>9. CASE /\ configTerm[n] = configTerm[s]
           /\ configVersion[n] > configVersion[s]
PROOF
<3>1. FALSE
  BY <2>5, <2>9
<3>2. currentTerm[s] >= currentTerm[y]
  BY <3>1
<3>3. QED
  BY <3>2
<2>10. currentTerm[s] >= currentTerm[y]
  BY <2>3, <2>7, <2>8, <2>9
<2>11. QED
  BY <2>10
<1>3. QED
  BY <1>2

THEOREM Reconfig_Fact_SourceNewerThanOther_If_NoNewOverlap ==
  \A s \in Server :
    \A newConfig \in SUBSET Server :
      \A u \in Server :
        IndAuto /\ Reconfig(s, newConfig) /\ u # s /\ ~ QuorumsOverlap(newConfig, config[u]) =>
          IsNewerConfig(s, u)
PROOF
<1>1. TAKE s \in Server
<1>2. TAKE newConfig \in SUBSET Server
<1>3. TAKE u \in Server
<1>4. ASSUME IndAuto /\ Reconfig(s, newConfig) /\ u # s /\ ~ QuorumsOverlap(newConfig, config[u])
      PROVE IsNewerConfig(s, u)
PROOF
<2>1. TypeOK
  BY <1>4 DEF IndAuto
<2>2. currentTerm \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>3. configTerm \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>4. configVersion \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>5. config \in [Server -> SUBSET Server]
  BY <2>1 DEF TypeOK
<2>6. state[s] = Primary
  BY <1>4 DEF Reconfig
<2>7. configTerm[s] = currentTerm[s]
  BY <1>4, <2>6 DEF IndAuto, StrConj_6
<2>8. currentTerm[s] >= currentTerm[u]
  BY <1>4, <1>3, Reconfig_Fact_CurrentTerm_Maximal
<2>9. PICK t \in config[u] : currentTerm[t] >= configTerm[u]
  BY <1>4 DEF IndAuto, StrConj_5
<2>10. t \in Server
  BY <1>3, <2>5, <2>9
<2>11. currentTerm[s] >= currentTerm[t]
  BY <1>4, <2>10, Reconfig_Fact_CurrentTerm_Maximal
<2>12. /\ currentTerm[s] \in Nat
       /\ currentTerm[t] \in Nat
       /\ configTerm[u] \in Nat
  BY <1>1, <1>3, <2>1, <2>3, <2>10 DEF TypeOK
<2>13. currentTerm[s] >= configTerm[u]
  BY <2>11, <2>12, <2>9, Nat_Geq_Transitive
<2>14. configTerm[s] >= configTerm[u]
  BY <2>7, <2>13
<2>15. CASE configTerm[s] > configTerm[u]
PROOF
<3>1. IsNewerConfig(s, u)
  BY <2>15 DEF IsNewerConfig
<3>2. QED
  BY <3>1
<2>16. CASE configTerm[s] = configTerm[u]
PROOF
<3>1. configVersion[u] <= configVersion[s]
  BY <1>4, <2>6, <2>16 DEF IndAuto, StrConj_13
<3>2. ASSUME configVersion[s] = configVersion[u]
      PROVE FALSE
PROOF
<4>1. StrConj_11
  BY <1>4 DEF IndAuto
<4>2. config[s] = config[u]
  BY <1>1, <1>3, <2>16, <3>2, <4>1 DEF StrConj_11
<4>3. QuorumsOverlap(config[s], newConfig)
  BY <1>4 DEF Reconfig
<4>4. QuorumsOverlap(newConfig, config[s])
  BY <1>1, <1>2, <2>5, <4>3, QuorumsOverlap_Fact_Symmetric
<4>5. QuorumsOverlap(newConfig, config[u])
  BY <4>2, <4>4
<4>6. FALSE
  BY <1>4, <4>5
<4>7. QED
  BY <4>6
<3>3. configVersion[s] > configVersion[u]
  BY <3>1, <3>2
<3>4. IsNewerConfig(s, u)
  BY <2>16, <3>3 DEF IsNewerConfig
<3>5. QED
  BY <3>4
<2>17. IsNewerConfig(s, u)
  BY <2>14, <2>15, <2>16
<2>18. QED
  BY <2>17
<1>5. QED
  BY <1>4

THEOREM Reconfig_Fact_OtherDisabledPreserved ==
  \A s \in Server :
    \A newConfig \in SUBSET Server :
      \A u \in Server :
        IndAuto /\ Reconfig(s, newConfig) /\ u # s /\ ConfigDisabled(u) => ConfigDisabled(u)'
PROOF
<1>1. TAKE s \in Server
<1>2. TAKE newConfig \in SUBSET Server
<1>3. TAKE u \in Server
<1>4. ASSUME IndAuto /\ Reconfig(s, newConfig) /\ u # s /\ ConfigDisabled(u)
      PROVE ConfigDisabled(u)'
PROOF
<2>1. TypeOK
  BY <1>4 DEF IndAuto
<2>2. config \in [Server -> SUBSET Server]
  BY <2>1 DEF TypeOK
<2>3. configTerm \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>4. configVersion \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>5. state[s] = Primary
  BY <1>4 DEF Reconfig
<2>6. configTerm[s] = currentTerm[s]
  BY <1>4, <2>5 DEF IndAuto, StrConj_6
<2>7. config' = [config EXCEPT ![s] = newConfig]
  BY <1>4 DEF Reconfig
<2>8. configTerm' = [configTerm EXCEPT ![s] = currentTerm[s]]
  BY <1>4 DEF Reconfig
<2>9. configVersion' = [configVersion EXCEPT ![s] = configVersion[s] + 1]
  BY <1>4 DEF Reconfig
<2>10. config'[u] = config[u]
  BY <1>3, <2>2, <2>7, <1>4
<2>11. configTerm'[u] = configTerm[u]
  BY <1>3, <2>3, <2>8, <1>4
<2>12. configVersion'[u] = configVersion[u]
  BY <1>3, <2>4, <2>9, <1>4
<2>13. \A Q \in Quorums(config'[u]) :
          \E m \in Q :
            NewerConfig(<<configVersion'[m], configTerm'[m]>>,
                        <<configVersion'[u], configTerm'[u]>>)
PROOF
<3>1. TAKE Q \in Quorums(config'[u])
<3>2. Q \in Quorums(config[u])
  BY <2>10, <3>1
<3>3. PICK n \in Q : NewerConfig(CV(n), CV(u))
  BY <1>4, <3>2 DEF ConfigDisabled
<3>4. CASE n = s
PROOF
<4>1. IsNewerConfig(s, u)
  BY <3>3, <3>4 DEF CV, IsNewerConfig, NewerConfig
<4>2. configTerm'[s] = configTerm[s]
  BY <1>1, <2>3, <2>6, <2>8
<4>3. configVersion'[s] = configVersion[s] + 1
  BY <1>1, <2>4, <2>9
<4>4. CASE configTerm[s] > configTerm[u]
PROOF
<5>1. NewerConfig(<<configVersion'[s], configTerm'[s]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <2>11, <2>12, <4>2, <4>4 DEF NewerConfig
<5>2. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <3>3, <3>4, <5>1
<5>3. QED
  BY <5>2
<4>5. CASE /\ configTerm[s] = configTerm[u]
           /\ configVersion[s] > configVersion[u]
PROOF
<5>1. configTerm'[s] = configTerm'[u]
  BY <2>11, <4>2, <4>5
<5>2. configVersion'[s] > configVersion'[u]
  BY <1>1, <1>3, <2>4, <2>12, <4>3, <4>5
<5>3. NewerConfig(<<configVersion'[s], configTerm'[s]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <5>1, <5>2 DEF NewerConfig
<5>4. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <3>3, <3>4, <5>3
<5>5. QED
  BY <5>4
<4>6. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <4>1, <4>4, <4>5 DEF IsNewerConfig
<4>8. QED
  BY <4>6
<3>5. CASE n # s
PROOF
<4>1. configTerm'[n] = configTerm[n]
  BY <1>3, <2>2, <2>3, <2>8, <3>2, <3>3, <3>5 DEF Quorums
<4>2. configVersion'[n] = configVersion[n]
  BY <1>3, <2>2, <2>4, <2>9, <3>2, <3>3, <3>5 DEF Quorums
<4>3. NewerConfig(<<configVersion'[n], configTerm'[n]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <2>11, <2>12, <3>3, <4>1, <4>2 DEF CV
<4>4. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <3>3, <4>3
<4>5. QED
  BY <4>4
<3>6. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <3>4, <3>5
<3>7. QED
  BY <3>6
<2>14. ConfigDisabled(u)'
  BY <1>3, <2>13, ConfigDisabled_Primed_Intro
<2>15. QED
  BY <2>14
<1>5. QED
  BY <1>4

THEOREM Reconfig_Fact_SourceNotDisabled ==
  \A s \in Server :
    \A newConfig \in SUBSET Server :
      IndAuto /\ Reconfig(s, newConfig) => ~ ConfigDisabled(s)
PROOF
<1>1. TAKE s \in Server
<1>2. TAKE newConfig \in SUBSET Server
<1>3. ASSUME IndAuto /\ Reconfig(s, newConfig)
      PROVE ~ ConfigDisabled(s)
PROOF
<2>1. ConfigIsCommitted(s)
  BY <1>3 DEF Reconfig
<2>2. PICK Q \in QuorumsAt(s) :
        \A t \in Q :
          /\ configVersion[s] = configVersion[t]
          /\ configTerm[s] = configTerm[t]
          /\ currentTerm[t] = currentTerm[s]
  BY <2>1 DEF ConfigIsCommitted
<2>3. ASSUME ConfigDisabled(s)
      PROVE FALSE
PROOF
<3>1. Q \in Quorums(config[s])
  BY <2>2 DEF QuorumsAt
<3>2. PICK n \in Q : NewerConfig(CV(n), CV(s))
  BY <2>3, <3>1 DEF ConfigDisabled
<3>3. configVersion[n] = configVersion[s]
  BY <2>2, <3>2
<3>4. configTerm[n] = configTerm[s]
  BY <2>2, <3>2
<3>5. FALSE
  BY <3>2, <3>3, <3>4 DEF CV, NewerConfig
<3>6. QED
  BY <3>5
<2>4. QED
  BY <2>3
<1>4. QED
  BY <1>3

THEOREM Reconfig_Fact_SourceOverlap_Implies_NewOverlap_Or_OtherDisabled ==
  \A s \in Server :
    \A newConfig \in SUBSET Server :
      \A u \in Server :
        IndAuto /\ Reconfig(s, newConfig) /\ u # s /\ QuorumsOverlap(config[s], config[u]) =>
          QuorumsOverlap(newConfig, config[u]) \/ ConfigDisabled(u)'
PROOF
<1>1. TAKE s \in Server
<1>2. TAKE newConfig \in SUBSET Server
<1>3. TAKE u \in Server
<1>4. ASSUME IndAuto /\ Reconfig(s, newConfig) /\ u # s /\ QuorumsOverlap(config[s], config[u])
      PROVE QuorumsOverlap(newConfig, config[u]) \/ ConfigDisabled(u)'
PROOF
<2>1. TypeOK
  BY <1>4 DEF IndAuto
<2>2. config \in [Server -> SUBSET Server]
  BY <2>1 DEF TypeOK
<2>3. configTerm \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>4. configVersion \in [Server -> Nat]
  BY <2>1 DEF TypeOK
<2>5. config' = [config EXCEPT ![s] = newConfig]
  BY <1>4 DEF Reconfig
<2>6. ConfigIsCommitted(s)
  BY <1>4 DEF Reconfig
<2>7. PICK committedQ \in QuorumsAt(s) :
        \A t \in committedQ :
          /\ configVersion[s] = configVersion[t]
          /\ configTerm[s] = configTerm[t]
          /\ currentTerm[t] = currentTerm[s]
  BY <2>6 DEF ConfigIsCommitted
<2>8. committedQ \in Quorums(config[s])
  BY <2>7 DEF QuorumsAt
<2>9. CASE QuorumsOverlap(newConfig, config[u])
PROOF
<3>1. QuorumsOverlap(newConfig, config[u]) \/ ConfigDisabled(u)'
  BY <2>9
<3>2. QED
  BY <3>1
<2>10. CASE ~ QuorumsOverlap(newConfig, config[u])
PROOF
<3>1. \A Q \in Quorums(config'[u]) :
          \E m \in Q :
            NewerConfig(<<configVersion'[m], configTerm'[m]>>,
                        <<configVersion'[u], configTerm'[u]>>)
PROOF
<4>1. config'[u] = config[u]
  BY <1>3, <1>4, <2>2, <2>5
<4>2. configTerm' = [configTerm EXCEPT ![s] = currentTerm[s]]
  BY <1>4 DEF Reconfig
<4>3. configVersion' = [configVersion EXCEPT ![s] = configVersion[s] + 1]
  BY <1>4 DEF Reconfig
<4>4. TAKE Q \in Quorums(config'[u])
<4>5. Q \in Quorums(config[u])
  BY <4>1, <4>4
<4>6. Q \cap committedQ # {}
  BY <1>4, <2>8, <4>5 DEF QuorumsOverlap
<4>7. PICK n \in Q \cap committedQ : TRUE
  BY <4>6
<4>8. n \in Q
  BY <4>7
<4>9. n \in committedQ
  BY <4>7
<4>10. configVersion[n] = configVersion[s]
  BY <2>7, <4>9
<4>11. configTerm[n] = configTerm[s]
  BY <2>7, <4>9
<4>12. currentTerm[n] = currentTerm[s]
  BY <2>7, <4>9
<4>13. configTerm'[u] = configTerm[u]
  BY <1>3, <1>4, <2>3, <4>2
<4>14. configVersion'[u] = configVersion[u]
  BY <1>3, <1>4, <2>4, <4>3
<4>15. IsNewerConfig(s, u)
  BY <1>4, <2>10, Reconfig_Fact_SourceNewerThanOther_If_NoNewOverlap
<4>16. CASE n = s
PROOF
<5>1. state[s] = Primary
  BY <1>4 DEF Reconfig
<5>2. configTerm[s] = currentTerm[s]
  BY <1>4, <5>1 DEF IndAuto, StrConj_6
<5>3. configTerm'[n] = configTerm[s]
  BY <1>1, <2>3, <4>2, <4>16, <5>2
<5>4. configVersion'[n] = configVersion[s] + 1
  BY <1>1, <2>4, <4>3, <4>16
<5>5. CASE configTerm[s] > configTerm[u]
PROOF
<6>1. NewerConfig(<<configVersion'[n], configTerm'[n]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <4>13, <5>3, <5>5 DEF NewerConfig
<6>2. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <4>8, <6>1
<6>3. QED
  BY <6>2
<5>6. CASE /\ configTerm[s] = configTerm[u]
           /\ configVersion[s] > configVersion[u]
PROOF
<6>1. configTerm'[n] = configTerm'[u]
  BY <4>13, <5>3, <5>6
<6>2. configVersion'[n] > configVersion'[u]
  BY <1>1, <1>3, <2>4, <4>14, <5>4, <5>6
<6>3. NewerConfig(<<configVersion'[n], configTerm'[n]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <6>1, <6>2 DEF NewerConfig
<6>4. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <4>8, <6>3
<6>5. QED
  BY <6>4
<5>7. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <4>15, <5>5, <5>6 DEF IsNewerConfig
<5>8. QED
  BY <5>7
<4>17. CASE n # s
PROOF
<5>1. IsNewerConfig(n, u)
  BY <4>10, <4>11, <4>15 DEF IsNewerConfig
<5>2. configTerm'[n] = configTerm[n]
  BY <2>2, <2>3, <2>8, <4>2, <4>9, <4>17 DEF Quorums
<5>3. configVersion'[n] = configVersion[n]
  BY <2>2, <2>4, <2>8, <4>3, <4>9, <4>17 DEF Quorums
<5>4. NewerConfig(<<configVersion'[n], configTerm'[n]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <4>13, <4>14, <5>1, <5>2, <5>3 DEF IsNewerConfig, NewerConfig
<5>5. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <4>8, <5>4
<5>6. QED
  BY <5>5
<4>18. \E m \in Q : NewerConfig(<<configVersion'[m], configTerm'[m]>>, <<configVersion'[u], configTerm'[u]>>)
  BY <4>16, <4>17
<4>20. QED
  BY <4>18
<3>2. ConfigDisabled(u)'
  BY <1>3, <3>1, ConfigDisabled_Primed_Intro
<3>3. QuorumsOverlap(newConfig, config[u]) \/ ConfigDisabled(u)'
  BY <2>10, <3>2
<3>4. QED
  BY <3>3
<2>11. QuorumsOverlap(newConfig, config[u]) \/ ConfigDisabled(u)'
  BY <2>9, <2>10
<2>12. QED
  BY <2>11
<1>5. QED
  BY <1>4

THEOREM Reconfig_Fact_SourceOverlap_Implies_PrimedTargetOverlap_Or_OtherDisabled ==
  \A s \in Server :
    \A newConfig \in SUBSET Server :
      \A u \in Server :
        IndAuto /\ Reconfig(s, newConfig) /\ u # s /\ QuorumsOverlap(config[s], config[u]) =>
          QuorumsOverlap(config'[s], config'[u]) \/ ConfigDisabled(u)'
PROOF
<1>1. TAKE s \in Server
<1>2. TAKE newConfig \in SUBSET Server
<1>3. TAKE u \in Server
<1>4. ASSUME IndAuto /\ Reconfig(s, newConfig) /\ u # s /\ QuorumsOverlap(config[s], config[u])
      PROVE QuorumsOverlap(config'[s], config'[u]) \/ ConfigDisabled(u)'
PROOF
<2>1. TypeOK
  BY <1>4 DEF IndAuto
<2>2. config'[s] = newConfig
  BY <2>1, <1>4, Reconfig_Fact_TargetConfigVars
<2>3. config'[u] = config[u]
  BY <2>1, <1>4, <1>3, Reconfig_Fact_OtherConfigVars
<2>4. QuorumsOverlap(newConfig, config[u]) \/ ConfigDisabled(u)'
  BY <1>4, Reconfig_Fact_SourceOverlap_Implies_NewOverlap_Or_OtherDisabled
<2>5. CASE QuorumsOverlap(newConfig, config[u])
PROOF
<3>1. QuorumsOverlap(config'[s], config'[u])
  BY <2>2, <2>3, <2>5
<3>2. QuorumsOverlap(config'[s], config'[u]) \/ ConfigDisabled(u)'
  BY <3>1
<3>3. QED
  BY <3>2
<2>6. CASE ConfigDisabled(u)'
PROOF
<3>1. QuorumsOverlap(config'[s], config'[u]) \/ ConfigDisabled(u)'
  BY <2>6
<3>2. QED
  BY <3>1
<2>7. QED
  BY <2>4, <2>5, <2>6
<1>5. QED
  BY <1>4

THEOREM ReconfigAction_Preserves_StrConj_8 == IndAuto /\ ReconfigAction => StrConj_8'
PROOF
<1>1. ASSUME IndAuto /\ ReconfigAction
      PROVE StrConj_8'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. ReconfigAction
  BY <1>1
<2>3. PICK s \in Server, newConfig \in SUBSET Server : Reconfig(s, newConfig)
  BY <2>2 DEF ReconfigAction
<2>4. TypeOK
  BY <2>1 DEF IndAuto
<2>5. config \in [Server -> SUBSET Server]
  BY <2>4 DEF TypeOK
<2>6. \A x \in Server :
        \A y \in Server :
          QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)' \/ ConfigDisabled(y)'
PROOF
<3>1. TAKE x \in Server
<3>2. TAKE y \in Server
<3>3. CASE x = s /\ y = s
PROOF
<4>1. config'[s] = newConfig
  BY <2>4, <2>3, Reconfig_Fact_TargetConfigVars
<4>2. config'[x] = newConfig
  BY <3>3, <4>1
<4>3. config'[y] = newConfig
  BY <3>3, <4>1
<4>4. QuorumsOverlap(config'[x], config'[y])
  BY <2>3, <3>3, <4>2, <4>3, QuorumsOverlap_Fact_Self
<4>5. QED
  BY <4>4
<3>4. CASE x = s /\ y # s
PROOF
<4>1. QuorumsOverlap(config[s], config[y]) \/ ConfigDisabled(s) \/ ConfigDisabled(y)
  BY <2>1 DEF IndAuto, StrConj_8
<4>2. CASE ConfigDisabled(y)
PROOF
<5>1. ConfigDisabled(y)'
  BY <2>1, <2>3, <3>1, <3>2, <3>4, <4>2, Reconfig_Fact_OtherDisabledPreserved
<5>2. QED
  BY <5>1
<4>3. CASE QuorumsOverlap(config[s], config[y]) \/ ConfigDisabled(s)
PROOF
<5>1. CASE QuorumsOverlap(config[s], config[y])
PROOF
<6>1. QuorumsOverlap(config'[s], config'[y]) \/ ConfigDisabled(y)'
  BY <2>1, <2>3, <3>1, <3>2, <3>4, <5>1, Reconfig_Fact_SourceOverlap_Implies_PrimedTargetOverlap_Or_OtherDisabled
<6>2. config'[x] = config'[s]
  BY <3>4
<6>3. QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(y)'
  BY <6>1, <6>2
<6>4. QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)' \/ ConfigDisabled(y)'
  BY <6>3
<6>5. QED
  BY <6>4
<5>2. CASE ConfigDisabled(s)
PROOF
<6>1. FALSE
  BY <2>1, <2>3, <5>2, Reconfig_Fact_SourceNotDisabled
<6>2. QED
  BY <6>1
<5>3. QED
  BY <4>3, <5>1, <5>2
<4>4. QED
  BY <4>1, <4>2, <4>3
<3>5. CASE x # s /\ y = s
PROOF
<4>1. QuorumsOverlap(config[x], config[s]) \/ ConfigDisabled(x) \/ ConfigDisabled(s)
  BY <2>1 DEF IndAuto, StrConj_8
<4>2. CASE ConfigDisabled(x)
PROOF
<5>1. ConfigDisabled(x)'
  BY <2>1, <2>3, <3>1, <3>2, <3>5, <4>2, Reconfig_Fact_OtherDisabledPreserved
<5>2. QED
  BY <5>1
<4>3. CASE QuorumsOverlap(config[x], config[s]) \/ ConfigDisabled(s)
PROOF
<5>1. CASE QuorumsOverlap(config[x], config[s])
PROOF
<6>1. QuorumsOverlap(config[s], config[x])
  BY <2>5, <3>1, <3>2, <5>1, QuorumsOverlap_Fact_Symmetric
<6>2. QuorumsOverlap(config'[s], config'[x]) \/ ConfigDisabled(x)'
  BY <2>1, <2>3, <3>1, <3>2, <3>5, <6>1, Reconfig_Fact_SourceOverlap_Implies_PrimedTargetOverlap_Or_OtherDisabled
<6>3. CASE QuorumsOverlap(config'[s], config'[x])
PROOF
<7>1. config'[s] = newConfig
  BY <2>4, <2>3, Reconfig_Fact_TargetConfigVars
<7>2. config'[s] \in SUBSET Server
  BY <2>3, <7>1
<7>3. config'[x] = config[x]
  BY <2>4, <2>3, <3>1, <3>2, <3>5, Reconfig_Fact_OtherConfigVars
<7>4. config'[x] \in SUBSET Server
  BY <2>5, <3>1, <7>3
<7>5. QuorumsOverlap(config'[x], config'[s])
  BY <7>2, <7>4, <6>3, QuorumsOverlap_Fact_Symmetric
<7>6. config'[y] = config'[s]
  BY <3>5
<7>7. QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)' \/ ConfigDisabled(y)'
  BY <7>5, <7>6
<7>8. QED
  BY <7>7
<6>4. CASE ConfigDisabled(x)'
PROOF
<7>1. QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)' \/ ConfigDisabled(y)'
  BY <6>4
<7>2. QED
  BY <7>1
<6>5. QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)' \/ ConfigDisabled(y)'
  BY <6>2, <6>3, <6>4
<6>6. QED
  BY <6>5
<5>2. CASE ConfigDisabled(s)
PROOF
<6>1. FALSE
  BY <2>1, <2>3, <5>2, Reconfig_Fact_SourceNotDisabled
<6>2. QED
  BY <6>1
<5>3. QED
  BY <4>3, <5>1, <5>2
<4>4. QED
  BY <4>1, <4>2, <4>3
<3>6. CASE x # s /\ y # s
PROOF
<4>1. QuorumsOverlap(config[x], config[y]) \/ ConfigDisabled(x) \/ ConfigDisabled(y)
  BY <2>1 DEF IndAuto, StrConj_8
<4>2. CASE QuorumsOverlap(config[x], config[y])
PROOF
<5>1. config'[x] = config[x]
  BY <2>4, <2>3, <3>1, <3>2, <3>6, Reconfig_Fact_OtherConfigVars
<5>2. config'[y] = config[y]
  BY <2>4, <2>3, <3>1, <3>2, <3>6, Reconfig_Fact_OtherConfigVars
<5>3. QuorumsOverlap(config'[x], config'[y])
  BY <4>2, <5>1, <5>2
<5>4. QED
  BY <5>3
<4>3. CASE ConfigDisabled(x)
PROOF
<5>1. ConfigDisabled(x)'
  BY <2>1, <2>3, <3>1, <3>2, <3>6, <4>3, Reconfig_Fact_OtherDisabledPreserved
<5>2. QED
  BY <5>1
<4>4. CASE ConfigDisabled(y)
PROOF
<5>1. ConfigDisabled(y)'
  BY <2>1, <2>3, <3>1, <3>2, <3>6, <4>4, Reconfig_Fact_OtherDisabledPreserved
<5>2. QED
  BY <5>1
<4>5. QED
  BY <4>1, <4>2, <4>3, <4>4
<3>7. QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)' \/ ConfigDisabled(y)'
  BY <3>3, <3>4, <3>5, <3>6
<3>8. QED
  BY <3>7
<2>7. StrConj_8'
  BY <2>6 DEF StrConj_8
<2>8. QED
  BY <2>7
<1>2. QED
  BY <1>1

THEOREM ReconfigAction_Preserves_StrConj_10 == IndAuto /\ ReconfigAction => StrConj_10'
PROOF
<1>1. SUFFICES ASSUME IndAuto, ReconfigAction PROVE StrConj_10'
  BY SMT
<1>2. IndAuto
  BY <1>1
<1>3. ReconfigAction
  BY <1>1
<1>4. PICK s \in Server, newConfig \in SUBSET Server : Reconfig(s, newConfig)
  BY <1>3 DEF ReconfigAction
<1>5. TypeOK
  BY <1>2 DEF IndAuto
<1>6. config \in [Server -> SUBSET Server]
  BY <1>5 DEF TypeOK
<1>7. configTerm \in [Server -> Nat]
  BY <1>5 DEF TypeOK
<1>8. configVersion \in [Server -> Nat]
  BY <1>5 DEF TypeOK
<1>9. currentTerm' = currentTerm
  BY <1>3, ReconfigAction_Fact_Frame_CurrentTerm
<1>10. configTerm' = [configTerm EXCEPT ![s] = currentTerm[s]]
  BY <1>4 DEF Reconfig
<1>11. configVersion' = [configVersion EXCEPT ![s] = configVersion[s] + 1]
  BY <1>4 DEF Reconfig
<1>12. config' = [config EXCEPT ![s] = newConfig]
  BY <1>4 DEF Reconfig
<1>13. ConfigIsCommitted(s)
  BY <1>4 DEF Reconfig
<1>14. PICK committedQ \in QuorumsAt(s) :
         \A t \in committedQ :
           /\ configVersion[s] = configVersion[t]
           /\ configTerm[s] = configTerm[t]
           /\ currentTerm[t] = currentTerm[s]
  BY <1>13 DEF ConfigIsCommitted
<1>15. \A x \in Server :
         \A y \in Server :
           \A Q \in Quorums(config'[x]) :
             \E n \in Q :
               currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
PROOF
<2>1. TAKE x \in Server
<2>2. TAKE y \in Server
<2>3. TAKE Q \in Quorums(config'[x])
<2>4. CASE x = s
PROOF
<3>1. config'[x] = newConfig
  BY <1>5, <1>4, <2>4, Reconfig_Fact_TargetConfigVars
<3>2. Q \in Quorums(newConfig)
  BY <2>3, <3>1
<3>3. committedQ \in Quorums(config[s])
  BY <1>14 DEF QuorumsAt
<3>4. Q \cap committedQ # {}
  BY <1>4, <3>2, <3>3 DEF Reconfig, QuorumsOverlap
<3>5. PICK n \in Q \cap committedQ : TRUE
  BY <3>4
<3>6. n \in Q
  BY <3>5
<3>7. n \in committedQ
  BY <3>5
<3>8. currentTerm[n] = currentTerm[s]
  BY <1>14, <3>7
<3>9. currentTerm[s] >= currentTerm[y]
  BY <1>2, <1>4, <2>2, Reconfig_Fact_CurrentTerm_Maximal
<3>10. currentTerm'[n] = currentTerm[n]
  BY <1>9
<3>11. currentTerm'[y] = currentTerm[y]
  BY <1>9
<3>12. currentTerm'[n] >= currentTerm'[y]
  BY <3>8, <3>9, <3>10, <3>11
<3>13. currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <3>12
<3>14. \E n \in Q :
         currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <3>6, <3>13
<3>15. QED
  BY <3>14
<2>5. CASE x # s
PROOF
<3>1. config'[x] = config[x]
  BY <1>6, <1>12, <2>5
<3>2. Q \in Quorums(config[x])
  BY <2>3, <3>1
<3>3. PICK n \in Q :
        currentTerm[n] >= currentTerm[y]
        \/ configTerm[n] > configTerm[x]
        \/ /\ configTerm[n] = configTerm[x]
           /\ configVersion[n] > configVersion[x]
  BY <1>2, <3>2 DEF IndAuto, StrConj_10, QuorumsAt, IsNewerConfig
<3>4. CASE n = s
PROOF
<4>1. currentTerm'[n] = currentTerm[n]
  BY <1>9
<4>2. currentTerm'[y] = currentTerm[y]
  BY <1>9
<4>3. configTerm'[n] = currentTerm[s]
  BY <1>5, <1>4, <3>4, Reconfig_Fact_TargetConfigVars
<4>4. state[s] = Primary
  BY <1>4 DEF Reconfig
<4>5. configTerm[s] = currentTerm[s]
  BY <1>2, <4>4 DEF IndAuto, StrConj_6
<4>6. configTerm'[n] = configTerm[s]
  BY <3>4, <4>3, <4>5
<4>7. configVersion'[n] = configVersion[s] + 1
  BY <1>5, <1>4, <3>4, Reconfig_Fact_TargetConfigVars
<4>8. configTerm'[x] = configTerm[x]
  BY <1>5, <1>4, <2>5, Reconfig_Fact_OtherConfigVars
<4>9. configVersion'[x] = configVersion[x]
  BY <1>5, <1>4, <2>5, Reconfig_Fact_OtherConfigVars
<4>10. currentTerm[n] >= currentTerm[y] \/ IsNewerConfig(n, x)
  BY <3>3 DEF IsNewerConfig
<4>11. ASSUME currentTerm[n] >= currentTerm[y]
       PROVE currentTerm'[n] >= currentTerm'[y]
             \/ configTerm'[n] > configTerm'[x]
             \/ /\ configTerm'[n] = configTerm'[x]
                /\ configVersion'[n] > configVersion'[x]
PROOF
<5>1. currentTerm'[n] >= currentTerm'[y]
  BY <4>1, <4>2, <4>11
<5>2. currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <5>1
<5>3. QED
  BY <5>2
<4>12. ASSUME IsNewerConfig(n, x)
       PROVE currentTerm'[n] >= currentTerm'[y]
             \/ configTerm'[n] > configTerm'[x]
             \/ /\ configTerm'[n] = configTerm'[x]
                /\ configVersion'[n] > configVersion'[x]
PROOF
<5>1. IsNewerConfig(s, x)
  BY <3>4, <4>12
<5>2. configTerm[s] > configTerm[x]
      \/ /\ configTerm[s] = configTerm[x]
         /\ configVersion[s] > configVersion[x]
  BY <5>1 DEF IsNewerConfig
<5>3. CASE configTerm[s] > configTerm[x]
PROOF
<6>1. configTerm'[n] > configTerm'[x]
  BY <4>6, <4>8, <5>3
<6>2. currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <6>1
<6>3. QED
  BY <6>2
<5>4. CASE /\ configTerm[s] = configTerm[x]
           /\ configVersion[s] > configVersion[x]
PROOF
<6>1. configTerm'[n] = configTerm'[x]
  BY <4>6, <4>8, <5>4
<6>2. configVersion'[n] > configVersion'[x]
  BY <1>8, <4>7, <4>9, <5>4, Nat_Succ_Preserves_Gt
<6>3. /\ configTerm'[n] = configTerm'[x]
       /\ configVersion'[n] > configVersion'[x]
  BY <6>1, <6>2
<6>4. currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <6>3
<6>5. QED
  BY <6>4
<5>5. currentTerm'[n] >= currentTerm'[y]
      \/ configTerm'[n] > configTerm'[x]
      \/ /\ configTerm'[n] = configTerm'[x]
         /\ configVersion'[n] > configVersion'[x]
  BY <5>2, <5>3, <5>4
<5>6. QED
  BY <5>5
<4>13. currentTerm'[n] >= currentTerm'[y]
       \/ configTerm'[n] > configTerm'[x]
       \/ /\ configTerm'[n] = configTerm'[x]
          /\ configVersion'[n] > configVersion'[x]
  BY <4>10, <4>11, <4>12
<4>14. currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <4>13 DEF IsNewerConfig
<4>15. \E m \in Q :
         currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <3>3, <4>14
<4>16. QED
  BY <4>15
<3>5. CASE n # s
PROOF
<4>1. currentTerm'[n] = currentTerm[n]
  BY <1>9
<4>2. currentTerm'[y] = currentTerm[y]
  BY <1>9
<4>3. configTerm'[n] = configTerm[n]
  BY <1>5, <1>4, <3>5, <1>6, <2>2, <3>2, <3>3,
     Quorums_Fact_MemberSubsetCarrier, Reconfig_Fact_OtherConfigVars
<4>4. configVersion'[n] = configVersion[n]
  BY <1>5, <1>4, <3>5, <1>6, <2>2, <3>2, <3>3,
     Quorums_Fact_MemberSubsetCarrier, Reconfig_Fact_OtherConfigVars
<4>5. configTerm'[x] = configTerm[x]
  BY <1>5, <1>4, <2>5, Reconfig_Fact_OtherConfigVars
<4>6. configVersion'[x] = configVersion[x]
  BY <1>5, <1>4, <2>5, Reconfig_Fact_OtherConfigVars
<4>7. currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <3>3, <4>1, <4>2, <4>3, <4>4, <4>5, <4>6 DEF IsNewerConfig
<4>8. \E m \in Q :
         currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <3>3, <4>7
<4>9. QED
  BY <4>8
<3>6. \E n \in Q :
        currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <3>4, <3>5
<3>7. QED
  BY <3>6
<2>6. ASSUME x = s \/ x # s
      PROVE \E n \in Q :
              currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
PROOF
<3>1. CASE x = s
PROOF
<4>1. \E n \in Q :
         currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <2>4, <3>1
<4>2. QED
  BY <4>1
<3>2. CASE x # s
PROOF
<4>1. \E n \in Q :
         currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <2>5, <3>2
<4>2. QED
  BY <4>1
<3>3. QED
  BY <2>6, <3>1, <3>2
<2>7. x = s \/ x # s
  BY <2>1
<2>8. \E n \in Q :
        currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <2>6, <2>7
<2>9. QED
  BY <2>8
<1>16. StrConj_10'
  BY <1>15, StrConj_10_Primed_Intro
<1>17. QED
  BY <1>1, <1>16

THEOREM ReconfigAction_Preserves_StrConj_11 == IndAuto /\ ReconfigAction => StrConj_11'
PROOF
<1>1. SUFFICES ASSUME IndAuto, ReconfigAction PROVE StrConj_11'
  BY SMT
<1>2. IndAuto
  BY <1>1
<1>3. ReconfigAction
  BY <1>1
<1>4. PICK s \in Server, newConfig \in SUBSET Server : Reconfig(s, newConfig)
  BY <1>3 DEF ReconfigAction
<1>5. configTerm' = [configTerm EXCEPT ![s] = currentTerm[s]]
  BY <1>4 DEF Reconfig
<1>6. configVersion' = [configVersion EXCEPT ![s] = configVersion[s] + 1]
  BY <1>4 DEF Reconfig
<1>7. config' = [config EXCEPT ![s] = newConfig]
  BY <1>4 DEF Reconfig
<1>8. TypeOK
  BY <1>2 DEF IndAuto
<1>9. \A x \in Server :
        \A y \in Server :
          (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
PROOF
<2>1. TAKE x \in Server
<2>2. TAKE y \in Server
<2>3. CASE x = s /\ y = s
PROOF
<3>1. config'[x] = config'[y]
  BY <2>3
<3>2. (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
  BY <3>1
<3>3. QED
  BY <3>2
<2>4. CASE x = s /\ y # s
PROOF
<3>1. ASSUME /\ configTerm'[x] = configTerm'[y]
              /\ configVersion'[x] = configVersion'[y]
      PROVE config'[x] = config'[y]
PROOF
<4>1. state[s] = Primary
  BY <1>4 DEF Reconfig
<4>2. configTerm[s] = currentTerm[s]
  BY <1>2, <4>1 DEF IndAuto, StrConj_6
<4>3. configTerm'[x] = currentTerm[s]
  BY <1>8, <1>4, <2>4, Reconfig_Fact_TargetConfigVars
<4>4. configTerm'[y] = configTerm[y]
  BY <1>8, <1>4, <2>4, Reconfig_Fact_OtherConfigVars
<4>5. configTerm[y] = currentTerm[s]
  BY <3>1, <4>3, <4>4
<4>6. configTerm[y] = configTerm[s]
  BY <4>2, <4>5
<4>7. configVersion'[x] = configVersion[s] + 1
  BY <1>8, <1>4, <2>4, Reconfig_Fact_TargetConfigVars
<4>8. configVersion'[y] = configVersion[y]
  BY <1>8, <1>4, <2>4, Reconfig_Fact_OtherConfigVars
<4>9. configVersion[y] = configVersion[s] + 1
  BY <3>1, <4>7, <4>8
<4>10. state[s] = Primary => \A z \in Server : configTerm[z] # configTerm[s] \/ configVersion[z] <= configVersion[s]
  BY <1>2 DEF IndAuto, StrConj_13
<4>11. \A z \in Server : configTerm[z] # configTerm[s] \/ configVersion[z] <= configVersion[s]
  BY <4>1, <4>10
<4>12. configTerm[y] # configTerm[s] \/ configVersion[y] <= configVersion[s]
  BY <4>11
<4>13. configVersion[y] <= configVersion[s]
  BY <4>6, <4>12
<4>14. configVersion \in [Server -> Nat]
  BY <1>2 DEF IndAuto, TypeOK
<4>15. configVersion[s] \in Nat
  BY <4>14
<4>16. FALSE
  BY <4>9, <4>13, <4>15
<4>17. config'[x] = config'[y]
  BY <4>16
<4>18. QED
  BY <4>17
<3>2. (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
  BY <3>1
<3>3. QED
  BY <3>2
<2>5. CASE x # s /\ y = s
PROOF
<3>1. ASSUME /\ configTerm'[x] = configTerm'[y]
              /\ configVersion'[x] = configVersion'[y]
      PROVE config'[x] = config'[y]
PROOF
<4>1. state[s] = Primary
  BY <1>4 DEF Reconfig
<4>2. configTerm[s] = currentTerm[s]
  BY <1>2, <4>1 DEF IndAuto, StrConj_6
<4>3. configTerm'[x] = configTerm[x]
  BY <1>8, <1>4, <2>5, Reconfig_Fact_OtherConfigVars
<4>4. configTerm'[y] = currentTerm[s]
  BY <1>8, <1>4, <2>5, Reconfig_Fact_TargetConfigVars
<4>5. configTerm[x] = currentTerm[s]
  BY <3>1, <4>3, <4>4
<4>6. configTerm[x] = configTerm[s]
  BY <4>2, <4>5
<4>7. configVersion'[x] = configVersion[x]
  BY <1>8, <1>4, <2>5, Reconfig_Fact_OtherConfigVars
<4>8. configVersion'[y] = configVersion[s] + 1
  BY <1>8, <1>4, <2>5, Reconfig_Fact_TargetConfigVars
<4>9. configVersion[x] = configVersion[s] + 1
  BY <3>1, <4>7, <4>8
<4>10. state[s] = Primary => \A z \in Server : configTerm[z] # configTerm[s] \/ configVersion[z] <= configVersion[s]
  BY <1>2 DEF IndAuto, StrConj_13
<4>11. \A z \in Server : configTerm[z] # configTerm[s] \/ configVersion[z] <= configVersion[s]
  BY <4>1, <4>10
<4>12. configTerm[x] # configTerm[s] \/ configVersion[x] <= configVersion[s]
  BY <4>11
<4>13. configVersion[x] <= configVersion[s]
  BY <4>6, <4>12
<4>14. configVersion \in [Server -> Nat]
  BY <1>2 DEF IndAuto, TypeOK
<4>15. configVersion[s] \in Nat
  BY <4>14
<4>16. FALSE
  BY <4>9, <4>13, <4>15
<4>17. config'[x] = config'[y]
  BY <4>16
<4>18. QED
  BY <4>17
<3>2. (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
  BY <3>1
<3>3. QED
  BY <3>2
<2>6. CASE x # s /\ y # s
PROOF
<3>1. configTerm'[x] = configTerm[x]
  BY <1>8, <1>4, <2>6, Reconfig_Fact_OtherConfigVars
<3>2. configVersion'[x] = configVersion[x]
  BY <1>8, <1>4, <2>6, Reconfig_Fact_OtherConfigVars
<3>3. config'[x] = config[x]
  BY <1>8, <1>4, <2>6, Reconfig_Fact_OtherConfigVars
<3>4. configTerm'[y] = configTerm[y]
  BY <1>8, <1>4, <2>6, Reconfig_Fact_OtherConfigVars
<3>5. configVersion'[y] = configVersion[y]
  BY <1>8, <1>4, <2>6, Reconfig_Fact_OtherConfigVars
<3>6. config'[y] = config[y]
  BY <1>8, <1>4, <2>6, Reconfig_Fact_OtherConfigVars
<3>7. (configTerm[x] = configTerm[y] /\ configVersion[x] = configVersion[y]) => config[x] = config[y]
  BY <1>2 DEF IndAuto, StrConj_11
<3>8. (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
  BY <3>1, <3>2, <3>3, <3>4, <3>5, <3>6, <3>7
<3>9. QED
  BY <3>8
<2>7. (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
  BY <2>3, <2>4, <2>5, <2>6
<2>8. QED
  BY <2>7
<1>10. StrConj_11'
  BY <1>9 DEF StrConj_11
<1>11. QED
  BY <1>1, <1>10

THEOREM ReconfigAction_Preserves_StrConj_13 == IndAuto /\ ReconfigAction => StrConj_13'
PROOF
<1>1. SUFFICES ASSUME IndAuto, ReconfigAction PROVE StrConj_13'
  BY SMT
<1>2. IndAuto
  BY <1>1
<1>3. ReconfigAction
  BY <1>1
<1>4. PICK s \in Server, newConfig \in SUBSET Server : Reconfig(s, newConfig)
  BY <1>3 DEF ReconfigAction
<1>5. UNCHANGED <<currentTerm, state>>
  BY <1>4 DEF Reconfig
<1>6. configTerm' = [configTerm EXCEPT ![s] = currentTerm[s]]
  BY <1>4 DEF Reconfig
<1>7. configVersion' = [configVersion EXCEPT ![s] = configVersion[s] + 1]
  BY <1>4 DEF Reconfig
<1>8. TypeOK
  BY <1>2 DEF IndAuto
<1>9. \A x \in Server :
        state'[x] = Primary =>
          \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
PROOF
<2>1. TAKE x \in Server
<2>2. currentTerm' = currentTerm
  BY <1>3, ReconfigAction_Fact_Frame_CurrentTerm
<2>3. state' = state
  BY <1>3, ReconfigAction_Fact_Frame_State
<2>4. CASE x = s
PROOF
<3>1. state[s] = Primary
  BY <1>4 DEF Reconfig
<3>2. configTerm[s] = currentTerm[s]
  BY <1>2, <3>1 DEF IndAuto, StrConj_6
<3>3. configTerm'[x] = currentTerm[s]
  BY <1>8, <1>4, <2>4, Reconfig_Fact_TargetConfigVars
<3>4. configVersion'[x] = configVersion[s] + 1
  BY <1>8, <1>4, <2>4, Reconfig_Fact_TargetConfigVars
<3>5. ASSUME state'[x] = Primary
      PROVE \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
PROOF
<4>1. TAKE y \in Server
<4>2. CASE y = s
PROOF
<5>1. configVersion'[y] = configVersion[s] + 1
  BY <1>8, <1>4, <4>2, Reconfig_Fact_TargetConfigVars
<5>2. configVersion'[x] = configVersion[s] + 1
  BY <3>4
<5>3. configVersion[s] \in Nat
  BY <1>8 DEF TypeOK
<5>4. configVersion[s] + 1 <= configVersion[s] + 1
  BY <5>3, SMT
<5>5. configVersion'[y] <= configVersion'[x]
  BY <5>1, <5>2, <5>4
<5>6. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <5>5
<5>7. QED
  BY <5>6
<4>3. CASE y # s
PROOF
<5>1. configTerm'[y] = configTerm[y]
  BY <1>8, <1>4, <4>3, Reconfig_Fact_OtherConfigVars
<5>2. configTerm'[x] = configTerm[s]
  BY <3>2, <3>3
<5>3. configVersion'[y] = configVersion[y]
  BY <1>8, <1>4, <4>3, Reconfig_Fact_OtherConfigVars
<5>4. state[s] = Primary => \A z \in Server : configTerm[z] # configTerm[s] \/ configVersion[z] <= configVersion[s]
  BY <1>2 DEF IndAuto, StrConj_13
<5>5. \A z \in Server : configTerm[z] # configTerm[s] \/ configVersion[z] <= configVersion[s]
  BY <3>1, <5>4
<5>6. configTerm[y] # configTerm[s] \/ configVersion[y] <= configVersion[s]
  BY <5>5
<5>7. CASE configTerm[y] # configTerm[s]
PROOF
<6>1. configTerm'[y] # configTerm'[x]
  BY <5>1, <5>2, <5>7
<6>2. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <6>1
<6>3. QED
  BY <6>2
<5>8. CASE ~(configTerm[y] # configTerm[s])
PROOF
<6>1. configVersion[y] <= configVersion[s]
  BY <5>6, <5>8
<6>2. configVersion \in [Server -> Nat]
  BY <1>2 DEF IndAuto, TypeOK
<6>3. configVersion[y] \in Nat
  BY <4>1, <6>2
<6>4. configVersion[s] \in Nat
  BY <6>2
<6>5. configVersion[s] <= configVersion[s] + 1
  BY <6>4, SMT
<6>6. configVersion[y] <= configVersion[s] + 1
  BY <6>3, <6>4, <6>1, <6>5, Nat_Leq_Transitive
<6>7. configVersion'[y] <= configVersion'[x]
  BY <3>4, <5>3, <6>6
<6>8. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <6>7
<6>9. QED
  BY <6>8
<5>9. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <5>7, <5>8
<5>10. QED
  BY <5>9
<4>4. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <4>2, <4>3
<4>5. QED
  BY <4>4
<3>6. state'[x] = Primary => \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <3>5
<3>7. QED
  BY <3>6
<2>5. CASE x # s
PROOF
<3>1. configTerm'[x] = configTerm[x]
  BY <1>8, <1>4, <2>5, Reconfig_Fact_OtherConfigVars
<3>2. configVersion'[x] = configVersion[x]
  BY <1>8, <1>4, <2>5, Reconfig_Fact_OtherConfigVars
<3>3. ASSUME state'[x] = Primary
      PROVE \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
PROOF
<4>1. state[x] = Primary
  BY <2>3, <3>3
<4>2. state[s] = Primary
  BY <1>4 DEF Reconfig
<4>3. configTerm[x] = currentTerm[x]
  BY <1>2, <4>1 DEF IndAuto, StrConj_6
<4>4. TAKE y \in Server
<4>5. CASE y = s
PROOF
<5>1. configTerm'[y] = currentTerm[s]
  BY <1>8, <1>4, <4>5, Reconfig_Fact_TargetConfigVars
<5>2. ASSUME configTerm'[y] = configTerm'[x]
      PROVE configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
PROOF
<6>1. currentTerm[s] = configTerm[x]
  BY <3>1, <5>1, <5>2
<6>2. currentTerm[s] = currentTerm[x]
  BY <4>3, <6>1
<6>3. s = x
  BY <1>2, <4>1, <4>2, <6>2 DEF IndAuto, Safety, OnePrimaryPerTerm
<6>4. FALSE
  BY <2>5, <6>3
<6>5. configTerm'[y] # configTerm'[x]
  BY <6>4
<6>6. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <6>5
<6>7. QED
  BY <6>6
<5>3. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <5>2
<5>4. QED
  BY <5>3
<4>6. CASE y # s
PROOF
<5>1. configTerm'[y] = configTerm[y]
  BY <1>8, <1>4, <4>6, Reconfig_Fact_OtherConfigVars
<5>2. configVersion'[y] = configVersion[y]
  BY <1>8, <1>4, <4>6, Reconfig_Fact_OtherConfigVars
<5>3. state[x] = Primary => \A z \in Server : configTerm[z] # configTerm[x] \/ configVersion[z] <= configVersion[x]
  BY <1>2 DEF IndAuto, StrConj_13
<5>4. \A z \in Server : configTerm[z] # configTerm[x] \/ configVersion[z] <= configVersion[x]
  BY <4>1, <5>3
<5>5. configTerm[y] # configTerm[x] \/ configVersion[y] <= configVersion[x]
  BY <5>4
<5>6. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <3>1, <3>2, <5>1, <5>2, <5>5
<5>7. QED
  BY <5>6
<4>7. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <4>5, <4>6
<4>8. QED
  BY <4>7
<3>4. state'[x] = Primary => \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <3>3
<3>5. QED
  BY <3>4
<2>6. state'[x] = Primary => \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <2>4, <2>5
<2>7. QED
  BY <2>6
<1>10. StrConj_13'
  BY <1>9 DEF StrConj_13
<1>11. QED
  BY <1>1, <1>10

THEOREM SendConfigAction_Preserves_TypeOK == IndAuto /\ SendConfigAction => TypeOK'
PROOF
<1>1. ASSUME IndAuto /\ SendConfigAction
      PROVE TypeOK'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. SendConfigAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : SendConfig(s, t)
  BY <2>2 DEF SendConfigAction
<2>4. configVersion' = [configVersion EXCEPT ![t] = configVersion[s]]
  BY <2>3 DEF SendConfig
<2>5. configTerm' = [configTerm EXCEPT ![t] = configTerm[s]]
  BY <2>3 DEF SendConfig
<2>6. config' = [config EXCEPT ![t] = config[s]]
  BY <2>3 DEF SendConfig
<2>7. TypeOK
  BY <2>1 DEF IndAuto
<2>8. currentTerm' = currentTerm
  BY <2>2, SendConfigAction_Fact_Frame_CurrentTerm
<2>9. state' = state
  BY <2>2, SendConfigAction_Fact_Frame_State
<2>10. TypeOK'
  BY <2>3, <2>4, <2>5, <2>6, <2>7, <2>8, <2>9 DEF TypeOK
<2>11. QED
  BY <2>10
<1>2. QED
  BY <1>1

THEOREM SendConfigAction_Preserves_Safety == IndAuto /\ SendConfigAction => Safety'
PROOF
<1>1. ASSUME IndAuto /\ SendConfigAction
      PROVE Safety'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. SendConfigAction
  BY <1>1
<2>3. currentTerm' = currentTerm
  BY <2>2, SendConfigAction_Fact_Frame_CurrentTerm
<2>4. state' = state
  BY <2>2, SendConfigAction_Fact_Frame_State
<2>5. Safety'
  BY <2>1, <2>3, <2>4, TermStateFrame_Preserves_Safety
<2>6. QED
  BY <2>5
<1>2. QED
  BY <1>1

THEOREM SendConfigAction_Preserves_StrConj_0 == IndAuto /\ SendConfigAction => StrConj_0'
PROOF
<1>1. ASSUME IndAuto /\ SendConfigAction
      PROVE StrConj_0'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. SendConfigAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : SendConfig(s, t)
  BY <2>2 DEF SendConfigAction
<2>4. configVersion' = [configVersion EXCEPT ![t] = configVersion[s]]
  BY <2>3 DEF SendConfig
<2>5. TypeOK
  BY <2>1 DEF IndAuto
<2>6. configVersion \in [Server -> Nat]
  BY <2>5 DEF TypeOK
<2>7. \A x \in Server : configVersion'[x] >= 1
PROOF
<3>1. TAKE x \in Server
<3>2. configVersion[s] >= 1
  BY <2>1 DEF IndAuto, StrConj_0
<3>3. CASE x = t
PROOF
<4>1. configVersion'[t] = configVersion[s]
  BY <2>5, <2>3, SendConfig_Fact_TargetPairIsSourcePair
<4>2. configVersion'[x] = configVersion[s]
  BY <3>3, <4>1
<4>3. configVersion'[x] >= 1
  BY <3>2, <4>2
<4>4. QED
  BY <4>3
<3>4. CASE x # t
PROOF
<4>1. configVersion'[x] = configVersion[x]
  BY <2>4, <2>6, <3>4
<4>2. configVersion[x] >= 1
  BY <2>1 DEF IndAuto, StrConj_0
<4>3. configVersion'[x] >= 1
  BY <4>1, <4>2
<4>4. QED
  BY <4>3
<3>5. QED
  BY <3>3, <3>4
<2>8. StrConj_0'
  BY <2>7, StrConj_0_Primed_Intro
<2>9. QED
  BY <2>8
<1>2. QED
  BY <1>1

THEOREM SendConfigAction_Preserves_StrConj_5 == IndAuto /\ SendConfigAction => StrConj_5'
PROOF
<1>1. ASSUME IndAuto /\ SendConfigAction
      PROVE StrConj_5'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. SendConfigAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : SendConfig(s, t)
  BY <2>2 DEF SendConfigAction
<2>4. configTerm' = [configTerm EXCEPT ![t] = configTerm[s]]
  BY <2>3 DEF SendConfig
<2>5. config' = [config EXCEPT ![t] = config[s]]
  BY <2>3 DEF SendConfig
<2>6. currentTerm' = currentTerm
  BY <2>2, SendConfigAction_Fact_Frame_CurrentTerm
<2>7. TypeOK
  BY <2>1 DEF IndAuto
<2>8. config \in [Server -> SUBSET Server]
  BY <2>7 DEF TypeOK
<2>9. configTerm \in [Server -> Nat]
  BY <2>7 DEF TypeOK
<2>10. \A x \in Server : \E u \in config'[x] : currentTerm'[u] >= configTerm'[x]
PROOF
<3>1. TAKE x \in Server
<3>2. CASE x = t
PROOF
<4>1. PICK witness \in config[s] : currentTerm[witness] >= configTerm[s]
  BY <2>1 DEF IndAuto, StrConj_5
<4>2. witness \in config'[x]
  BY <2>5, <2>8, <3>2, <4>1
<4>3. currentTerm'[witness] = currentTerm[witness]
  BY <2>6
<4>4. configTerm'[x] = configTerm[s]
  BY <2>4, <2>9, <3>2
<4>5. currentTerm'[witness] >= configTerm'[x]
  BY <4>1, <4>3, <4>4
<4>6. \E u \in config'[x] : currentTerm'[u] >= configTerm'[x]
  BY <4>2, <4>5
<4>7. QED
  BY <4>6
<3>3. CASE x # t
PROOF
<4>1. PICK witness \in config[x] : currentTerm[witness] >= configTerm[x]
  BY <2>1 DEF IndAuto, StrConj_5
<4>2. witness \in config'[x]
  BY <2>5, <2>8, <3>3, <4>1
<4>3. currentTerm'[witness] = currentTerm[witness]
  BY <2>6
<4>4. configTerm'[x] = configTerm[x]
  BY <2>4, <2>9, <3>3
<4>5. currentTerm'[witness] >= configTerm'[x]
  BY <4>1, <4>3, <4>4
<4>6. \E u \in config'[x] : currentTerm'[u] >= configTerm'[x]
  BY <4>2, <4>5
<4>7. QED
  BY <4>6
<3>4. QED
  BY <3>2, <3>3
<2>11. StrConj_5'
  BY <2>10, StrConj_5_Primed_Intro
<2>12. QED
  BY <2>11
<1>2. QED
  BY <1>1

THEOREM SendConfigAction_Preserves_StrConj_6 == IndAuto /\ SendConfigAction => StrConj_6'
PROOF
<1>1. ASSUME IndAuto /\ SendConfigAction
      PROVE StrConj_6'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. SendConfigAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : SendConfig(s, t)
  BY <2>2 DEF SendConfigAction
<2>4. currentTerm' = currentTerm
  BY <2>2, SendConfigAction_Fact_Frame_CurrentTerm
<2>5. state' = state
  BY <2>2, SendConfigAction_Fact_Frame_State
<2>6. configTerm' = [configTerm EXCEPT ![t] = configTerm[s]]
  BY <2>3 DEF SendConfig
<2>7. TypeOK
  BY <2>1 DEF IndAuto
<2>8. configTerm \in [Server -> Nat]
  BY <2>7 DEF TypeOK
<2>9. \A x \in Server : state'[x] = Primary => configTerm'[x] = currentTerm'[x]
PROOF
<3>1. TAKE x \in Server
<3>2. CASE x = t
PROOF
<4>1. state[t] = Secondary
  BY <2>3 DEF SendConfig
<4>2. state'[x] = Secondary
  BY <2>5, <3>2, <4>1
<4>3. ASSUME state'[x] = Primary
      PROVE configTerm'[x] = currentTerm'[x]
PROOF
<5>1. FALSE
  BY <4>2, <4>3, BenchmarkAssumption_PrimarySecondaryDistinct
<5>2. configTerm'[x] = currentTerm'[x]
  BY <5>1
<5>3. QED
  BY <5>2
<4>4. state'[x] = Primary => configTerm'[x] = currentTerm'[x]
  BY <4>3
<4>5. QED
  BY <4>4
<3>3. CASE x # t
PROOF
<4>1. configTerm'[x] = configTerm[x]
  BY <2>6, <2>8, <3>3
<4>2. currentTerm'[x] = currentTerm[x]
  BY <2>4
<4>3. state'[x] = state[x]
  BY <2>5
<4>4. state[x] = Primary => configTerm[x] = currentTerm[x]
  BY <2>1 DEF IndAuto, StrConj_6
<4>5. state'[x] = Primary => configTerm'[x] = currentTerm'[x]
  BY <4>1, <4>2, <4>3, <4>4
<4>6. QED
  BY <4>5
<3>4. QED
  BY <3>2, <3>3
<2>10. StrConj_6'
  BY <2>9, StrConj_6_Primed_Intro
<2>11. QED
  BY <2>10
<1>2. QED
  BY <1>1

THEOREM SendConfigAction_Preserves_StrConj_8 == IndAuto /\ SendConfigAction => StrConj_8'
PROOF
<1>1. ASSUME IndAuto /\ SendConfigAction
      PROVE StrConj_8'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. SendConfigAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : SendConfig(s, t)
  BY <2>2 DEF SendConfigAction
<2>4. TypeOK
  BY <2>1 DEF IndAuto
<2>5. config \in [Server -> SUBSET Server]
  BY <2>4 DEF TypeOK
<2>6. configTerm \in [Server -> Nat]
  BY <2>4 DEF TypeOK
<2>7. configVersion \in [Server -> Nat]
  BY <2>4 DEF TypeOK
<2>8. config' = [config EXCEPT ![t] = config[s]]
  BY <2>3 DEF SendConfig
<2>9. configTerm' = [configTerm EXCEPT ![t] = configTerm[s]]
  BY <2>3 DEF SendConfig
<2>10. configVersion' = [configVersion EXCEPT ![t] = configVersion[s]]
  BY <2>3 DEF SendConfig
<2>11. \A x \in Server :
         \A y \in Server :
           QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)' \/ ConfigDisabled(y)'
PROOF
<3>1. TAKE x \in Server
<3>2. TAKE y \in Server
<3>3. CASE x = t /\ y = t
PROOF
<4>1. QuorumsOverlap(config[s], config[s]) \/ ConfigDisabled(s) \/ ConfigDisabled(s)
  BY <2>1 DEF IndAuto, StrConj_8
<4>2. CASE QuorumsOverlap(config[s], config[s])
PROOF
<5>1. config'[x] = config[s]
  BY <2>4, <2>3, <3>3, SendConfig_Fact_TargetConfigVars
<5>2. config'[y] = config[s]
  BY <2>4, <2>3, <3>3, SendConfig_Fact_TargetConfigVars
<5>3. QuorumsOverlap(config'[x], config'[y])
  BY <4>2, <5>1, <5>2
<5>4. QED
  BY <5>3
<4>3. CASE ConfigDisabled(s)
PROOF
<5>1. ConfigDisabled(x)'
  BY <2>4, <2>3, <3>3, <4>3, SendConfig_Fact_SourceDisabledImpliesTargetDisabled
<5>2. QED
  BY <5>1
<4>4. QED
  BY <4>1, <4>2, <4>3
<3>4. CASE x = t /\ y # t
PROOF
<4>1. QuorumsOverlap(config[s], config[y]) \/ ConfigDisabled(s) \/ ConfigDisabled(y)
  BY <2>1 DEF IndAuto, StrConj_8
<4>2. CASE QuorumsOverlap(config[s], config[y])
PROOF
<5>1. config'[x] = config[s]
  BY <2>4, <2>3, <3>4, SendConfig_Fact_TargetConfigVars
<5>2. config'[y] = config[y]
  BY <2>4, <2>3, <3>2, <3>4, SendConfig_Fact_OtherConfigVars
<5>3. QuorumsOverlap(config'[x], config'[y])
  BY <4>2, <5>1, <5>2
<5>4. QED
  BY <5>3
<4>3. CASE ConfigDisabled(s)
PROOF
<5>1. ConfigDisabled(x)'
  BY <2>4, <2>3, <3>4, <4>3, SendConfig_Fact_SourceDisabledImpliesTargetDisabled
<5>2. QED
  BY <5>1
<4>4. CASE ConfigDisabled(y)
PROOF
<5>1. ConfigDisabled(y)'
  BY <2>4, <2>3, <3>2, <3>4, <4>4, SendConfig_Fact_OtherDisabledUnchanged
<5>2. QED
  BY <5>1
<4>5. QED
  BY <4>1, <4>2, <4>3, <4>4
<3>5. CASE x # t /\ y = t
PROOF
<4>1. QuorumsOverlap(config[x], config[s]) \/ ConfigDisabled(x) \/ ConfigDisabled(s)
  BY <2>1 DEF IndAuto, StrConj_8
<4>2. CASE QuorumsOverlap(config[x], config[s])
PROOF
<5>1. config'[x] = config[x]
  BY <2>4, <2>3, <3>1, <3>5, SendConfig_Fact_OtherConfigVars
<5>2. config'[y] = config[s]
  BY <2>4, <2>3, <3>5, SendConfig_Fact_TargetConfigVars
<5>3. QuorumsOverlap(config'[x], config'[y])
  BY <4>2, <5>1, <5>2
<5>4. QED
  BY <5>3
<4>3. CASE ConfigDisabled(x)
PROOF
<5>1. ConfigDisabled(x)'
  BY <2>4, <2>3, <3>1, <3>5, <4>3, SendConfig_Fact_OtherDisabledUnchanged
<5>2. QED
  BY <5>1
<4>4. CASE ConfigDisabled(s)
PROOF
<5>1. ConfigDisabled(y)'
  BY <2>4, <2>3, <3>5, <4>4, SendConfig_Fact_SourceDisabledImpliesTargetDisabled
<5>2. QED
  BY <5>1
<4>5. QED
  BY <4>1, <4>2, <4>3, <4>4
<3>6. CASE x # t /\ y # t
PROOF
<4>1. QuorumsOverlap(config[x], config[y]) \/ ConfigDisabled(x) \/ ConfigDisabled(y)
  BY <2>1 DEF IndAuto, StrConj_8
<4>2. CASE QuorumsOverlap(config[x], config[y])
PROOF
<5>1. config'[x] = config[x]
  BY <2>4, <2>3, <3>1, <3>6, SendConfig_Fact_OtherConfigVars
<5>2. config'[y] = config[y]
  BY <2>4, <2>3, <3>2, <3>6, SendConfig_Fact_OtherConfigVars
<5>3. QuorumsOverlap(config'[x], config'[y])
  BY <4>2, <5>1, <5>2
<5>4. QED
  BY <5>3
<4>3. CASE ConfigDisabled(x)
PROOF
<5>1. ConfigDisabled(x)'
  BY <2>4, <2>3, <3>1, <3>6, <4>3, SendConfig_Fact_OtherDisabledUnchanged
<5>2. QED
  BY <5>1
<4>4. CASE ConfigDisabled(y)
PROOF
<5>1. ConfigDisabled(y)'
  BY <2>4, <2>3, <3>2, <3>6, <4>4, SendConfig_Fact_OtherDisabledUnchanged
<5>2. QED
  BY <5>1
<4>5. QED
  BY <4>1, <4>2, <4>3, <4>4
<3>7. QED
  BY <3>3, <3>4, <3>5, <3>6
<2>12. StrConj_8'
  BY <2>11, StrConj_8_Primed_Intro
<2>13. QED
  BY <2>12
<1>2. QED
  BY <1>1

THEOREM SendConfigAction_Preserves_StrConj_10 == IndAuto /\ SendConfigAction => StrConj_10'
PROOF
<1>1. ASSUME IndAuto /\ SendConfigAction
      PROVE StrConj_10'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. SendConfigAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : SendConfig(s, t)
  BY <2>2 DEF SendConfigAction
<2>4. currentTerm' = currentTerm
  BY <2>2, SendConfigAction_Fact_Frame_CurrentTerm
<2>5. configTerm' = [configTerm EXCEPT ![t] = configTerm[s]]
  BY <2>3 DEF SendConfig
<2>6. configVersion' = [configVersion EXCEPT ![t] = configVersion[s]]
  BY <2>3 DEF SendConfig
<2>7. config' = [config EXCEPT ![t] = config[s]]
  BY <2>3 DEF SendConfig
<2>8. TypeOK
  BY <2>1 DEF IndAuto
<2>9. config \in [Server -> SUBSET Server]
  BY <2>8 DEF TypeOK
<2>10. \A x \in Server :
         \A y \in Server :
           \A Q \in Quorums(config'[x]) :
             \E n \in Q :
               currentTerm'[n] >= currentTerm'[y]
               \/ configTerm'[n] > configTerm'[x]
               \/ /\ configTerm'[n] = configTerm'[x]
                  /\ configVersion'[n] > configVersion'[x]
PROOF
<3>1. TAKE x \in Server
<3>2. TAKE y \in Server
<3>3. TAKE Q \in Quorums(config'[x])
<3>4. CASE x = t
PROOF
<4>1. config'[x] = config[s]
  BY <2>8, <2>3, <3>4, SendConfig_Fact_TargetConfigVars
<4>2. Q \in Quorums(config[s])
  BY <3>3, <4>1
<4>3. PICK n \in Q :
        currentTerm[n] >= currentTerm[y]
        \/ configTerm[n] > configTerm[s]
        \/ /\ configTerm[n] = configTerm[s]
           /\ configVersion[n] > configVersion[s]
  BY <2>1, <4>2 DEF IndAuto, StrConj_10, QuorumsAt, IsNewerConfig
<4>4. Q \subseteq config[s]
  BY <4>2 DEF Quorums
<4>5. n \in config[s]
  BY <4>3, <4>4
<4>6. n \in Server
  BY <2>9, <4>5 DEF TypeOK
<4>7. currentTerm'[n] >= currentTerm'[y]
       \/ configTerm'[n] > configTerm'[x]
       \/ /\ configTerm'[n] = configTerm'[x]
          /\ configVersion'[n] > configVersion'[x]
PROOF
<5>1. CASE n = t
PROOF
<6>1. currentTerm'[n] = currentTerm[n]
  BY <2>4
<6>2. currentTerm'[y] = currentTerm[y]
  BY <2>4
<6>3. configTerm'[x] = configTerm[s]
  BY <2>8, <2>3, <3>4, SendConfig_Fact_TargetConfigVars
<6>4. configVersion'[x] = configVersion[s]
  BY <2>8, <2>3, <3>4, SendConfig_Fact_TargetConfigVars
<6>5. configTerm'[n] = configTerm[s]
  BY <2>8, <2>3, <5>1, SendConfig_Fact_TargetConfigVars
<6>6. configVersion'[n] = configVersion[s]
  BY <2>8, <2>3, <5>1, SendConfig_Fact_TargetConfigVars
<6>7. currentTerm[n] >= currentTerm[y] \/ IsNewerConfig(n, s)
  BY <4>3 DEF IsNewerConfig
<6>8. ASSUME currentTerm[n] >= currentTerm[y]
      PROVE currentTerm'[n] >= currentTerm'[y]
             \/ configTerm'[n] > configTerm'[x]
             \/ /\ configTerm'[n] = configTerm'[x]
                /\ configVersion'[n] > configVersion'[x]
PROOF
<7>1. currentTerm'[n] >= currentTerm'[y]
  BY <6>1, <6>2, <6>8
<7>2. currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <7>1
<7>3. QED
  BY <7>2
<6>9. ASSUME IsNewerConfig(n, s)
      PROVE currentTerm'[n] >= currentTerm'[y]
             \/ configTerm'[n] > configTerm'[x]
             \/ /\ configTerm'[n] = configTerm'[x]
                /\ configVersion'[n] > configVersion'[x]
PROOF
<7>1. IsNewerConfig(n, s)
  BY <6>9
<7>2. IsNewerConfig(t, s)
  BY <5>1, <7>1
<7>3. IsNewerConfig(s, t)
  BY <2>3 DEF SendConfig, IsNewerConfig
<7>4. ~ IsNewerConfig(t, s)
  BY <2>8, <1>1, <7>3, IsNewerConfig_Asymmetric
<7>5. FALSE
  BY <7>2, <7>4
<7>6. currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <7>5
<7>7. QED
  BY <7>6
<6>10. currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <6>7, <6>8, <6>9
<6>11. QED
  BY <6>10
<5>2. CASE n # t
PROOF
<6>1. currentTerm'[n] = currentTerm[n]
  BY <2>4
<6>2. currentTerm'[y] = currentTerm[y]
  BY <2>4
<6>3. configTerm'[n] = configTerm[n]
  BY <2>8, <2>3, <4>6, <5>2, SendConfig_Fact_OtherConfigVars
<6>4. configVersion'[n] = configVersion[n]
  BY <2>8, <2>3, <4>6, <5>2, SendConfig_Fact_OtherConfigVars
<6>5. configTerm'[x] = configTerm[s]
  BY <2>8, <2>3, <3>4, SendConfig_Fact_TargetConfigVars
<6>6. configVersion'[x] = configVersion[s]
  BY <2>8, <2>3, <3>4, SendConfig_Fact_TargetConfigVars
<6>7. currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <4>3, <6>1, <6>2, <6>3, <6>4, <6>5, <6>6
<6>8. QED
  BY <6>7
<5>3. QED
  BY <5>1, <5>2
<4>8. \E n \in Q :
        currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <4>3, <4>7
<4>9. QED
  BY <4>8
<3>5. CASE x # t
PROOF
<4>1. config'[x] = config[x]
  BY <2>8, <2>3, <3>1, <3>5, SendConfig_Fact_OtherConfigVars
<4>2. Q \in Quorums(config[x])
  BY <3>3, <4>1
<4>3. PICK n \in Q :
        currentTerm[n] >= currentTerm[y]
        \/ configTerm[n] > configTerm[x]
        \/ /\ configTerm[n] = configTerm[x]
           /\ configVersion[n] > configVersion[x]
  BY <2>1, <4>2 DEF IndAuto, StrConj_10, QuorumsAt, IsNewerConfig
<4>4. Q \subseteq config[x]
  BY <4>2 DEF Quorums
<4>5. n \in config[x]
  BY <4>3, <4>4
<4>6. n \in Server
  BY <2>9, <4>5 DEF TypeOK
<4>7. currentTerm'[n] >= currentTerm'[y]
       \/ configTerm'[n] > configTerm'[x]
       \/ /\ configTerm'[n] = configTerm'[x]
          /\ configVersion'[n] > configVersion'[x]
PROOF
<5>1. CASE n = t
PROOF
<6>1. currentTerm'[n] = currentTerm[n]
  BY <2>4
<6>2. currentTerm'[y] = currentTerm[y]
  BY <2>4
<6>3. configTerm'[n] = configTerm[s]
  BY <2>8, <2>3, <5>1, SendConfig_Fact_TargetConfigVars
<6>4. configVersion'[n] = configVersion[s]
  BY <2>8, <2>3, <5>1, SendConfig_Fact_TargetConfigVars
<6>5. configTerm'[x] = configTerm[x]
  BY <2>8, <2>3, <3>1, <3>5, SendConfig_Fact_OtherConfigVars
<6>6. configVersion'[x] = configVersion[x]
  BY <2>8, <2>3, <3>1, <3>5, SendConfig_Fact_OtherConfigVars
<6>7. currentTerm[n] >= currentTerm[y] \/ IsNewerConfig(n, x)
  BY <4>3 DEF IsNewerConfig
<6>8. ASSUME currentTerm[n] >= currentTerm[y]
      PROVE currentTerm'[n] >= currentTerm'[y]
             \/ configTerm'[n] > configTerm'[x]
             \/ /\ configTerm'[n] = configTerm'[x]
                /\ configVersion'[n] > configVersion'[x]
PROOF
<7>1. currentTerm'[n] >= currentTerm'[y]
  BY <6>1, <6>2, <6>8
<7>2. currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <7>1
<7>3. QED
  BY <7>2
<6>9. ASSUME IsNewerConfig(n, x)
      PROVE currentTerm'[n] >= currentTerm'[y]
             \/ configTerm'[n] > configTerm'[x]
             \/ /\ configTerm'[n] = configTerm'[x]
                /\ configVersion'[n] > configVersion'[x]
PROOF
<7>1. IsNewerConfig(n, x)
  BY <6>9
<7>2. IsNewerConfig(t, x)
  BY <5>1, <7>1
<7>3. IsNewerConfig(s, t)
  BY <2>3 DEF SendConfig, IsNewerConfig
<7>4. IsNewerConfig(s, x)
  BY <2>8, <3>1, <5>1, <7>2, <7>3, IsNewerConfig_Transitive
<7>5. configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <6>3, <6>4, <6>5, <6>6, <7>4 DEF IsNewerConfig
<7>6. currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <7>5
<7>7. QED
  BY <7>6
<6>10. currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <6>7, <6>8, <6>9
<6>11. QED
  BY <6>10
<5>2. CASE n # t
PROOF
<6>1. currentTerm'[n] = currentTerm[n]
  BY <2>4
<6>2. currentTerm'[y] = currentTerm[y]
  BY <2>4
<6>3. configTerm'[n] = configTerm[n]
  BY <2>8, <2>3, <4>6, <5>2, SendConfig_Fact_OtherConfigVars
<6>4. configVersion'[n] = configVersion[n]
  BY <2>8, <2>3, <4>6, <5>2, SendConfig_Fact_OtherConfigVars
<6>5. configTerm'[x] = configTerm[x]
  BY <2>8, <2>3, <3>1, <3>5, SendConfig_Fact_OtherConfigVars
<6>6. configVersion'[x] = configVersion[x]
  BY <2>8, <2>3, <3>1, <3>5, SendConfig_Fact_OtherConfigVars
<6>7. currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <4>3, <6>1, <6>2, <6>3, <6>4, <6>5, <6>6
<6>8. QED
  BY <6>7
<5>3. QED
  BY <5>1, <5>2
<4>8. \E n \in Q :
        currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <4>3, <4>7
<4>9. QED
  BY <4>8
<3>6. QED
  BY <3>4, <3>5
<2>11. \A x \in Server :
         \A y \in Server :
           \A Q \in Quorums(config'[x]) :
             \E n \in Q :
               currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
PROOF
<3>1. TAKE x \in Server
<3>2. TAKE y \in Server
<3>3. TAKE Q \in Quorums(config'[x])
<3>4. PICK n \in Q :
        currentTerm'[n] >= currentTerm'[y]
        \/ configTerm'[n] > configTerm'[x]
        \/ /\ configTerm'[n] = configTerm'[x]
           /\ configVersion'[n] > configVersion'[x]
  BY <2>10, <3>1, <3>2, <3>3
<3>5. currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <3>4 DEF IsNewerConfig
<3>6. \E n \in Q :
        currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <3>4, <3>5
<3>7. QED
  BY <3>6
<2>12. StrConj_10'
  BY <2>11, StrConj_10_Primed_Intro
<2>13. QED
  BY <2>12
<1>2. QED
  BY <1>1

THEOREM SendConfigAction_Preserves_StrConj_11 == IndAuto /\ SendConfigAction => StrConj_11'
PROOF
<1>1. ASSUME IndAuto /\ SendConfigAction
      PROVE StrConj_11'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. SendConfigAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : SendConfig(s, t)
  BY <2>2 DEF SendConfigAction
<2>4. configTerm' = [configTerm EXCEPT ![t] = configTerm[s]]
  BY <2>3 DEF SendConfig
<2>5. configVersion' = [configVersion EXCEPT ![t] = configVersion[s]]
  BY <2>3 DEF SendConfig
<2>6. config' = [config EXCEPT ![t] = config[s]]
  BY <2>3 DEF SendConfig
<2>7. TypeOK
  BY <2>1 DEF IndAuto
<2>8. \A x \in Server :
        \A y \in Server :
          (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
PROOF
<3>1. TAKE x \in Server
<3>2. TAKE y \in Server
<3>3. CASE x = t /\ y = t
PROOF
<4>1. config'[x] = config'[y]
  BY <3>3
<4>2. (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
  BY <4>1
<4>3. QED
  BY <4>2
<3>4. CASE x = t /\ y # t
PROOF
<4>1. ASSUME /\ configTerm'[x] = configTerm'[y]
              /\ configVersion'[x] = configVersion'[y]
      PROVE config'[x] = config'[y]
PROOF
<5>1. configTerm'[x] = configTerm[s]
  BY <2>7, <2>3, <3>4, SendConfig_Fact_TargetConfigVars
<5>2. configVersion'[x] = configVersion[s]
  BY <2>7, <2>3, <3>4, SendConfig_Fact_TargetConfigVars
<5>3. configTerm'[y] = configTerm[y]
  BY <2>7, <2>3, <3>4, SendConfig_Fact_OtherConfigVars
<5>4. configVersion'[y] = configVersion[y]
  BY <2>7, <2>3, <3>4, SendConfig_Fact_OtherConfigVars
<5>5. (configTerm[s] = configTerm[y] /\ configVersion[s] = configVersion[y]) => config[s] = config[y]
  BY <2>1 DEF IndAuto, StrConj_11
<5>6. config[s] = config[y]
  BY <4>1, <5>1, <5>2, <5>3, <5>4, <5>5
<5>7. config'[x] = config[s]
  BY <2>7, <2>3, <3>4, SendConfig_Fact_TargetConfigVars
<5>8. config'[y] = config[y]
  BY <2>7, <2>3, <3>4, SendConfig_Fact_OtherConfigVars
<5>9. config'[x] = config'[y]
  BY <5>6, <5>7, <5>8
<5>10. QED
  BY <5>9
<4>2. (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
  BY <4>1
<4>3. QED
  BY <4>2
<3>5. CASE x # t /\ y = t
PROOF
<4>1. ASSUME /\ configTerm'[x] = configTerm'[y]
              /\ configVersion'[x] = configVersion'[y]
      PROVE config'[x] = config'[y]
PROOF
<5>1. configTerm'[x] = configTerm[x]
  BY <2>7, <2>3, <3>5, SendConfig_Fact_OtherConfigVars
<5>2. configVersion'[x] = configVersion[x]
  BY <2>7, <2>3, <3>5, SendConfig_Fact_OtherConfigVars
<5>3. configTerm'[y] = configTerm[s]
  BY <2>7, <2>3, <3>5, SendConfig_Fact_TargetConfigVars
<5>4. configVersion'[y] = configVersion[s]
  BY <2>7, <2>3, <3>5, SendConfig_Fact_TargetConfigVars
<5>5. (configTerm[x] = configTerm[s] /\ configVersion[x] = configVersion[s]) => config[x] = config[s]
  BY <2>1 DEF IndAuto, StrConj_11
<5>6. config[x] = config[s]
  BY <4>1, <5>1, <5>2, <5>3, <5>4, <5>5
<5>7. config'[x] = config[x]
  BY <2>7, <2>3, <3>5, SendConfig_Fact_OtherConfigVars
<5>8. config'[y] = config[s]
  BY <2>7, <2>3, <3>5, SendConfig_Fact_TargetConfigVars
<5>9. config'[x] = config'[y]
  BY <5>6, <5>7, <5>8
<5>10. QED
  BY <5>9
<4>2. (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
  BY <4>1
<4>3. QED
  BY <4>2
<3>6. CASE x # t /\ y # t
PROOF
<4>1. configTerm'[x] = configTerm[x]
  BY <2>7, <2>3, <3>6, SendConfig_Fact_OtherConfigVars
<4>2. configVersion'[x] = configVersion[x]
  BY <2>7, <2>3, <3>6, SendConfig_Fact_OtherConfigVars
<4>3. config'[x] = config[x]
  BY <2>7, <2>3, <3>6, SendConfig_Fact_OtherConfigVars
<4>4. configTerm'[y] = configTerm[y]
  BY <2>7, <2>3, <3>6, SendConfig_Fact_OtherConfigVars
<4>5. configVersion'[y] = configVersion[y]
  BY <2>7, <2>3, <3>6, SendConfig_Fact_OtherConfigVars
<4>6. config'[y] = config[y]
  BY <2>7, <2>3, <3>6, SendConfig_Fact_OtherConfigVars
<4>7. (configTerm[x] = configTerm[y] /\ configVersion[x] = configVersion[y]) => config[x] = config[y]
  BY <2>1 DEF IndAuto, StrConj_11
<4>8. (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
  BY <4>1, <4>2, <4>3, <4>4, <4>5, <4>6, <4>7
<4>9. QED
  BY <4>8
<3>7. (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
  BY <3>3, <3>4, <3>5, <3>6
<3>8. QED
  BY <3>7
<2>9. StrConj_11'
  BY <2>8 DEF StrConj_11
<2>10. QED
  BY <2>9
<1>2. QED
  BY <1>1

THEOREM SendConfigAction_Preserves_StrConj_13 == IndAuto /\ SendConfigAction => StrConj_13'
PROOF
<1>1. ASSUME IndAuto /\ SendConfigAction
      PROVE StrConj_13'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. SendConfigAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : SendConfig(s, t)
  BY <2>2 DEF SendConfigAction
<2>4. UNCHANGED <<currentTerm, state>>
  BY <2>3 DEF SendConfig
<2>5. configTerm' = [configTerm EXCEPT ![t] = configTerm[s]]
  BY <2>3 DEF SendConfig
<2>6. configVersion' = [configVersion EXCEPT ![t] = configVersion[s]]
  BY <2>3 DEF SendConfig
<2>7. TypeOK
  BY <2>1 DEF IndAuto
<2>8. \A x \in Server :
        state'[x] = Primary =>
          \A y \in Server :
            configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
PROOF
<3>1. TAKE x \in Server
<3>2. state' = state
  BY <2>2, SendConfigAction_Fact_Frame_State
<3>3. CASE x = t
PROOF
<4>1. state[t] = Secondary
  BY <2>3 DEF SendConfig
<4>2. state'[x] = Secondary
  BY <3>2, <3>3, <4>1
<4>3. state'[x] # Primary
  BY <4>2, BenchmarkAssumption_PrimarySecondaryDistinct
<4>4. state'[x] = Primary => \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <4>3
<4>5. QED
  BY <4>4
<3>4. CASE x # t
PROOF
<4>1. configTerm'[x] = configTerm[x]
  BY <2>7, <2>3, <3>1, <3>4, SendConfig_Fact_OtherConfigVars
<4>2. configVersion'[x] = configVersion[x]
  BY <2>7, <2>3, <3>1, <3>4, SendConfig_Fact_OtherConfigVars
<4>3. ASSUME state'[x] = Primary
      PROVE \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
PROOF
<5>1. state[x] = Primary
  BY <3>2, <4>3
<5>2. state[x] = Primary => \A z \in Server : configTerm[z] # configTerm[x] \/ configVersion[z] <= configVersion[x]
  BY <2>1 DEF IndAuto, StrConj_13
<5>3. \A z \in Server : configTerm[z] # configTerm[x] \/ configVersion[z] <= configVersion[x]
  BY <5>1, <5>2
<5>4. TAKE y \in Server
<5>5. CASE y = t
PROOF
<6>1. configTerm'[y] = configTerm[s]
  BY <2>7, <2>3, <5>4, <5>5, SendConfig_Fact_TargetConfigVars
<6>2. configVersion'[y] = configVersion[s]
  BY <2>7, <2>3, <5>4, <5>5, SendConfig_Fact_TargetConfigVars
<6>3. configTerm[s] # configTerm[x] \/ configVersion[s] <= configVersion[x]
  BY <5>3
<6>4. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <4>1, <4>2, <6>1, <6>2, <6>3
<6>5. QED
  BY <6>4
<5>6. CASE y # t
PROOF
<6>1. configTerm'[y] = configTerm[y]
  BY <2>7, <2>3, <5>4, <5>6, SendConfig_Fact_OtherConfigVars
<6>2. configVersion'[y] = configVersion[y]
  BY <2>7, <2>3, <5>4, <5>6, SendConfig_Fact_OtherConfigVars
<6>3. configTerm[y] # configTerm[x] \/ configVersion[y] <= configVersion[x]
  BY <5>3, <5>4
<6>4. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <4>1, <4>2, <6>1, <6>2, <6>3
<6>5. QED
  BY <6>4
<5>7. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <5>5, <5>6
<5>8. QED
  BY <5>7
<4>4. state'[x] = Primary => \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <4>3
<4>5. QED
  BY <4>4
<3>5. state'[x] = Primary => \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <3>3, <3>4
<3>6. QED
  BY <3>5
<2>9. QED
  BY <2>8, StrConj_13_Primed_Intro
<1>2. QED
  BY <1>1

THEOREM BecomeLeaderAction_Preserves_TypeOK == IndAuto /\ BecomeLeaderAction => TypeOK'
PROOF
<1>1. ASSUME IndAuto /\ BecomeLeaderAction
      PROVE TypeOK'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. BecomeLeaderAction
  BY <1>1
<2>3. PICK i \in Server : \E Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>2 DEF BecomeLeaderAction
<2>4. PICK Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>3
<2>5. LET newTerm == currentTerm[i] + 1 IN
        currentTerm' = [s \in Server |-> IF s \in Q THEN newTerm ELSE currentTerm[s]]
  BY <2>4 DEF BecomeLeader
<2>6. state' = [s \in Server |->
                  IF s = i THEN Primary
                  ELSE IF s \in Q THEN Secondary
                  ELSE state[s]]
  BY <2>4 DEF BecomeLeader
<2>7. configTerm' = [configTerm EXCEPT ![i] = currentTerm[i] + 1]
  BY <2>4 DEF BecomeLeader
<2>8. TypeOK
  BY <2>1 DEF IndAuto
<2>9. config' = config
  BY <2>2, BecomeLeaderAction_Fact_Frame_Config
<2>10. configVersion' = configVersion
  BY <2>2, BecomeLeaderAction_Fact_Frame_ConfigVersion
<2>11. TypeOK'
  BY <2>5, <2>6, <2>7, <2>8, <2>9, <2>10 DEF TypeOK
<2>12. QED
  BY <2>11
<1>2. QED
  BY <1>1

THEOREM BecomeLeaderAction_Preserves_Safety == IndAuto /\ BecomeLeaderAction => Safety'
PROOF
<1>1. ASSUME IndAuto /\ BecomeLeaderAction
      PROVE Safety'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. BecomeLeaderAction
  BY <1>1
<2>3. PICK i \in Server : \E Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>2 DEF BecomeLeaderAction
<2>4. PICK Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>3
<2>5. currentTerm' = [s \in Server |-> IF s \in Q THEN currentTerm[i] + 1 ELSE currentTerm[s]]
  BY <2>4 DEF BecomeLeader
<2>6. state' = [s \in Server |->
                  IF s = i THEN Primary
                  ELSE IF s \in Q THEN Secondary
                  ELSE state[s]]
  BY <2>4 DEF BecomeLeader
<2>7. i \in Q
  BY <2>4 DEF BecomeLeader
<2>8. Safety'
PROOF
<3>1. \A x, y \in Server :
        (/\ state'[x] = Primary
         /\ state'[y] = Primary
         /\ currentTerm'[x] = currentTerm'[y]) => x = y
PROOF
<4>1. TAKE x \in Server, y \in Server
<4>2. CASE x = i
PROOF
<5>1. ASSUME /\ state'[x] = Primary
              /\ state'[y] = Primary
              /\ currentTerm'[x] = currentTerm'[y]
      PROVE x = y
PROOF
<6>1. currentTerm'[x] = currentTerm[i] + 1
  BY <2>5, <2>7, <4>2
<6>2. CASE y = i
PROOF
<7>1. x = y
  BY <4>2, <6>2
<7>2. QED
  BY <7>1
<6>3. CASE y # i
PROOF
<7>1. CASE y \in Q
PROOF
<8>1. state'[y] = Secondary
  BY <2>6, <6>3, <7>1
<8>2. state'[y] # Primary
  BY <8>1, BenchmarkAssumption_PrimarySecondaryDistinct
<8>3. FALSE
  BY <5>1, <8>2
<8>4. x = y
  BY <8>3
<8>5. QED
  BY <8>4
<7>2. CASE y \notin Q
PROOF
<8>1. currentTerm'[y] = currentTerm[y]
  BY <2>5, <7>2
<8>2. currentTerm[y] < currentTerm[i] + 1
  BY <2>1, <2>4, <6>3, BecomeLeader_Fact_NewTerm_Exceeds_AllCurrentTerms
<8>3. currentTerm'[x] # currentTerm'[y]
  BY <6>1, <8>1, <8>2
<8>4. FALSE
  BY <5>1, <8>3
<8>5. x = y
  BY <8>4
<8>6. QED
  BY <8>5
<7>3. x = y
  BY <7>1, <7>2
<7>4. QED
  BY <7>3
<6>4. x = y
  BY <6>2, <6>3
<6>5. QED
  BY <6>4
<5>2. QED
  BY <5>1
<4>3. CASE x # i
PROOF
<5>1. ASSUME /\ state'[x] = Primary
              /\ state'[y] = Primary
              /\ currentTerm'[x] = currentTerm'[y]
      PROVE x = y
PROOF
<6>1. CASE x \in Q
PROOF
<7>1. state'[x] = Secondary
  BY <2>6, <4>3, <6>1
<7>2. state'[x] # Primary
  BY <7>1, BenchmarkAssumption_PrimarySecondaryDistinct
<7>3. FALSE
  BY <5>1, <7>2
<7>4. x = y
  BY <7>3
<7>5. QED
  BY <7>4
<6>2. CASE x \notin Q
PROOF
<7>1. state[x] = Primary
  BY <2>6, <4>3, <6>2, <5>1
<7>2. currentTerm'[x] = currentTerm[x]
  BY <2>5, <6>2
<7>3. CASE y = i
PROOF
<8>1. currentTerm'[y] = currentTerm[i] + 1
  BY <2>5, <2>7, <7>3
<8>2. currentTerm[x] < currentTerm[i] + 1
  BY <2>1, <2>4, <4>3, BecomeLeader_Fact_NewTerm_Exceeds_AllCurrentTerms
<8>3. currentTerm'[x] # currentTerm'[y]
  BY <7>2, <8>1, <8>2
<8>4. FALSE
  BY <5>1, <8>3
<8>5. x = y
  BY <8>4
<8>6. QED
  BY <8>5
<7>4. CASE y # i
PROOF
<8>1. CASE y \in Q
PROOF
<9>1. state'[y] = Secondary
  BY <2>6, <7>4, <8>1
<9>2. state'[y] # Primary
  BY <9>1, BenchmarkAssumption_PrimarySecondaryDistinct
<9>3. FALSE
  BY <5>1, <9>2
<9>4. x = y
  BY <9>3
<9>5. QED
  BY <9>4
<8>2. CASE y \notin Q
PROOF
<9>1. state[y] = Primary
  BY <2>6, <7>4, <8>2, <5>1
<9>2. currentTerm'[y] = currentTerm[y]
  BY <2>5, <8>2
<9>3. currentTerm[x] = currentTerm[y]
  BY <5>1, <7>2, <9>2
<9>4. x = y
  BY <2>1, <4>1, <7>1, <9>1, <9>3 DEF IndAuto, Safety, OnePrimaryPerTerm
<9>5. QED
  BY <9>4
<8>3. x = y
  BY <8>1, <8>2
<8>4. QED
  BY <8>3
<7>5. x = y
  BY <7>3, <7>4
<7>6. QED
  BY <7>5
<6>3. x = y
  BY <6>1, <6>2
<6>4. QED
  BY <6>3
<5>2. QED
  BY <5>1
<4>4. (/\ state'[x] = Primary
        /\ state'[y] = Primary
        /\ currentTerm'[x] = currentTerm'[y]) => x = y
  BY <4>2, <4>3
<4>5. QED
  BY <4>4
<3>2. OnePrimaryPerTerm'
  BY <3>1, OnePrimaryPerTerm_Primed_Intro
<3>3. QED
  BY <3>2, Safety_Primed_Intro
<2>9. QED
  BY <2>8
<1>2. QED
  BY <1>1

THEOREM BecomeLeaderAction_Preserves_StrConj_0 == IndAuto /\ BecomeLeaderAction => StrConj_0'
PROOF
<1>1. ASSUME IndAuto /\ BecomeLeaderAction
      PROVE StrConj_0'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. BecomeLeaderAction
  BY <1>1
<2>3. PICK i \in Server : \E Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>2 DEF BecomeLeaderAction
<2>4. PICK Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>3
<2>5. UNCHANGED <<config, configVersion>>
  BY <2>4 DEF BecomeLeader
<2>6. \A x \in Server : configVersion'[x] >= 1
PROOF
<3>1. TAKE x \in Server
<3>2. configVersion' = configVersion
  BY <2>2, BecomeLeaderAction_Fact_Frame_ConfigVersion
<3>3. configVersion[x] >= 1
  BY <2>1 DEF IndAuto, StrConj_0
<3>4. configVersion'[x] >= 1
  BY <3>2, <3>3
<3>5. QED
  BY <3>4
<2>7. QED
  BY <2>6, StrConj_0_Primed_Intro
<1>2. QED
  BY <1>1

THEOREM BecomeLeaderAction_Preserves_StrConj_5 == IndAuto /\ BecomeLeaderAction => StrConj_5'
PROOF
<1>1. ASSUME IndAuto /\ BecomeLeaderAction
      PROVE StrConj_5'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. BecomeLeaderAction
  BY <1>1
<2>3. PICK i \in Server : \E Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>2 DEF BecomeLeaderAction
<2>4. PICK Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>3
<2>5. currentTerm' = [s \in Server |-> IF s \in Q THEN currentTerm[i] + 1 ELSE currentTerm[s]]
  BY <2>4 DEF BecomeLeader
<2>6. configTerm' = [configTerm EXCEPT ![i] = currentTerm[i] + 1]
  BY <2>4 DEF BecomeLeader
<2>7. config' = config
  BY <2>2, BecomeLeaderAction_Fact_Frame_Config
<2>8. TypeOK
  BY <2>1 DEF IndAuto
<2>9. configTerm \in [Server -> Nat]
  BY <2>8 DEF TypeOK
<2>10. \A x \in Server :
          \E u \in config'[x] : currentTerm'[u] >= configTerm'[x]
PROOF
<3>1. TAKE x \in Server
<3>2. CASE x = i
PROOF
<4>1. i \in Q
  BY <2>4 DEF BecomeLeader
<4>2. i \in config'[x]
  BY <2>4, <2>7, <3>2 DEF BecomeLeader
<4>3. currentTerm'[i] = currentTerm[i] + 1
  BY <2>5, <4>1
<4>4. configTerm'[x] = currentTerm[i] + 1
  BY <2>9, <2>6, <3>1, <3>2
<4>5. TypeOK'
  BY <1>1, BecomeLeaderAction_Preserves_TypeOK
<4>6. currentTerm'[i] \in Nat
  BY <2>3, <4>5 DEF TypeOK
<4>7. currentTerm'[i] = configTerm'[x]
  BY <4>3, <4>4
<4>8. currentTerm'[i] >= configTerm'[x]
  BY <4>6, <4>7, Nat_Geq_Reflexive
<4>9. \E u \in config'[x] : currentTerm'[u] >= configTerm'[x]
  BY <4>2, <4>8
<4>10. QED
  BY <4>9
<3>3. CASE x # i
PROOF
<4>1. PICK witness \in config[x] : currentTerm[witness] >= configTerm[x]
  BY <2>1 DEF IndAuto, StrConj_5
<4>2. witness \in Server
  BY <2>8, <3>1, <4>1 DEF TypeOK
<4>3. witness \in config'[x]
  BY <2>7, <3>3, <4>1
<4>4. currentTerm'[witness] >= currentTerm[witness]
  BY <2>8, <2>2, <4>2, BecomeLeaderAction_Fact_CurrentTerm_Nondecreasing
<4>5. configTerm'[x] = configTerm[x]
  BY <2>9, <2>6, <3>1, <3>3
<4>6. TypeOK'
  BY <1>1, BecomeLeaderAction_Preserves_TypeOK
<4>7. /\ currentTerm'[witness] \in Nat
       /\ currentTerm[witness] \in Nat
       /\ configTerm'[x] \in Nat
  BY <2>8, <3>1, <4>2, <4>5, <4>6 DEF TypeOK
<4>8. currentTerm[witness] >= configTerm'[x]
  BY <4>1, <4>5
<4>9. currentTerm'[witness] >= configTerm'[x]
  BY <4>4, <4>7, <4>8, Nat_Geq_Transitive
<4>10. \E u \in config'[x] : currentTerm'[u] >= configTerm'[x]
  BY <4>3, <4>9
<4>11. QED
  BY <4>10
<3>4. \E u \in config'[x] : currentTerm'[u] >= configTerm'[x]
  BY <3>2, <3>3
<3>5. QED
  BY <3>4
<2>11. QED
  BY <2>10, StrConj_5_Primed_Intro
<1>2. QED
  BY <1>1

THEOREM BecomeLeaderAction_Preserves_StrConj_6 == IndAuto /\ BecomeLeaderAction => StrConj_6'
PROOF
<1>1. ASSUME IndAuto /\ BecomeLeaderAction
      PROVE StrConj_6'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. BecomeLeaderAction
  BY <1>1
<2>3. PICK i \in Server : \E Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>2 DEF BecomeLeaderAction
<2>4. PICK Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>3
<2>5. currentTerm' = [s \in Server |-> IF s \in Q THEN currentTerm[i] + 1 ELSE currentTerm[s]]
  BY <2>4 DEF BecomeLeader
<2>6. state' = [s \in Server |->
                  IF s = i THEN Primary
                  ELSE IF s \in Q THEN Secondary
                  ELSE state[s]]
  BY <2>4 DEF BecomeLeader
<2>7. configTerm' = [configTerm EXCEPT ![i] = currentTerm[i] + 1]
  BY <2>4 DEF BecomeLeader
<2>8. TypeOK
  BY <2>1 DEF IndAuto
<2>9. configTerm \in [Server -> Nat]
  BY <2>8 DEF TypeOK
<2>10. \A x \in Server :
          state'[x] = Primary => configTerm'[x] = currentTerm'[x]
PROOF
<3>1. TAKE x \in Server
<3>2. CASE x = i
PROOF
<4>1. i \in Q
  BY <2>4 DEF BecomeLeader
<4>2. currentTerm'[x] = currentTerm[i] + 1
  BY <2>5, <3>2, <4>1
<4>3. configTerm'[x] = currentTerm[i] + 1
  BY <2>9, <2>7, <3>1, <3>2
<4>4. state'[x] = Primary => configTerm'[x] = currentTerm'[x]
  BY <4>2, <4>3
<4>5. QED
  BY <4>4
<3>3. CASE x # i
PROOF
<4>1. CASE x \in Q
PROOF
<5>1. state'[x] = Secondary
  BY <2>6, <3>3, <4>1
<5>2. state'[x] # Primary
  BY <5>1, BenchmarkAssumption_PrimarySecondaryDistinct
<5>3. state'[x] = Primary => configTerm'[x] = currentTerm'[x]
  BY <5>2
<5>4. QED
  BY <5>3
<4>2. CASE x \notin Q
PROOF
<5>1. currentTerm'[x] = currentTerm[x]
  BY <2>5, <4>2
<5>2. state'[x] = state[x]
  BY <2>6, <3>3, <4>2
<5>3. configTerm'[x] = configTerm[x]
  BY <2>9, <2>7, <3>1, <3>3
<5>4. state[x] = Primary => configTerm[x] = currentTerm[x]
  BY <2>1 DEF IndAuto, StrConj_6
<5>5. state'[x] = Primary => configTerm'[x] = currentTerm'[x]
  BY <5>1, <5>2, <5>3, <5>4
<5>6. QED
  BY <5>5
<4>3. state'[x] = Primary => configTerm'[x] = currentTerm'[x]
  BY <4>1, <4>2
<4>4. QED
  BY <4>3
<3>4. state'[x] = Primary => configTerm'[x] = currentTerm'[x]
  BY <3>2, <3>3
<3>5. QED
  BY <3>4
<2>11. QED
  BY <2>10, StrConj_6_Primed_Intro
<1>2. QED
  BY <1>1

THEOREM BecomeLeaderAction_Preserves_StrConj_8 == IndAuto /\ BecomeLeaderAction => StrConj_8'
PROOF
<1>1. ASSUME IndAuto /\ BecomeLeaderAction
      PROVE StrConj_8'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. BecomeLeaderAction
  BY <1>1
<2>3. PICK i \in Server : \E Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>2 DEF BecomeLeaderAction
<2>4. PICK Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>3
<2>5. UNCHANGED <<config, configVersion>>
  BY <2>4 DEF BecomeLeader
<2>6. \A x, y \in Server :
        QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)' \/ ConfigDisabled(y)'
PROOF
<3>1. TAKE x \in Server, y \in Server
<3>2. configVersion' = configVersion
  BY <2>2, BecomeLeaderAction_Fact_Frame_ConfigVersion
<3>3. configTerm' = [configTerm EXCEPT ![i] = currentTerm[i] + 1]
  BY <2>4 DEF BecomeLeader
<3>4. config' = config
  BY <2>2, BecomeLeaderAction_Fact_Frame_Config
<3>5. QuorumsOverlap(config[x], config[y]) \/ ConfigDisabled(x) \/ ConfigDisabled(y)
  BY <2>1 DEF IndAuto, StrConj_8
<3>6. CASE x = i /\ y = i
PROOF
<4>1. QuorumsOverlap(config[i], config[i]) \/ ConfigDisabled(i) \/ ConfigDisabled(i)
  BY <2>1 DEF IndAuto, StrConj_8
<4>2. CASE QuorumsOverlap(config[i], config[i])
PROOF
<5>1. config'[x] = config[i]
  BY <3>4, <3>6
<5>2. config'[y] = config[i]
  BY <3>4, <3>6
<5>3. QuorumsOverlap(config'[x], config'[y])
  BY <4>2, <5>1, <5>2
<5>4. QED
  BY <5>3
<4>3. CASE ConfigDisabled(i)
PROOF
<5>1. FALSE
  BY <2>1, <2>4, <4>3, BecomeLeader_Fact_LeaderNotDisabled DEF IndAuto
<5>2. QED
  BY <5>1
<4>4. QED
  BY <4>1, <4>2, <4>3
<3>7. CASE x = i /\ y # i
PROOF
<4>1. QuorumsOverlap(config[i], config[y]) \/ ConfigDisabled(i) \/ ConfigDisabled(y)
  BY <2>1 DEF IndAuto, StrConj_8
<4>2. ~ ConfigDisabled(i)
  BY <2>1, <2>4, BecomeLeader_Fact_LeaderNotDisabled DEF IndAuto
<4>3. QuorumsOverlap(config[i], config[y]) \/ ConfigDisabled(y)
  BY <4>1, <4>2
<4>4. QuorumsOverlap(config'[i], config'[y]) \/ ConfigDisabled(y)'
  BY <2>1, <2>4, <3>2, <3>7, <4>3, BecomeLeader_Fact_LeaderOverlapOrOtherDisabledPreserved
<4>5. config'[x] = config'[i]
  BY <3>7
<4>6. QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(y)'
  BY <4>4, <4>5
<4>7. QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)' \/ ConfigDisabled(y)'
  BY <4>6
<4>8. QED
  BY <4>7
<3>8. CASE x # i /\ y = i
PROOF
<4>1. QuorumsOverlap(config[x], config[i]) \/ ConfigDisabled(x) \/ ConfigDisabled(i)
  BY <2>1 DEF IndAuto, StrConj_8
<4>2. ~ ConfigDisabled(i)
  BY <2>1, <2>4, BecomeLeader_Fact_LeaderNotDisabled DEF IndAuto
<4>3. QuorumsOverlap(config[x], config[i]) \/ ConfigDisabled(x)
  BY <4>1, <4>2
<4>4. QuorumsOverlap(config'[x], config'[i]) \/ ConfigDisabled(x)'
  BY <2>1, <2>4, <3>1, <3>8, <4>3, BecomeLeader_Fact_OtherOverlapOrOtherDisabledPreserved
<4>5. config'[y] = config'[i]
  BY <3>8
<4>6. QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)'
  BY <4>4, <4>5
<4>7. QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)' \/ ConfigDisabled(y)'
  BY <4>6
<4>8. QED
  BY <4>7
<3>9. CASE x # i /\ y # i
PROOF
<4>1. QuorumsOverlap(config[x], config[y]) \/ ConfigDisabled(x) \/ ConfigDisabled(y)
  BY <3>5
<4>2. CASE QuorumsOverlap(config[x], config[y])
PROOF
<5>1. config'[x] = config[x]
  BY <3>4, <3>9
<5>2. config'[y] = config[y]
  BY <3>4, <3>9
<5>3. QuorumsOverlap(config'[x], config'[y])
  BY <4>2, <5>1, <5>2
<5>4. QED
  BY <5>3
<4>3. CASE ConfigDisabled(x)
PROOF
<5>1. ConfigDisabled(x)'
  BY <2>1, <2>4, <3>1, <3>9, <4>3, BecomeLeader_Fact_OtherDisabledPreserved
<5>2. QED
  BY <5>1
<4>4. CASE ConfigDisabled(y)
PROOF
<5>1. ConfigDisabled(y)'
  BY <2>1, <2>4, <3>1, <3>9, <4>4, BecomeLeader_Fact_OtherDisabledPreserved
<5>2. QED
  BY <5>1
<4>5. QED
  BY <4>1, <4>2, <4>3, <4>4
<3>10. QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)' \/ ConfigDisabled(y)'
  BY <3>6, <3>7, <3>8, <3>9
<3>11. QED
  BY <3>10
<2>7. QED
  BY <2>6, StrConj_8_Primed_Intro
<1>2. QED
  BY <1>1

THEOREM BecomeLeaderAction_Preserves_StrConj_10 == IndAuto /\ BecomeLeaderAction => StrConj_10'
PROOF
<1>1. SUFFICES ASSUME IndAuto, BecomeLeaderAction PROVE StrConj_10'
  BY SMT
<1>2. IndAuto
  BY <1>1
<1>3. BecomeLeaderAction
  BY <1>1
<1>4. PICK i \in Server : \E Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <1>3 DEF BecomeLeaderAction
<1>5. PICK Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <1>4
<1>6. currentTerm' = [s \in Server |-> IF s \in Q THEN currentTerm[i] + 1 ELSE currentTerm[s]]
  BY <1>5 DEF BecomeLeader
<1>7. configTerm' = [configTerm EXCEPT ![i] = currentTerm[i] + 1]
  BY <1>5 DEF BecomeLeader
<1>8. config' = config
  BY <1>3, BecomeLeaderAction_Fact_Frame_Config
<1>9. configVersion' = configVersion
  BY <1>3, BecomeLeaderAction_Fact_Frame_ConfigVersion
<1>10. TypeOK
  BY <1>2 DEF IndAuto
<1>11. config \in [Server -> SUBSET Server]
  BY <1>10 DEF TypeOK
<1>12. configTerm \in [Server -> Nat]
  BY <1>10 DEF TypeOK
<1>13. ~ ConfigDisabled(i)
  BY <1>10, <1>4, <1>5, BecomeLeader_Fact_LeaderNotDisabled
<1>14. \A x, y \in Server :
          \A R \in Quorums(config'[x]) :
            \E n \in R :
              currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
PROOF
<2>1. TAKE x \in Server, y \in Server
<2>2. TAKE R \in Quorums(config'[x])
<2>3. CASE x = i
PROOF
<3>1. R \in Quorums(config[i])
  BY <1>8, <2>2, <2>3
<3>2. QuorumsOverlap(config[i], config[i]) \/ ConfigDisabled(i) \/ ConfigDisabled(i)
  BY <1>2 DEF IndAuto, StrConj_8
<3>3. QuorumsOverlap(config[i], config[i])
  BY <1>13, <3>2
<3>4. Q \cap R # {}
  BY <1>5, <3>1, <3>3 DEF QuorumsOverlap
<3>5. PICK n \in Q \cap R : TRUE
  BY <3>4
<3>6. n \in R
  BY <3>5
<3>7. n \in Q
  BY <3>5
<3>8. currentTerm'[n] = currentTerm[i] + 1
  BY <1>6, <1>11, <1>5, <3>7 DEF Quorums
<3>9. ASSUME y \in Q
      PROVE \E n \in R :
              currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
PROOF
<4>1. currentTerm'[y] = currentTerm[i] + 1
  BY <1>6, <3>9
<4>2. TypeOK'
  BY <1>1, BecomeLeaderAction_Preserves_TypeOK
<4>3. currentTerm' \in [Server -> Nat]
  BY <4>2 DEF TypeOK
<4>4. currentTerm'[y] \in Nat
  BY <2>1, <4>3
<4>5. currentTerm'[n] = currentTerm'[y]
  BY <3>8, <4>1
<4>6. currentTerm'[y] >= currentTerm'[y]
  BY <4>4, Nat_Geq_Reflexive
<4>7. currentTerm'[n] >= currentTerm'[y]
  BY <4>5, <4>6
<4>8. \E m \in R :
         currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <3>6, <4>7
<4>9. QED
  BY <4>8
<3>10. ASSUME y \notin Q
       PROVE \E n \in R :
               currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
PROOF
<4>1. currentTerm'[y] = currentTerm[y]
  BY <1>6, <3>10
<4>2. currentTerm[y] < currentTerm[i] + 1
  BY <1>2, <1>4, <1>5, <2>1, BecomeLeader_Fact_NewTerm_Exceeds_AllCurrentTerms
<4>3. currentTerm'[n] >= currentTerm'[y]
  BY <3>8, <4>1, <4>2
<4>4. \E m \in R :
         currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <3>6, <4>3
<4>5. QED
  BY <4>4
<3>11. y \in Q \/ y \notin Q
  BY SMT
<3>12. \E m \in R :
         currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <3>9, <3>10, <3>11
<3>13. QED
  BY <3>12
<2>4. CASE x # i
PROOF
<3>1. R \in Quorums(config[x])
  BY <1>8, <2>2
<3>2. configTerm'[x] = configTerm[x]
  BY <1>7, <1>12, <2>1, <2>4
<3>3. configVersion'[x] = configVersion[x]
  BY <1>9
<3>4. CASE y \in Q
PROOF
<4>1. currentTerm'[y] = currentTerm[i] + 1
  BY <1>6, <3>4
<4>2. QuorumsOverlap(config[x], config[i]) \/ ConfigDisabled(x) \/ ConfigDisabled(i)
  BY <1>2 DEF IndAuto, StrConj_8
<4>3. ASSUME QuorumsOverlap(config[x], config[i])
      PROVE \E n \in R :
              currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
PROOF
<5>1. Q \cap R # {}
  BY <1>5, <3>1, <4>3 DEF QuorumsOverlap
<5>2. PICK n \in Q \cap R : TRUE
  BY <5>1
<5>3. n \in R
  BY <5>2
<5>4. n \in Q
  BY <5>2
<5>5. currentTerm'[n] = currentTerm[i] + 1
  BY <1>6, <1>11, <1>5, <5>4 DEF Quorums
<5>6. TypeOK'
  BY <1>1, BecomeLeaderAction_Preserves_TypeOK
<5>7. currentTerm' \in [Server -> Nat]
  BY <5>6 DEF TypeOK
<5>8. currentTerm'[y] \in Nat
  BY <2>1, <5>7
<5>9. currentTerm'[n] = currentTerm'[y]
  BY <4>1, <5>5
<5>10. currentTerm'[y] >= currentTerm'[y]
  BY <5>8, Nat_Geq_Reflexive
<5>11. currentTerm'[n] >= currentTerm'[y]
  BY <5>9, <5>10
<5>12. \E m \in R :
         currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <5>3, <5>11
<5>13. QED
  BY <5>12
<4>4. ASSUME ConfigDisabled(x)
      PROVE \E m \in R :
              currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
PROOF
<5>1. PICK n \in R : NewerConfig(CV(n), CV(x))
  BY <3>1, <4>4 DEF ConfigDisabled
<5>2. ASSUME n = i
      PROVE \E m \in R :
              currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
PROOF
<6>1. configTerm'[n] = currentTerm[i] + 1
  BY <1>2, <1>5, <5>2, BecomeLeader_Fact_TargetConfigTerm
<6>2. configTerm[x] < currentTerm[i] + 1
  BY <1>2, <1>4, <1>5, <2>1, BecomeLeader_Fact_NewTerm_Exceeds_AllConfigTerms
<6>3. configTerm'[n] > configTerm'[x]
  BY <3>2, <5>2, <6>1, <6>2
<6>4. IsNewerConfig(n, x)'
  BY <6>3 DEF IsNewerConfig
<6>5. currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <6>4
<6>6. \E m \in R :
         currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <5>1, <6>5
<6>7. QED
  BY <6>6
<5>3. ASSUME n # i
      PROVE \E m \in R :
              currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
PROOF
<6>1. configTerm'[n] = configTerm[n]
  BY <1>7, <1>11, <1>12, <3>1, <5>1, <5>3 DEF Quorums
<6>2. configVersion'[n] = configVersion[n]
  BY <1>9
<6>3. configTerm[n] > configTerm[x]
      \/ /\ configTerm[n] = configTerm[x]
         /\ configVersion[n] > configVersion[x]
  BY <5>1 DEF CV, NewerConfig
<6>4. IsNewerConfig(n, x)'
  BY <3>2, <3>3, <6>1, <6>2, <6>3 DEF IsNewerConfig
<6>5. currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <6>4
<6>6. \E m \in R :
         currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <5>1, <6>5
<6>7. QED
  BY <6>6
<5>4. n = i \/ n # i
  BY SMT
<5>5. \E m \in R :
         currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <5>2, <5>3, <5>4
<5>6. QED
  BY <5>5
<4>5. ~ ConfigDisabled(i)
  BY <1>13
<4>6. QuorumsOverlap(config[x], config[i]) \/ ConfigDisabled(x)
  BY <4>2, <4>5
<4>7. ASSUME QuorumsOverlap(config[x], config[i])
      PROVE \E n \in R :
              currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
PROOF
<5>1. \E n \in R :
         currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <4>3, <4>7
<5>2. QED
  BY <5>1
<4>8. ASSUME ConfigDisabled(x)
      PROVE \E n \in R :
              currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
PROOF
<5>1. \E n \in R :
         currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <4>4, <4>8
<5>2. QED
  BY <5>1
<4>9. \E n \in R :
         currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <4>6, <4>7, <4>8
<4>10. QED
  BY <4>9
<3>5. CASE y \notin Q
PROOF
<4>1. currentTerm'[y] = currentTerm[y]
  BY <1>6, <3>5
<4>2. PICK n \in R :
       currentTerm[n] >= currentTerm[y] \/ IsNewerConfig(n, x)
  BY <1>2, <2>1, <3>1 DEF IndAuto, StrConj_10, QuorumsAt
<4>3. n \in Server
  BY <2>1, <1>10, <3>1, <4>2 DEF TypeOK, Quorums
<4>4. ASSUME currentTerm[n] >= currentTerm[y]
      PROVE \E m \in R :
              currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
PROOF
<5>1. TypeOK'
  BY <1>1, BecomeLeaderAction_Preserves_TypeOK
<5>2. currentTerm' \in [Server -> Nat]
  BY <5>1 DEF TypeOK
<5>3. /\ currentTerm'[n] \in Nat
       /\ currentTerm[n] \in Nat
       /\ currentTerm'[y] \in Nat
  BY <1>10, <2>1, <4>3, <5>2 DEF TypeOK
<5>4. currentTerm[n] >= currentTerm'[y]
  BY <4>1, <4>4
<5>5. currentTerm'[n] >= currentTerm[n]
  BY <1>10, <1>3, <4>3, BecomeLeaderAction_Fact_CurrentTerm_Nondecreasing
<5>6. currentTerm'[n] >= currentTerm'[y]
  BY <5>3, <5>4, <5>5, Nat_Geq_Transitive
<5>7. currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <5>6
<5>8. \E m \in R :
         currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <4>2, <5>7
<5>9. QED
  BY <5>8
<4>5. ASSUME IsNewerConfig(n, x)
      PROVE \E m \in R :
              currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
PROOF
<5>1. CASE n = i
PROOF
<6>1. configTerm'[n] = currentTerm[i] + 1
  BY <1>2, <1>5, <5>1, BecomeLeader_Fact_TargetConfigTerm
<6>2. configTerm[x] < currentTerm[i] + 1
  BY <1>2, <1>4, <1>5, <2>1, BecomeLeader_Fact_NewTerm_Exceeds_AllConfigTerms
<6>3. configTerm'[n] > configTerm'[x]
  BY <3>2, <6>1, <6>2
<6>4. IsNewerConfig(n, x)'
  BY <6>3 DEF IsNewerConfig
<6>5. currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <6>4
<6>6. \E m \in R :
         currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <4>2, <6>5
<6>7. QED
  BY <6>6
<5>2. CASE n # i
PROOF
<6>1. configTerm'[n] = configTerm[n]
  BY <1>7, <1>12, <4>3, <5>2
<6>2. configVersion'[n] = configVersion[n]
  BY <1>9
<6>3. IsNewerConfig(n, x)'
  BY <3>2, <3>3, <6>1, <6>2, <4>5 DEF IsNewerConfig
<6>4. currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <6>3
<6>5. \E m \in R :
         currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <4>2, <6>4
<6>6. QED
  BY <6>5
<5>3. QED
  BY <5>1, <5>2
<4>6. \E n \in R :
        currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <4>2, <4>4, <4>5
<4>7. QED
  BY <4>6
<3>6. CASE y \in Q
PROOF
<4>1. \E n \in R :
         currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <3>4, <3>6
<4>2. QED
  BY <4>1
<3>7. CASE y \notin Q
PROOF
<4>1. \E n \in R :
         currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <3>5, <3>7
<4>2. QED
  BY <4>1
<3>8. y \in Q \/ y \notin Q
  BY SMT
<3>9. \E n \in R :
        currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <3>6, <3>7, <3>8
<3>10. QED
  BY <3>9
<2>5. ASSUME x = i \/ x # i
      PROVE \E n \in R :
              currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
PROOF
<3>1. CASE x = i
PROOF
<4>1. \E n \in R :
         currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <2>3, <3>1
<4>2. QED
  BY <4>1
<3>2. CASE x # i
PROOF
<4>1. \E n \in R :
         currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <2>4, <3>2
<4>2. QED
  BY <4>1
<3>3. QED
  BY <2>5, <3>1, <3>2
<2>6. x = i \/ x # i
  BY SMT
<2>7. \E n \in R :
        currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <2>5, <2>6
<2>8. QED
  BY <2>7
<1>15. QED
  BY <1>14, StrConj_10_Primed_Intro

THEOREM BecomeLeaderAction_Preserves_StrConj_11 == IndAuto /\ BecomeLeaderAction => StrConj_11'
PROOF
<1>1. ASSUME IndAuto /\ BecomeLeaderAction
      PROVE StrConj_11'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. BecomeLeaderAction
  BY <1>1
<2>3. PICK i \in Server : \E Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>2, BecomeLeaderAction_Fact_Params
<2>4. PICK Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>3
<2>5. configTerm' = [configTerm EXCEPT ![i] = currentTerm[i] + 1]
  BY <2>4 DEF BecomeLeader
<2>6. UNCHANGED <<config, configVersion>>
  BY <2>4 DEF BecomeLeader
<2>7. \A x \in Server :
        \A y \in Server :
          (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
PROOF
<3>1. TAKE x \in Server
<3>2. TAKE y \in Server
<3>3. (configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]) => config'[x] = config'[y]
PROOF
<4>1. ASSUME configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]
      PROVE config'[x] = config'[y]
PROOF
<5>1. config' = config
  BY <2>6
<5>2. CASE /\ x = i
           /\ y = i
PROOF
<6>1. x = y
  BY <5>2
<6>2. config'[x] = config'[y]
  BY <6>1
<6>3. QED
  BY <6>2
<5>3. CASE /\ x = i
           /\ y # i
PROOF
<6>1. configTerm'[i] = configTerm'[y]
  BY <4>1, <5>3
<6>2. configTerm'[i] = currentTerm[i] + 1
  BY <2>1, <2>4, BecomeLeader_Fact_TargetConfigTerm
<6>3. configTerm'[y] = configTerm[y]
  BY <2>1, <2>4, <3>2, <5>3, BecomeLeader_Fact_OtherConfigTerm
<6>4. configTerm[y] # currentTerm[i] + 1
  BY <2>1, <2>4, <3>2, <5>3, BecomeLeader_Fact_OtherConfigTerm_DiffersFromNewTerm
<6>5. configTerm[y] = currentTerm[i] + 1
  BY <6>1, <6>2, <6>3
<6>6. FALSE
  BY <6>4, <6>5
<6>7. QED
  BY <6>6
<5>4. CASE /\ x # i
           /\ y = i
PROOF
<6>1. configTerm'[x] = configTerm'[i]
  BY <4>1, <5>4
<6>2. configTerm'[i] = currentTerm[i] + 1
  BY <2>1, <2>4, BecomeLeader_Fact_TargetConfigTerm
<6>3. configTerm'[x] = configTerm[x]
  BY <2>1, <2>4, <3>1, <5>4, BecomeLeader_Fact_OtherConfigTerm
<6>4. configTerm[x] # currentTerm[i] + 1
  BY <2>1, <2>4, <3>1, <5>4, BecomeLeader_Fact_OtherConfigTerm_DiffersFromNewTerm
<6>5. configTerm[x] = currentTerm[i] + 1
  BY <6>1, <6>2, <6>3
<6>6. FALSE
  BY <6>4, <6>5
<6>7. QED
  BY <6>6
<5>5. CASE /\ x # i
           /\ y # i
PROOF
<6>1. configTerm'[x] = configTerm[x]
  BY <2>1, <2>4, <3>1, <5>5, BecomeLeader_Fact_OtherConfigTerm
<6>2. configTerm'[y] = configTerm[y]
  BY <2>1, <2>4, <3>2, <5>5, BecomeLeader_Fact_OtherConfigTerm
<6>3. configTerm[x] = configTerm[y] /\ configVersion[x] = configVersion[y]
  BY <2>6, <4>1, <6>1, <6>2
<6>4. config[x] = config[y]
  BY <2>1, <3>1, <3>2, <6>3 DEF IndAuto, StrConj_11
<6>5. config'[x] = config'[y]
  BY <5>1, <6>4
<6>6. QED
  BY <6>5
<5>6. QED
  BY <5>2, <5>3, <5>4, <5>5
<4>2. QED
  BY <4>1
<3>4. QED
  BY <3>3
<2>8. StrConj_11'
  BY <2>7, StrConj_11_Primed_Intro
<2>9. QED
  BY <2>8
<1>2. QED
  BY <1>1

THEOREM BecomeLeaderAction_Preserves_StrConj_13 == IndAuto /\ BecomeLeaderAction => StrConj_13'
PROOF
<1>1. ASSUME IndAuto /\ BecomeLeaderAction
      PROVE StrConj_13'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. BecomeLeaderAction
  BY <1>1
<2>3. PICK i \in Server : \E Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>2, BecomeLeaderAction_Fact_Params
<2>4. PICK Q \in Quorums(config[i]) : BecomeLeader(i, Q)
  BY <2>3
<2>5. state' = [s \in Server |->
                  IF s = i THEN Primary
                  ELSE IF s \in Q THEN Secondary
                  ELSE state[s]]
  BY <2>4 DEF BecomeLeader
<2>6. configTerm' = [configTerm EXCEPT ![i] = currentTerm[i] + 1]
  BY <2>4 DEF BecomeLeader
<2>7. UNCHANGED <<config, configVersion>>
  BY <2>4 DEF BecomeLeader
<2>8. TypeOK'
  BY <1>1, BecomeLeaderAction_Preserves_TypeOK
<2>9. \A x \in Server : state'[x] = Primary => \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
PROOF
<3>1. TAKE x \in Server
<3>2. state'[x] = Primary => \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
PROOF
<4>1. ASSUME state'[x] = Primary
      PROVE \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
PROOF
<5>1. CASE x = i
PROOF
<6>1. TAKE y \in Server
<6>2. CASE y = i
PROOF
<7>1. y = x
  BY <5>1, <6>2
<7>2. configVersion' \in [Server -> Nat]
  BY <2>8 DEF TypeOK
<7>3. configVersion'[x] \in Nat
  BY <3>1, <7>2
<7>4. configVersion'[x] <= configVersion'[x]
  BY <7>3, SMT
<7>5. configVersion'[y] <= configVersion'[x]
  BY <7>1, <7>4
<7>6. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <7>5
<7>7. QED
  BY <7>6
<6>3. CASE y # i
PROOF
<7>1. configTerm'[y] = configTerm[y]
  BY <2>1, <2>4, <6>1, <6>3, BecomeLeader_Fact_OtherConfigTerm
<7>2. configTerm'[x] = currentTerm[i] + 1
  BY <2>1, <2>4, <5>1, BecomeLeader_Fact_TargetConfigTerm
<7>3. configTerm[y] # currentTerm[i] + 1
  BY <2>1, <2>4, <6>1, <6>3, BecomeLeader_Fact_OtherConfigTerm_DiffersFromNewTerm
<7>4. configTerm'[y] # configTerm'[x]
  BY <7>1, <7>2, <7>3
<7>5. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <7>4
<7>6. QED
  BY <7>5
<6>4. QED
  BY <6>2, <6>3
<5>2. CASE x # i
PROOF
<6>1. CASE x \in Q
PROOF
<7>1. state'[x] = Secondary
  BY <2>5, <5>2, <6>1
<7>2. Secondary = Primary
  BY <4>1, <7>1
<7>3. FALSE
  BY <7>2, BenchmarkAssumption_PrimarySecondaryDistinct
<7>4. QED
  BY <7>3
<6>2. CASE x \notin Q
PROOF
<7>1. state[x] = Primary
  BY <2>5, <4>1, <5>2, <6>2
<7>2. TAKE y \in Server
<7>3. CASE y = i
PROOF
<8>1. configTerm'[y] = currentTerm[i] + 1
  BY <2>1, <2>4, <7>3, BecomeLeader_Fact_TargetConfigTerm
<8>2. configTerm'[x] = configTerm[x]
  BY <2>1, <2>4, <3>1, <5>2, BecomeLeader_Fact_OtherConfigTerm
<8>3. configTerm[x] # currentTerm[i] + 1
  BY <2>1, <2>4, <3>1, <5>2, BecomeLeader_Fact_OtherConfigTerm_DiffersFromNewTerm
<8>4. configTerm'[y] # configTerm'[x]
  BY <8>1, <8>2, <8>3
<8>5. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <8>4
<8>6. QED
  BY <8>5
<7>4. CASE y # i
PROOF
<8>1. configTerm'[y] = configTerm[y]
  BY <2>1, <2>4, <7>2, <7>4, BecomeLeader_Fact_OtherConfigTerm
<8>2. configTerm'[x] = configTerm[x]
  BY <2>1, <2>4, <3>1, <5>2, BecomeLeader_Fact_OtherConfigTerm
<8>3. configTerm[y] # configTerm[x] \/ configVersion[y] <= configVersion[x]
  BY <2>1, <3>1, <7>2, <7>1 DEF IndAuto, StrConj_13
<8>4. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <2>7, <8>1, <8>2, <8>3
<8>5. QED
  BY <8>4
<7>5. QED
  BY <7>3, <7>4
<6>3. QED
  BY <6>1, <6>2
<5>3. QED
  BY <5>1, <5>2
<4>2. QED
  BY <4>1
<3>3. QED
  BY <3>2
<2>10. StrConj_13'
  BY <2>9, StrConj_13_Primed_Intro
<2>11. QED
  BY <2>10
<1>2. QED
  BY <1>1

THEOREM UpdateTermsAction_Preserves_TypeOK == IndAuto /\ UpdateTermsAction => TypeOK'
PROOF
<1>1. ASSUME IndAuto /\ UpdateTermsAction
      PROVE TypeOK'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. UpdateTermsAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : UpdateTerms(s, t)
  BY <2>2 DEF UpdateTermsAction
<2>4. currentTerm' = [currentTerm EXCEPT ![t] = currentTerm[s]]
  BY <2>3 DEF UpdateTerms, UpdateTermsExpr
<2>5. state' = [state EXCEPT ![t] = Secondary]
  BY <2>3 DEF UpdateTerms, UpdateTermsExpr
<2>6. TypeOK
  BY <2>1 DEF IndAuto
<2>7. configVersion' = configVersion
  BY <2>2, UpdateTermsAction_Fact_Frame_ConfigVersion
<2>8. configTerm' = configTerm
  BY <2>2, UpdateTermsAction_Fact_Frame_ConfigTerm
<2>9. config' = config
  BY <2>2, UpdateTermsAction_Fact_Frame_Config
<2>10. TypeOK'
  BY <2>4, <2>5, <2>6, <2>7, <2>8, <2>9 DEF TypeOK
<2>11. QED
  BY <2>10
<1>2. QED
  BY <1>1

THEOREM UpdateTermsAction_Preserves_Safety == IndAuto /\ UpdateTermsAction => Safety'
PROOF
<1>1. ASSUME IndAuto /\ UpdateTermsAction
      PROVE Safety'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. UpdateTermsAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : UpdateTerms(s, t)
  BY <2>2 DEF UpdateTermsAction
<2>4. currentTerm' = [currentTerm EXCEPT ![t] = currentTerm[s]]
  BY <2>3 DEF UpdateTerms, UpdateTermsExpr
<2>5. state' = [state EXCEPT ![t] = Secondary]
  BY <2>3 DEF UpdateTerms, UpdateTermsExpr
<2>6. TypeOK
  BY <2>1 DEF IndAuto
<2>7. Safety'
PROOF
<3>1. \A x \in Server :
        \A y \in Server :
          (/\ state'[x] = Primary
           /\ state'[y] = Primary
           /\ currentTerm'[x] = currentTerm'[y]) => x = y
PROOF
<4>1. TAKE x \in Server
<4>2. TAKE y \in Server
<4>3. CASE x = t
PROOF
<5>1. state'[t] = Secondary
  BY <2>6, <2>3, UpdateTerms_Fact_TargetTermState
<5>2. state'[x] = Secondary
  BY <4>3, <5>1
<5>3. (/\ state'[x] = Primary
        /\ state'[y] = Primary
        /\ currentTerm'[x] = currentTerm'[y]) => x = y
  BY <5>2, BenchmarkAssumption_PrimarySecondaryDistinct
<5>4. QED
  BY <5>3
<4>4. CASE x # t
PROOF
<5>1. currentTerm'[x] = currentTerm[x]
  BY <2>6, <2>3, <4>1, <4>4, UpdateTerms_Fact_OtherTermState
<5>2. state'[x] = state[x]
  BY <2>6, <2>3, <4>1, <4>4, UpdateTerms_Fact_OtherTermState
<5>3. CASE y = t
PROOF
<6>1. state'[t] = Secondary
  BY <2>6, <2>3, UpdateTerms_Fact_TargetTermState
<6>2. state'[y] = Secondary
  BY <5>3, <6>1
<6>3. (/\ state'[x] = Primary
        /\ state'[y] = Primary
        /\ currentTerm'[x] = currentTerm'[y]) => x = y
  BY <6>2, BenchmarkAssumption_PrimarySecondaryDistinct
<6>4. QED
  BY <6>3
<5>4. CASE y # t
PROOF
<6>1. currentTerm'[y] = currentTerm[y]
  BY <2>6, <2>3, <4>2, <5>4, UpdateTerms_Fact_OtherTermState
<6>2. state'[y] = state[y]
  BY <2>6, <2>3, <4>2, <5>4, UpdateTerms_Fact_OtherTermState
<6>3. (/\ state[x] = Primary
        /\ state[y] = Primary
        /\ currentTerm[x] = currentTerm[y]) => x = y
  BY <2>1 DEF IndAuto, Safety, OnePrimaryPerTerm
<6>4. (/\ state'[x] = Primary
        /\ state'[y] = Primary
        /\ currentTerm'[x] = currentTerm'[y]) => x = y
  BY <5>1, <5>2, <6>1, <6>2, <6>3
<6>5. QED
  BY <6>4
<5>5. (/\ state'[x] = Primary
        /\ state'[y] = Primary
        /\ currentTerm'[x] = currentTerm'[y]) => x = y
  BY <5>3, <5>4
<5>6. QED
  BY <5>5
<4>5. (/\ state'[x] = Primary
        /\ state'[y] = Primary
        /\ currentTerm'[x] = currentTerm'[y]) => x = y
  BY <4>3, <4>4
<4>6. QED
  BY <4>5
<3>2. OnePrimaryPerTerm'
  BY <3>1 DEF OnePrimaryPerTerm
<3>3. QED
  BY <3>2 DEF Safety
<2>8. QED
  BY <2>7
<1>2. QED
  BY <1>1

THEOREM UpdateTermsAction_Preserves_StrConj_0 == IndAuto /\ UpdateTermsAction => StrConj_0'
PROOF
<1>1. ASSUME IndAuto /\ UpdateTermsAction
      PROVE StrConj_0'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. UpdateTermsAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : UpdateTerms(s, t)
  BY <2>2 DEF UpdateTermsAction
<2>4. UNCHANGED <<configVersion, configTerm, config>>
  BY <2>3 DEF UpdateTerms
<2>5. \A x \in Server : configVersion'[x] >= 1
PROOF
<3>1. TAKE x \in Server
<3>2. configVersion' = configVersion
  BY <2>2, UpdateTermsAction_Fact_Frame_ConfigVersion
<3>3. configVersion[x] >= 1
  BY <2>1 DEF IndAuto, StrConj_0
<3>4. configVersion'[x] >= 1
  BY <3>2, <3>3
<3>5. QED
  BY <3>4
<2>6. StrConj_0'
  BY <2>5 DEF StrConj_0
<2>7. QED
  BY <2>6
<1>2. QED
  BY <1>1

THEOREM UpdateTermsAction_Preserves_StrConj_5 == IndAuto /\ UpdateTermsAction => StrConj_5'
PROOF
<1>1. ASSUME IndAuto /\ UpdateTermsAction
      PROVE StrConj_5'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. UpdateTermsAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : UpdateTerms(s, t)
  BY <2>2 DEF UpdateTermsAction
<2>4. currentTerm' = [currentTerm EXCEPT ![t] = currentTerm[s]]
  BY <2>3 DEF UpdateTerms, UpdateTermsExpr
<2>5. configTerm' = configTerm
  BY <2>2, UpdateTermsAction_Fact_Frame_ConfigTerm
<2>6. config' = config
  BY <2>2, UpdateTermsAction_Fact_Frame_Config
<2>7. \A x \in Server : \E u \in config'[x] : currentTerm'[u] >= configTerm'[x]
PROOF
<3>1. TAKE x \in Server
<3>2. PICK witness \in config[x] : currentTerm[witness] >= configTerm[x]
  BY <2>1 DEF IndAuto, StrConj_5
<3>3. TypeOK
  BY <2>1 DEF IndAuto
<3>4. TypeOK'
  BY <1>1, UpdateTermsAction_Preserves_TypeOK
<3>5. witness \in Server
  BY <3>1, <3>2, <3>3 DEF TypeOK
<3>6. currentTerm[witness] \in Nat
  BY <3>3, <3>5 DEF TypeOK
<3>7. currentTerm'[witness] \in Nat
  BY <3>4, <3>5 DEF TypeOK
<3>8. configTerm[x] \in Nat
  BY <3>1, <3>3 DEF TypeOK
<3>9. currentTerm'[witness] >= currentTerm[witness]
  BY <2>1, <2>2, <3>5, UpdateTermsAction_Fact_CurrentTerm_Nondecreasing
<3>10. witness \in config'[x]
  BY <2>6, <3>2
<3>11. configTerm'[x] = configTerm[x]
  BY <2>5
<3>12. currentTerm[witness] >= configTerm[x]
  BY <3>2
<3>13. currentTerm'[witness] >= configTerm[x]
  BY <3>6, <3>7, <3>8, <3>9, <3>12, Nat_Geq_Transitive
<3>14. currentTerm'[witness] >= configTerm'[x]
  BY <3>11, <3>13
<3>15. \E u \in config'[x] : currentTerm'[u] >= configTerm'[x]
  BY <3>10, <3>14
<3>16. QED
  BY <3>15
<2>8. StrConj_5'
  BY <2>7 DEF StrConj_5
<2>9. QED
  BY <2>8
<1>2. QED
  BY <1>1

THEOREM UpdateTermsAction_Preserves_StrConj_6 == IndAuto /\ UpdateTermsAction => StrConj_6'
PROOF
<1>1. ASSUME IndAuto /\ UpdateTermsAction
      PROVE StrConj_6'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. UpdateTermsAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : UpdateTerms(s, t)
  BY <2>2 DEF UpdateTermsAction
<2>4. currentTerm' = [currentTerm EXCEPT ![t] = currentTerm[s]]
  BY <2>3 DEF UpdateTerms, UpdateTermsExpr
<2>5. state' = [state EXCEPT ![t] = Secondary]
  BY <2>3 DEF UpdateTerms, UpdateTermsExpr
<2>6. configTerm' = configTerm
  BY <2>2, UpdateTermsAction_Fact_Frame_ConfigTerm
<2>7. TypeOK
  BY <2>1 DEF IndAuto
<2>8. \A x \in Server : state'[x] = Primary => configTerm'[x] = currentTerm'[x]
PROOF
<3>1. TAKE x \in Server
<3>2. CASE x = t
PROOF
<4>1. state'[x] = Secondary
  BY <2>7, <2>3, <3>1, <3>2, UpdateTerms_Fact_TargetTermState
<4>2. ASSUME state'[x] = Primary
      PROVE configTerm'[x] = currentTerm'[x]
PROOF
<5>1. Secondary = Primary
  BY <4>1, <4>2
<5>2. FALSE
  BY <5>1, BenchmarkAssumption_PrimarySecondaryDistinct
<5>3. QED
  BY <5>2
<4>3. state'[x] = Primary => configTerm'[x] = currentTerm'[x]
  BY <4>2
<4>4. QED
  BY <4>3
<3>3. CASE x # t
PROOF
<4>1. state'[x] = state[x]
  BY <2>5, <2>7, <3>1, <3>3 DEF TypeOK
<4>2. currentTerm'[x] = currentTerm[x]
  BY <2>4, <2>7, <3>1, <3>3 DEF TypeOK
<4>3. configTerm'[x] = configTerm[x]
  BY <2>6
<4>4. state[x] = Primary => configTerm[x] = currentTerm[x]
  BY <2>1 DEF IndAuto, StrConj_6
<4>5. state'[x] = Primary => configTerm'[x] = currentTerm'[x]
  BY <4>1, <4>2, <4>3, <4>4
<4>6. QED
  BY <4>5
<3>4. state'[x] = Primary => configTerm'[x] = currentTerm'[x]
  BY <3>2, <3>3
<3>5. QED
  BY <3>4
<2>9. StrConj_6'
  BY <2>8 DEF StrConj_6
<2>10. QED
  BY <2>9
<1>2. QED
  BY <1>1

THEOREM UpdateTermsAction_Preserves_StrConj_8 == IndAuto /\ UpdateTermsAction => StrConj_8'
PROOF
<1>1. ASSUME IndAuto /\ UpdateTermsAction
      PROVE StrConj_8'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. UpdateTermsAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : UpdateTerms(s, t)
  BY <2>2 DEF UpdateTermsAction
<2>4. UNCHANGED <<configVersion, configTerm, config>>
  BY <2>3 DEF UpdateTerms
<2>5. \A x \in Server :
        \A y \in Server :
          QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)' \/ ConfigDisabled(y)'
PROOF
<3>1. TAKE x \in Server
<3>2. TAKE y \in Server
<3>3. configVersion' = configVersion
  BY <2>2, UpdateTermsAction_Fact_Frame_ConfigVersion
<3>4. configTerm' = configTerm
  BY <2>2, UpdateTermsAction_Fact_Frame_ConfigTerm
<3>5. config' = config
  BY <2>2, UpdateTermsAction_Fact_Frame_Config
<3>6. QuorumsOverlap(config[x], config[y]) \/ ConfigDisabled(x) \/ ConfigDisabled(y)
  BY <2>1 DEF IndAuto, StrConj_8
<3>7. QuorumsOverlap(config'[x], config'[y]) \/ ConfigDisabled(x)' \/ ConfigDisabled(y)'
  BY <3>3, <3>4, <3>5, <3>6 DEF ConfigDisabled, CV
<3>8. QED
  BY <3>7
<2>6. StrConj_8'
  BY <2>5 DEF StrConj_8
<2>7. QED
  BY <2>6
<1>2. QED
  BY <1>1

THEOREM UpdateTermsAction_Preserves_StrConj_10 == IndAuto /\ UpdateTermsAction => StrConj_10'
PROOF
<1>1. ASSUME IndAuto /\ UpdateTermsAction
      PROVE StrConj_10'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. UpdateTermsAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : UpdateTerms(s, t)
  BY <2>2 DEF UpdateTermsAction
<2>4. TypeOK
  BY <2>1 DEF IndAuto
<2>5. TypeOK'
  BY <1>1, UpdateTermsAction_Preserves_TypeOK
<2>6. configVersion' = configVersion
  BY <2>2, UpdateTermsAction_Fact_Frame_ConfigVersion
<2>7. configTerm' = configTerm
  BY <2>2, UpdateTermsAction_Fact_Frame_ConfigTerm
<2>8. config' = config
  BY <2>2, UpdateTermsAction_Fact_Frame_Config
<2>9. \A x \in Server :
        \A y \in Server :
          \A Q \in QuorumsAt(x)' :
            \E n \in Q : currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
PROOF
<3>1. TAKE x \in Server
<3>2. TAKE y \in Server
<3>3. TAKE Q \in QuorumsAt(x)'
<3>4. Q \in Quorums(config'[x])
  BY <3>3 DEF QuorumsAt
<3>5. config'[x] = config[x]
  BY <2>8
<3>6. Q \in Quorums(config[x])
  BY <3>4, <3>5
<3>7. Q \in QuorumsAt(x)
  BY <3>6 DEF QuorumsAt
<3>8. CASE y = t
PROOF
<4>1. PICK n \in Q : currentTerm[n] >= currentTerm[s] \/ IsNewerConfig(n, x)
  BY <2>1, <3>1, <3>7 DEF IndAuto, StrConj_10, QuorumsAt
<4>2. n \in Server
  BY <2>4, <3>1, <3>7, <4>1 DEF TypeOK, QuorumsAt, Quorums
<4>3. currentTerm'[n] \in Nat
  BY <2>5, <4>2 DEF TypeOK
<4>4. currentTerm'[n] >= currentTerm[n]
  BY <2>1, <2>2, <4>2, UpdateTermsAction_Fact_CurrentTerm_Nondecreasing
<4>5. currentTerm[n] \in Nat
  BY <2>4, <4>2 DEF TypeOK
<4>6. currentTerm[s] \in Nat
  BY <2>4 DEF TypeOK
<4>7. currentTerm'[t] = currentTerm[s]
  BY <2>4, <2>3, UpdateTerms_Fact_TargetTermState
<4>8. currentTerm'[y] = currentTerm[s]
  BY <3>2, <3>8, <4>7
<4>9. ASSUME currentTerm[n] >= currentTerm[s]
      PROVE \E m \in Q : currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
PROOF
<5>1. currentTerm'[n] >= currentTerm[s]
  BY <4>3, <4>4, <4>5, <4>6, <4>9, Nat_Geq_Transitive
<5>2. currentTerm'[n] >= currentTerm'[y]
  BY <4>8, <5>1
<5>3. currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <5>2
<5>4. \E m \in Q : currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <4>1, <5>2
<5>5. QED
  BY <5>4
<4>10. ASSUME IsNewerConfig(n, x)
      PROVE \E m \in Q : currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
PROOF
<5>1. IsNewerConfig(n, x)' <=> IsNewerConfig(n, x)
  BY <2>2, <3>1, <4>2, UpdateTermsAction_Fact_Frame_IsNewerConfig
<5>2. IsNewerConfig(n, x)'
  BY <4>10, <5>1
<5>3. currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <5>2
<5>4. \E m \in Q : currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <4>1, <5>3
<5>5. QED
  BY <5>4
<4>11. \E m \in Q : currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <4>1, <4>9, <4>10
<4>12. QED
  BY <4>11
<3>9. CASE y # t
PROOF
<4>1. PICK n \in Q : currentTerm[n] >= currentTerm[y] \/ IsNewerConfig(n, x)
  BY <2>1, <3>1, <3>2, <3>7 DEF IndAuto, StrConj_10, QuorumsAt
<4>2. n \in Server
  BY <2>4, <3>1, <3>7, <4>1 DEF TypeOK, QuorumsAt, Quorums
<4>3. currentTerm'[n] \in Nat
  BY <2>5, <4>2 DEF TypeOK
<4>4. currentTerm'[n] >= currentTerm[n]
  BY <2>1, <2>2, <4>2, UpdateTermsAction_Fact_CurrentTerm_Nondecreasing
<4>5. currentTerm'[y] = currentTerm[y]
  BY <2>4, <2>3, <3>2, <3>9, UpdateTerms_Fact_OtherTermState
<4>6. currentTerm[n] \in Nat
  BY <2>4, <3>2, <4>2 DEF TypeOK
<4>7. currentTerm[y] \in Nat
  BY <2>4, <3>2 DEF TypeOK
<4>8. ASSUME currentTerm[n] >= currentTerm[y]
      PROVE \E m \in Q : currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
PROOF
<5>1. currentTerm'[n] >= currentTerm[y]
  BY <4>3, <4>4, <4>6, <4>7, <4>8, Nat_Geq_Transitive
<5>2. currentTerm'[n] >= currentTerm'[y]
  BY <4>5, <5>1
<5>3. currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <5>2
<5>4. \E m \in Q : currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <4>1, <5>3
<5>5. QED
  BY <5>4
<4>9. ASSUME IsNewerConfig(n, x)
      PROVE \E m \in Q : currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
PROOF
<5>1. IsNewerConfig(n, x)' <=> IsNewerConfig(n, x)
  BY <2>2, <3>1, <4>2, UpdateTermsAction_Fact_Frame_IsNewerConfig
<5>2. IsNewerConfig(n, x)'
  BY <4>9, <5>1
<5>3. currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <5>2
<5>4. \E m \in Q : currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <4>1, <5>3
<5>5. QED
  BY <5>4
<4>10. \E m \in Q : currentTerm'[m] >= currentTerm'[y] \/ IsNewerConfig(m, x)'
  BY <4>1, <4>8, <4>9
<4>11. QED
  BY <4>10
<3>10. \E n \in Q : currentTerm'[n] >= currentTerm'[y] \/ IsNewerConfig(n, x)'
  BY <3>8, <3>9
<3>11. QED
  BY <3>10
<2>10. StrConj_10'
  BY <2>9 DEF StrConj_10
<2>11. QED
  BY <2>10
<1>2. QED
  BY <1>1

THEOREM UpdateTermsAction_Preserves_StrConj_11 == IndAuto /\ UpdateTermsAction => StrConj_11'
PROOF
<1>1. ASSUME IndAuto /\ UpdateTermsAction
      PROVE StrConj_11'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. UpdateTermsAction
  BY <1>1
<2>3. \A x \in Server :
        \A y \in Server :
          configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y] =>
            config'[x] = config'[y]
PROOF
<3>1. TAKE x \in Server
<3>2. TAKE y \in Server
<3>3. ASSUME configTerm'[x] = configTerm'[y] /\ configVersion'[x] = configVersion'[y]
      PROVE config'[x] = config'[y]
PROOF
<4>1. configTerm' = configTerm
  BY <2>2, UpdateTermsAction_Fact_Frame_ConfigTerm
<4>2. configVersion' = configVersion
  BY <2>2, UpdateTermsAction_Fact_Frame_ConfigVersion
<4>3. config' = config
  BY <2>2, UpdateTermsAction_Fact_Frame_Config
<4>4. configTerm[x] = configTerm[y] /\ configVersion[x] = configVersion[y]
  BY <3>3, <4>1, <4>2
<4>5. config[x] = config[y]
  BY <2>1, <3>1, <3>2, <4>4 DEF IndAuto, StrConj_11
<4>6. config'[x] = config'[y]
  BY <4>3, <4>5
<4>7. QED
  BY <4>6
<3>4. QED
  BY <3>3
<2>4. StrConj_11'
  BY <2>3 DEF StrConj_11
<2>5. QED
  BY <2>4
<1>2. QED
  BY <1>1

THEOREM UpdateTermsAction_Preserves_StrConj_13 == IndAuto /\ UpdateTermsAction => StrConj_13'
PROOF
<1>1. ASSUME IndAuto /\ UpdateTermsAction
      PROVE StrConj_13'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. UpdateTermsAction
  BY <1>1
<2>3. PICK s \in Server, t \in Server : UpdateTerms(s, t)
  BY <2>2 DEF UpdateTermsAction
<2>4. TypeOK
  BY <2>1 DEF IndAuto
<2>5. configVersion' = configVersion
  BY <2>2, UpdateTermsAction_Fact_Frame_ConfigVersion
<2>6. configTerm' = configTerm
  BY <2>2, UpdateTermsAction_Fact_Frame_ConfigTerm
<2>7. \A x \in Server :
        state'[x] = Primary => \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
PROOF
<3>1. TAKE x \in Server
<3>2. CASE x = t
PROOF
<4>1. state'[x] = Secondary
  BY <2>4, <2>3, <3>1, <3>2, UpdateTerms_Fact_TargetTermState
<4>2. ASSUME state'[x] = Primary
      PROVE \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
PROOF
<5>1. Secondary = Primary
  BY <4>1, <4>2
<5>2. FALSE
  BY <5>1, BenchmarkAssumption_PrimarySecondaryDistinct
<5>3. TAKE y \in Server
<5>4. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <5>2
<5>5. QED
  BY <5>4
<4>3. state'[x] = Primary => \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <4>2
<4>4. QED
  BY <4>3
<3>3. CASE x # t
PROOF
<4>1. state'[x] = state[x]
  BY <2>4, <2>3, <3>1, <3>3, UpdateTerms_Fact_OtherTermState
<4>2. state[x] = Primary => \A y \in Server : configTerm[y] # configTerm[x] \/ configVersion[y] <= configVersion[x]
  BY <2>1 DEF IndAuto, StrConj_13
<4>3. ASSUME state'[x] = Primary
      PROVE \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
PROOF
<5>1. state[x] = Primary
  BY <4>1, <4>3
<5>2. \A y \in Server : configTerm[y] # configTerm[x] \/ configVersion[y] <= configVersion[x]
  BY <4>2, <5>1
<5>3. TAKE y \in Server
<5>4. configTerm'[y] = configTerm[y]
  BY <2>6
<5>5. configVersion'[y] = configVersion[y]
  BY <2>5
<5>6. configTerm'[x] = configTerm[x]
  BY <2>6
<5>7. configVersion'[x] = configVersion[x]
  BY <2>5
<5>8. configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <5>2, <5>3, <5>4, <5>5, <5>6, <5>7
<5>9. QED
  BY <5>8
<4>4. state'[x] = Primary => \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <4>3
<4>5. QED
  BY <4>4
<3>4. state'[x] = Primary => \A y \in Server : configTerm'[y] # configTerm'[x] \/ configVersion'[y] <= configVersion'[x]
  BY <3>2, <3>3
<3>5. QED
  BY <3>4
<2>8. StrConj_13'
  BY <2>7 DEF StrConj_13
<2>9. QED
  BY <2>8
<1>2. QED
  BY <1>1

THEOREM Next_Preserves_TypeOK == IndAuto /\ Next => TypeOK'
PROOF
<1>1. ASSUME IndAuto /\ Next
      PROVE TypeOK'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. Next
  BY <1>1
<2>3. CASE ReconfigAction
PROOF
<3>1. IndAuto /\ ReconfigAction
  BY <2>1, <2>3
<3>2. TypeOK'
  BY <3>1, ReconfigAction_Preserves_TypeOK
<3>3. QED
  BY <3>2
<2>4. CASE SendConfigAction
PROOF
<3>1. IndAuto /\ SendConfigAction
  BY <2>1, <2>4
<3>2. TypeOK'
  BY <3>1, SendConfigAction_Preserves_TypeOK
<3>3. QED
  BY <3>2
<2>5. CASE BecomeLeaderAction
PROOF
<3>1. IndAuto /\ BecomeLeaderAction
  BY <2>1, <2>5
<3>2. TypeOK'
  BY <3>1, BecomeLeaderAction_Preserves_TypeOK
<3>3. QED
  BY <3>2
<2>6. CASE UpdateTermsAction
PROOF
<3>1. IndAuto /\ UpdateTermsAction
  BY <2>1, <2>6
<3>2. TypeOK'
  BY <3>1, UpdateTermsAction_Preserves_TypeOK
<3>3. QED
  BY <3>2
<2>7. TypeOK'
  BY <2>2, <2>3, <2>4, <2>5, <2>6 DEF Next
<2>8. QED
  BY <2>7
<1>2. QED
  BY <1>1

THEOREM Next_Preserves_Safety == IndAuto /\ Next => Safety'
PROOF
<1>1. ASSUME IndAuto /\ Next
      PROVE Safety'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. Next
  BY <1>1
<2>3. CASE ReconfigAction
PROOF
<3>1. IndAuto /\ ReconfigAction
  BY <2>1, <2>3
<3>2. Safety'
  BY <3>1, ReconfigAction_Preserves_Safety
<3>3. QED
  BY <3>2
<2>4. CASE SendConfigAction
PROOF
<3>1. IndAuto /\ SendConfigAction
  BY <2>1, <2>4
<3>2. Safety'
  BY <3>1, SendConfigAction_Preserves_Safety
<3>3. QED
  BY <3>2
<2>5. CASE BecomeLeaderAction
PROOF
<3>1. IndAuto /\ BecomeLeaderAction
  BY <2>1, <2>5
<3>2. Safety'
  BY <3>1, BecomeLeaderAction_Preserves_Safety
<3>3. QED
  BY <3>2
<2>6. CASE UpdateTermsAction
PROOF
<3>1. IndAuto /\ UpdateTermsAction
  BY <2>1, <2>6
<3>2. Safety'
  BY <3>1, UpdateTermsAction_Preserves_Safety
<3>3. QED
  BY <3>2
<2>7. Safety'
  BY <2>2, <2>3, <2>4, <2>5, <2>6 DEF Next
<2>8. QED
  BY <2>7
<1>2. QED
  BY <1>1

THEOREM Next_Preserves_StrConj_0 == IndAuto /\ Next => StrConj_0'
PROOF
<1>1. ASSUME IndAuto /\ Next
      PROVE StrConj_0'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. Next
  BY <1>1
<2>3. CASE ReconfigAction
PROOF
<3>1. IndAuto /\ ReconfigAction
  BY <2>1, <2>3
<3>2. StrConj_0'
  BY <3>1, ReconfigAction_Preserves_StrConj_0
<3>3. QED
  BY <3>2
<2>4. CASE SendConfigAction
PROOF
<3>1. IndAuto /\ SendConfigAction
  BY <2>1, <2>4
<3>2. StrConj_0'
  BY <3>1, SendConfigAction_Preserves_StrConj_0
<3>3. QED
  BY <3>2
<2>5. CASE BecomeLeaderAction
PROOF
<3>1. IndAuto /\ BecomeLeaderAction
  BY <2>1, <2>5
<3>2. StrConj_0'
  BY <3>1, BecomeLeaderAction_Preserves_StrConj_0
<3>3. QED
  BY <3>2
<2>6. CASE UpdateTermsAction
PROOF
<3>1. IndAuto /\ UpdateTermsAction
  BY <2>1, <2>6
<3>2. StrConj_0'
  BY <3>1, UpdateTermsAction_Preserves_StrConj_0
<3>3. QED
  BY <3>2
<2>7. StrConj_0'
  BY <2>2, <2>3, <2>4, <2>5, <2>6 DEF Next
<2>8. QED
  BY <2>7
<1>2. QED
  BY <1>1

THEOREM Next_Preserves_StrConj_5 == IndAuto /\ Next => StrConj_5'
PROOF
<1>1. ASSUME IndAuto /\ Next
      PROVE StrConj_5'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. Next
  BY <1>1
<2>3. CASE ReconfigAction
PROOF
<3>1. IndAuto /\ ReconfigAction
  BY <2>1, <2>3
<3>2. StrConj_5'
  BY <3>1, ReconfigAction_Preserves_StrConj_5
<3>3. QED
  BY <3>2
<2>4. CASE SendConfigAction
PROOF
<3>1. IndAuto /\ SendConfigAction
  BY <2>1, <2>4
<3>2. StrConj_5'
  BY <3>1, SendConfigAction_Preserves_StrConj_5
<3>3. QED
  BY <3>2
<2>5. CASE BecomeLeaderAction
PROOF
<3>1. IndAuto /\ BecomeLeaderAction
  BY <2>1, <2>5
<3>2. StrConj_5'
  BY <3>1, BecomeLeaderAction_Preserves_StrConj_5
<3>3. QED
  BY <3>2
<2>6. CASE UpdateTermsAction
PROOF
<3>1. IndAuto /\ UpdateTermsAction
  BY <2>1, <2>6
<3>2. StrConj_5'
  BY <3>1, UpdateTermsAction_Preserves_StrConj_5
<3>3. QED
  BY <3>2
<2>7. StrConj_5'
  BY <2>2, <2>3, <2>4, <2>5, <2>6 DEF Next
<2>8. QED
  BY <2>7
<1>2. QED
  BY <1>1

THEOREM Next_Preserves_StrConj_6 == IndAuto /\ Next => StrConj_6'
PROOF
<1>1. ASSUME IndAuto /\ Next
      PROVE StrConj_6'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. Next
  BY <1>1
<2>3. CASE ReconfigAction
PROOF
<3>1. IndAuto /\ ReconfigAction
  BY <2>1, <2>3
<3>2. StrConj_6'
  BY <3>1, ReconfigAction_Preserves_StrConj_6
<3>3. QED
  BY <3>2
<2>4. CASE SendConfigAction
PROOF
<3>1. IndAuto /\ SendConfigAction
  BY <2>1, <2>4
<3>2. StrConj_6'
  BY <3>1, SendConfigAction_Preserves_StrConj_6
<3>3. QED
  BY <3>2
<2>5. CASE BecomeLeaderAction
PROOF
<3>1. IndAuto /\ BecomeLeaderAction
  BY <2>1, <2>5
<3>2. StrConj_6'
  BY <3>1, BecomeLeaderAction_Preserves_StrConj_6
<3>3. QED
  BY <3>2
<2>6. CASE UpdateTermsAction
PROOF
<3>1. IndAuto /\ UpdateTermsAction
  BY <2>1, <2>6
<3>2. StrConj_6'
  BY <3>1, UpdateTermsAction_Preserves_StrConj_6
<3>3. QED
  BY <3>2
<2>7. StrConj_6'
  BY <2>2, <2>3, <2>4, <2>5, <2>6 DEF Next
<2>8. QED
  BY <2>7
<1>2. QED
  BY <1>1

THEOREM Next_Preserves_StrConj_8 == IndAuto /\ Next => StrConj_8'
PROOF
<1>1. ASSUME IndAuto /\ Next
      PROVE StrConj_8'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. Next
  BY <1>1
<2>3. CASE ReconfigAction
PROOF
<3>1. IndAuto /\ ReconfigAction
  BY <2>1, <2>3
<3>2. StrConj_8'
  BY <3>1, ReconfigAction_Preserves_StrConj_8
<3>3. QED
  BY <3>2
<2>4. CASE SendConfigAction
PROOF
<3>1. IndAuto /\ SendConfigAction
  BY <2>1, <2>4
<3>2. StrConj_8'
  BY <3>1, SendConfigAction_Preserves_StrConj_8
<3>3. QED
  BY <3>2
<2>5. CASE BecomeLeaderAction
PROOF
<3>1. IndAuto /\ BecomeLeaderAction
  BY <2>1, <2>5
<3>2. StrConj_8'
  BY <3>1, BecomeLeaderAction_Preserves_StrConj_8
<3>3. QED
  BY <3>2
<2>6. CASE UpdateTermsAction
PROOF
<3>1. IndAuto /\ UpdateTermsAction
  BY <2>1, <2>6
<3>2. StrConj_8'
  BY <3>1, UpdateTermsAction_Preserves_StrConj_8
<3>3. QED
  BY <3>2
<2>7. ReconfigAction \/ SendConfigAction \/ BecomeLeaderAction \/ UpdateTermsAction
  BY <2>2, Next_Fact_ActionCases
<2>8. StrConj_8'
  BY <2>7, <2>3, <2>4, <2>5, <2>6
<2>9. QED
  BY <2>8
<1>2. QED
  BY <1>1

THEOREM Next_Preserves_StrConj_10 == IndAuto /\ Next => StrConj_10'
PROOF
<1>1. ASSUME IndAuto /\ Next
      PROVE StrConj_10'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. Next
  BY <1>1
<2>3. CASE ReconfigAction
PROOF
<3>1. IndAuto /\ ReconfigAction
  BY <2>1, <2>3
<3>2. StrConj_10'
  BY <3>1, ReconfigAction_Preserves_StrConj_10
<3>3. QED
  BY <3>2
<2>4. CASE SendConfigAction
PROOF
<3>1. IndAuto /\ SendConfigAction
  BY <2>1, <2>4
<3>2. StrConj_10'
  BY <3>1, SendConfigAction_Preserves_StrConj_10
<3>3. QED
  BY <3>2
<2>5. CASE BecomeLeaderAction
PROOF
<3>1. IndAuto /\ BecomeLeaderAction
  BY <2>1, <2>5
<3>2. StrConj_10'
  BY <3>1, BecomeLeaderAction_Preserves_StrConj_10
<3>3. QED
  BY <3>2
<2>6. CASE UpdateTermsAction
PROOF
<3>1. IndAuto /\ UpdateTermsAction
  BY <2>1, <2>6
<3>2. StrConj_10'
  BY <3>1, UpdateTermsAction_Preserves_StrConj_10
<3>3. QED
  BY <3>2
<2>7. ReconfigAction \/ SendConfigAction \/ BecomeLeaderAction \/ UpdateTermsAction
  BY <2>2, Next_Fact_ActionCases
<2>8. StrConj_10'
  BY <2>7, <2>3, <2>4, <2>5, <2>6
<2>9. QED
  BY <2>8
<1>2. QED
  BY <1>1

THEOREM Next_Preserves_StrConj_11 == IndAuto /\ Next => StrConj_11'
PROOF
<1>1. ASSUME IndAuto /\ Next
      PROVE StrConj_11'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. Next
  BY <1>1
<2>3. CASE ReconfigAction
PROOF
<3>1. IndAuto /\ ReconfigAction
  BY <2>1, <2>3
<3>2. StrConj_11'
  BY <3>1, ReconfigAction_Preserves_StrConj_11
<3>3. QED
  BY <3>2
<2>4. CASE SendConfigAction
PROOF
<3>1. IndAuto /\ SendConfigAction
  BY <2>1, <2>4
<3>2. StrConj_11'
  BY <3>1, SendConfigAction_Preserves_StrConj_11
<3>3. QED
  BY <3>2
<2>5. CASE BecomeLeaderAction
PROOF
<3>1. IndAuto /\ BecomeLeaderAction
  BY <2>1, <2>5
<3>2. StrConj_11'
  BY <3>1, BecomeLeaderAction_Preserves_StrConj_11
<3>3. QED
  BY <3>2
<2>6. CASE UpdateTermsAction
PROOF
<3>1. IndAuto /\ UpdateTermsAction
  BY <2>1, <2>6
<3>2. StrConj_11'
  BY <3>1, UpdateTermsAction_Preserves_StrConj_11
<3>3. QED
  BY <3>2
<2>7. ReconfigAction \/ SendConfigAction \/ BecomeLeaderAction \/ UpdateTermsAction
  BY <2>2, Next_Fact_ActionCases
<2>8. StrConj_11'
  BY <2>7, <2>3, <2>4, <2>5, <2>6
<2>9. QED
  BY <2>8
<1>2. QED
  BY <1>1

THEOREM Next_Preserves_StrConj_13 == IndAuto /\ Next => StrConj_13'
PROOF
<1>1. ASSUME IndAuto /\ Next
      PROVE StrConj_13'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. Next
  BY <1>1
<2>3. CASE ReconfigAction
PROOF
<3>1. IndAuto /\ ReconfigAction
  BY <2>1, <2>3
<3>2. StrConj_13'
  BY <3>1, ReconfigAction_Preserves_StrConj_13
<3>3. QED
  BY <3>2
<2>4. CASE SendConfigAction
PROOF
<3>1. IndAuto /\ SendConfigAction
  BY <2>1, <2>4
<3>2. StrConj_13'
  BY <3>1, SendConfigAction_Preserves_StrConj_13
<3>3. QED
  BY <3>2
<2>5. CASE BecomeLeaderAction
PROOF
<3>1. IndAuto /\ BecomeLeaderAction
  BY <2>1, <2>5
<3>2. StrConj_13'
  BY <3>1, BecomeLeaderAction_Preserves_StrConj_13
<3>3. QED
  BY <3>2
<2>6. CASE UpdateTermsAction
PROOF
<3>1. IndAuto /\ UpdateTermsAction
  BY <2>1, <2>6
<3>2. StrConj_13'
  BY <3>1, UpdateTermsAction_Preserves_StrConj_13
<3>3. QED
  BY <3>2
<2>7. ReconfigAction \/ SendConfigAction \/ BecomeLeaderAction \/ UpdateTermsAction
  BY <2>2, Next_Fact_ActionCases
<2>8. StrConj_13'
  BY <2>7, <2>3, <2>4, <2>5, <2>6
<2>9. QED
  BY <2>8
<1>2. QED
  BY <1>1

THEOREM Init_Implies_IndAuto == Init => IndAuto
PROOF
<1>1. ASSUME Init
      PROVE IndAuto
PROOF
<2>1. TypeOK
  BY <1>1, Init_Implies_TypeOK
<2>2. Safety
  BY <1>1, Init_Implies_Safety
<2>3. StrConj_0
  BY <1>1, Init_Implies_StrConj_0
<2>4. StrConj_5
  BY <1>1, Init_Implies_StrConj_5
<2>5. StrConj_6
  BY <1>1, Init_Implies_StrConj_6
<2>6. StrConj_8
  BY <1>1, Init_Implies_StrConj_8
<2>7. StrConj_10
  BY <1>1, Init_Implies_StrConj_10
<2>8. StrConj_11
  BY <1>1, Init_Implies_StrConj_11
<2>9. StrConj_13
  BY <1>1, Init_Implies_StrConj_13
<2>10. QED
  BY <2>1, <2>2, <2>3, <2>4, <2>5, <2>6, <2>7, <2>8, <2>9 DEF IndAuto
<1>2. QED
  BY <1>1

THEOREM Next_Preserves_IndAuto == IndAuto /\ Next => IndAuto'
PROOF
<1>1. ASSUME IndAuto /\ Next
      PROVE IndAuto'
PROOF
<2>1. IndAuto
  BY <1>1
<2>2. Next
  BY <1>1
<2>3. TypeOK'
  BY <2>1, <2>2, Next_Preserves_TypeOK
<2>4. Safety'
  BY <2>1, <2>2, Next_Preserves_Safety
<2>5. StrConj_0'
  BY <2>1, <2>2, Next_Preserves_StrConj_0
<2>6. StrConj_5'
  BY <2>1, <2>2, Next_Preserves_StrConj_5
<2>7. StrConj_6'
  BY <2>1, <2>2, Next_Preserves_StrConj_6
<2>8. StrConj_8'
  BY <2>1, <2>2, Next_Preserves_StrConj_8
<2>9. StrConj_10'
  BY <2>1, <2>2, Next_Preserves_StrConj_10
<2>10. StrConj_11'
  BY <2>1, <2>2, Next_Preserves_StrConj_11
<2>11. StrConj_13'
  BY <2>1, <2>2, Next_Preserves_StrConj_13
<2>12. IndAuto'
  BY <2>3, <2>4, <2>5, <2>6, <2>7, <2>8, <2>9, <2>10, <2>11 DEF IndAuto
<2>13. QED
  BY <2>12
<1>2. QED
  BY <1>1

====
