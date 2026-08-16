# Button

Fluent Button with WinUI stroke / fill / focus chrome.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Button.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Button.qml)

**Category:** Styled controls · **Library:** v1.15

[← Component index](../components.md)

**Gallery:** `Button` — [`src/gallery/pages/ButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ButtonPage.qml)

## Example

```qml
Button {
    id: btn
    text: qsTr("OK")
    onClicked: accept()
}
// --- API ---
// style-only Fluent chrome; API is Qt Quick Controls Button
// btn.text / enabled / highlighted / clicked()
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Button.
Public API is the Qt Quick Controls Button type; this file supplies visuals/metrics only.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `accented` | `bool` | Use accent chrome |
| `lightScheme` | `bool` | True in light theme |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
