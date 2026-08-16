# RadarChart

Radar / spider chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RadarChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/RadarChart.qml)

**Category:** Charts & gauges · **Library:** v1.07

[← Component index](../components.md)

**Gallery:** `RadarChart` — [`src/gallery/pages/RadarChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RadarChartPage.qml)

**Extends** `Control`.

## Example

```qml
RadarChart {
    id: radarChart
    values: [3, 5, 2, 4]; axes: ["A","B","C","D"]
}

// --- API ---
// methods: playReveal(), requestRedraw(), clearHover()
// radarChart.playReveal()
// radarChart.requestRedraw()
// radarChart.clearHover()
```

## Notes

Polar axes from categories + series values (one value per spoke).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `series` | `var` | Chart series array |
| `values` | `var` | Numeric values array |
| `axes` | `var` | Axis labels |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `levels` | `int` | Discrete level descriptors |
| `filled` | `bool` | Fill under line / area |
| `showLabels` | `bool` | Show item labels |
| `animated` | `bool` | Play enter / reveal animation |
| `interactive` | `bool` | Enable hover / click interaction |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `hoverSeries` | `int` | Hovered series index |
| `selectedIndex` | `alias` | Selected index alias |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `isEmpty` | `bool` | True when there is no data |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
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
