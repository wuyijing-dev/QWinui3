# ChartLegend

Fluent legend for series/slices.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ChartLegend.qml`](../../src/extras/QWinUI3/Extras/ChartLegend.qml)

[← Component index](../components.md)

## Usage

```qml
ChartLegend { items: [{ label: "A", color: Theme.accent }] }
```

## Properties

- `items: var` — Item list / children model
- `hoverIndex: int` — Hovered item index
- `selectedIndex: int` — Selected index alias
- `interactive: bool` — Enable hover / click interaction
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `showValue: bool` — Show numeric value label
- `header: string` — Header label above the control

## Signals

- `itemClicked(int index)` — Emitted when an item is clicked
- `itemHovered(int index)` — Emitted when a legend item is hovered

## Methods

- `select(index)` — Select item by index
- `clearSelection()` — Clear the current selection

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
