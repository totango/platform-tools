---
title: "platform-castleguard — agentic red team"
tags: [eng-information, platform-bots]
last_updated: "2026-08-28"
status: scaffold
audience: [engineers, agents]
gaps:
  - "Slack webhook routing (placeholder env var names only)"
  - "UI auth on shared EKS"
  - "Exact check catalog enable/disable via UI"
sources_to_synthesize:
  - "platform-bots/docs/infra-kg/PROJECT_RESEARCH.md (canonical research summary)"
  - "Future platform-castleguard repo README and deployment manifests"
---

# platform-castleguard

**Namespace:** `castleguard` on platform-eks  
**Jira:** Findings → E06 intake; security program → E05

## Role

Agentic red team: internet boundary observation, exposure checks (nuclei, certs, ENIs, ACM), DDoS signals, AWS compliance. **Does not mutate IKG** — read-only MCP consumer.

## Calls

| Target | Protocol | Direction |
|--------|----------|-----------|
| IKG MCP | MCP | read-only (`ikg_search`, `ikg_get_node`, …) |
| AWS APIs | AWS SDK | read / probe for boundary checks |

## Exports

Findings remain Castleguard-owned: local store, export API/S3, optional Castleguard MCP. Consumed by **Zaha** for cost/security overlap analysis.

## UI

Web UI for topology and configurable/excludable checks; Slack notifications for findings (placeholder config).

> When `platform-castleguard` repo exists, link its README here.
