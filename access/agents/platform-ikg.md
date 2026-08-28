---
title: "platform-ikg — Infra Knowledge Graph"
tags: [eng-information, platform-bots]
last_updated: "2026-08-28"
status: scaffold
audience: [engineers, agents]
gaps:
  - "Exact MCP Service DNS inside cluster"
  - "S3 bucket name and mount path verification"
  - "CNPG connection details (placeholder only in git)"
sources_to_synthesize:
  - "argocd-tele: workspace/docs/infra-knowledge-graph.md"
  - "Future platform-ikg repo README and deployment manifests"
---

# platform-ikg

**Jira:** Epic E09 → Stories PLAT-309 (graph + MCP), PLAT-310 (Zaha diagram UI)  
**Namespace:** `infra-kg` on platform-eks

## Role

Structured model of platform topology: clusters, accounts, DNS, services, dependencies, ownership. **System of record for inventory and linkage** — read-only for consumers.

## MCP tools (names only — stub)

| Tool | Purpose |
|------|---------|
| `ikg_search` | Full-text / label search |
| `ikg_get_node` | Fetch node by ID |
| `ikg_traverse` | Walk edges from a node |
| `ikg_export_snapshot` | Latest graph export metadata |

## Mount path

Agent pods mount read-only snapshots at **`/ikg/mount`** (JSON/DOT exports from scheduled builder).

## Consumes

- AWS APIs (accounts, EKS, Route53, …)
- Kubernetes API
- Terraform state / repo docs

## Read by

- **Castleguard** — architectural context for boundary compare (read-only MCP)
- **Zaha** — architecture diagrams and FinOps correlation
- **IDE agents** — via port-forward or future Teleport app (stub)

> When `platform-ikg` repo exists, link its README here.
