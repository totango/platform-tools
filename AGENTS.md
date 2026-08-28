# Agent read order

For AI agents (Goose, Cursor, etc.) working on Platypus platform tooling:

1. [access/README.md](access/README.md)
2. [access/mcps/interlink-map.md](access/mcps/interlink-map.md)
3. [docs/how-we-work.md](docs/how-we-work.md)
4. [jira/rules/epic-preservation.yaml](jira/rules/epic-preservation.yaml)

**Rules**

- Do not invent credentials. Use placeholders.
- Public endpoints only in git (`*.odieplat.io`).
- Do not commit personal paths, kubeconfig, or customer-identifying data.
- Store local secrets in `~/.config/<repo_name>/config.yaml` — never in the repo tree.
- Obfuscate customer names and minimize data in docs and commits.
- Update `last_updated` when verifying docs; list gaps explicitly in frontmatter.
