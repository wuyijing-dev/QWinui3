# HeatmapChart

Heatmap matrix chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/HeatmapChart.qml`](../../src/extras/QWinUI3/Extras/HeatmapChart.qml)

[← Component index](../components.md)

## Usage

```qml
HeatmapChart { values: matrix }
```

## Properties

- `values: var` — Numeric values array
- `rowLabels: var` — Heatmap row labels
- `columnLabels: var` — Heatmap column labels
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `cellGap: real` — Gap between heatmap cells
- `cellRadius: real` — Heatmap cell corner radius
- `animated: bool` — Play enter / reveal animation
- `interactive: bool` — Enable hover / click interaction
- `revealProgress: real` — 0..1 reveal animation progress
- `hoverRow: int` — Hovered heatmap row index
- `hoverCol: int` — Hovered column index
- `lowColor: color` — Low-zone color
- `highColor: color` — High-zone color
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `isEmpty: bool` — True when there is no data
- `labelW: real` — Label column width
- `labelH: real` — Label area height
- `cellW: real` — Cell width
- `cellH: real` — Cell height
- `rows: int` — Grid row count
- `cols: int` — Column count

## Signals

- `cellClicked(int row, int col, real value)` — Emitted when a cell is clicked

## Methods

- `playReveal()` — Play entrance reveal animation
- `requestRedraw()` — Request chart / canvas redraw
- `clearHover()` — Clear hovered item state
- `lerpColor(a, b, t)` — Linearly interpolate two colors

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
