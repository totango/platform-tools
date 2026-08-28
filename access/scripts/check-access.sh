#!/usr/bin/env bash
# Local platform access checklist — stub; does NOT read credential stores.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
# shellcheck source=/dev/null
source "${REPO_ROOT}/jira/scripts/lib/load-config.sh"

STARGATE_URL="${STARGATE_URL:-https://stargate.odieplat.io}"
ARGOCD_URL="${ARGOCD_URL:-https://argocd.odieplat.io}"
CONFIG_HINT="${XDG_CONFIG_HOME:-$HOME/.config}/platform-tools/config.yaml"

pass_fail_skip() {
  local name="$1" result="$2"
  printf '[%s] %s\n' "$result" "$name"
}

echo "Platform access checklist (scaffold — fill ${CONFIG_HINT} locally)"
echo "last_updated: 2026-08-28"
echo

# Stargate reachability (HTTPS HEAD)
if curl -sf --max-time 5 -o /dev/null -I "$STARGATE_URL" 2>/dev/null; then
  pass_fail_skip "Reach $STARGATE_URL" "PASS"
else
  pass_fail_skip "Reach $STARGATE_URL (or network/VPN required)" "FAIL"
fi

# ArgoCD reachability
if curl -sf --max-time 5 -o /dev/null -I "$ARGOCD_URL" 2>/dev/null; then
  pass_fail_skip "Reach $ARGOCD_URL" "PASS"
else
  pass_fail_skip "Reach $ARGOCD_URL (or not yet deployed)" "FAIL"
fi

# Teleport proxy
if [[ -n "${TSH_PROXY:-}" ]]; then
  if command -v tsh &>/dev/null; then
    pass_fail_skip "tsh installed (TSH_PROXY set in config)" "PASS"
  else
    pass_fail_skip "tsh not found" "FAIL"
  fi
else
  pass_fail_skip "Teleport (set access.tsh_proxy in config)" "SKIP"
fi

# MCP port-forward stub
if [[ -n "${IKG_MCP_LOCAL_PORT:-}" ]]; then
  pass_fail_skip "IKG MCP port-forward (port set — verify manually)" "SKIP"
else
  pass_fail_skip "IKG MCP port-forward (set access.ikg_mcp_local_port in config)" "SKIP"
fi

echo
echo "Reminder: copy config/config.yaml.example → ${CONFIG_HINT}. Never commit config or customer data."
