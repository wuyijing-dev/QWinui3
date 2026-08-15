# CheckBox

Fluent styled CheckBox.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/CheckBox.qml`](../../src/style/QWinUI3/CheckBox.qml)

[← Component index](../components.md)

## Example

```qml
CheckBox {
    id: box
    text: qsTr("Remember me")
    checked: true
    onToggled: save()
}
```

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `CheckBox` API (this file only supplies Fluent visuals / metrics).

### Inherited from `CheckBox`

- `text`
- `checked` / `checkState`
- `toggled()`
- `clicked()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
