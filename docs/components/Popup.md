# Popup

Fluent styled Popup chrome.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Popup.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Popup.qml)

**Category:** Styled controls · **Library:** v1.73

[← Component index](../components.md)

## Example

```qml
Popup {
    id: pop
    modal: true
    contentItem: Label { text: qsTr("Hi") }
}
pop.open()
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Popup.
Public API is the Qt Quick Controls Popup type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Popup` API (this file only supplies Fluent visuals / metrics).

### Inherited from `Popup`

- `open()` / `close()`
- `opened()` / `closed()`
- `modal` / `focus`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
