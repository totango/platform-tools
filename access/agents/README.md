---
title: "Platform agents — overview"
tags: [eng-information, platform-bots]
last_updated: "2026-08-28"
status: scaffold
audience: [engineers, agents]
gaps:
  - "Future repo URLs for platform-{ikg,castleguard,zaha} when created"
  - "Exact MCP tool lists and deployment versions on platform-eks"
sources_to_synthesize:
  - "goose-ws2/argocd-tele/workspace/docs/infra-knowledge-graph.md"
  - "goose-ws2/platform-bots/docs/infra-kg/PROJECT_RESEARCH.md"
---

# Platform agents

Three platform agents on **platform-eks**, each with a dedicated namespace. Future repos: `platform-ikg`, `platform-castleguard`, `platform-zaha` (no language suffix).

## Relationship diagram

```mermaid
flowchart LR
  subgraph sources [Data sources]
    TF[Terraform state]
    K8s[K8s API]
    AWS[AWS APIs]
  end

  subgraph ikg [platform-ikg]
    IKG_MCP[IKG MCP]
    IKG_MOUNT["/ikg/mount snapshots"]
  end

  subgraph castleguard [platform-castleguard]
    CG[Boundary scans]
    CG_UI[Web UI]
  end

  subgraph zaha [platform-zaha]
    ZA[Jira / GitHub orchestration]
    ZC[zaha-cogs FinOps]
  end

  TF --> IKG_MCP
  K8s --> IKG_MCP
  AWS --> IKG_MCP
  IKG_MCP --> IKG_MOUNT
  CG -->|read-only MCP| IKG_MCP
  ZA -->|read-only MCP| IKG_MCP
  ZA -->|findings export| CG
  CG --> AWS
```

## Agent index

| Agent | Repo (future) | Role | Doc |
|-------|---------------|------|-----|
| IKG | `platform-ikg` | Infra knowledge graph — inventory, linkage, MCP tools | [platform-ikg.md](platform-ikg.md) |
| Castleguard | `platform-castleguard` | Agentic red team — boundary, exposure, compliance | [platform-castleguard.md](platform-castleguard.md) |
| Zaha | `platform-zaha` | Architecture review, FinOps, Jira/GitHub orchestration | [platform-zaha.md](platform-zaha.md) |

When `platform-{ikg,castleguard,zaha}` repos exist, their `README.md` should link here for access patterns.
