---
title: "Galva example — catalyst-ingest migrate to shared Temporal"
tags: [eng-information, galva, catalyst-ingest, temporal, migration]
last_updated: "2026-08-28"
status: scaffold
audience: [engineers, agents]
gaps:
  - "Current Temporal version and namespace layout not verified"
  - "PostgreSQL sizing, HA model, and migration tooling unknown"
  - "Shared Temporal target cluster/version not selected"
  - "Consumer blast radius not inventoried"
sources_to_synthesize:
  - "Approved service repo (catalyst-ingest) — via PR, no personal paths"
  - "Platform IKG when available (E09)"
  - "FinOps signals for dedicated vs shared Temporal cost (E04)"
jira: "PLAT-98"
---

# Galva: catalyst-ingest → shared Temporal

**Jira:** [PLAT-98](https://catalystsoftware.atlassian.net/browse/PLAT-98) (Story under [PLAT-96](https://catalystsoftware.atlassian.net/browse/PLAT-96) / E10)  
**Size:** Small-to-medium galva (single primary workload; shared infra dependency)  
**Program:** [galva-program.md](./galva-program.md)

## Goal

Research whether **catalyst-ingest** should migrate from its **dedicated Temporal deployment** (possibly older version) to a **shared Temporal platform**, including PostgreSQL requirements and EKS placement constraints.

This document is a **research scaffold** — facts marked `TBD` must be verified before any delivery epic is opened.

## Known facts (intake)

| Field | Value | Verified |
|-------|-------|----------|
| Workload | `catalyst-ingest` | Partial — name only |
| EKS placement | Dedicated cluster, **same AWS account and VPC** as shared services | `TBD` |
| Workflow engine | Temporal (version `TBD` — possibly behind current shared standard) | `TBD` |
| Data store | PostgreSQL required | `TBD` |
| Languages | `TBD` (likely Java and/or Go — confirm from repo) | `TBD` |

## Research questions

### 1. Current state

| Question | Notes |
|----------|-------|
| Which EKS cluster and namespace? | Same-VPC constraint affects network path to shared Temporal |
| Temporal version, namespace, and task queue layout? | Version skew drives SDK and server compatibility matrix |
| PostgreSQL: RDS vs in-cluster? Region? HA? | Co-migration vs split-brain risk |
| Workflow/activity inventory | Count, criticality, long-running vs cron |
| Who consumes ingest outputs? | Blast radius for cutover |

### 2. Target state options

| Option | Pros | Cons |
|--------|------|------|
| **A. Shared Temporal cluster, new namespace** | Lower ops cost; centralized upgrades | Noisy-neighbor; RBAC/isolation design needed |
| **B. Shared Temporal + version upgrade in place** | Single migration event | Higher risk; longer freeze window |
| **C. Stay dedicated; upgrade only** | Minimal blast radius | Does not capture shared-platform savings |

**Deliverable:** Recommended option with rollback path.

### 3. Cost and efficiency

| Line item | Dedicated (today) | Shared (hypothesis) |
|-----------|-------------------|---------------------|
| Temporal compute / storage | `TBD` | `TBD` |
| PostgreSQL | `TBD` | `TBD` |
| Engineering toil (upgrades, on-call) | Qualitative | Qualitative |

Coordinate with **FinOps (E04)** for utilization data — do not paste billing exports into git.

### 4. Effort, risk, blast radius

| Dimension | Initial hypothesis |
|-----------|-------------------|
| **Effort** | `TBD` — depends on SDK version gap and DB migration approach |
| **Risk** | Workflow nondeterminism on SDK upgrade; DB schema migration downtime |
| **Blast radius** | All workflows and downstream consumers of ingest artifacts |
| **Dependencies** | Shared Temporal readiness; VPC/security group rules; DB access (see [PLAT-95](https://catalystsoftware.atlassian.net/browse/PLAT-95)) |

### 5. Suggested migration phases (draft)

1. **Discover** — AST/repo analysis + IKG topology; verify intake table above
2. **Design** — target namespace, RBAC, DB strategy, compatibility matrix
3. **Pilot** — non-prod namespace on shared Temporal; shadow traffic or canary workflows
4. **Cutover** — phased queue migration with rollback triggers
5. **Decommission** — retire dedicated Temporal resources after soak period

## Language / AST focus

When analyzing the catalyst-ingest repo:

- Locate Temporal **workflow** and **activity** registrations
- Map **PostgreSQL** access (ORM, migrations, connection pools)
- Identify **deployment config** (Helm/K8s, env vars — placeholders only in docs)
- Flag **version-sensitive** APIs (Temporal SDK changelog)

## Out of scope

- Executing production migration (opens under delivery epic after galva sign-off)
- Committing kubeconfig, connection strings, or customer data
- Bulk-creating Jira tasks without human review

## Acceptance criteria (PLAT-98)

- [ ] Intake table verified or gaps explicitly documented
- [ ] Target-state recommendation with cost/effort/risk summary
- [ ] Up to 5 follow-up delivery tasks **proposed** (not auto-created)
- [ ] All examples obfuscated; no secrets in git
