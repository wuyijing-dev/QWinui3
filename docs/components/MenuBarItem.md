# MenuBarItem

Fluent styled MenuBarItem.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/MenuBarItem.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/MenuBarItem.qml)

**Category:** Styled controls · **Library:** v1.09

[← Component index](../components.md)

## Example

```qml
MenuBar {
    MenuBarItem {
        text: qsTr("Edit")
        menu: Menu { MenuItem { text: qsTr("Undo") } }
    }
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls MenuBarItem.
Public API is the Qt Quick Controls MenuBarItem type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `MenuBarItem` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
