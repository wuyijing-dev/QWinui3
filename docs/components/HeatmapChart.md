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
- `hoverCol: int` — Hover Col
- `lowColor: color` — Low Color
- `highColor: color` — High Color
- `title: string` — Primary title text
- `emptyText: string` — Placeholder when there is no data
- `isEmpty: bool` — True when there is no data
- `labelW: real` — Label column width
- `labelH: real` — Label H
- `cellW: real` — Cell W
- `cellH: real` — Cell H
- `rows: int` — Grid row count
- `cols: int` — Cols

## Signals

- `cellClicked(int row, int col, real value)` — Cell Clicked

## Methods

- `playReveal()` — Play Reveal
- `requestRedraw()` — Request Redraw
- `clearHover()` — Clear Hover
- `lerpColor(a, b, t)` — Lerp Color

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
