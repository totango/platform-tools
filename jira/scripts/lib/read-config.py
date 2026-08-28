#!/usr/bin/env python3
"""Read ~/.config/platform-tools/config.yaml and print shell export statements."""
from __future__ import annotations

import os
import re
import shlex
import sys
from typing import Any


def config_path() -> str:
    override = os.environ.get("PLATFORM_TOOLS_CONFIG")
    if override:
        return os.path.expanduser(override)
    base = os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config"))
    return os.path.join(base, "platform-tools", "config.yaml")


def parse_simple_yaml(text: str) -> dict[str, Any]:
    """Minimal parser for two-level YAML maps (no external deps)."""
    root: dict[str, Any] = {}
    section: str | None = None
    for raw in text.splitlines():
        line = raw.split("#", 1)[0].rstrip()
        if not line.strip():
            continue
        if line.startswith("  ") and section:
            match = re.match(r"(\w+):\s*(.*)$", line.strip())
            if not match:
                continue
            key, value = match.group(1), match.group(2).strip()
            value = value.strip("\"'")
            root.setdefault(section, {})[key] = value
            continue
        match = re.match(r"(\w+):\s*$", line)
        if match:
            section = match.group(1)
            root.setdefault(section, {})
    return root


def load_config(path: str) -> dict[str, Any]:
    if not os.path.isfile(path):
        return {}
    with open(path, encoding="utf-8") as handle:
        return parse_simple_yaml(handle.read())


def emit_exports(cfg: dict[str, Any]) -> None:
    jira = cfg.get("jira", {}) or {}
    access = cfg.get("access", {}) or {}
    mapping = {
        "JIRA_EMAIL": jira.get("email", ""),
        "JIRA_API_TOKEN": jira.get("api_token", ""),
        "JIRA_SITE": jira.get("site", ""),
        "JIRA_PROJECT": jira.get("project", ""),
        "TSH_PROXY": access.get("tsh_proxy", ""),
        "STARGATE_URL": access.get("stargate_url", ""),
        "ARGOCD_URL": access.get("argocd_url", ""),
        "IKG_MCP_LOCAL_PORT": access.get("ikg_mcp_local_port", ""),
    }
    for key, value in mapping.items():
        if value:
            print(f"export {key}={shlex.quote(str(value))}")


def main() -> int:
    path = config_path()
    emit_exports(load_config(path))
    return 0


if __name__ == "__main__":
    sys.exit(main())
