# Drawer

Fluent styled Drawer.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Drawer.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Drawer.qml)

**Category:** Styled controls · **Library:** v1.21

[← Component index](../components.md)

**Gallery:** `Drawer` — [`src/gallery/pages/DrawerPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/DrawerPage.qml)

## Example

```qml
Drawer {
    id: drawer
    edge: Qt.LeftEdge
    width: Theme.dp(320)
    Label { text: qsTr("Menu") }
}
drawer.open()
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Drawer.
Qt Drawer only slides via `position` — it does not auto-set height/width to the
window edge. Side drawers bind height to Overlay; top/bottom bind width.
Enter/exit must use SmoothedAnimation on `position` (not x/y/opacity).
Parent must stay on the window Overlay: page-local overlay slots (e.g. Gallery
CatalogPage) reparent children and would otherwise clip the drawer to the pane.
Overlay size / DPI changes re-assert full-edge span.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Drawer` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
