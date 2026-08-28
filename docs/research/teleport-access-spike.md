---
title: "Teleport access — monitoring, tooling, and multi-resource discovery"
tags: [eng-information, platform-bots, research]
last_updated: "2026-08-28"
status: draft
audience: [engineers, agents]
gaps:
  - "Inventory of DB types, regions, and current access paths per environment"
  - "Whether a centralized access tool exists beyond Teleport candidates"
  - "VPC / security-group / NACL constraints for UDP/TCP from spokes to hub"
  - "Teleport edition (OSS vs Enterprise) for DB protocol and audit features"
sources_to_synthesize:
  - "argocd-tele: workspace/docs/eks-teleport-platform-research.md"
  - "argocd-tele: workspace/docs/jira-space-organization.md (E01)"
  - "platform-tools/access/endpoints/stargate.md"
jira: "PLAT-95"
---

# Teleport access spike — research brief

**Jira:** [PLAT-95](https://catalystsoftware.atlassian.net/browse/PLAT-95) (Spike under Epic E01 → Story PLAT-10)  
**Hub endpoint:** `https://stargate.odieplat.io`  
**Canonical prior art:** `argocd-tele` → `workspace/docs/eks-teleport-platform-research.md`

## Goal

Discover what is required to use **Teleport (Stargate)** as the primary **human access gateway** for:

- Kubernetes clusters (multi-region, private API endpoints)
- Databases (heterogeneous engines, regions, and VPC placement)
- Auditing and operational monitoring of access sessions

This spike is **discovery only** — no production changes, no secrets in git, no personal machine paths.

## Out of scope

- ArgoCD hub migration (separate Story PLAT-108)
- Full Teleport hub deployment (tracked under PLAT-43 and subtasks)
- Populating `access/` with verified connection strings (see [PLAT-92](https://catalystsoftware.atlassian.net/browse/PLAT-92))

## Research questions

### 1. Monitoring and tooling

| Question | Notes |
|----------|-------|
| What should we monitor on the Teleport proxy and agents? | Health, auth failures, agent disconnects, cert expiry |
| Where do metrics/logs land today? | Hub `kube-prometheus-stack` pattern from Leviosa; audit to S3 |
| What alerts matter for access outages? | Agent cannot dial proxy; OIDC failures; NLB target unhealthy |
| CLI ergonomics | `tsh status`, `tsh kube ls`, `tsh db ls` — document expected engineer workflow |
| IDE / agent integration | Port-forward vs Teleport app access for MCP services (stub in `access/mcps/`) |

**Deliverable:** Recommended observability stack for Teleport on `platform-eks` (metrics, logs, audit export, on-call runbook outline).

### 2. AWS changes that may be required

| Area | Hypothesis | Verify |
|------|------------|--------|
| **NLB** | Internet-facing TCP passthrough to Teleport `:443` (do not terminate TLS at LB) | Confirm with Teleport HA reference architecture |
| **VPC / subnets** | Reuse shared-services `10.200.0.0/16`; new EKS subnets | Subnet capacity, route tables |
| **Egress from spokes** | Kube agents dial **outbound** to public proxy | NACLs, NAT, firewall rules per spoke |
| **TGW / peering** | Required for ArgoCD hub → spoke API; **optional** for Teleport-only kubectl | Document which paths need hub-to-spoke vs spoke-to-hub |
| **VPC flow logs** | Parquet/Hive to S3 (required) | Wire shared-services workspace to existing flow-log module |
| **IAM / Pod Identity** | Hub uses EKS Pod Identity (not IRSA default) | ALB controller, ExternalDNS, ESO associations |
| **Secrets** | Google OIDC client secret via External Secrets | Secrets Manager → ESO pattern |
| **Audit storage** | Teleport session recordings + audit events → S3 | Bucket policy, retention, encryption |

**Deliverable:** AWS change checklist (Terraform workspaces affected, net-new vs reuse).

### 3. Kubernetes cluster access — context switching best practices

| Topic | Research |
|-------|----------|
| **Private EKS APIs** | All spokes use `endpoint_public_access = false` — Teleport kube agents inside each cluster |
| **Registration model** | Hub registers clusters; engineers `tsh kube login <cluster>` |
| **Context hygiene** | Avoid committing kubeconfig; use `tsh` cert-based contexts; document `~/.config/<repo>/config.yaml` pattern only |
| **Multi-cluster UX** | Naming convention for clusters; dev vs prod RBAC via Teleport roles |
| **Break-glass** | SSM bastion pattern (`eks-connect.sh`) until Teleport spoke rollout complete |
| **Rollout order** | MVP hub → `leviosa-dev-eks` pilot → broader spokes (PLAT-53) |

**Deliverable:** Recommended engineer workflow doc section for `access/endpoints/stargate.md` (placeholders only until verified).

### 4. Database access — multi-region, multi-engine

| Challenge | Discovery needed |
|-----------|------------------|
| **Engine diversity** | Postgres, MySQL, Redis, DynamoDB, etc. — which support Teleport DB access vs need other paths |
| **Regional spread** | DBs in different regions/clusters/VPCs — agent placement per region |
| **Existing patterns** | VPN, SSM tunnels, PrivateLink, Pomerium — what is used today per DB class |
| **Teleport DB access** | `tsh proxy db` / `tsh db connect` — protocol support, TLS requirements |
| **Centralized gateway** | Is Teleport the single pane, or hybrid (Teleport for some, PrivateLink for service-to-service)? |
| **Customer data** | Session recordings and query audit — minimize/obfuscate customer identifiers in logs |

**Deliverable:** DB access matrix (engine × region × current path × Teleport feasibility × blockers).

### 5. Network constraints — VPC, UDP, TCP

| Path | Protocol | Discovery |
|------|----------|-----------|
| Engineer → Stargate | TCP 443 (HTTPS / Teleport TLS) | Public NLB; optional corp IP allowlist |
| Spoke agent → Stargate | TCP 443 outbound | Verify egress per spoke VPC |
| `tsh proxy db` | TCP local forward | Client-side; document ports |
| Teleport tunnel / reverse tunnel | TCP (multiplexed) | Confirm no UDP requirement for MVP |
| Legacy VPN (OpenVPN) | UDP/TCP | Document overlap with Teleport rollout; retirement path (RFW) |
| ArgoCD → spoke API | TCP 443 | Separate fabric requirement (TGW) |

**Deliverable:** Network requirements table + list of VPCs where egress to `stargate.odieplat.io:443` is blocked or unknown.

### 6. Auditing and compliance

| Capability | Question |
|------------|----------|
| **Session recording** | K8s exec/SSH — required? Storage and retention policy |
| **DB query audit** | Teleport DB audit events — sufficient for compliance asks? |
| **Identity** | Google OIDC email allowlist → Teleport roles (no group dependency) |
| **Revocation** | `tctl lock` / session termination — runbook |
| **Export** | SIEM integration (if any); correlation with VPC flow logs |
| **Privacy** | No customer names/tenant IDs in audit exports committed to git |

**Deliverable:** Audit requirements doc + gap list vs Teleport OSS vs Enterprise.

## Suggested investigation order

1. Read `eks-teleport-platform-research.md` executive summary and open questions.
2. Inventory current human access paths (VPN, SSM, Pomerium) — **names only**, no hostnames with customer data.
3. Confirm spoke egress to `stargate.odieplat.io:443` (PLAT-54 pattern).
4. Draft DB matrix with platform/SRE input.
5. Propose monitoring + audit architecture for hub MVP.
6. File follow-up Tasks/Stories from findings (do not bulk-move existing tickets).

## Acceptance criteria (spike)

- [ ] Written findings added to this doc or linked ADR (privacy-safe)
- [ ] DB access matrix drafted (engines × regions × path × Teleport fit)
- [ ] AWS change checklist with Terraform workspace owners
- [ ] Network/egress gap list per spoke class (dev/prod/EU)
- [ ] Monitoring and audit recommendations for Teleport on `platform-eks`
- [ ] Follow-up Tasks created in Jira with clear owners (max 5 — no bulk ticket moves)
- [ ] `access/endpoints/stargate.md` updated with spike link only (no secrets)

## Related tickets

| Key | Summary |
|-----|---------|
| PLAT-4 | Epic E01 — Platform hub — Teleport & ArgoCD |
| PLAT-10 | Story — Platform Access — Stargate (Teleport) |
| PLAT-43 | Task — Teleport hub at stargate.odieplat.io |
| PLAT-53 | Task — Dev spoke pilot (leviosa-dev-eks) |
| PLAT-92 | Synthesize verified access patterns into `access/` |

## References

- [Stargate endpoint stub](../../access/endpoints/stargate.md)
- [MCP interlink map](../../access/mcps/interlink-map.md)
- [Security policy](../security.md)
- [How we work — privacy](../how-we-work.md#privacy)
