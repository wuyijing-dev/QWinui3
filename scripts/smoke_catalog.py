#!/usr/bin/env python3
"""Validate Gallery ControlCatalog sources + document critical smoke pages (1.20).

  python scripts/smoke_catalog.py
  python scripts/smoke_catalog.py --list-critical

Does not launch Qt. Pair with scripts/smoke_gallery.py for --smoke page loads.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CATALOG = ROOT / "src" / "gallery" / "ControlCatalog.qml"
PAGES = ROOT / "src" / "gallery" / "pages"
MAIN_CPP = ROOT / "src" / "gallery" / "main.cpp"

# Keep in sync with main.cpp kCriticalPages and ControlCatalog.smokeCriticalComponents().
CRITICAL = [
    "HomePage",
    "ButtonPage",
    "ContentDialogPage",
    "DataTablePage",
    "FormValidationPage",
    "CommandPalettePage",
    "AccessibilityPage",
    "SystemIntegrationPage",
    "WebView2Page",
    "ChartsPage",
    "DialogsFlyoutsPage",
    "I18nRtlPage",
]


def parse_catalog_sources(text: str) -> list[tuple[str, str]]:
    """Return (component, source) pairs from ControlCatalog.controls."""
    pairs: list[tuple[str, str]] = []
    # Match blocks with component + source (order flexible within an object).
    for m in re.finditer(
        r"component:\s*\"([^\"]+)\"[\s\S]*?source:\s*\"([^\"]+)\"",
        text,
    ):
        pairs.append((m.group(1), m.group(2)))
    # Also catch source-before-component (unlikely) via second pass if empty.
    if not pairs:
        for m in re.finditer(
            r"source:\s*\"([^\"]+)\"[\s\S]*?component:\s*\"([^\"]+)\"",
            text,
        ):
            pairs.append((m.group(2), m.group(1)))
    return pairs


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate Gallery catalog QML sources")
    parser.add_argument("--list-critical", action="store_true", help="Print critical smoke page ids")
    args = parser.parse_args()

    if args.list_critical:
        for name in CRITICAL:
            print(name)
        return 0

    if not CATALOG.is_file():
        print(f"error: missing {CATALOG}", file=sys.stderr)
        return 2

    text = CATALOG.read_text(encoding="utf-8", errors="replace")
    pairs = parse_catalog_sources(text)
    if len(pairs) < 50:
        print(f"error: expected many catalog entries, got {len(pairs)}", file=sys.stderr)
        return 2

    missing: list[str] = []
    for component, source in pairs:
        # source like pages/Foo.qml
        path = ROOT / "src" / "gallery" / source.replace("\\", "/")
        if not path.is_file():
            missing.append(f"{component} -> {source}")

    # Critical pages must exist and be listed in main.cpp
    main_text = MAIN_CPP.read_text(encoding="utf-8", errors="replace") if MAIN_CPP.is_file() else ""
    crit_missing_files: list[str] = []
    crit_missing_cpp: list[str] = []
    for name in CRITICAL:
        qml = PAGES / f"{name}.qml"
        if name == "HomePage":
            qml = PAGES / "HomePage.qml"
        if name == "SettingsPage":
            qml = PAGES / "SettingsPage.qml"
        if not qml.is_file() and name != "HomePage":
            # HomePage is under pages/
            pass
        page_path = PAGES / f"{name}.qml"
        if not page_path.is_file():
            crit_missing_files.append(name)
        if f'"{name}"' not in main_text:
            crit_missing_cpp.append(name)

    print(f"catalog: {len(pairs)} entries")
    if missing:
        print("error: missing QML sources:", file=sys.stderr)
        for line in missing:
            print(f"  {line}", file=sys.stderr)
        return 1
    print("catalog: all ControlCatalog sources exist")

    if crit_missing_files:
        print("error: critical smoke pages missing files:", crit_missing_files, file=sys.stderr)
        return 1
    if crit_missing_cpp:
        print("error: critical pages not listed in main.cpp:", crit_missing_cpp, file=sys.stderr)
        return 1
    print(f"catalog: {len(CRITICAL)} critical smoke pages OK (synced with main.cpp)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
