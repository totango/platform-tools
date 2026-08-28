# PLAT Jira space — overview

**last_updated:** 2026-08-28

Abbreviated summary. **Canonical source:** [argocd-tele jira-space-organization.md](https://github.com/totango/argocd-tele/blob/main/workspace/docs/jira-space-organization.md).

## Hierarchy

```text
Epic (initiative — quarter / multi-month)
  └── Story (shippable outcome, 1–4 weeks)
        └── Task (work chunk, few days)
              └── Subtask (single PR / ticket-sized)
```

| Level | Use for |
|-------|---------|
| **Epic** | Theme spanning multiple stories (E01 Stargate/ArgoCD, E09 IKG, …) |
| **Story** | Demo-able outcome with acceptance criteria |
| **Task** | Phase-sized chunk inside a story |
| **Subtask** | One concrete deliverable / PR |

**Rule:** Acceptance criteria on **Story**; definition of done on **Tasks**.

## Epic map (E01–E10)

| Epic | Name |
|------|------|
| E01 | Platform hub — Teleport & ArgoCD |
| E02 | Atlantis & platform DNS (`odieplat.io`) |
| E03 | Reduce future work (RFW) |
| E04 | FinOps & cost hygiene (Zaha-led) |
| E05 | Security & compliance (SOC2) |
| E06 | Intake — findings & triage (quarterly) |
| E07 | Agent research & validation |
| E08 | Agent platform & lifecycle |
| E09 | Infra Knowledge Graph (IKG) & Zaha UI |
| E10 | Galva — modernization research & migration planning ([PLAT-96](https://catalystsoftware.atlassian.net/browse/PLAT-96)) |

Traceability labels: `plat-ref:E01` … `plat-ref:E10`, `plat-ref:100` for logical IDs.

**Galva (E10):** research/planning for modernizing older codebases — future repo `totango/platform-galva`; see [docs/research/galva-program.md](research/galva-program.md).

## Tooling in this repo

- [jira/rules/epic-preservation.yaml](../jira/rules/epic-preservation.yaml) — preserve epic structure on apply
- [jira/rules/dependency-rules.yaml](../jira/rules/dependency-rules.yaml) — seeded dependency hints
- [jira/scripts/jira-plan.sh](../jira/scripts/jira-plan.sh) — pull / synthesize / apply CLI (stub)

## Board

https://catalystsoftware.atlassian.net/jira/software/c/projects/PLAT/summary
