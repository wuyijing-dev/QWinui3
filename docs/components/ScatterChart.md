# ScatterChart

Scatter / bubble chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ScatterChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ScatterChart.qml)

**Category:** Charts & gauges · **Library:** v1.00

[← Component index](../components.md)

**Gallery:** `ScatterChart` — [`src/gallery/pages/ScatterChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ScatterChartPage.qml)

**Extends** `Control`.

## Example

```qml
ScatterChart {
    id: scatterChart
    points: [{ x: 1, y: 2
}] }

// --- API ---
// signals: onPointClicked
// methods: invalidateLod(), ensureLod(binsX, binsY), playReveal(), requestRedraw(), clearHover()
// scatterChart.invalidateLod()
// scatterChart.ensureLod(binsX, binsY)
// scatterChart.playReveal()
// scatterChart.requestRedraw()
```

## Notes

points: [{ x, y, color? }] or separate xValues/yValues.
LOD helpers for large point counts; requestRedraw after updates.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `points` | `var` | Scatter points |
| `values` | `var` | Numeric values array |
| `minimumX` | `real` | X-axis minimum |
| `maximumX` | `real` | X-axis maximum |
| `minimumY` | `real` | Y-axis minimum |
| `maximumY` | `real` | Y-axis maximum |
| `pointRadius` | `real` | Scatter point radius |
| `showGrid` | `bool` | Show chart grid |
| `showTrendLine` | `bool` | Show trend line |
| `interactive` | `bool` | Enable hover / click interaction |
| `animated` | `bool` | Play enter / reveal animation |
| `maxPoints` | `int` | Max points before LOD kicks in |
| `autoLod` | `bool` | Auto-enable LOD for large series |
| `lodFactor` | `real` | Level-of-detail downsample factor |
| `gridColor` | `color` | Grid line color |
| `pointColor` | `color` | Color for a series point |
| `trendColor` | `color` | Trend / delta color |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `hoverIndex` | `int` | Hovered item index |
| `selectedIndex` | `alias` | Selected index alias |
| `hoverText` | `string` | Tooltip / hover readout text |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `sourcePointCount` | `int` | Raw point count before LOD |
| `drawnPointCount` | `int` | Points drawn after LOD |
| `isEmpty` | `bool` | True when there is no data |

### Signals

| Signature | Description |
| --- | --- |
| `pointClicked(int index, real x, real y)` | Emitted when a chart point is clicked |

### Methods

| Signature | Description |
| --- | --- |
| `invalidateLod()` | Invalidate level-of-detail cache |
| `ensureLod(binsX, binsY)` | Build LOD samples for the given budget |
| `playReveal()` | Play entrance reveal animation |
| `requestRedraw()` | Request chart / canvas redraw |
| `clearHover()` | Clear hovered item state |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
