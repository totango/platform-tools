# Agent read order

For AI agents (Goose, Cursor, etc.) working on Platypus platform tooling:

1. [access/README.md](access/README.md)
2. [access/mcps/interlink-map.md](access/mcps/interlink-map.md)
3. [docs/how-we-work.md](docs/how-we-work.md)
4. [jira/recipes/jira-delivery-workflow.md](jira/recipes/jira-delivery-workflow.md)
5. [jira/rules/epic-preservation.yaml](jira/rules/epic-preservation.yaml)

**Before coding a ticket:** run `jira/scripts/jira-context.sh PLAT-XXX` for scope (requires local Jira config). After merge, comment on the ticket and mark the correct issue level Done — see the recipe.

**Rules**

- Do not invent credentials. Use placeholders.
- Public endpoints only in git (`*.odieplat.io`).
- Do not commit personal paths, kubeconfig, or customer-identifying data.
- Store local secrets in `~/.config/<repo_name>/config.yaml` — never in the repo tree.
- Obfuscate customer names and minimize data in docs and commits.
- Update `last_updated` when verifying docs; list gaps explicitly in frontmatter.
