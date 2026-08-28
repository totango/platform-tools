#!/usr/bin/env bash
# Apply standard main-branch protection for Platypus repos.
# Usage: setup-branch-protection.sh [owner/repo]   (default: totango/platform-tools)
set -euo pipefail

REPO="${1:-totango/platform-tools}"
BRANCH="${2:-main}"

gh api "repos/${REPO}/branches/${BRANCH}/protection" -X PUT \
  -H "Accept: application/vnd.github+json" \
  --input - <<EOF
{
  "required_status_checks": {
    "strict": true,
    "checks": [
      {"context": "validate-pr-title", "app_id": null}
    ]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": false,
    "require_code_owner_reviews": false,
    "required_approving_review_count": 1
  },
  "restrictions": null,
  "required_linear_history": false,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "block_creations": false,
  "required_conversation_resolution": false
}
EOF

echo "Branch protection applied to ${REPO}:${BRANCH}"
