#!/usr/bin/env bash
# Validate PR title: PLAT-XXX: <summary> and optionally verify ticket in Jira.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "${SCRIPT_DIR}/lib/load-config.sh"

TITLE="${1:-${PR_TITLE:-}}"
if [[ -z "$TITLE" ]]; then
  echo "usage: validate-pr-title.sh '<PR title>'" >&2
  echo "       PR_TITLE='PLAT-1: example' validate-pr-title.sh" >&2
  exit 2
fi

exec python3 "${SCRIPT_DIR}/lib/validate-pr-title.py" "$TITLE"
