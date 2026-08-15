# WaterfallChart

Waterfall chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/WaterfallChart.qml`](../../src/extras/QWinUI3/Extras/WaterfallChart.qml)

[← Component index](../components.md)

## Usage

```qml
WaterfallChart { values: [10, -3, 5] }
```

## Properties

- `steps: var` — Waterfall step descriptors
- `values: var` — Numeric values array
- `showConnector: bool` — Show connectors between steps
- `showLabels: bool` — Show item labels
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `selectedIndex: alias` — Selected index alias
- `totalColor: color` — Waterfall total bar color
- `showTotal: bool` — Show total column
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `valueUnit: string` — Unit appended to value text
- `isEmpty: bool` — True when there is no data
- `slot: real` — Named content slot
- `padL: real` — Left padding
- `count: int` — Item count

## Signals

- `stepClicked(int index, real value)` — Emitted when a step is clicked

## Methods

- `playReveal()` — Play entrance reveal animation
- `requestRedraw()` — Request chart / canvas redraw
- `clearHover()` — Clear hovered item state
- `Y(v)`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
