# Frame

Fluent styled Frame.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Frame.qml`](../../src/style/QWinUI3/Frame.qml)

[← Component index](../components.md)

## Example

```qml
Frame {
    id: frame
    padding: Theme.paddingControlH
    Label { text: qsTr("Framed content") }
}
// --- API ---
// inherits Frame/Pane: padding, background, contentItem
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Frame.
Public API is the Qt Quick Controls Frame type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Frame` API (this file only supplies Fluent visuals / metrics).

### Inherited from `Frame`

- `padding`
- `background`
- `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
