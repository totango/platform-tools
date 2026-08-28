# Recipe: Jira delivery workflow (PLAT)

**last_updated:** 2026-08-28  
**tags:** eng-information, platform, jira  
**audience:** engineers, agents

Use this recipe when starting work, opening a PR, or closing out a ticket. It complements [how-we-work.md](../../docs/how-we-work.md) and is safe to load as agent context.

---

## 1. Pull context before coding

```bash
# Single ticket (markdown for humans/agents)
jira/scripts/jira-context.sh PLAT-XXX

# Raw JSON for tooling
jira/scripts/jira-context.sh PLAT-XXX --json

# Broader snapshot (planning / dependency review)
jira/scripts/jira-plan.sh pull
```

**Read in Jira (or from context output):**

| Check | Why |
|-------|-----|
| Parent **Story** acceptance criteria | Your task should roll up to story outcomes |
| **Epic** (`plat-ref:E0N` label or parent) | Avoid work that conflicts with epic sequencing |
| **Linked issues** | Blockers, duplicates, relates-to |
| **Status** of siblings | Coordinate if another task owns the same surface |

**Agents:** Use `jira-context.sh` output for scope only. Do not paste ticket bodies with customer names into commits.

---

## 2. Branch and PR alignment

| Artifact | Convention |
|----------|------------|
| Branch | `ab/PLAT-XXX/short-topic` or `platform-tools/PLAT-XXX/topic` |
| PR title | `PLAT-XXX: imperative summary` (CI validates) |
| PR body | Jira link, Summary, QA, Validation, Next steps — see [PR template](../../.github/pull_request_template.md) |
| Commits | Prefer `PLAT-XXX: …` in subject when practical |

One **Subtask** ≈ one PR where possible. If scope grows, split a new PLAT ticket rather than overloading the original.

---

## 3. During development — blockers

Create a **blocker** ticket when work cannot proceed without another team, access, or decision.

| Field | Guidance |
|-------|----------|
| **Type** | Task (or Bug if production defect) |
| **Summary** | `Blocker: <what is blocked> — needs <owner/team>` |
| **Link** | `blocks` → the ticket you cannot finish |
| **Labels** | `blocker`, area label (`platform`, `access-docs`, …) |
| **Description** | What you tried, what is missing, **no customer PII** |

Comment on the blocked ticket with the new blocker key. Do **not** mark the original ticket Done while blocked.

---

## 4. At merge — Jira + git hygiene

After the PR merges to `main`:

```bash
# 1. Comment with PR link (no secrets, no customer data)
jira/scripts/jira-comment.sh PLAT-XXX "Merged: https://github.com/totango/platform-tools/pull/N — <one-line summary>"

# 2. Transition in Jira UI (or list transitions for automation later)
#    Subtask/Task → Done when PR scope is complete
#    Story → Done only when ALL acceptance criteria are met
```

**Completion checklist**

- [ ] PR merged; branch deleted
- [ ] Jira comment links the PR (or documents why not, e.g. doc-only internal change)
- [ ] **Subtask/Task** moved to **Done** if this PR fulfilled it
- [ ] **Story** moved to **Done** only if every AC is satisfied (or split remaining AC to new tasks)
- [ ] **Blocker** tickets updated: close if resolved, or leave open with comment
- [ ] Follow-up work filed as new PLAT tickets (not left as PR comment only)

---

## 5. When to mark what Done

| Level | Mark Done when |
|-------|----------------|
| **Subtask** | Single deliverable shipped (usually one merged PR) |
| **Task** | Phase complete; no open subtasks for this chunk |
| **Story** | All acceptance criteria met and demo-able |
| **Epic** | Exit criteria from [jira-space-overview.md](../../docs/jira-space-overview.md) — typically quarterly review, not every PR |

If you only completed part of a Story, leave the Story **In Progress** and close the Task/Subtask you finished.

---

## 6. Agent quick reference

```text
START  → jira-context.sh PLAT-XXX
WORK   → branch ab/PLAT-XXX/… ; PR title PLAT-XXX: …
BLOCK  → create blocker ticket ; link blocks ; comment
MERGE  → jira-comment.sh ; transition Done on correct level
```

See [AGENTS.md](../../AGENTS.md) for repo read order and privacy rules.
