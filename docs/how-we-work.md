# How we work — platform-tools

**last_updated:** 2026-08-28

## PLAT planning loop

Platform delivery is tracked on the [PLAT board](https://catalystsoftware.atlassian.net/jira/software/c/projects/PLAT/summary). This repo owns lightweight **jira-plan** tooling (read-before-write, human ack before apply):

```text
jira-plan pull  →  synthesize  →  human review  →  ack  →  apply
```

| Step | Command | Purpose |
|------|---------|---------|
| Pull | `jira/scripts/jira-plan.sh pull` | Snapshot live PLAT issues → `jira/plans/<run-id>/` |
| Synthesize | `jira/scripts/jira-plan.sh synthesize` | Draft plan YAML from snapshot (stub in v1) |
| Review | `jira/scripts/jira-plan.sh review` | Human-readable summary |
| Ack | `jira/scripts/jira-plan.sh ack` | Write `approval.json` |
| Apply | `jira/scripts/jira-plan.sh apply` | Refuses without approval |

```bash
jira/scripts/jira-plan.sh --help
```

See [jira-space-overview.md](jira-space-overview.md) for Epic → Story → Task hierarchy.

## Local configuration

Store machine-specific settings **outside the git repo** using the XDG-style path:

```text
~/.config/<repo_name>/config.yaml
```

For this repo:

```bash
mkdir -p ~/.config/platform-tools
cp config/config.yaml.example ~/.config/platform-tools/config.yaml
```

| Section | Keys | Used by |
|---------|------|---------|
| `jira` | `email`, `api_token`, `site`, `project` | `jira/scripts/jira-plan.sh` |
| `access` | `tsh_proxy`, `stargate_url`, `argocd_url`, `ikg_mcp_local_port` | `access/scripts/check-access.sh` |

Override the path with `PLATFORM_TOOLS_CONFIG` if needed. **Never** commit `~/.config/platform-tools/config.yaml` or copy its contents into PRs, Jira tickets, or agent context.

The same convention applies to other Platypus repos (`platform-ikg`, `platform-castleguard`, `platform-zaha`): each uses `~/.config/<repo_name>/config.yaml` for local secrets and endpoints.

## Privacy

Access docs and Jira tickets in this repo must respect **personal privacy**, **customer privacy**, and the **no-secrets** policy in [security.md](security.md).

### Personal privacy

- **Do not** commit personal machine paths (home directories, usernames in file paths, IDE config locations).
- **Do not** sync kubeconfig contents, context names, or cluster credentials into git or Jira descriptions.
- **Do not** paste personal email addresses — use `name@example.com` in examples.
- Store local secrets in **`~/.config/<repo_name>/config.yaml`** (see [Local configuration](#local-configuration)) — not in the repo tree.
- Verify access **locally** if needed; document **patterns and placeholders** in PRs — not copies of your environment.

### Customer privacy

- **Obfuscate and minimize** customer names, tenant identifiers, account IDs, hostnames, and any production data in docs, tickets, logs, and agent context.
- Prefer generic labels (`customer-a`, `tenant-example`) over real customer names unless already public and approved.
- Redact or aggregate before sharing findings, screenshots, or exports — especially in agent prompts and PR descriptions.
- When in doubt, leave detail out of git and track verification in private runbooks or approved internal systems.

### For agents (Goose, Cursor, etc.)

- Load `access/` for **patterns**, not to scrape or exfiltrate local config.
- Never invent credentials or copy kubeconfig or `~/.config/*/config.yaml` contents into commits or ticket bodies.
- Treat all non-public identifiers as sensitive until a human confirms otherwise.

## Access docs workflow

1. Read [access/README.md](../access/README.md) before changing platform agents or MCP configs.
2. Verify endpoints through approved access; update `last_updated` and `verified` in frontmatter/tables.
3. Open a PR; label **`eng-information`**; follow [security.md](security.md) and this privacy section.
4. Reference canonical sources (argocd-tele docs, future agent repos) — not personal machine paths.

Scaffold-only content is expected until the synthesis ticket ([PLAT-92](https://catalystsoftware.atlassian.net/browse/PLAT-92)) is completed via privacy-safe PRs.

## Galva — modernization research (E10)

**Galva** ([PLAT-96](https://catalystsoftware.atlassian.net/browse/PLAT-96)) is the PLAT program for researching how to modernize, migrate, and refactor older codebases — without executing production changes in the research phase.

| Concept | Guidance |
|---------|----------|
| **Intake** | Facts in (topology, deps, versions) → strategy out (savings, effort, risk, blast radius) |
| **Sizing** | Small galvas (one program) vs big galvas (service groups) — see [galva-program.md](research/galva-program.md) |
| **Languages** | Java, Python, Go, etc. — derive ASTs per ecosystem; no single-language assumption |
| **Platform context** | Use IKG (E09), FinOps (E04), access docs — not personal machine paths |
| **Handoff** | Approved plans become delivery stories under E01/E02/… — Galva does not merge infra changes |

Example inaugural galva: [catalyst-ingest → shared Temporal](research/galva-catalyst-ingest.md) ([PLAT-98](https://catalystsoftware.atlassian.net/browse/PLAT-98)).

## Deployment and merge process

`main` is **protected** on Platypus repos. Treat merges as a small deployment: traceable ticket, human review, and CI validation.

### Branch protection (main)

| Rule | Enforcement | Notes |
|------|-------------|-------|
| Pull requests required | **Hard** | No direct pushes to `main` |
| ≥ 1 approving review | **Soft** | GitHub requires one approval; admins may bypass with documented reason |
| PR title Jira check | **Hard** (format) | CI validates `PLAT-XXX: <summary>`; live Jira lookup when secrets are set |
| Doc validation | **Hard** (on doc paths) | Secret scan + `last_updated` frontmatter when `access/` or `docs/` change |

Apply or update protection on a repo:

```bash
.github/scripts/setup-branch-protection.sh totango/platform-tools
```

Use the same script (with a different `owner/repo` argument) when bootstrapping `platform-ikg`, `platform-castleguard`, `platform-zaha`, and other Platypus repos.

### PR title (Jira-linked)

Every merge to `main` must use a **valid PLAT ticket** in the PR title:

```text
PLAT-XXX: <short imperative summary>
```

Examples:

- `PLAT-92: synthesize verified platform access patterns`
- `PLAT-108: document argocd endpoint auth flow`

CI runs `jira/scripts/validate-pr-title.sh` on each PR. With repo secrets `JIRA_EMAIL` and `JIRA_API_TOKEN`, CI also confirms the ticket exists in project **PLAT**. Without secrets, only the title format is enforced (add secrets for full validation):

```bash
gh secret set JIRA_EMAIL -R totango/platform-tools
gh secret set JIRA_API_TOKEN -R totango/platform-tools
```

Local check before opening a PR:

```bash
PR_TITLE='PLAT-92: my change' jira/scripts/validate-pr-title.sh
```

### PR body template

GitHub pre-fills [`.github/pull_request_template.md`](../.github/pull_request_template.md). Use these sections:

| Section | Purpose |
|---------|---------|
| **Jira** | Ticket link (`PLAT-XXX`) — must match the PR title |
| **Summary** | What changed and why |
| **QA** | How to test; what you verified manually |
| **Validation** | CI results, privacy/security checklist |
| **Next steps** | Optional follow-ups, rollout, synthesis work |

Label doc-only PRs **`eng-information`**.

### Merge checklist

1. Branch from `main`; keep scope focused.
2. Title: `PLAT-XXX: …` (ticket exists and matches the work).
3. Fill PR template sections; no secrets or customer-identifying data.
4. CI green (`validate-pr-title` required; doc checks when applicable).
5. **≥ 1 approval** from a teammate (soft rule — do not self-merge without review).
6. Squash or merge per team preference; delete the branch after merge.

### Privacy at merge time

Re-read [Privacy](#privacy) before approving: no personal paths, no kubeconfig sync, customer names and tenant identifiers obfuscated or omitted.

## Onboarding

See [onboarding.md](onboarding.md) for engineer checklist.

---

## Optional: Using Goose / Cursor

*Suggestions only — not requirements. Folks can work however they want with this repo.*

- Load `access/` as context when working on platform agents.
- Point your agent at the `totango/platform-tools` repo (clone locally first).
- Example MCP snippet (**placeholders only** — do not commit real config):

```json
{
  "mcpServers": {
    "ikg": {
      "command": "PLACEHOLDER",
      "args": ["PLACEHOLDER"]
    }
  }
}
```

- Read order for agents: [AGENTS.md](../AGENTS.md)
- Respect the [Privacy](#privacy) section above — agents must not harvest local paths or customer data into commits.

ws2 lane integration is managed separately; not wired in this repo.
