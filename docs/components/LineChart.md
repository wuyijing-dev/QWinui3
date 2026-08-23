# LineChart

Multi-series line/area chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/LineChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/LineChart.qml)

**Category:** Charts & gauges · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `LineChart` — [`src/gallery/pages/LineChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/LineChartPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
LineChart {
    id: lineChart
    values: [1, 4, 2, 6]
}

// --- API ---
// methods: playReveal(), sourcePointCountEstimate(), invalidateLod(), ensureLod(budget), requestRedraw(), clearHover()
// lineChart.playReveal()
// lineChart.sourcePointCountEstimate()
// lineChart.invalidateLod()
// lineChart.ensureLod(budget)
```

## Notes

Prefer series: [{ name, values, color? }] or a flat values: number[].
Large series use LOD (invalidateLod / ensureLod); call requestRedraw after data changes.
interactive / isInteractive aliases. playReveal() / clearHover() for enter + crosshair.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `series` | `var` | Chart series array |
| `values` | `var` | Numeric values array |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `showGrid` | `bool` | Show chart grid |
| `showArea` | `bool` | Fill area under the line |
| `showLegend` | `bool` | Show chart legend |
| `interactive` | `bool` | Enable hover / click interaction |
| `isInteractive` | `alias` | Alias of interactive (gauge / KPI naming parity) |
| `animated` | `bool` | Play enter / reveal animation |
| `animateDataUpdates` | `bool` | Lerp displayed values on series updates (2.68 B4) |
| `maxPoints` | `int` | Max points before LOD kicks in |
| `lodFactor` | `real` | Level-of-detail downsample factor |
| `autoLod` | `bool` | Auto-enable LOD for large series |
| `autoDecimate` | `alias` | Alias of autoLod — 2.67 C2 naming |
| `decimateMode` | `string` | ChartUtils.douglasPeucker when series length exceeds the pixel budget. |
| `strokeWidth` | `real` | Stroke thickness in px |
| `gridColor` | `color` | Grid line color |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `dataProgress` | `real` | 0..1 data-update tween progress |
| `hoverIndex` | `int` | Hovered item index |
| `hoverX` | `real` | Pointer X while hovered |
| `hoverY` | `real` | Pointer Y while hovered |
| `hoverLineX` | `real` | Hover crosshair X |
| `hoverMarkers` | `var` | Hover marker descriptors |
| `hoverText` | `string` | Tooltip / hover readout text |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `xAxisLabels` | `var` | Category labels along the X axis (sparse; drawn at sampled indices) |
| `stepMode` | `bool` | Horizontal-then-vertical steps instead of a polyline |
| `zoomEnabled` | `bool` | Drag a brush on the plot to zoom the X window (2.65). Crosshair stays on hover. |
| `viewStart` | `real` | Visible window as normalized [0, 1] fractions of the source series. |
| `viewEnd` | `real` | — |
| `sourcePointCount` | `int` | LOD diagnostics |
| `drawnPointCount` | `int` | Points drawn after LOD |
| `isEmpty` | `bool` | True when there is no data |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `resetZoom()` | Reset the zoom window to the full series |
| `playReveal()` | Play entrance reveal animation |
| `sourcePointCountEstimate()` | Estimated source point count before LOD |
| `invalidateLod()` | Invalidate level-of-detail cache |
| `ensureLod(budget)` | Build LOD samples for the given budget |
| `requestRedraw()` | Request chart / canvas redraw (coalesced per frame — 1.89) |
| `clearHover()` | Clear hovered item state |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
