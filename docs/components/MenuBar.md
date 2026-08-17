# MenuBar

Fluent styled MenuBar.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/MenuBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/MenuBar.qml)

**Category:** Styled controls · **Library:** v1.76

[← Component index](../components.md)

**Gallery:** `MenuBar` — [`src/gallery/pages/MenuBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/MenuBarPage.qml)

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

## Notes

Style-only Fluent chrome for Qt Quick Controls MenuBar.
Public API is the Qt Quick Controls MenuBar type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `MenuBar` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
