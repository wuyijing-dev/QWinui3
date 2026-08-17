#!/usr/bin/env python3
"""Validate docs/planning/ IA (expansion + friction + strategy).

  python scripts/check_planning_ia.py

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
            ROOT / "docs" / "planning" / "index.md",
            (
                "expansion/charts-dashboard-arc.md",
                "friction-log.md",
                "roadmap-strategy.md",
                "charts-dashboard-arc.md",
                "component-capabilities-expansion.md",
                "check_planning_ia.py",
            ),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "mkdocs.yml",
            (
                "Planning:",
                "planning/index.md",
                "planning/friction-log.md",
                "planning/expansion/charts-dashboard-arc.md",
                "planning/expansion/component-capabilities-expansion.md",
            ),
        )
    )
    for rel, needle in (("ROADMAP.md", "docs/planning/"), ("docs/roadmap.md", "planning/")):
        errors.extend(
            must_contain(
                ROOT / rel,
                (
                    needle,
                    "component-capabilities-expansion.md",
                ),
            )
        )
    errors.extend(
        must_contain(
            ROOT / "docs" / "recipes.md",
            (
                "## Planning & product expansion",
                "planning/index.md",
            ),
        )
    )

    if errors:
        print("error: planning IA checks failed:", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1

    print("planning IA: OK (docs/planning hub + MkDocs + recipes)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
