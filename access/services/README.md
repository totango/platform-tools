---
title: "Platform services on platform-eks"
tags: [eng-information, platform-bots]
last_updated: "2026-08-28"
status: scaffold
audience: [engineers, agents]
gaps:
  - "Exact hub cluster identifier (document naming pattern only — no personal kubeconfig in git)"
  - "Namespace labels and platform.totango.com/component values"
  - "Org MCP lane Service names in mcp-servers namespace"
sources_to_synthesize:
  - "goose-ws2/argocd-tele/workspace/scripts/jira-bootstrap-manifest.yaml (E01 hub scope)"
---

# Platform services

## Hub cluster: platform-eks

Shared services cluster for Platypus platform delivery (AWS account and region — **PLACEHOLDER**, see argocd-tele docs locally).

Hosts:

- **Stargate** (Teleport) — `https://stargate.odieplat.io`
- **ArgoCD** — `https://argocd.odieplat.io`
- Platform agent workloads (below)

## Agent namespaces

| Namespace | Workloads | Notes |
|-----------|-----------|-------|
| `infra-kg` | IKG builder CronWorkflow, MCP Deployment, CNPG (expected) | Graph snapshots → S3 + `/ikg/mount` |
| `castleguard` | Boundary scans, UI, findings store | Read-only IKG MCP client |
| `zaha` | Orchestration agent, zaha-cogs, FinOps CronWorkflows | Jira/GitHub integration |

## Org MCP lane (distinct pattern)

Thin internal MCP adapters deployed via org convention (`terraform-leviosa/helm/mcps/`):

| MCP (examples) | Namespace | Use |
|----------------|-----------|-----|
| `terraform-mcp` | `mcp-servers` | Live Terraform ops |
| `grafana-mcp` | `mcp-servers` | Metrics queries |
| `postgres-mcp` | `mcp-servers` | DB introspection |

Platform-bots agents use **cluster-internal Service endpoints** and MCP between themselves — not necessarily the org MCP ingress ALB.

## Teleport app access (stub)

Future: register IKG MCP and other apps in Teleport when hub rollout completes. v1: `kubectl port-forward` only — see [mcps/interlink-map.md](../mcps/interlink-map.md).

```bash
# PLACEHOLDER — Teleport app name TBD
# tsh apps login <APP_NAME>
```
