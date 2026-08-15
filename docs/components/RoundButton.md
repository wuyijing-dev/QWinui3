# RoundButton

Fluent styled RoundButton.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/RoundButton.qml`](../../src/style/QWinUI3/RoundButton.qml)

[← Component index](../components.md)

## Example

```qml
RoundButton {
    id: round
    text: "+"
    enabled: true
    onClicked: add()
}
// --- API ---
// inherits AbstractButton: text, enabled, clicked()
```

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `RoundButton` API (this file only supplies Fluent visuals / metrics).

### Inherited from `RoundButton`

- `text`
- `enabled`
- `clicked()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
