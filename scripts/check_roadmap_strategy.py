#!/usr/bin/env python3
"""Validate roadmap strategy docs (post-2.43).

  python scripts/check_roadmap_strategy.py

No build required.
"""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

STRATEGY = ROOT / "docs" / "planning" / "roadmap-strategy.md"


def must_contain(path: Path, needles: tuple[str, ...]) -> list[str]:
    if not path.is_file():
        return [f"missing {path.relative_to(ROOT)}"]
    text = path.read_text(encoding="utf-8")
    return [f"{path.relative_to(ROOT)}: missing {n!r}" for n in needles if n not in text]


def main() -> int:
    errors: list[str] = []

    errors.extend(
        must_contain(
            STRATEGY,
            (
                "2.44",
                "2.50",
                "2.51",
                "2.73",
                "3.00",
                "checkpoint-300",
                "friction-log",
                "icons-dashboard-expansion",
                "charts-dashboard-arc",
                "component-capabilities-expansion",
                "check_roadmap_strategy.py",
            ),
        )
    )
    for rel in ("ROADMAP.md", "docs/roadmap.md"):
        errors.extend(
            must_contain(
                ROOT / rel,
                (
                    "roadmap-strategy.md",
                    "icons-dashboard-expansion.md",
                    "charts-dashboard-arc.md",
                    "component-capabilities-expansion.md",
                    "Strategy",
                    "3.00",
                    "checkpoint-300",
                ),
            )
        )

    if errors:
        print("error: roadmap strategy checks failed:", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1

    print("roadmap strategy: OK (phases through 3.00 + friction queue + expansion tracks)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
