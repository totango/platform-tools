# Teleport access spike — PLAT-95

**Key:** [PLAT-95](https://catalystsoftware.atlassian.net/browse/PLAT-95)  
**Type:** Spike  
**Parent:** PLAT-4 (Epic E01 — Platform hub — Teleport & ArgoCD)  
**Related story:** PLAT-10 (Platform Access — Stargate)  
**Labels:** `stargate`, `teleport`, `eng-information`, `spike`, `access`, `tier:2`

## Summary

Spike: Teleport monitoring, multi-cluster/DB access, AWS and network discovery

## Description

Investigate how **Teleport (Stargate)** at `https://stargate.odieplat.io` should serve as the human access gateway for Kubernetes and databases across regions, clusters, and VPCs.

### Scope

**In scope (discovery):**

1. **Monitoring and tooling** — metrics, logs, alerts, and engineer CLI workflow (`tsh`, context switching)
2. **AWS changes** — NLB, VPC/subnets, egress, flow logs, Pod Identity, audit S3, Secrets Manager
3. **Kubernetes access** — best practices for private EKS APIs, kube agents, RBAC, rollout order
4. **Database access** — heterogeneous engines and regions; Teleport DB vs VPN/PrivateLink/SSM today
5. **Network constraints** — VPC requirements, TCP/UDP paths, spoke egress to public proxy
6. **Auditing** — session recording, DB audit, identity/revocation, privacy (no customer data in exports)

**Out of scope:** ArgoCD hub (PLAT-108), Teleport hub deployment tasks (PLAT-43+), populating `access/` with verified secrets (PLAT-92).

### Prior art

- `argocd-tele` → `workspace/docs/eks-teleport-platform-research.md`
- `platform-tools` → `docs/research/teleport-access-spike.md`

### Deliverables

- DB access matrix (engine × region × current path × Teleport feasibility)
- AWS change checklist with workspace owners
- Network/egress gap list per spoke class
- Monitoring + audit recommendations for Teleport on `platform-eks`
- Up to 5 follow-up Tasks with owners (no bulk ticket moves)

### Rules

- No secrets, tokens, or personal machine paths in findings committed to git
- Obfuscate/minimize customer names and tenant identifiers in any examples
- Use `~/.config/<repo_name>/config.yaml` for local config references only
