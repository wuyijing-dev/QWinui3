# ComboBox

Fluent ComboBox with rotating chevron indicator.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ComboBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ComboBox.qml)

**Category:** Styled controls · **Library:** v1.51

[← Component index](../components.md)

**Gallery:** `ComboBox` — [`src/gallery/pages/ComboBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ComboBoxPage.qml)

## Example

```qml
ComboBox {
    id: combo
    model: ["Red", "Green", "Blue"]
    onActivated: (index) => apply(index)
}
// --- API ---
// combo.model / currentIndex / currentText / activated() / accepted()
```

## Notes

Style-only Fluent chrome for Qt Quick Controls ComboBox.
Public API is the Qt Quick Controls ComboBox type; this file supplies visuals/metrics only.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `lightScheme` | `bool` | True in light theme |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
