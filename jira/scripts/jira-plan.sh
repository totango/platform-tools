#!/usr/bin/env bash
# jira-plan — read-before-write PLAT planning CLI (stub + optional live pull)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
PLANS_DIR="${REPO_ROOT}/jira/plans"
FIXTURE="${REPO_ROOT}/jira/plans/examples/snapshot-fixture.json"
LIB="${SCRIPT_DIR}/lib/jira-api.sh"

usage() {
  cat <<'EOF'
jira-plan — PLAT issue planning (platform-tools)

Usage:
  jira-plan.sh [--help]
  jira-plan.sh pull [--run-id ID]     Snapshot PLAT issues → jira/plans/<run-id>/
  jira-plan.sh synthesize [--run-id ID]  Draft plan from snapshot (stub: copies fixture metadata)
  jira-plan.sh review [--run-id ID]   Print human-readable summary
  jira-plan.sh ack [--run-id ID]      Write approval.json (interactive stub)
  jira-plan.sh apply [--run-id ID]    Refuse without approval.json

Related:
  jira-context.sh PLAT-XXX            Pull ticket context (markdown)
  jira-comment.sh PLAT-XXX "text"     Post merge/blocker comment
  See jira/recipes/jira-delivery-workflow.md

Local config (~/.config/platform-tools/config.yaml):
  jira.email, jira.api_token, jira.site, jira.project
  See config/config.yaml.example

TODO: Full synthesize pipeline; apply with epic-preservation rules.
EOF
}

die() { echo "error: $*" >&2; exit 1; }

latest_run_id() {
  date -u +"%Y%m%dT%H%M%SZ"
}

resolve_run_dir() {
  local run_id="${1:-}"
  if [[ -z "$run_id" ]]; then
    run_id="$(ls -1t "$PLANS_DIR" 2>/dev/null | grep -E '^[0-9]{8}T' | head -1 || true)"
    [[ -n "$run_id" ]] || die "No run-id; pass --run-id or run pull first"
  fi
  echo "${PLANS_DIR}/${run_id}"
}

cmd_pull() {
  local run_id="" 
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --run-id) run_id="$2"; shift 2 ;;
      *) die "unknown pull arg: $1" ;;
    esac
  done
  [[ -n "$run_id" ]] || run_id="$(latest_run_id)"
  local run_dir="${PLANS_DIR}/${run_id}"
  mkdir -p "$run_dir"

  # shellcheck source=/dev/null
  source "${SCRIPT_DIR}/lib/load-config.sh"
  if [[ -n "${JIRA_EMAIL:-}" && -n "${JIRA_API_TOKEN:-}" ]]; then
    # shellcheck source=/dev/null
    source "$LIB"
    echo "Pulling live PLAT issues..."
    local result
    result="$(jira_search "project = ${JIRA_PROJECT:-PLAT} ORDER BY created DESC" 100)"
    echo "$result" | jq '{project: "'"${JIRA_PROJECT:-PLAT}"'", snapshot_at: (now | strftime("%Y-%m-%dT%H:%M:%SZ")), source: "live", issues: [.issues[] | {key: .key, summary: .fields.summary, labels: .fields.labels}]}' \
      > "${run_dir}/snapshot.json"
    echo "Wrote ${run_dir}/snapshot.json ($(jq '.issues | length' "${run_dir}/snapshot.json") issues)"
  else
    cp "$FIXTURE" "${run_dir}/snapshot.json"
    echo "No Jira credentials — wrote offline fixture to ${run_dir}/snapshot.json"
  fi
  echo "$run_id" > "${run_dir}/.run-id"
}

cmd_synthesize() {
  local run_dir
  run_dir="$(resolve_run_dir "${1:-}")"
  [[ -f "${run_dir}/snapshot.json" ]] || die "missing ${run_dir}/snapshot.json — run pull first"
  cat > "${run_dir}/jira-plan-draft.yaml" <<EOF
# Auto-generated stub — TODO: implement full synthesize
run_id: $(basename "$run_dir")
source: ${run_dir}/snapshot.json
status: draft
notes: Copy of snapshot metadata only; dependency rules not yet applied.
EOF
  jq -c . "${run_dir}/snapshot.json" >> "${run_dir}/jira-plan-draft.yaml"
  echo "Wrote ${run_dir}/jira-plan-draft.yaml (stub)"
}

cmd_review() {
  local run_dir
  run_dir="$(resolve_run_dir "${1:-}")"
  [[ -f "${run_dir}/snapshot.json" ]] || die "missing snapshot"
  echo "=== jira-plan review: $(basename "$run_dir") ==="
  jq -r '.epics[]? | "Epic \(.ref): \(.summary)"' "${run_dir}/snapshot.json" 2>/dev/null || true
  jq -r '.issues[]? | "\(.plat_ref // .key) [\(.type)]: \(.summary)"' "${run_dir}/snapshot.json" 2>/dev/null || true
  jq -r '.issues[]? | "\(.key): \(.summary)"' "${run_dir}/snapshot.json" 2>/dev/null || true
  echo "Draft: ${run_dir}/jira-plan-draft.yaml ($(test -f "${run_dir}/jira-plan-draft.yaml" && echo yes || echo missing))"
  echo "Approval: ${run_dir}/approval.json ($(test -f "${run_dir}/approval.json" && echo yes || echo missing))"
}

cmd_ack() {
  local run_dir
  run_dir="$(resolve_run_dir "${1:-}")"
  cat > "${run_dir}/approval.json" <<EOF
{
  "approved_by": "name@example.com",
  "approved_at": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "notes": "STUB — replace approved_by with real identity before apply"
}
EOF
  echo "Wrote ${run_dir}/approval.json (stub — edit approved_by before apply)"
}

cmd_apply() {
  local run_dir
  run_dir="$(resolve_run_dir "${1:-}")"
  [[ -f "${run_dir}/approval.json" ]] || die "Refusing apply: missing ${run_dir}/approval.json — run ack after human review"
  echo "apply: TODO — would apply jira-plan-draft.yaml with epic-preservation rules"
  echo "Dry-run only in v1 stub. Approval present: $(basename "$run_dir")"
}

main() {
  local cmd="${1:-}"
  shift || true
  case "$cmd" in
    --help|-h|help|"") usage ;;
    pull) cmd_pull "$@" ;;
    synthesize)
      local rid=""
      [[ "${1:-}" == "--run-id" ]] && { rid="$2"; shift 2; }
      cmd_synthesize "$rid"
      ;;
    review)
      local rid=""
      [[ "${1:-}" == "--run-id" ]] && { rid="$2"; shift 2; }
      cmd_review "$rid"
      ;;
    ack)
      local rid=""
      [[ "${1:-}" == "--run-id" ]] && { rid="$2"; shift 2; }
      cmd_ack "$rid"
      ;;
    apply)
      local rid=""
      [[ "${1:-}" == "--run-id" ]] && { rid="$2"; shift 2; }
      cmd_apply "$rid"
      ;;
    *) die "unknown command: $cmd (try --help)" ;;
  esac
}

main "$@"
