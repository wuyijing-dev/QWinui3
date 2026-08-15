# ChipGroup

Horizontal chip group for filters / single select.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ChipGroup.qml`](../../src/extras/QWinUI3/Extras/ChipGroup.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
ChipGroup {
    id: chipGroup
   model: ["All", "Open"]; currentIndex: 0
}

// --- API ---
// signals: onSelectionChanged, onItemClicked
// methods: isSelected(index), clearSelection(), select(index), toggleIndex(index)
// chipGroup.isSelected(index)
// chipGroup.clearSelection()
// chipGroup.select(index)
// chipGroup.toggleIndex(index)
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `alias` | Data model / item list for this control |
| `currentIndex` | `int` | Selected index |
| `selectedIndex` | `alias` | Selected index alias |
| `exclusive` | `bool` | Single-select when true |
| `selectionMode` | `string` | single \| multiple \| none |
| `selectedIndexes` | `var` | Multi-select indexes |
| `maxSelected` | `int` | Max selected chips when not exclusive |
| `chipSpacing` | `real` | Spacing between chips |
| `chipSize` | `string` | small \| medium |

### Signals

| Signature | Description |
| --- | --- |
| `selectionChanged()` | Selection changed |
| `itemClicked(int index)` | Emitted when an item is clicked |

### Methods

| Signature | Description |
| --- | --- |
| `isSelected(index)` | True when this item is selected |
| `clearSelection()` | Clear the current selection |
| `select(index)` | Select item by index |
| `toggleIndex(index)` | Toggle selection at index |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
