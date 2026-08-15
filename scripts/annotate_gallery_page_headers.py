#!/usr/bin/env python3
"""Add brief // Gallery headers to gallery pages (link to docs/components)."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PAGES = ROOT / "src/gallery/pages"
DOCS = ROOT / "docs/components"


def main() -> None:
    added = 0
    for path in sorted(PAGES.glob("*Page.qml")):
        text = path.read_text(encoding="utf-8")
        if text.lstrip().startswith("//"):
            continue
        stem = path.stem
        name = stem[:-4] if stem.endswith("Page") else stem
        title_m = re.search(r'title:\s*qsTr\("([^"]+)"\)', text)
        title = title_m.group(1) if title_m else name
        sub_m = re.search(r'subtitle:\s*qsTr\("([^"]+)"\)', text)
        summary = sub_m.group(1) if sub_m else f"Gallery demo for {title}."
        doc_name = name if (DOCS / f"{name}.md").exists() else None
        lines = text.splitlines()
        insert_at = 0
        for i, line in enumerate(lines):
            if line.startswith("import ") or line.startswith("pragma "):
                insert_at = i + 1
            elif insert_at and not line.strip():
                insert_at = i + 1
                break
            elif insert_at:
                break
        header = [f"// Gallery — {title}."]
        header.append("//")
        if doc_name:
            header.append(f"// {summary} API: docs/components/{doc_name}.md")
        else:
            header.append(f"// {summary}")
        header.append("")
        new_lines = lines[:insert_at] + header + lines[insert_at:]
        path.write_text("\n".join(new_lines) + "\n", encoding="utf-8", newline="\n")
        added += 1
        print(f"HEADER {path.name}")
    print(f"Added headers to {added} gallery pages")


if __name__ == "__main__":
    main()
