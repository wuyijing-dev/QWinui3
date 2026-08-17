#!/usr/bin/env python3
"""Validate Docs IA v2 + recipes hub regroup (2.46).

  python scripts/check_docs_ia_v2.py

No build required.
"""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def must_contain(path: Path, needles: tuple[str, ...]) -> list[str]:
    if not path.is_file():
        return [f"missing {path.relative_to(ROOT)}"]
    text = path.read_text(encoding="utf-8")
    return [f"{path.relative_to(ROOT)}: missing {n!r}" for n in needles if n not in text]


def main() -> int:
    errors: list[str] = []

    errors.extend(
        must_contain(
            ROOT / "docs" / "docs-ia-v2.md",
            (
                "2.46",
                "recipes.md",
                "developer-diagnostics.md",
                "experimental-sweep.md",
                "gallery-catalog-expansion.md",
                "check_docs_ia_v2.py",
            ),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "mkdocs.yml",
            (
                "docs-ia-v2.md",
                "Planning:",
                "planning/index.md",
                "developer-diagnostics.md",
                "experimental-sweep.md",
                "2.xx developer",
                "2.xx controls",
                "gallery-catalog-expansion.md",
            ),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "docs" / "recipes.md",
            (
                "2.46",
                "docs-ia-v2.md",
                "## Planning & product expansion",
                "## 2.xx developer & stability",
                "## 2.xx controls & Gallery",
                "planning/index.md",
                "developer-diagnostics.md",
                "experimental-sweep.md",
            ),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "docs" / "index.md",
            ("docs-ia-v2.md", "2.46"),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "src" / "gallery" / "pages" / "RecipesHubPage.qml",
            (
                "docs-ia-v2.md",
                "Planning & product expansion",
                "docs/planning/index.md",
                "developer-diagnostics.md",
            ),
        )
    )

    if errors:
        print("error: docs IA v2 checks failed:", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1

    print("docs IA v2: OK (MkDocs regroup + recipes hub + Gallery mirror)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
