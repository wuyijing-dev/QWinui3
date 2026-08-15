# RadarChart

Radar / spider chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RadarChart.qml`](../../src/extras/QWinUI3/Extras/RadarChart.qml)

[← Component index](../components.md)

## Usage

```qml
RadarChart { values: [3, 5, 2, 4]; axes: ["A","B","C","D"] }
```

## Properties

- `series: var` — Chart series array
- `values: var` — Numeric values array
- `axes: var` — Axis labels
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `levels: int` — Discrete level descriptors
- `filled: bool` — Fill under line / area
- `showLabels: bool` — Show item labels
- `animated: bool` — Play enter / reveal animation
- `interactive: bool` — Enable hover / click interaction
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverSeries: int` — Hovered series index
- `selectedIndex: alias` — Selected index alias
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `isEmpty: bool` — True when there is no data

## Methods

- `playReveal()` — Play entrance reveal animation
- `requestRedraw()` — Request chart / canvas redraw
- `clearHover()` — Clear hovered item state
- `point(i, norm)`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
