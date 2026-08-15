# ToolButton

Fluent styled ToolButton.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ToolButton.qml`](../../src/style/QWinUI3/ToolButton.qml)

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

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `ToolButton` API (this file only supplies Fluent visuals / metrics).

### Inherited from `ToolButton`

- `text`
- `enabled`
- `checkable` / `checked`
- `clicked()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
