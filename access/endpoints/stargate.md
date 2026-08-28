---
title: "Stargate — Teleport platform access"
tags: [eng-information, platform-bots]
last_updated: "2026-08-28"
status: scaffold
audience: [engineers, agents]
gaps:
  - "Exact Teleport proxy hostname and SSO steps"
  - "Registered cluster list (verify via tsh — do not commit context names or kubeconfig to git)"
  - "Spoke rollout status after MVP sign-off"
sources_to_synthesize:
  - "argocd-tele: workspace/docs/jira-tickets.md (PLAT-100)"
  - "Verified Teleport access patterns via PR (placeholders only in git)"
---

# Stargate (Teleport)

**Public URL:** `https://stargate.odieplat.io`  
**Jira:** Epic E01 → Story [PLAT-100](https://catalystsoftware.atlassian.net/browse/PLAT-100) (Platform Access — Stargate)

## Purpose

Engineers access registered EKS clusters and platform apps via Teleport instead of VPN. Hub runs on **platform-eks**.

## Auth (placeholder)

```bash
# PLACEHOLDER — verify via approved Teleport access; document pattern in PR only
tsh login --proxy=<YOUR_PROXY>
tsh kube login <YOUR_CLUSTER>
kubectl get nodes
```

Expected pattern: Google SSO once per day, then `tsh` session for kubectl and app access.

## Related

- [ArgoCD](argocd.md) — same hub cluster, sequenced after Stargate MVP
- [services/README.md](../services/README.md) — `platform-eks` hub
