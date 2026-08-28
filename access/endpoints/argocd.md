---
title: "ArgoCD hub — GitOps"
tags: [eng-information, platform-bots]
last_updated: "2026-08-28"
status: scaffold
audience: [engineers, agents]
gaps:
  - "Confirm canonical FQDN (expected argocd.odieplat.io)"
  - "Dex/OAuth login steps for humans"
  - "Wave 3 cutover status per cluster"
sources_to_synthesize:
  - "argocd-tele: workspace/docs/unison-integrations-argocd-migration.md"
  - "Verified browser login flow via PR (placeholders only in git)"
---

# ArgoCD hub

**Public URL:** `https://argocd.odieplat.io`  
**Jira:** Epic E01 → Story [PLAT-108](https://catalystsoftware.atlassian.net/browse/PLAT-108) (ArgoCD hub + unison-integrations GitOps)

## Purpose

Central GitOps on **platform-eks**. One build per commit; promote-by-tag to dev EU, prod EU, and prod US (`unison-integrations`, `nango-auth`).

## Auth (placeholder)

```bash
# PLACEHOLDER — verify via approved access; document pattern in PR only
# Browser: https://argocd.odieplat.io
# Login method: Dex + Google OAuth (expected) — confirm via approved access; do not commit session details
```

## Sequencing

Depends on hub cluster, routing, and central ECR — **after** Stargate MVP (PLAT-100) sign-off per E01 plan.

## Related

- [Stargate](stargate.md)
- [services/README.md](../services/README.md)
