# GroupBox

Fluent styled GroupBox.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/GroupBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/GroupBox.qml)

**Category:** Styled controls · **Library:** v1.71

[← Component index](../components.md)

**Gallery:** `GroupBox` — [`src/gallery/pages/GroupBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/GroupBoxPage.qml)

## Example

```qml
GroupBox {
    title: qsTr("Options")
    Column {
        CheckBox { text: qsTr("A") }
        CheckBox { text: qsTr("B") }
    }
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls GroupBox.
Public API is the Qt Quick Controls GroupBox type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `GroupBox` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
