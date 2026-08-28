---
title: "Platform access documentation"
tags: [eng-information, platform-bots]
last_updated: "2026-08-28"
status: scaffold
audience: [engineers, agents]
gaps:
  - "Teleport proxy hostname, SSO steps, and MCP port-forward patterns — verify via approved access; document placeholders only"
  - "Verify all endpoint login flows and mark verified: yes in endpoints/README.md"
sources_to_synthesize:
  - "argocd-tele workspace docs (Jira model, infra-knowledge-graph)"
  - "Future agent repos: platform-ikg, platform-castleguard, platform-zaha"
  - "Live cluster/service discovery via approved access (patterns in PRs only — no personal paths or kubeconfig in git)"
---

# Platform access

How engineers and AI agents access platform tools on **platform-eks** and related services.

> **First pass is scaffold only.** Follow-up work to populate verified access patterns (via PR, with placeholders for credentials) is tracked in **[PLAT-92](https://catalystsoftware.atlassian.net/browse/PLAT-92)** (synthesis ticket under Epic E07). Do not commit personal machine paths, kubeconfig contents, or customer-identifying data — see [docs/how-we-work.md](../docs/how-we-work.md#privacy).

## Quick links

| Resource | Link |
|----------|------|
| PLAT board | [catalystsoftware.atlassian.net/jira/software/c/projects/PLAT](https://catalystsoftware.atlassian.net/jira/software/c/projects/PLAT/summary) |
| How we work | [docs/how-we-work.md](../docs/how-we-work.md) |
| Security policy | [docs/security.md](../docs/security.md) |
| Agent read order | [AGENTS.md](../AGENTS.md) |

## Security

- **Placeholders only** in git — no API tokens, passwords, or private keys.
- **Public endpoints** (`*.odieplat.io`) are the only real URLs in this tree until verified locally.
- Update `last_updated` when you verify an endpoint or access path.

## Index

| Section | Purpose |
|---------|---------|
| [endpoints/](endpoints/README.md) | Public platform URLs (Stargate, ArgoCD, …) |
| [agents/](agents/README.md) | Castleguard, Zaha, IKG — roles and relationships |
| [mcps/](mcps/README.md) | MCP interlink map between agents and services |
| [services/](services/README.md) | platform-eks hub, namespaces, org MCP lane |
| [scripts/](scripts/README.md) | Local access verification stubs |

## Doc template

Copy [\_template.md](_template.md) when adding new access docs. Tag with `eng-information`.
