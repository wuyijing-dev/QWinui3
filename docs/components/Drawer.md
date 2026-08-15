# Drawer

Fluent styled Drawer.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Drawer.qml`](../../src/style/QWinUI3/Drawer.qml)

[← Component index](../components.md)

## Example

```qml
Drawer {
    id: drawer
    edge: Qt.LeftEdge
    Label { anchors.centerIn: parent; text: qsTr("Menu") }
}
drawer.open()
```

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Drawer` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
