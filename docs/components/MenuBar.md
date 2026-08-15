# MenuBar

Fluent styled MenuBar.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/MenuBar.qml`](../../src/style/QWinUI3/MenuBar.qml)

[← Component index](../components.md)

## Example

```qml
ApplicationWindow {
    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem { text: qsTr("Exit") }
        }
    }
}
```

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `MenuBar` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
