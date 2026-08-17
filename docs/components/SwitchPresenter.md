# SwitchPresenter

Shows the SwitchCase matching value.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SwitchPresenter.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SwitchPresenter.qml)

**Category:** Input & forms · **Library:** v1.75

[← Component index](../components.md)

**Gallery:** `SwitchPresenter` — [`src/gallery/pages/SwitchPresenterPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SwitchPresenterPage.qml)

**Extends** `Control`.

## Example

```qml
SwitchPresenter {
    id: switchPresenter
    value: mode
    SwitchCase { value: "a"; Label { text: "A" } }
}

// --- API ---
// signals: onCaseChanged
// methods: valuesEqual(a, b), select(index), applyValue(), setCaseActive(ch, on), syncWidths()
// switchPresenter.valuesEqual(a, b)
// switchPresenter.select(index)
// switchPresenter.applyValue()
// switchPresenter.setCaseActive(ch, on)
```

## Notes

Shows one SwitchCase child by currentCase / setCaseActive(name).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `var` | Current value |
| `animated` | `bool` | Play enter / reveal animation |
| `currentIndex` | `int` | Selected index |
| `selectedIndex` | `alias` | Selected index alias |
| `cases` | `alias` | Named case content map |

### Signals

| Signature | Description |
| --- | --- |
| `caseChanged(var value, int index)` | Emitted when the active SwitchPresenter case changes |

### Methods

| Signature | Description |
| --- | --- |
| `valuesEqual(a, b)` | True when two values compare equal |
| `select(index)` | Select item by index |
| `applyValue()` | Commit the pending value |
| `setCaseActive(ch, on)` | Activate a SwitchPresenter case by name |
| `syncWidths()` | Sync SwitchPresenter case widths |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
