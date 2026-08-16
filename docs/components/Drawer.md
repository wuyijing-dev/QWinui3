# Drawer

Fluent styled Drawer.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Drawer.qml`](../../src/style/QWinUI3/Drawer.qml)

[← Component index](../components.md)

## Example

```qml
Drawer {
    id: drawer
    edge: Qt.LeftEdge
    width: 320
    Label { text: qsTr("Menu") }
}
drawer.open()
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Drawer.
Qt Drawer only slides via `position` — it does not auto-set height/width to the
window edge. Side drawers bind height to Overlay; top/bottom bind width.
Enter/exit must use SmoothedAnimation on `position` (not x/y/opacity).

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Drawer` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
