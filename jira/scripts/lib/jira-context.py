#!/usr/bin/env python3
"""Format Jira issue JSON as markdown context for engineers and agents."""
from __future__ import annotations

import json
import re
import sys
from typing import Any


def adf_to_text(node: Any) -> str:
    if node is None:
        return ""
    if isinstance(node, str):
        return node
    if isinstance(node, list):
        return "".join(adf_to_text(item) for item in node)
    if not isinstance(node, dict):
        return ""
    node_type = node.get("type")
    if node_type == "text":
        return node.get("text", "")
    if node_type == "hardBreak":
        return "\n"
    if node_type == "paragraph":
        return adf_to_text(node.get("content", [])) + "\n"
    if node_type in {"bulletList", "orderedList", "listItem"}:
        return adf_to_text(node.get("content", []))
    if node_type == "heading":
        level = node.get("attrs", {}).get("level", 2)
        prefix = "#" * min(level, 6)
        return f"{prefix} {adf_to_text(node.get('content', [])).strip()}\n\n"
    return adf_to_text(node.get("content", []))


def field_text(value: Any) -> str:
    if value is None:
        return ""
    if isinstance(value, str):
        return value.strip()
    if isinstance(value, dict):
        if "content" in value:
            return adf_to_text(value).strip()
        if "name" in value:
            return str(value["name"])
        if "status" in value:
            return field_text(value["status"])
    return str(value).strip()


def link_type_name(link: dict[str, Any]) -> str:
    return link.get("type", {}).get("name", "relates to")


def format_issue(issue: dict[str, Any], children: list[dict[str, Any]] | None = None) -> str:
    key = issue.get("key", "UNKNOWN")
    fields = issue.get("fields", {})
    summary = fields.get("summary", "")
    status = field_text(fields.get("status"))
    issue_type = field_text(fields.get("issuetype"))
    labels = fields.get("labels") or []
    parent = fields.get("parent") or {}
    parent_key = parent.get("key", "")
    parent_summary = parent.get("fields", {}).get("summary", "")
    description = field_text(fields.get("description"))
    assignee = field_text(fields.get("assignee")) or "unassigned"
    links = fields.get("issuelinks") or []

    lines = [
        f"# {key}: {summary}",
        "",
        f"- **Type:** {issue_type}",
        f"- **Status:** {status}",
        f"- **Assignee:** {assignee}",
    ]
    if parent_key:
        lines.append(f"- **Parent:** {parent_key} — {parent_summary}")
    if labels:
        lines.append(f"- **Labels:** {', '.join(labels)}")
    lines.append(f"- **URL:** https://catalystsoftware.atlassian.net/browse/{key}")
    lines.append("")

    if description:
        lines.extend(["## Description", "", description, ""])

    if links:
        lines.append("## Links")
        for link in links:
            outward = link.get("outwardIssue")
            inward = link.get("inwardIssue")
            rel = link_type_name(link)
            if outward:
                ok = outward.get("key", "")
                osum = outward.get("fields", {}).get("summary", "")
                lines.append(f"- {rel} → **{ok}** {osum}")
            if inward:
                ik = inward.get("key", "")
                isum = inward.get("fields", {}).get("summary", "")
                lines.append(f"- {rel} ← **{ik}** {isum}")
        lines.append("")

    if children:
        lines.append("## Child issues")
        for child in children:
            ck = child.get("key", "")
            cs = child.get("fields", {}).get("summary", "")
            cst = field_text(child.get("fields", {}).get("status"))
            lines.append(f"- **{ck}** ({cst}) — {cs}")
        lines.append("")

    lines.extend(
        [
            "## Privacy reminder",
            "",
            "Do not paste customer names, tenant IDs, or credentials into git or agent context.",
            "Use this summary for scope only; verify details in Jira.",
            "",
        ]
    )
    return "\n".join(lines)


def extract_key(text: str) -> str:
    match = re.search(r"\b(PLAT-\d+)\b", text, re.IGNORECASE)
    if not match:
        raise SystemExit(f"Could not parse PLAT key from: {text!r}")
    return match.group(1).upper()


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: jira-context.py <PLAT-XXX> [issue.json]", file=sys.stderr)
        return 2
    key = extract_key(sys.argv[1])
    if len(sys.argv) >= 3:
        payload = json.load(open(sys.argv[2], encoding="utf-8"))
    else:
        payload = json.load(sys.stdin)
    children = payload.get("children", [])
    issue = payload.get("issue", payload)
    print(format_issue(issue, children))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
