#!/usr/bin/env bash
# Jira REST read helpers — patterns extracted from argocd-tele jira-bootstrap.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/load-config.sh"

JIRA_SITE="${JIRA_SITE:-catalystsoftware.atlassian.net}"
JIRA_EMAIL="${JIRA_EMAIL:-}"
JIRA_API_TOKEN="${JIRA_API_TOKEN:-}"
JIRA_PROJECT="${JIRA_PROJECT:-PLAT}"
CONFIG_HINT="${XDG_CONFIG_HOME:-$HOME/.config}/platform-tools/config.yaml"

jira_die() { echo "jira-api: error: $*" >&2; exit 1; }

jira_require_auth() {
  [[ -n "$JIRA_EMAIL" && -n "$JIRA_API_TOKEN" ]] || jira_die \
    "Set jira.email and jira.api_token in ${CONFIG_HINT}"
}

jira_api() {
  local method="$1" path="$2"
  shift 2
  curl -sS -X "$method" \
    -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "User-Agent: platform-tools-jira-plan/0.1" \
    "$@" \
    "https://${JIRA_SITE}/rest/api/3${path}"
}

jira_search() {
  local jql="$1" max="${2:-50}"
  jira_require_auth
  jira_api GET "/search/jql?jql=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$jql")&maxResults=${max}&fields=summary,labels,issuetype,parent"
}

jira_get_issue() {
  local key="$1"
  jira_require_auth
  jira_api GET "/issue/${key}?fields=summary,labels,issuetype,parent"
}

jira_get_issue_full() {
  local key="$1"
  jira_require_auth
  jira_api GET "/issue/${key}?fields=summary,description,status,assignee,labels,issuetype,parent,issuelinks,subtasks"
}

jira_add_comment() {
  local key="$1" payload="$2"
  jira_require_auth
  jira_api POST "/issue/${key}/comment" -d "$payload"
}

jira_list_transitions() {
  local key="$1"
  jira_require_auth
  jira_api GET "/issue/${key}/transitions"
}

jira_transition_issue() {
  local key="$1" transition_id="$2" payload="${3:-}"
  jira_require_auth
  if [[ -n "$payload" ]]; then
    jira_api POST "/issue/${key}/transitions" -d "$payload"
  else
    jira_api POST "/issue/${key}/transitions" -d "{\"transition\":{\"id\":\"${transition_id}\"}}"
  fi
}

jira_create_issue() {
  local payload="$1"
  jira_require_auth
  jira_api POST "/issue" -d "$payload"
}
