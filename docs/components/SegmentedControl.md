# SegmentedControl

Mutually exclusive segment buttons.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SegmentedControl.qml`](../../src/extras/QWinUI3/Extras/SegmentedControl.qml)

[← Component index](../components.md)

## Usage

```qml
SegmentedControl {
    model: ["Day", "Week", "Month"]
    currentIndex: 0
}
```

## Properties

- `model: var` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `stretch: bool` — Stretch factor / stretch pip
- `equalWidth: bool` — Equal Width
- `modelData: var`
- `index: int`
- `segmentIndex: int` — Active segment index

## Signals

- `selected(int index, var item)` — Selected state
- `selectionChanged(int index)` — Selection changed

## Methods

- `select(index)` — Select
- `itemAt(index)` — Item At
- `moveIndicator(instant)` — Move Indicator
- `syncIndicatorIfIdle()` — Sync Indicator If Idle
- `nextEnabled(from, delta)` — Next Enabled

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
