#!/usr/bin/env python3
"""Validate component capabilities expansion docs (2.51 → 3.00).

  python scripts/check_component_capabilities_expansion.py

No build required.
"""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

CAP = ROOT / "docs" / "planning" / "expansion" / "component-capabilities-expansion.md"
FRICTION = ROOT / "docs" / "planning" / "friction-log.md"
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
            CAP,
            (
                "2.55",
                "2.56",
                "2.58",
                "2.64",
                "2.65",
                "DataTable",
                "NavigationView",
                "FormLayout",
                "ContentDialog",
                "OnScreenKeyboard",
                "CommandPalette",
                "FL-016",
                "FL-017",
                "FL-018",
                "check_component_capabilities_expansion.py",
            ),
        )
    )
    for rel in ("ROADMAP.md", "docs/roadmap.md"):
        errors.extend(
            must_contain(
                ROOT / rel,
                (
                    "component-capabilities-expansion.md",
                    "2.64",
                    "FL-016",
                ),
            )
        )
    errors.extend(
        must_contain(
            FRICTION,
            ("FL-016", "FL-017", "FL-018", "component-capabilities-expansion.md"),
        )
    )
    errors.extend(
        must_contain(
            STRATEGY,
            ("component-capabilities-expansion.md", "2.64"),
        )
    )

    if errors:
        print("error: component capabilities expansion checks failed:", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1

    print("component capabilities expansion: OK (all modules + roadmap + friction)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
