#!/usr/bin/env python3
"""Validate icons & dashboard expansion docs + Gallery anchors.

  python scripts/check_icons_dashboard_expansion.py

No build required.
"""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

ICON = ROOT / "docs" / "planning" / "expansion" / "icons-dashboard-expansion.md"


def must_contain(path: Path, needles: tuple[str, ...]) -> list[str]:
    if not path.is_file():
        return [f"missing {path.relative_to(ROOT)}"]
    text = path.read_text(encoding="utf-8")
    return [f"{path.relative_to(ROOT)}: missing {n!r}" for n in needles if n not in text]


def main() -> int:
    errors: list[str] = []

    errors.extend(
        must_contain(
            ICON,
            (
                "KpiTile",
                "ChartCard.symbol",
                "2.65",
                "FluentIcons",
                "check_icons_dashboard_expansion.py",
            ),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "docs" / "icons.md",
            ("icons-dashboard-expansion.md",),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "docs" / "charts.md",
            ("icons-dashboard-expansion.md",),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "src" / "gallery" / "pages" / "DashboardPage.qml",
            ("ChartCard", "symbol:", "FluentIcons", "Iconography"),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "src" / "gallery" / "pages" / "FontIconPage.qml",
            ("Dashboard", "KpiTile", "icons-dashboard-expansion"),
        )
    )

    if errors:
        print("error: icons/dashboard expansion checks failed:", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1

    print("icons/dashboard expansion: OK (docs + Gallery dashboard/icon anchors)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
