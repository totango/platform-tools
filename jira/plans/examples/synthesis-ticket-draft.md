# Synthesis ticket — PLAT-92

**Key:** [PLAT-92](https://catalystsoftware.atlassian.net/browse/PLAT-92)  
**Parent:** PLAT-8 (Epic E07 — Agent research & validation)  
**Updated:** 2026-08-28

## Summary

Synthesize verified platform access patterns into `platform-tools/access/` (via PR)

## Description (privacy-safe)

Scaffold exists in `totango/platform-tools/access/`. Populate verified connection **patterns** through PRs:

- Teleport proxy hostname and SSO flow (placeholders for credentials)
- MCP port-forward / in-cluster Service DNS patterns
- ArgoCD and Stargate login methods (public URLs only in git)

**Rules:**

- No secrets in git
- No personal home-directory paths or kubeconfig sync
- Local secrets in `~/.config/platform-tools/config.yaml` only (see `config/config.yaml.example`)
- No customer names or identifying production data — obfuscate and minimize
- Public endpoints only (`stargate.odieplat.io`, `argocd.odieplat.io`)
- Update `last_updated` on each verified doc

**Canonical sources (not personal machines):**

- `totango/platform-tools/access/` scaffold
- argocd-tele workspace docs (Jira model, infra-knowledge-graph)
- Future agent repos: `platform-ikg`, `platform-castleguard`, `platform-zaha`
- Approved cluster/service discovery (patterns in PRs only — raw output stays local)

## Labels

`eng-information`, `platform`, `access-docs`, `tier:1`
