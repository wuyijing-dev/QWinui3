#!/usr/bin/env python3
"""Annotate any remaining undoc properties/signals at any depth in QML files."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DIRS = [
    ROOT / "src/extras/QWinUI3/Extras",
    ROOT / "src/style/QWinUI3",
    ROOT / "src/platform/QWinUI3/Platform",
    ROOT / "src/theme/QWinUI3/Theme",
]

HINTS = {
    "hasOverflow": "True when content overflows the visible area",
    "childItems": "Expanded child rows for a nav group",
    "baseHeight": "Selection pip rest height",
    "contentFromY": "Pip animation start contentY",
    "contentToY": "Pip animation end contentY",
    "progress": "0..1 animation / progress value",
    "slid": "True after a swipe/slide reveal",
    "title": "Title text",
    "itemChecked": "True when this option is selected",
    "itemText": "Display text for this option",
    "inset": "Use inset stroke chrome",
    "tabIndex": "Tab index in the model",
    "dragActive": "True while this tab is being dragged",
    "travel": "Absolute pip travel distance",
    "contentCenterY": "Animated pip center Y in content coords",
    "visualHeight": "Current pip visual height (stretch)",
    "eased": "Eased 0..1 animation progress",
}

SKIP = {"index", "modelData"}
PROP = re.compile(
    r"^(\s*)((?:readonly\s+|default\s+|required\s+)*property\s+"
    r"(?:alias\s+)?[\w.<>,\s]+?\s+)(\w+)\b"
)
SIG = re.compile(r"^(\s*)(signal\s+)(\w+)\b")
FUNC = re.compile(r"^(\s*)(function\s+)(\w+)\b")


def humanize(name: str) -> str:
    words = re.sub(r"([a-z0-9])([A-Z])", r"\1 \2", name).replace("_", " ")
    return (words[:1].upper() + words[1:]) if words else name


def main() -> None:
    inserted = changed = 0
    for d in DIRS:
        if not d.is_dir():
            continue
        for path in sorted(d.glob("*.qml")):
            lines = path.read_text(encoding="utf-8").splitlines()
            out: list[str] = []
            file_changed = False
            for i, line in enumerate(lines):
                prev = out[-1] if out else ""
                m = PROP.match(line) or SIG.match(line)
                if m and not prev.strip().startswith("//"):
                    name = m.group(3)
                    if not (
                        name.startswith("_")
                        or name in SKIP
                        or "required " in m.group(2)
                    ):
                        hint = HINTS.get(name) or humanize(name)
                        out.append(f"{m.group(1)}// {hint}")
                        inserted += 1
                        file_changed = True
                # document public functions missing comments
                fm = FUNC.match(line)
                if (
                    fm
                    and not prev.strip().startswith("//")
                    and not fm.group(3).startswith("_")
                ):
                    # only at shallow depth (root API)
                    if i < 120 or path.name == "Theme.qml":
                        out.append(f"{fm.group(1)}// {humanize(fm.group(3))}")
                        inserted += 1
                        file_changed = True
                out.append(line)
            if file_changed:
                path.write_text("\n".join(out) + "\n", encoding="utf-8", newline="\n")
                changed += 1
                print(f"DEEP {path.relative_to(ROOT)}")
    print(f"Inserted {inserted} comments in {changed} files")


if __name__ == "__main__":
    main()
