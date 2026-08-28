---
title: "platform-zaha — architecture & orchestration"
tags: [eng-information, platform-bots]
last_updated: "2026-08-28"
status: scaffold
audience: [engineers, agents]
gaps:
  - "zaha-cogs vendor registry API endpoint (internal only)"
  - "Argo CronWorkflow schedules on platform-eks"
  - "Jira automation credentials (never in git)"
sources_to_synthesize:
  - "goose-ws2/argocd-tele/workspace/docs/jira-space-organization.md (E04, E07)"
---

# platform-zaha

**Namespace:** `zaha` on platform-eks (includes **zaha-cogs** for FinOps/COGS)  
**Jira:** Epic E04 (FinOps), E07 (agent research), E08 (lifecycle)

## Role

- Architectural soundness review: HA, overlap, scalability
- FinOps scans (scheduled CronWorkflows) — findings to E06 intake
- Jira and GitHub orchestration for platform delivery
- COGS vendor intelligence via **zaha-cogs** service

## Consumes

| Source | Use |
|--------|-----|
| IKG MCP | Architecture context, node correlation |
| Castleguard export | Boundary findings for overlap with cost/security |
| Grafana / metrics MCPs | Runtime signals (org MCP lane — stub) |

## Does not

- Mutate IKG graph
- Auto-switch vendors or approve RI/SP purchases (human gate)

> When `platform-zaha` repo exists, link its README here.
