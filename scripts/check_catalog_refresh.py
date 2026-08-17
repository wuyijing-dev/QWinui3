#!/usr/bin/env python3
"""Validate component docs + Gallery catalog refresh (2.20).

  python scripts/check_catalog_refresh.py

No build required. Pair with:
  python scripts/generate_component_docs.py
  python scripts/smoke_catalog.py
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

CMAKE = ROOT / "CMakeLists.txt"
COMPONENTS_MD = ROOT / "docs" / "components.md"
COMPONENTS_JSON = ROOT / "docs" / "components.json"
CI_SMOKE = ROOT / "docs" / "ci-smoke.md"
CATALOG = ROOT / "src" / "gallery" / "ControlCatalog.qml"


def _project_version() -> str:
    text = CMAKE.read_text(encoding="utf-8")
    m = re.search(r'set\(QWINUI3_VERSION\s+"([^"]+)"\)', text)
    return m.group(1) if m else ""


def _critical_from_smoke_catalog() -> list[str]:
    text = (ROOT / "scripts" / "smoke_catalog.py").read_text(encoding="utf-8")
    m = re.search(r"CRITICAL\s*=\s*\[([\s\S]*?)\]", text)
    if not m:
        return []
    return re.findall(r'"([A-Za-z0-9]+)"', m.group(1))


def main() -> int:
    errors: list[str] = []

    version = _project_version()
    if not version:
        errors.append("CMakeLists.txt: missing QWINUI3_VERSION")

    if not COMPONENTS_MD.is_file():
        errors.append("missing docs/components.md — run generate_component_docs.py")
    else:
        md = COMPONENTS_MD.read_text(encoding="utf-8")
        vm = re.search(r"Library \*\*v([0-9.]+)\*\*", md)
        if not vm:
            errors.append("components.md: missing Library version line")
        elif version and vm.group(1) != version:
            errors.append(
                f"components.md version v{vm.group(1)} != CMake QWINUI3_VERSION {version}"
            )
        if "generate_component_docs.py" not in md:
            errors.append("components.md: missing generate_component_docs.py pointer")

    if not COMPONENTS_JSON.is_file():
        errors.append("missing docs/components.json — run generate_component_docs.py")
    else:
        data = json.loads(COMPONENTS_JSON.read_text(encoding="utf-8"))
        if version and str(data.get("version", "")) != version:
            errors.append(
                f"components.json version {data.get('version')} != {version}"
            )
        items = data.get("components") or data.get("items") or []
        if len(items) < 200:
            errors.append(f"components.json: expected 200+ entries, got {len(items)}")

    if CI_SMOKE.is_file():
        ctext = CI_SMOKE.read_text(encoding="utf-8")
        for needle in ("2.55", "PitfallsPage", "forms-unlike-winui-255"):
            if needle not in ctext:
                errors.append(f"ci-smoke.md: missing {needle!r}")
    else:
        errors.append("missing docs/ci-smoke.md")

    if CATALOG.is_file():
        ctext = CATALOG.read_text(encoding="utf-8")
        fn = re.search(
            r"function smokeCriticalComponents\(\)\s*\{\s*return\s*\[([\s\S]*?)\]\s*\}",
            ctext,
        )
        if not fn:
            errors.append("ControlCatalog: smokeCriticalComponents() missing")
        else:
            qml_crit = re.findall(r'"([A-Za-z0-9]+)"', fn.group(1))
            critical = _critical_from_smoke_catalog()
            if qml_crit != critical:
                errors.append("ControlCatalog.smokeCriticalComponents != smoke_catalog.CRITICAL")
        for page in ("MultiWindowPage", "StyleSpotCheckPage"):
            if page not in ctext:
                errors.append(f"ControlCatalog: missing {page}")
    else:
        errors.append("missing ControlCatalog.qml")

    main_cpp = ROOT / "src" / "gallery" / "main.cpp"
    if main_cpp.is_file():
        mtext = main_cpp.read_text(encoding="utf-8")
        for page in ("MultiWindowPage", "StyleSpotCheckPage"):
            if f'"{page}"' not in mtext:
                errors.append(f"main.cpp kCriticalPages: missing {page}")

    if errors:
        print("error: catalog refresh checks failed:", file=sys.stderr)
        for e in errors:
            print(f"  {e}", file=sys.stderr)
        return 1

    print(f"catalog refresh: OK (components v{version} + critical smoke sync)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
