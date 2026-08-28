#!/usr/bin/env bash
# Pull Jira issue context (summary, parent, links, children) for engineers and agents.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB="${SCRIPT_DIR}/lib/jira-api.sh"
FORMATTER="${SCRIPT_DIR}/lib/jira-context.py"

usage() {
  cat <<'EOF'
jira-context — fetch PLAT ticket context for planning or agent prompts

Usage:
  jira-context.sh PLAT-XXX           Markdown summary to stdout
  jira-context.sh PLAT-XXX --json    Raw issue + children JSON
  jira-context.sh --help

Requires jira.email and jira.api_token in ~/.config/platform-tools/config.yaml
EOF
}

die() { echo "jira-context: error: $*" >&2; exit 1; }

KEY="${1:-}"
FORMAT="markdown"
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi
[[ -n "$KEY" ]] || { usage; exit 2; }
if [[ "${2:-}" == "--json" ]]; then
  FORMAT="json"
fi

# shellcheck source=/dev/null
source "${SCRIPT_DIR}/lib/load-config.sh"
# shellcheck source=/dev/null
source "$LIB"

issue="$(jira_get_issue_full "$KEY")"
parent_key="$(echo "$issue" | jq -r '.fields.parent.key // empty')"
children_json='{"issues":[]}'
if [[ -n "$parent_key" ]]; then
  children_json="$(jira_search "parent = ${parent_key} ORDER BY rank" 50)"
elif [[ "$(echo "$issue" | jq -r '.fields.issuetype.name')" =~ ^(Story|Epic|Task)$ ]]; then
  children_json="$(jira_search "parent = ${KEY} ORDER BY rank" 50)"
fi

payload="$(jq -n --argjson issue "$issue" --argjson children "$children_json" \
  '{issue: $issue, children: $children.issues}')"

if [[ "$FORMAT" == "json" ]]; then
  echo "$payload" | jq .
else
  echo "$payload" | python3 "$FORMATTER" "$KEY"
fi
