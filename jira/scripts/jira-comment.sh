#!/usr/bin/env bash
# Post a comment on a PLAT issue (e.g. PR merged, blocker note).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/lib/load-config.sh"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/lib/jira-api.sh"

usage() {
  cat <<'EOF'
jira-comment — add a comment to a PLAT issue

Usage:
  jira-comment.sh PLAT-XXX "Comment text"
  jira-comment.sh PLAT-XXX --file path/to/comment.md
  echo "text" | jira-comment.sh PLAT-XXX --stdin

Use for PR links, merge notes, and blocker updates — not for secrets or customer data.
EOF
}

die() { echo "jira-comment: error: $*" >&2; exit 1; }

KEY="${1:-}"
[[ -n "$KEY" ]] || { usage; exit 2; }
shift

body=""
if [[ "${1:-}" == "--file" ]]; then
  [[ -n "${2:-}" ]] || die "missing --file path"
  body="$(cat "$2")"
elif [[ "${1:-}" == "--stdin" ]]; then
  body="$(cat)"
elif [[ -n "${1:-}" ]]; then
  body="$*"
else
  usage
  exit 2
fi

[[ -n "$body" ]] || die "empty comment"

payload="$(python3 -c '
import json, sys
text = sys.argv[1]
print(json.dumps({"body": {"type": "doc", "version": 1, "content": [
    {"type": "paragraph", "content": [{"type": "text", "text": text}]}
]}}))
' "$body")"

result="$(jira_add_comment "$KEY" "$payload")"
comment_id="$(echo "$result" | jq -r '.id // empty')"
echo "Comment added to ${KEY}${comment_id:+ (id ${comment_id})}"
