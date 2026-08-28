# ADR-002: Access documentation in platform-tools

**Status:** Accepted (scaffold)  
**Date:** 2026-08-28  
**last_updated:** 2026-08-28

## Context

Engineers and AI agents need a single place to learn how to reach platform tools (Stargate, ArgoCD, IKG MCP, Castleguard, Zaha) on `platform-eks`. Prior art is scattered across argocd-tele, catalystio IKG, and sre-tools Castleguard.

## Decision

1. **`access/` lives in `totango/platform-tools`**, not in `platform-bots` monorepo or ws2 lanes.
2. **Scaffold first, synthesize second** — first pass uses placeholders and public endpoints only; a PLAT ticket tracks populating verified patterns via PR (no personal machine paths or kubeconfig sync to git).
3. Tag all access docs with **`eng-information`** (GitHub repo topic + doc frontmatter).
4. Agent repos (`platform-ikg`, `platform-castleguard`, `platform-zaha`) **link to** `platform-tools/access/` rather than duplicating access patterns.
5. Local secrets use **`~/.config/<repo_name>/config.yaml`** — never repo-local `.env` or personal paths in git.

## Consequences

- One canonical index for humans and agents (`AGENTS.md` read order).
- No secrets in git; local config at `~/.config/platform-tools/config.yaml`; verification updates `last_updated` and `verified` columns via PR.
- ws2 / Goose lane integration remains optional and out of scope for this ADR.

## Related

- [access/README.md](../../access/README.md)
- [docs/how-we-work.md](../how-we-work.md)
- argocd-tele: [jira-space-organization.md](https://github.com/totango/argocd-tele/blob/main/workspace/docs/jira-space-organization.md) (canonical Jira model)
