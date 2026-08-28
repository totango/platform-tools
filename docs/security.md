# Security policy — platform-tools

**last_updated:** 2026-08-28

This repo documents **how** to access platform tools. It must never become a credential store or a dump of personal or customer-identifying data.

## Allowed in git

| Category | Examples |
|----------|----------|
| Public URLs | `https://stargate.odieplat.io`, `https://argocd.odieplat.io` |
| Service account **names** | `plat-bootstrap`, `github-actions` (not keys) |
| Placeholder env var / config keys | `jira.api_token`, `access.tsh_proxy` in `~/.config/platform-tools/config.yaml` |
| Jira project key | `PLAT` |
| Architecture and MCP **tool names** | `ikg_search`, `ikg_get_node` |
| Generic / obfuscated examples | `customer-example`, `tenant-a`, `name@example.com` |

## Forbidden in git

| Category | Examples |
|----------|----------|
| API tokens, passwords | Atlassian tokens, GitHub PATs, AWS keys |
| Private keys | `-----BEGIN … PRIVATE KEY-----` |
| Kubeconfig **contents or paths** | Cluster certs/tokens, context names tied to individuals |
| Personal machine paths | Home directories, usernames in paths, IDE config locations |
| Repo-local secret files | `.env`, `config.yaml` (use `~/.config/<repo_name>/config.yaml` instead) |
| Real AWS account IDs | Unless already public in argocd-tele docs |
| Personal email addresses | Use `name@example.com` in examples |
| Customer-identifying data | Real customer names, tenant IDs, production hostnames, unredacted logs |

## Privacy (personal and customer)

See also [how-we-work.md#privacy](how-we-work.md#privacy).

- **Personal:** Verify access locally; document patterns in PRs. Never sync kubeconfig or home-directory paths into this repo or Jira tickets. Use `~/.config/platform-tools/config.yaml` for local secrets (see [how-we-work.md#local-configuration](how-we-work.md#local-configuration)).
- **Customer:** Obfuscate and minimize customer names and data in docs, tickets, and agent context. Use placeholders unless information is already public and approved.

## Doc requirements

Every file under `access/**/*.md` must include YAML frontmatter with:

- `last_updated`
- `gaps` (what the reader must fill locally — without pointing at personal paths)
- `tags` including `eng-information`

## CI

Pull requests run [.github/workflows/validate-docs.yml](../.github/workflows/validate-docs.yml) to block common secret patterns and missing frontmatter.

## Reporting

If secrets or customer data were committed, rotate/review immediately and remove from history per org policy.
