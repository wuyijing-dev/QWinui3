#!/usr/bin/env python3
"""Check recipe / ROADMAP / maturity doc markdown links (1.52 harden).

  python scripts/check_docs_links.py

Used by smoke_gallery.py. Exit 0 when all checked links resolve on disk.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def _md_links(text: str) -> list[str]:
    return re.findall(r"\]\(([^)#]+\.md)(?:#[^)]*)?\)", text)


def main() -> int:
    missing: list[str] = []

    recipes = ROOT / "docs" / "recipes.md"
    if recipes.is_file():
        for link in _md_links(recipes.read_text(encoding="utf-8")):
            # recipes.md links are relative to docs/
            p = (ROOT / "docs" / link).resolve()
            if not p.is_file():
                missing.append(f"recipes.md → {link}")

    for name in (
        "maturity-1xx.md",
        "compatibility-1xx.md",
        "stable-api.md",
        "upgrade-notes.md",
        "checkpoint-160.md",
    ):
        if not (ROOT / "docs" / name).is_file():
            missing.append(f"missing docs/{name}")

    roadmap = ROOT / "ROADMAP.md"
    if roadmap.is_file():
        for link in re.findall(r"\]\((docs/[^)#]+\.md)(?:#[^)]*)?\)", roadmap.read_text(encoding="utf-8")):
            if not (ROOT / link).is_file():
                missing.append(f"ROADMAP.md → {link}")

    for doc_name in ("maturity-1xx.md", "checkpoint-160.md"):
        doc = ROOT / "docs" / doc_name
        if doc.is_file():
            for link in _md_links(doc.read_text(encoding="utf-8")):
                if link.startswith("../"):
                    p = (doc.parent / link).resolve()
                else:
                    p = (ROOT / "docs" / link).resolve()
                if not p.is_file():
                    missing.append(f"{doc_name} → {link}")

    catalog = ROOT / "src" / "gallery" / "ControlCatalog.qml"
    if catalog.is_file():
        text = catalog.read_text(encoding="utf-8")
        if "gallery-shell" not in text and "ExamplesTemplatesPage" not in text:
            missing.append("ControlCatalog: expected ExamplesTemplatesPage / gallery-shell pointers")

    if missing:
        print("error: docs link / harden checks failed:", file=sys.stderr)
        for m in missing:
            print(f"  {m}", file=sys.stderr)
        return 1

    print("docs links: OK (recipes + ROADMAP + maturity / checkpoint core)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
