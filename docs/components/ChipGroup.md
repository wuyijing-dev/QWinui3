# ChipGroup

Horizontal chip group for filters / single select.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ChipGroup.qml`](../../src/extras/QWinUI3/Extras/ChipGroup.qml)

[← Component index](../components.md)

## Usage

```qml
ChipGroup { model: ["All", "Open"]; currentIndex: 0 }
```

## Properties

- `model: alias` — Data model / item list for this control
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `exclusive: bool` — Single-select when true
- `selectionMode: string` — single | multiple | none
- `selectedIndexes: var` — Multi-select indexes
- `maxSelected: int` — Max selected chips when not exclusive
- `chipSpacing: real` — Spacing between chips
- `chipSize: string` — small | medium
- `modelData: var`
- `index: int`

## Signals

- `selectionChanged()` — Selection changed
- `itemClicked(int index)` — Emitted when an item is clicked

## Methods

- `isSelected(index)` — Is Selected
- `clearSelection()` — Clear Selection
- `select(index)` — Select
- `toggleIndex(index)` — Toggle Index

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
