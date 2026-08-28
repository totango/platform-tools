---
title: "Access verification scripts"
tags: [eng-information, platform-bots]
last_updated: "2026-08-28"
status: scaffold
audience: [engineers, agents]
gaps:
  - "Copy config/config.yaml.example to ~/.config/platform-tools/config.yaml and fill placeholders locally"
sources_to_synthesize:
  - "Approved Teleport / endpoint access patterns documented in PRs"
---

# Access scripts

## Local configuration

Store secrets and machine-specific values **outside the repo**:

```bash
mkdir -p ~/.config/platform-tools
cp config/config.yaml.example ~/.config/platform-tools/config.yaml
# edit ~/.config/platform-tools/config.yaml locally — never commit
```

See [docs/how-we-work.md](../../docs/how-we-work.md#local-configuration) for the `~/.config/<repo_name>/config.yaml` convention.

## check-access.sh

Runs a **local checklist** — does not read kubeconfig files or sync cluster context names to this repo.

```bash
./access/scripts/check-access.sh
```

Expected on scaffold: mostly **SKIP** or **FAIL** until optional config values are set.

## Config keys (`access` section)

| Key | Purpose |
|-----|---------|
| `tsh_proxy` | Teleport proxy for Stargate |
| `stargate_url` | Default `https://stargate.odieplat.io` |
| `argocd_url` | Default `https://argocd.odieplat.io` |
| `ikg_mcp_local_port` | Local port if you port-forward MCP (verify manually) |

Jira credentials live under the `jira` section — used by `jira/scripts/jira-plan.sh`.

**Do not** add kubeconfig paths, home-directory paths, or customer-identifying values to config or docs in git.
