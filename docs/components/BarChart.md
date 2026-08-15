# BarChart

Vertical bar chart with reveal animation.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/BarChart.qml`](../../src/extras/QWinUI3/Extras/BarChart.qml)

[← Component index](../components.md)

## Usage

```qml
BarChart { values: [4, 2, 7, 3] }
```

## Properties

- `values: var` — Numeric values array
- `bars: var` — Bar descriptors
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `barRadius: real` — Bar corner radius
- `barGap: real` — Gap between bars
- `showBaseline: bool` — Show zero baseline
- `showValueLabels: bool` — Show value labels on bars
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `selectedIndex: alias` — Selected index alias
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `valueUnit: string` — Unit appended to value text
- `isEmpty: bool` — True when there is no data
- `slot: real` — Named content slot
- `gap: real` — Gap between items
- `padL: real` — Left padding

## Signals

- `barClicked(int index, real value)` — Emitted when a bar is clicked

## Methods

- `playReveal()` — Play Reveal
- `requestRedraw()` — Request Redraw

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
