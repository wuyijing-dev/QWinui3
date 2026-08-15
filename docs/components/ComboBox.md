# ComboBox

Fluent ComboBox with rotating chevron indicator.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ComboBox.qml`](../../src/style/QWinUI3/ComboBox.qml)

[← Component index](../components.md)

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
