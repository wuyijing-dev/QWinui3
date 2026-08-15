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
- `cases: alias` — Cases

## Signals

- `caseChanged(var value, int index)` — Case Changed

## Methods

- `valuesEqual(a, b)` — Values Equal
- `select(index)` — Select
- `applyValue()` — Apply Value
- `setCaseActive(ch, on)` — Set Case Active
- `syncWidths()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
