#!/usr/bin/env python3
"""Validate friction-only slot 2.48 (FL-009 dashboard compose decision).

  python scripts/check_friction_slot_248.py

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
            ROOT / "docs" / "dashboard-compose-decision.md",
            (
                "2.48",
                "FL-009",
                "KpiTile",
                "LineChart",
                "DonutChart",
                "RingGauge",
                "check_friction_slot_248.py",
            ),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "docs" / "planning" / "friction-log.md",
            ("FL-009", "2.48", "dashboard-compose-decision.md"),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "docs" / "charts.md",
            ("dashboard-compose-decision.md", "2.48"),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "src" / "gallery" / "pages" / "DashboardPage.qml",
            ("2.48", "FL-009", "dashboard-compose-decision"),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "src" / "gallery" / "pages" / "PitfallsPage.qml",
            ("2.48", "FL-009", "dashboard-compose-decision"),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "src" / "gallery" / "pages" / "ChartsPage.qml",
            ("dashboard-compose-decision", "2.48"),
        )
    )

    if errors:
        print("error: friction slot 2.48 checks failed:", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1

    print("friction slot 2.48: OK (FL-009 compose decision + Gallery + Pitfalls)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
