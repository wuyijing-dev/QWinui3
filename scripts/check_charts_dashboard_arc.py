#!/usr/bin/env python3
"""Validate charts & dashboard arc docs (2.51 → 3.00).

  python scripts/check_charts_dashboard_arc.py

No build required.
"""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

ARC = ROOT / "docs" / "planning" / "expansion" / "charts-dashboard-arc.md"
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
            ARC,
            (
                "2.65",
                "2.67",
                "2.69",
                "3.00",
                "3.01",
                "DashboardShell",
                "Wave A",
                "Wave B",
                "Wave C",
                "LineChart",
                "KpiTile",
                "Sparkline",
                "HistogramChart",
                "BulletChart",
                "FL-014",
                "FL-015",
                "check_charts_dashboard_arc.py",
            ),
        )
    )
    for rel in ("ROADMAP.md", "docs/roadmap.md"):
        errors.extend(
            must_contain(
                ROOT / rel,
                (
                    "charts-dashboard-arc.md",
                    "2.65",
                    "DashboardShell",
                ),
            )
        )
    errors.extend(
        must_contain(
            FRICTION,
            ("FL-014", "FL-015", "charts-dashboard-arc.md"),
        )
    )
    errors.extend(
        must_contain(
            STRATEGY,
            ("charts-dashboard-arc.md", "2.65", "DashboardShell"),
        )
    )

    if errors:
        print("error: charts/dashboard arc checks failed:", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1

    print("charts/dashboard arc: OK (2.65…3.01 waves + roadmap + friction)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
