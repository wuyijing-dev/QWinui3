# ToolTip

Fluent styled ToolTip.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ToolTip.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ToolTip.qml)

**Category:** Styled controls · **Library:** v1.10

[← Component index](../components.md)

**Gallery:** `ToolTip` — [`src/gallery/pages/ToolTipPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ToolTipPage.qml)

## Example

```qml
Button {
    text: qsTr("Hover")
    ToolTip.visible: hovered
    ToolTip.text: qsTr("Help")
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls ToolTip.
Public API is the Qt Quick Controls ToolTip type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `ToolTip` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
