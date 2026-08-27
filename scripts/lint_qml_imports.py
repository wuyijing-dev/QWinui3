#!/usr/bin/env python3
"""Lint example app QML for experimental / permanent-defer types (2.51).

  python scripts/lint_qml_imports.py
  python scripts/lint_qml_imports.py --path examples/dashboard

Scans product-facing examples (and Gallery `Main.qml` / `HomePage.qml` for the shell import set). See docs/stable-clarity-251.md · docs/packaging-consumer.md (3.36).
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# Types that must not appear in stable example apps (compose alternatives exist).
PERMANENT_DEFER = (
    "AreaChart",
    "Sparkline",
    "MediaPlayerElement",
    "PieChart",
    "ScatterChart",
    "HeatmapChart",
    "RadarChart",
    "BulletChart",
    "TankGauge",
    "ThermometerGauge",
    "HorizontalBarChart",
    "StackedBarChart",
    "WaterfallChart",
    "RadialGauge",
    "LinearGauge",
    "ArcGauge",
    "SegmentedGauge",
    "ZoneGauge",
)

# Allowed only in named demo folders (OSK sample).
EXPERIMENTAL = (
    "OnScreenKeyboard",
    "OnScreenKeyboardWindow",
    "KeyboardEngine",
    "ImeCandidateBar",
    "TreeDataGrid",
    "FileTree",
    "ItemsWrapGrid",
    "CalendarView",
    "NotificationCenter",
    "SwipeControl",
)

ALLOW_EXPERIMENTAL_DIRS = frozenset({"floating-osk", "osk-dock"})

# Optional URIs (3.36 S13) — shell examples must not import these.
DEFERRED_IMPORTS = (
    "QWinUI3.Extras.Charts",
    "QWinUI3.Extras.Osk",
    "QWinUI3.Platform.WebView2",
)
ALLOW_CHARTS_DIRS = frozenset({"dashboard"})
ALLOW_OSK_DIRS = frozenset({"floating-osk", "osk-dock"})
ALLOW_WEBVIEW2_DIRS = frozenset()  # no in-tree example hosts WebView2 yet

# Gallery / template entrypoints that must stay on the shell import set.
SHELL_ENTRYPOINTS = (
    ROOT / "src" / "gallery" / "Main.qml",
    ROOT / "src" / "gallery" / "pages" / "HomePage.qml",
    ROOT / "templates" / "consumer" / "cpp" / "first-app" / "Main.qml",
)


def _deferred_import_errors(path: Path, text: str) -> list[str]:
    rel = path.relative_to(ROOT)
    parts = set(path.relative_to(ROOT).parts)
    errors: list[str] = []
    for uri in DEFERRED_IMPORTS:
        if not re.search(rf"^import {re.escape(uri)}\b", text, re.MULTILINE):
            continue
        if uri.endswith(".Charts") and (parts & ALLOW_CHARTS_DIRS):
            continue
        if uri.endswith(".Osk") and (parts & ALLOW_OSK_DIRS):
            continue
        if uri.endswith("WebView2") and (parts & ALLOW_WEBVIEW2_DIRS):
            continue
        errors.append(f"{rel}: shell import set forbids `{uri}` (3.36 S13)")
    return errors


def lint_file(path: Path) -> list[str]:
    rel = path.relative_to(ROOT)
    parts = set(path.relative_to(ROOT).parts)
    allow_experimental = bool(parts & ALLOW_EXPERIMENTAL_DIRS)
    text = path.read_text(encoding="utf-8")
    errors: list[str] = []
    for name in PERMANENT_DEFER:
        if re.search(rf"\b{re.escape(name)}\b", text):
            errors.append(f"{rel}: permanent-defer type {name!r}")
    if not allow_experimental:
        for name in EXPERIMENTAL:
            if re.search(rf"\b{re.escape(name)}\b", text):
                errors.append(f"{rel}: experimental type {name!r} (allowed only in {sorted(ALLOW_EXPERIMENTAL_DIRS)})")
    errors.extend(_deferred_import_errors(path, text))
    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Lint example QML imports (2.51)")
    parser.add_argument(
        "--path",
        type=Path,
        default=ROOT / "examples",
        help="Root directory to scan (default: examples/)",
    )
    args = parser.parse_args()
    root = args.path.resolve()
    if not root.is_dir():
        print(f"error: not a directory: {root}", file=sys.stderr)
        return 2

    errors: list[str] = []
    for qml in sorted(root.rglob("*.qml")):
        # Skip local mirrors / caches (e.g. python-gallery/.qml-module/)
        if any(part.startswith(".") for part in qml.relative_to(root).parts):
            continue
        errors.extend(lint_file(qml))

    if root == (ROOT / "examples").resolve():
        for extra in SHELL_ENTRYPOINTS:
            if extra.is_file():
                errors.extend(_deferred_import_errors(extra, extra.read_text(encoding="utf-8")))

    if errors:
        print("error: QML import lint failed:", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1

    print(f"QML import lint: OK ({root.relative_to(ROOT)})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
