# AreaChart

Filled area chart with legend and hover crosshair.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AreaChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/AreaChart.qml)

**Category:** Charts & gauges · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `AreaChart` — [`src/gallery/pages/AreaChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/AreaChartPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
AreaChart {
    id: areaChart
    values: [1, 3, 2, 5]
}

// --- API ---
// methods: invalidateLod(), sourcePointCountEstimate(), ensureLod(budget), playReveal(), requestRedraw()
// areaChart.invalidateLod()
// areaChart.sourcePointCountEstimate()
// areaChart.ensureLod(budget)
// areaChart.playReveal()
```

## Notes

Filled area under the line; same series/values + LOD APIs as LineChart.
interactive / isInteractive aliases; showLegend toggles ChartLegend.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `series` | `var` | Chart series array |
| `values` | `var` | Numeric values array |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `showGrid` | `bool` | Show chart grid |
| `stacked` | `bool` | Stack series instead of overlay |
| `showLegend` | `bool` | Show chart legend |
| `interactive` | `bool` | Enable hover / click interaction |
| `isInteractive` | `alias` | Alias of interactive (gauge / KPI naming parity) |
| `animated` | `bool` | Play enter / reveal animation |
| `maxPoints` | `int` | Max points before LOD kicks in |
| `lodFactor` | `real` | Level-of-detail downsample factor |
| `autoLod` | `bool` | Auto-enable LOD for large series |
| `gridColor` | `color` | Grid line color |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `hoverIndex` | `int` | Hovered item index |
| `hoverLineX` | `real` | Hover crosshair X |
| `hoverMarkers` | `var` | Hover marker descriptors |
| `hoverText` | `string` | Tooltip / hover readout text |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `sourcePointCount` | `int` | Raw point count before LOD |
| `drawnPointCount` | `int` | Points drawn after LOD |
| `isEmpty` | `bool` | True when there is no data |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `invalidateLod()` | Invalidate level-of-detail cache |
| `sourcePointCountEstimate()` | Estimated source point count before LOD |
| `ensureLod(budget)` | Build LOD samples for the given budget |
| `playReveal()` | Play entrance reveal animation |
| `requestRedraw()` | Request chart / canvas redraw |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
