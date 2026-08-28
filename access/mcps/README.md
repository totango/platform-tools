---
title: "MCP documentation index"
tags: [eng-information, platform-bots]
last_updated: "2026-08-28"
status: scaffold
audience: [engineers, agents]
gaps:
  - "Port numbers and Service DNS for each MCP endpoint"
sources_to_synthesize:
  - "Cluster Service listings: kubectl get svc -A | grep mcp"
---

# MCP access

Platform-bots agents expose MCP for inter-service and IDE access. See [interlink-map.md](interlink-map.md) for the full relationship map.

**Distinct from org MCP lane:** `terraform-mcp`, `grafana-mcp`, etc. in `mcp-servers` namespace — thin internal adapters, not platform-bots services.
