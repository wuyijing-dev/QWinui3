# SettingsSliderCard

SettingsCard with a built-in value Slider action.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SettingsSliderCard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SettingsSliderCard.qml)

**Category:** Input & forms · **Library:** v2.80

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `SettingsCard`.

## Example

```qml
SettingsSliderCard {
    title: qsTr("Volume")
    from: 0; to: 100; value: 40
    onMoved: { … }
}
```

## Notes

Convenience over SettingsCard { action: Slider {…} }. Shows a live value label.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `from` | `alias` | — |
| `to` | `alias` | — |
| `value` | `alias` | — |
| `stepSize` | `alias` | — |
| `slider` | `alias` | — |
| `valuePrecision` | `int` | — |

### Signals

| Signature | Description |
| --- | --- |
| `moved()` | — |
| `valueEdited(real value)` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
