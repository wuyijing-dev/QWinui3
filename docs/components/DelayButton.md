# DelayButton

Fluent styled DelayButton.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/DelayButton.qml`](../../src/style/QWinUI3/DelayButton.qml)

[← Component index](../components.md)

## Example

```qml
DelayButton {
    id: hold
    text: qsTr("Hold to confirm")
    delay: 1000
    onActivated: confirm()
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls DelayButton.
Public API is the Qt Quick Controls DelayButton type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `DelayButton` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
