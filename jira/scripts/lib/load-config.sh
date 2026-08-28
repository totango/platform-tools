#!/usr/bin/env bash
# Load ~/.config/platform-tools/config.yaml into the shell environment.
set -euo pipefail

LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
READ_CONFIG="${LIB_DIR}/read-config.py"

if [[ -x "$READ_CONFIG" ]] || [[ -f "$READ_CONFIG" ]]; then
  # shellcheck disable=SC1090
  eval "$(python3 "$READ_CONFIG" 2>/dev/null || true)"
fi
