# HeatmapChart

Heatmap matrix chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/HeatmapChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/HeatmapChart.qml)

**Category:** Charts & gauges · **Library:** v1.81

[← Component index](../components.md)

**Gallery:** `HeatmapChart` — [`src/gallery/pages/HeatmapChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/HeatmapChartPage.qml)

**Extends** `Control`.

## Example

```qml
HeatmapChart {
    id: heatmapChart
    values: matrix
}

// --- API ---
// signals: onCellClicked
// methods: playReveal(), requestRedraw(), clearHover(), lerpColor(a, b, t)
// heatmapChart.playReveal()
// heatmapChart.requestRedraw()
// heatmapChart.clearHover()
// heatmapChart.lerpColor(a, b, t)
```

## Notes

2D matrix / cells model; cellClicked for selection.
colorScale maps value -> color; show axes labels as needed.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `values` | `var` | Numeric values array |
| `rowLabels` | `var` | Heatmap row labels |
| `columnLabels` | `var` | Heatmap column labels |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `cellGap` | `real` | Gap between heatmap cells |
| `cellRadius` | `real` | Heatmap cell corner radius |
| `animated` | `bool` | Play enter / reveal animation |
| `interactive` | `bool` | Enable hover / click interaction |
| `isInteractive` | `alias` | Alias of interactive (gauge / KPI naming parity) |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `hoverRow` | `int` | Hovered heatmap row index |
| `hoverCol` | `int` | Hovered column index |
| `lowColor` | `color` | Low-zone color |
| `highColor` | `color` | High-zone color |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `isEmpty` | `bool` | True when there is no data |

### Signals

| Signature | Description |
| --- | --- |
| `cellClicked(int row, int col, real value)` | Emitted when a cell is clicked |

### Methods

| Signature | Description |
| --- | --- |
| `playReveal()` | Play entrance reveal animation |
| `requestRedraw()` | Request chart / canvas redraw |
| `clearHover()` | Clear hovered item state |
| `lerpColor(a, b, t)` | Linearly interpolate two colors |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
