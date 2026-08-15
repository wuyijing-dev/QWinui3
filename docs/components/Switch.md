# Switch

Fluent styled Switch.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Switch.qml`](../../src/style/QWinUI3/Switch.qml)

[← Component index](../components.md)

## Example

```qml
Switch {
    id: sw
    text: qsTr("Dark mode")
    onToggled: Theme.dark = sw.checked
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Switch.
Public API is the Qt Quick Controls Switch type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Switch` API (this file only supplies Fluent visuals / metrics).

### Inherited from `Switch`

- `text`
- `checked`
- `toggled()`
- `clicked()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
