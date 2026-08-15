# DonutChart

Donut chart with hover and legend.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DonutChart.qml`](../../src/extras/QWinUI3/Extras/DonutChart.qml)

[← Component index](../components.md)

## Usage

```qml
DonutChart { slices: [{ value: 3, label: "A" }] }
```

## Properties

- `slices: var` — Pie/donut slice descriptors
- `thickness: real` — Donut ring thickness
- `showCenterLabel: bool` — Show center label in donut
- `centerText: string` — Donut center primary text
- `centerSubText: string` — Donut center secondary text
- `showLegend: bool` — Show chart legend
- `interactive: bool` — Enable hover / click interaction
- `animated: bool` — Play enter / reveal animation
- `startAngle: real` — Arc start angle in degrees
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverIndex: int` — Hovered item index
- `selectedIndex: alias` — Selected index alias
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `isEmpty: bool` — True when there is no data
- `total: real` — Sum of segment values
- `cx: real` — Center X
- `cy: real` — Center Y
- `outer: real` — Donut outer radius
- `inner: real` — Donut inner radius
- `arcs: var` — Arc path descriptors

## Signals

- `sliceClicked(int index, real value)` — Emitted when a slice is clicked

## Methods

- `playReveal()` — Play entrance reveal animation
- `requestRedraw()` — Request chart / canvas redraw

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
