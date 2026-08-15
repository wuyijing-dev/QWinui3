# Menu

Fluent styled Menu.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Menu.qml`](../../src/style/QWinUI3/Menu.qml)

[← Component index](../components.md)

## Example

```qml
Button {
    text: qsTr("Open")
    onClicked: menu.open()
    Menu {
        id: menu
        MenuItem { text: qsTr("New"); onTriggered: create() }
        MenuSeparator { }
        MenuItem { text: qsTr("Quit"); onTriggered: Qt.quit() }
    }
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Menu.
Public API is the Qt Quick Controls Menu type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Menu` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
