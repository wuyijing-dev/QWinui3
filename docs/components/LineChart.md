# LineChart

Multi-series line/area chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/LineChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/LineChart.qml)

**Category:** Charts & gauges · **Library:** v1.77

[← Component index](../components.md)

**Gallery:** `LineChart` — [`src/gallery/pages/LineChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/LineChartPage.qml)

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
| `maxPoints` | `int` | Max points before LOD kicks in |
| `lodFactor` | `real` | Level-of-detail downsample factor |
| `autoLod` | `bool` | Auto-enable LOD for large series |
| `strokeWidth` | `real` | Stroke thickness in px |
| `gridColor` | `color` | Grid line color |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `hoverIndex` | `int` | Hovered item index |
| `hoverX` | `real` | Pointer X while hovered |
| `hoverY` | `real` | Pointer Y while hovered |
| `hoverLineX` | `real` | Hover crosshair X |
| `hoverMarkers` | `var` | Hover marker descriptors |
| `hoverText` | `string` | Tooltip / hover readout text |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `sourcePointCount` | `int` | LOD diagnostics |
| `drawnPointCount` | `int` | Points drawn after LOD |
| `isEmpty` | `bool` | True when there is no data |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `playReveal()` | Play entrance reveal animation |
| `sourcePointCountEstimate()` | Estimated source point count before LOD |
| `invalidateLod()` | Invalidate level-of-detail cache |
| `ensureLod(budget)` | Build LOD samples for the given budget |
| `requestRedraw()` | Request chart / canvas redraw |
| `clearHover()` | Clear hovered item state |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
