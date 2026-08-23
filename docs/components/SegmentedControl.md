# SegmentedControl

Mutually exclusive segment buttons.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SegmentedControl.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SegmentedControl.qml)

**Category:** Other · **Library:** v2.65

[← Component index](../components.md)

**Gallery:** `SegmentedControl` — [`src/gallery/pages/SegmentedControlPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SegmentedControlPage.qml)

**Extends** `Control`.

## Example

```qml
SegmentedControl {
    id: segmentedControl
    model: ["Day", "Week", "Month"]
    currentIndex: 0
}

// --- API ---
// signals: onSelected, onSelectionChanged
// methods: select(index), itemAt(index), moveIndicator(instant), syncIndicatorIfIdle(), nextEnabled(from, delta)
// segmentedControl.select(index)
// segmentedControl.itemAt(index)
// segmentedControl.moveIndicator(instant)
// segmentedControl.syncIndicatorIfIdle()
```

## Notes

Exclusive segment buttons from model; currentIndex selection.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | Data model / item list for this control |
| `currentIndex` | `int` | Selected index |
| `selectedIndex` | `alias` | Selected index alias |
| `selectedItem` | `var` | Currently selected model item (WinUI SelectedItem) |
| `stretch` | `bool` | Stretch factor / stretch pip |
| `equalWidth` | `bool` | Force equal-width segments |

### Signals

| Signature | Description |
| --- | --- |
| `selected(int index, var item)` | Selected state |
| `selectionChanged(int index)` | Selection changed |

### Methods

| Signature | Description |
| --- | --- |
| `select(index)` | Select item by index |
| `itemAt(index)` | Item at the given index |
| `moveIndicator(instant)` | Move selection indicator to index |
| `syncIndicatorIfIdle()` | Sync selection indicator when idle |
| `nextEnabled(from, delta)` | True when next is available |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
