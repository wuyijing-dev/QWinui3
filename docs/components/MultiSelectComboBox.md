# MultiSelectComboBox

Combo that keeps the popup open for multi-select.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MultiSelectComboBox.qml`](../../src/extras/QWinUI3/Extras/MultiSelectComboBox.qml)

[← Component index](../components.md)

## Usage

```qml
MultiSelectComboBox { model: items; selectedIndexes: [0, 2] }
```

## Properties

- `model: var` — Data model / item list for this control
- `placeholderText: string` — Placeholder when empty
- `header: string` — Header label above the control
- `menuOpen: bool` — Menu currently open
- `isOpen: alias` — Open / visible state
- `selectedItems: var` — Selected Items
- `displayText: string` — Text shown to the user

## Signals

- `selectionChanged(var selected)` — Selection changed

## Methods

- `toggleAt(index)` — Toggle At
- `ensureObjectModel()` — Ensure Object Model
- `selectAll()` — Select All
- `clearSelection()` — Clear Selection

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
