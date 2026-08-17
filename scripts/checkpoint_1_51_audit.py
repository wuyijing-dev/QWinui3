#!/usr/bin/env python3
"""1.51 maturity checkpoint: light stable-api / Gallery / docs link audit."""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    stable_md = (ROOT / "docs/stable-api.md").read_text(encoding="utf-8")
    # First-column backtick types in markdown tables
    stable = set(re.findall(r"\|\s*`([A-Za-z][A-Za-z0-9/ ]+)`", stable_md))
    # Normalize Style `X` style rows already captured

    catalog = (ROOT / "src/gallery/ControlCatalog.qml").read_text(encoding="utf-8")
    pages = sorted(set(re.findall(r'component:\s*"([A-Za-z0-9]+)"', catalog)))

    cj_path = ROOT / "docs/components.json"
    public = []
    data = json.loads(cj_path.read_text(encoding="utf-8"))
    if isinstance(data, dict) and "components" in data:
        items = data["components"]
    elif isinstance(data, list):
        items = data
    else:
        items = []
    for item in items:
        if isinstance(item, dict) and item.get("name"):
            if item.get("visibility") == "internal":
                continue
            public.append(item["name"])

    # Recipe docs linked from recipes.md
    recipes = (ROOT / "docs/recipes.md").read_text(encoding="utf-8")
    recipe_links = re.findall(r"\]\(([^)#]+\.md)\)", recipes)
    missing = []
    for link in recipe_links:
        p = (ROOT / "docs" / link).resolve()
        if not p.exists():
            missing.append(link)

    # Spot-check ROADMAP doc links under docs/
    roadmap = (ROOT / "ROADMAP.md").read_text(encoding="utf-8")
    rm_links = re.findall(r"\]\((docs/[^)#]+\.md)\)", roadmap)
    for link in rm_links:
        if not (ROOT / link).exists():
            missing.append(link)

    print(f"stable-api table names (approx): {len(stable)}")
    print(f"Gallery catalog pages: {len(pages)}")
    print(f"public components.json: {len(public)}")
    print(f"broken recipe/roadmap links: {len(missing)}")
    for m in missing[:20]:
        print(f"  MISSING {m}")

    # Gallery pages that are recipe hubs (no control type)
    recipe_pages = [p for p in pages if p.endswith("Page") and any(
        k in p for k in (
            "Hub", "Recipes", "Pitfalls", "Performance", "CiSmoke", "I18n",
            "Keyboard", "Graphics", "Density", "Packaging", "QtCreator",
            "Examples", "FormsHub", "CommandsHub", "FeedbackHub",
        )
    )]
    print(f"recipe-ish Gallery pages: {len(recipe_pages)}")

    # Ensure gallery-shell mentioned in stable-api starters
    if "gallery-shell" not in stable_md:
        print("NOTE: stable-api starters missing gallery-shell")
    else:
        print("stable-api mentions gallery-shell: yes")

    out = ROOT / "docs" / "_checkpoint_1_51_audit.txt"
    # Don't write junk into docs permanently — print only
    return 0 if not missing else 1


if __name__ == "__main__":
    raise SystemExit(main())
