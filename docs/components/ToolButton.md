# ToolButton

Fluent styled ToolButton.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ToolButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ToolButton.qml)

**Category:** Styled controls · **Library:** v1.05

[← Component index](../components.md)

## Example

```qml
ToolBar {
    ToolButton {
        id: edit
        text: qsTr("Edit")
        checkable: false
        onClicked: startEdit()
    }
}
// --- API ---
// edit.text / enabled / checkable / clicked()
```

## Notes

Style-only Fluent chrome for Qt Quick Controls ToolButton.
Public API is the Qt Quick Controls ToolButton type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `ToolButton` API (this file only supplies Fluent visuals / metrics).

### Inherited from `ToolButton`

- `text`
- `checkable` / `checked`
- `clicked()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
