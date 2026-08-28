---
title: "Platform endpoints index"
tags: [eng-information, platform-bots]
last_updated: "2026-08-28"
status: scaffold
audience: [engineers, agents]
gaps:
  - "Confirm FQDN for any endpoint marked TBD"
  - "Set verified: yes after successful login from your environment"
sources_to_synthesize:
  - "goose-ws2/argocd-tele/workspace/docs/implementation-plan.md"
---

# Platform endpoints

Public and hub-facing endpoints for the Platypus platform on `odieplat.io`.

| Endpoint | URL | Doc | last_updated | verified |
|----------|-----|-----|--------------|----------|
| Stargate (Teleport) | `https://stargate.odieplat.io` | [stargate.md](stargate.md) | 2026-08-28 | no |
| ArgoCD hub | `https://argocd.odieplat.io` | [argocd.md](argocd.md) | 2026-08-28 | no |

## Notes

- All `verified` values are **no** in this scaffold pass.
- Internal MCP and cluster API endpoints live under [services/](../services/README.md) and [mcps/](../mcps/interlink-map.md).
