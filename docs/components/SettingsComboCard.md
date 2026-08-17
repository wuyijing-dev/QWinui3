# SettingsComboCard

SettingsCard with a built-in ComboBox action.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SettingsComboCard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SettingsComboCard.qml)

**Category:** Input & forms · **Library:** v2.56

[← Component index](../components.md)

**Extends** `SettingsCard`.

## Example

```qml
SettingsComboCard {
    title: qsTr("Density")
    model: [qsTr("Standard"), qsTr("Compact")]
    currentIndex: 0
    onActivated: (i) => { … }
}
```

## Notes

Convenience over SettingsCard { action: ComboBox {…} }. Prefer for settings rows.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `alias` | — |
| `currentIndex` | `alias` | — |
| `currentText` | `alias` | — |
| `currentValue` | `alias` | — |
| `textRole` | `alias` | — |
| `valueRole` | `alias` | — |
| `comboBox` | `alias` | — |

### Signals

| Signature | Description |
| --- | --- |
| `activated(int index)` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
