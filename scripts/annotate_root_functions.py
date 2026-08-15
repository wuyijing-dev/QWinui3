#!/usr/bin/env python3
"""Insert missing // comments above root-level functions in key QML files."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

HINTS = {
    "moveNavItem": "Reorder a top-level nav model entry (requires isReorderable)",
    "isGroupExpanded": "True when the nav group is expanded",
    "rebuildNavModel": "Rebuild the flattened ListModel from model",
    "setGroupExpanded": "Expand or collapse a nav group by key",
    "selectionAnchorItem": "Visual anchor item for the selection pip",
    "toggleGroup": "Toggle a nav group expanded state",
    "groupTitle": "Title text for a nav group key",
    "fillFlyoutModel": "Populate the compact-mode group flyout model",
    "openCompactFlyout": "Open the compact pane group flyout",
    "requestCompactFlyout": "Schedule opening the compact flyout (hover delay)",
    "requestCloseCompactFlyout": "Schedule closing the compact flyout",
    "componentForKey": "Resolve page component name for a nav key",
    "flatIndexForKey": "Flat list index for a nav key",
    "ensureSelectionVisible": "Scroll so the current selection is on-screen",
    "selectIndex": "Select a top-level model index (legacy)",
    "selectKey": "Select by nav key and open the page",
    "selectFooter": "Select the footer row and open footerComponent",
    "ensureComponent": "Load / cache a page Component from pageModule",
    "openPage": "Replace the page stack with the named component",
    "openSlide": "Open a page with the slide transition",
    "openFromCenter": "Open a page with the center scale transition",
    "navigateToTitle": "Select the first nav item matching a title",
    "reloadPage": "Reload the current page component",
    "reportHitTest": "Push title-bar hit-test rects to WindowHelper",
    "updateHitTest": "Push title-bar hit-test rects to WindowHelper",
    "applyChrome": "Apply WindowHelper chrome / backdrop",
    "addTab": "Append a tab to the model",
    "closeTab": "Close tab at index",
    "moveTab": "Move a tab from/to index",
    "layoutPanes": "Recompute TwoPaneView pane geometry",
    "swapPanes": "Swap primary / secondary panes",
    "reparentPanes": "Reparent panes for the current mode",
    "toggleSinglePane": "Toggle single-pane display",
    "enqueue": "Enqueue a ContentDialog",
    "clearQueue": "Drop queued dialogs without dismissing the current one",
    "replaceCurrent": "Replace the currently shown dialog",
    "cancel": "Cancel / dismiss the current dialog",
    "openQueued": "Open the next queued dialog",
}


def humanize(name: str) -> str:
    words = re.sub(r"([a-z0-9])([A-Z])", r"\1 \2", name).replace("_", " ")
    return (words[:1].upper() + words[1:]) if words else name


def hint_for(name: str) -> str:
    if name in HINTS:
        return HINTS[name]
    if name.startswith("is") and len(name) > 2 and name[2].isupper():
        return f"True when {humanize(name[2:]).lower()}"
    if name.startswith("set") and len(name) > 3 and name[3].isupper():
        return f"Set {humanize(name[3:]).lower()}"
    if name.startswith("open"):
        return f"Open {humanize(name[4:]).lower() or 'the control'}"
    if name.startswith("close"):
        return f"Close {humanize(name[5:]).lower() or 'the control'}"
    return humanize(name)


def annotate(path: Path) -> int:
    lines = path.read_text(encoding="utf-8").splitlines()
    # detect root indent
    indent = None
    for line in lines:
        m = re.match(r"^(\s+)(?:(?:readonly|default|required)\s+)*property\s+", line)
        if m:
            indent = len(m.group(1))
            break
    if indent is None:
        return 0
    func_re = re.compile(rf"^{' ' * indent}function\s+(\w+)\b")
    out: list[str] = []
    n = 0
    for i, line in enumerate(lines):
        m = func_re.match(line)
        if m:
            name = m.group(1)
            prev = out[-1] if out else ""
            if not name.startswith("_") and not prev.strip().startswith("//"):
                out.append(f"{' ' * indent}// {hint_for(name)}")
                n += 1
        out.append(line)
    if n:
        path.write_text("\n".join(out) + "\n", encoding="utf-8", newline="\n")
    return n


def main() -> None:
    dirs = [
        ROOT / "src/extras/QWinUI3/Extras",
        ROOT / "src/platform/QWinUI3/Platform",
        ROOT / "src/style/QWinUI3",
        ROOT / "src/theme/QWinUI3/Theme",
    ]
    total = files = 0
    for d in dirs:
        if not d.is_dir():
            continue
        for path in sorted(d.glob("*.qml")):
            n = annotate(path)
            if n:
                print(f"{path.relative_to(ROOT)}: +{n}")
                total += n
                files += 1
    print(f"Inserted {total} function comments in {files} files")


if __name__ == "__main__":
    main()
