#!/usr/bin/env python3
"""Validate pull request title contains a valid PLAT Jira ticket key."""
from __future__ import annotations

import base64
import json
import os
import re
import sys
import urllib.error
import urllib.request

TITLE_PATTERN = re.compile(r"^(PLAT-\d+):\s+.+", re.IGNORECASE)


def validate_format(title: str) -> tuple[str | None, str | None]:
    match = TITLE_PATTERN.match(title.strip())
    if not match:
        return None, (
            "PR title must match 'PLAT-XXX: <summary>' "
            "(example: PLAT-92: scaffold access docs)"
        )
    return match.group(1).upper(), None


def validate_jira(key: str, email: str, token: str, site: str, project: str) -> tuple[bool, str | None]:
    url = f"https://{site}/rest/api/3/issue/{key}?fields=project"
    auth = base64.b64encode(f"{email}:{token}".encode()).decode()
    request = urllib.request.Request(
        url,
        headers={
            "Accept": "application/json",
            "Authorization": f"Basic {auth}",
            "User-Agent": "platform-tools-validate-pr/0.1",
        },
    )
    try:
        with urllib.request.urlopen(request, timeout=30) as response:
            data = json.load(response)
    except urllib.error.HTTPError as exc:
        if exc.code == 404:
            return False, f"{key} not found in Jira"
        return False, f"Jira API error: HTTP {exc.code}"
    except urllib.error.URLError as exc:
        return False, f"Jira API unreachable: {exc.reason}"

    issue_project = data.get("fields", {}).get("project", {}).get("key", "")
    if issue_project != project:
        return False, f"{key} belongs to project {issue_project}, expected {project}"
    return True, None


def main() -> int:
    title = sys.argv[1] if len(sys.argv) > 1 else os.environ.get("PR_TITLE", "")
    if not title:
        print("Usage: validate-pr-title.py '<PR title>'", file=sys.stderr)
        return 2

    key, format_error = validate_format(title)
    if format_error:
        print(f"::error::{format_error}")
        return 1

    print(f"Format OK: {key}")

    email = os.environ.get("JIRA_EMAIL", "")
    token = os.environ.get("JIRA_API_TOKEN", "")
    site = os.environ.get("JIRA_SITE", "catalystsoftware.atlassian.net")
    project = os.environ.get("JIRA_PROJECT", "PLAT")

    if not email or not token:
        print(
            "::warning::Jira credentials not configured; "
            "format validated only (set JIRA_EMAIL and JIRA_API_TOKEN for live checks)"
        )
        return 0

    ok, jira_error = validate_jira(key, email, token, site, project)
    if not ok:
        print(f"::error::{jira_error}")
        return 1

    print(f"Jira OK: {key} exists in project {project}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
