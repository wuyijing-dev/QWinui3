# PieChart

Pie chart with legend.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PieChart.qml`](../../src/extras/QWinUI3/Extras/PieChart.qml)

[← Component index](../components.md)

## Usage

```qml
PieChart { slices: [{ value: 1, label: "A" }] }
```

## Properties

- `slices: var` — Pie/donut slice descriptors
- `showLegend: bool` — Show chart legend
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `startAngle: real` — Arc start angle in degrees
- `padAngle: real` — Padding angle between pie slices
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `selectedIndex: alias` — Selected index alias
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `isEmpty: bool` — True when there is no data
- `total: real` — Sum of segment values
- `cx: real` — Center X
- `cy: real` — Center Y
- `radius: real` — Corner radius
- `arcs: var` — Arc path descriptors

## Signals

- `sliceClicked(int index, real value)` — Emitted when a slice is clicked

## Methods

- `playReveal()` — Play entrance reveal animation
- `requestRedraw()` — Request chart / canvas redraw

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
