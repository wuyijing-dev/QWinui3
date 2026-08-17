# SettingsToggleCard

Convenience alias for SettingsCard { toggle: true }.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SettingsToggleCard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SettingsToggleCard.qml)

**Category:** Layout · **Library:** v2.59

[← Component index](../components.md)

**Extends** `SettingsCard`.

## Example

```qml
SettingsToggleCard {
    title: qsTr("Dark mode")
    checked: Theme.dark
    onToggled: Theme.dark = checked
}

Prefer SettingsCard { toggle: true } in new code.
Accessible CheckBox + keyboard live on SettingsCard when toggle: true.
```

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
