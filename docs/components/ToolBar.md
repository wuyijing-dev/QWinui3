# ToolBar

Fluent styled ToolBar.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ToolBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ToolBar.qml)

**Category:** Styled controls · **Library:** v1.18

[← Component index](../components.md)

**Gallery:** `ToolBar` — [`src/gallery/pages/ToolBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ToolBarPage.qml)

## Example

```qml
ToolBar {
    Row {
        ToolButton { text: qsTr("Back") }
        ToolSeparator { }
        ToolButton { text: qsTr("Forward") }
    }
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls ToolBar.
Public API is the Qt Quick Controls ToolBar type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `ToolBar` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
