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
- `equalWidth: bool` — Force equal-width segments

## Signals

- `selected(int index, var item)` — Selected state
- `selectionChanged(int index)` — Selection changed

## Methods

- `select(index)` — Select item by index
- `itemAt(index)` — Item at the given index
- `moveIndicator(instant)` — Move selection indicator to index
- `syncIndicatorIfIdle()` — Sync selection indicator when idle
- `nextEnabled(from, delta)` — True when next is available

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
