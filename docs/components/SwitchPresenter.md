# SwitchPresenter

Shows the SwitchCase matching value.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SwitchPresenter.qml`](../../src/extras/QWinUI3/Extras/SwitchPresenter.qml)

[← Component index](../components.md)

## Usage

```qml
SwitchPresenter {
    value: mode
    SwitchCase { value: "a"; Label { text: "A" } }
}
```

## Properties

- `value: var` — Current value
- `animated: bool` — Play enter / reveal animation
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `cases: alias` — Named case content map

## Signals

- `caseChanged(var value, int index)` — Emitted when the active SwitchPresenter case changes

## Methods

- `valuesEqual(a, b)` — True when two values compare equal
- `select(index)` — Select item by index
- `applyValue()` — Commit the pending value
- `setCaseActive(ch, on)` — Activate a SwitchPresenter case by name
- `syncWidths()` — Sync SwitchPresenter case widths

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
