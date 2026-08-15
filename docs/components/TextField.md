# TextField

Fluent styled TextField.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/TextField.qml`](../../src/style/QWinUI3/TextField.qml)

[← Component index](../components.md)

## Example

```qml
TextField {
    id: field
    placeholderText: qsTr("Name")
    onAccepted: submit(field.text)
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls TextField.
Public API is the Qt Quick Controls TextField type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `TextField` API (this file only supplies Fluent visuals / metrics).

### Inherited from `TextField`

- `text`
- `placeholderText`
- `accepted()`
- `editingFinished()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
