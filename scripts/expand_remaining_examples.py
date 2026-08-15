#!/usr/bin/env python3
"""Force-expand the remaining short style/platform examples."""
from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from generate_component_docs import RE_HEADER_BLOCK, parse_header_comments  # noqa: E402

RICH = {
    "BusyIndicator": """\
BusyIndicator {
    id: busy
    running: true
    // stop with: busy.running = false
}
// --- API ---
// inherits BusyIndicator: running
// Fluent ring visuals only — no extra public properties
""",
    "DayOfWeekRow": """\
DayOfWeekRow {
    id: dow
    locale: Qt.locale()
    // typically placed above MonthGrid
}
// --- API ---
// inherits DayOfWeekRow: locale, delegate
""",
    "Frame": """\
Frame {
    id: frame
    padding: Theme.paddingControlH
    Label { text: qsTr("Framed content") }
}
// --- API ---
// inherits Frame/Pane: padding, background, contentItem
""",
    "HorizontalHeaderView": """\
TableView {
    id: table
    // …
}
HorizontalHeaderView {
    id: header
    syncView: table
    clip: true
}
// --- API ---
// header.syncView / model / clip
""",
    "VerticalHeaderView": """\
TableView {
    id: table
}
VerticalHeaderView {
    id: vheader
    syncView: table
    clip: true
}
// --- API ---
// vheader.syncView / model / clip
""",
    "MenuItem": """\
Menu {
    id: menu
    MenuItem {
        id: item
        text: qsTr("Copy")
        enabled: true
        onTriggered: copy()
    }
}
// --- API ---
// item.text / enabled / checkable / triggered()
""",
    "PageIndicator": """\
SwipeView {
    id: pages
    Item {}
    Item {}
    Item {}
}
PageIndicator {
    id: dots
    count: pages.count
    currentIndex: pages.currentIndex
    interactive: true
    anchors.horizontalCenter: parent.horizontalCenter
}
// --- API ---
// dots.count / currentIndex / interactive
""",
    "RoundButton": """\
RoundButton {
    id: round
    text: "+"
    enabled: true
    onClicked: add()
}
// --- API ---
// inherits AbstractButton: text, enabled, clicked()
""",
    "ScrollBar": """\
Flickable {
    id: flick
    contentHeight: 2000
    ScrollBar.vertical: ScrollBar {
        id: vbar
        policy: ScrollBar.AsNeeded
    }
}
// --- API ---
// vbar.policy / size / position / increase() / decrease()
""",
    "ScrollIndicator": """\
Flickable {
    id: flick
    contentHeight: 2000
    ScrollIndicator.vertical: ScrollIndicator {
        id: indicator
    }
}
// --- API ---
// indicator.active / size / position
""",
    "ToggleMenuFlyoutItem": """\
MenuFlyout {
    ToggleMenuFlyoutItem {
        id: wrap
        text: qsTr("Word wrap")
        checked: true
        onToggled: applyWrap(wrap.checked)
    }
}
// --- API ---
// wrap.checked / onToggled / text
""",
    "ToolButton": """\
ToolBar {
    ToolButton {
        id: edit
        text: qsTr("Edit")
        checkable: false
        onClicked: startEdit()
    }
}
// --- API ---
// edit.text / enabled / checkable / clicked()
""",
    "TreeViewDelegate": """\
TreeView {
    id: tree
    model: treeModel
    delegate: TreeViewDelegate {
        // indentation / expansion affordance from style
    }
}
// --- API ---
// inherits TreeViewDelegate: treeView, expanded, depth, indentation
""",
    "Tumbler": """\
Tumbler {
    id: hours
    model: 24
    currentIndex: 8
    visibleItemCount: 5
    onCurrentIndexChanged: applyHour(hours.currentIndex)
}
// --- API ---
// hours.model / currentIndex / visibleItemCount
""",
    "Theme": """\
import QWinUI3.Theme

Theme.dark = true
Theme.reducedMotion = false
Theme.followSystemAccessibility = true
Theme.accent = "#005FB8"

Rectangle {
    color: Theme.bgCard
    radius: Theme.cornerControl
    Behavior on color {
        ColorAnimation { duration: Theme.duration(Theme.motionNormal) }
    }
}
// --- API ---
Theme.duration(ms)
Theme.controlFill(hovered, pressed, disabled)
Theme.accentFill(hovered, pressed, disabled)
""",
}


def commentize(usage: str) -> str:
    out = []
    for line in usage.splitlines():
        if not line.strip():
            out.append("//")
        else:
            out.append("//   " + line)
    return "\n".join(out)


def main() -> None:
    dirs = [
        ROOT / "src/style/QWinUI3",
        ROOT / "src/theme/QWinUI3/Theme",
        ROOT / "src/extras/QWinUI3/Extras",
        ROOT / "src/platform/QWinUI3/Platform",
    ]
    n = 0
    for d in dirs:
        for path in sorted(d.glob("*.qml")):
            if path.stem not in RICH:
                continue
            text = path.read_text(encoding="utf-8")
            summary, _, _ = parse_header_comments(text, path.stem)
            if not summary:
                summary = path.stem
            m = RE_HEADER_BLOCK.match(text)
            if not m:
                continue
            header = f"// {path.stem} — {summary}\n//\n{commentize(RICH[path.stem])}\n"
            new = text[: m.start("header")] + header + text[m.end("header") :]
            path.write_text(new, encoding="utf-8", newline="\n")
            print(f"EXPAND {path.relative_to(ROOT)}")
            n += 1
    print(f"Expanded {n}")


if __name__ == "__main__":
    main()
