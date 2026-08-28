---
title: "MCP interlink map"
tags: [eng-information, platform-bots]
last_updated: "2026-08-28"
status: scaffold
audience: [engineers, agents]
gaps:
  - "In-cluster Service DNS and port-forward patterns — verify via approved cluster access; document placeholders only"
  - "Exact Castleguard export bucket/API path"
sources_to_synthesize:
  - "Cluster service discovery (kubectl get svc — output stays local; patterns go in PRs only)"
  - "IDE MCP config templates with placeholders (never commit real tokens or home paths)"
---

# MCP interlink map

How platform agents, services, and IDE tools connect. **Scaffold only** — fill connection details locally; never commit secrets.

## Table

| From | To | Protocol | Direction | Notes |
|------|-----|----------|-----------|-------|
| Castleguard pod | IKG MCP Service | MCP | read-only | `ikg_search`, `ikg_get_node`, `ikg_traverse` |
| Zaha | IKG MCP | MCP | read-only | Architecture / FinOps correlation |
| Zaha | Castleguard export | S3 / API | read | Findings for cost/security overlap |
| IDE (Cursor/Goose) | IKG MCP | MCP stdio / port-forward | read | v1: `kubectl port-forward` stub |
| Castleguard | AWS APIs | AWS SDK | read / probe | Boundary checks |
| Zaha | Grafana MCP (org lane) | MCP | read | Metrics — **org MCP**, not platform-bots |

## Diagram

```mermaid
flowchart TB
  IDE[IDE: Cursor / Goose]
  CG[Castleguard]
  ZA[Zaha]
  IKG[IKG MCP Service]
  AWS[AWS APIs]
  EXP[Castleguard export]

  IDE -->|port-forward PLACEHOLDER| IKG
  CG -->|MCP read-only| IKG
  ZA -->|MCP read-only| IKG
  ZA -->|read| EXP
  CG --> AWS
  CG --> EXP
```

## Placeholder connection examples

```bash
# PLACEHOLDER — verify via approved cluster access; document pattern in PR only
# IKG MCP (in-cluster): infra-kg-mcp.infra-kg.svc.cluster.local:<PORT>
kubectl port-forward -n infra-kg svc/infra-kg-mcp <LOCAL_PORT>:<REMOTE_PORT>
```

```json
{
  "mcpServers": {
    "ikg": {
      "command": "PLACEHOLDER",
      "args": ["PLACEHOLDER — local MCP proxy or port-forward wrapper"]
    }
  }
}
```

Do not commit real tokens, personal paths, kubeconfig contents, or customer-identifying data.
