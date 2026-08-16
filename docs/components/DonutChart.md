# DonutChart

Donut chart with hover and legend.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DonutChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DonutChart.qml)

**Category:** Charts & gauges · **Library:** v1.02

[← Component index](../components.md)

**Gallery:** `DonutChart` — [`src/gallery/pages/DonutChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/DonutChartPage.qml)

**Extends** `Control`.

## Example

```qml
DonutChart {
    id: donutChart
    slices: [{ value: 3, label: "A"
}] }

// --- API ---
// signals: onSliceClicked
// methods: playReveal(), requestRedraw()
// donutChart.playReveal()
// donutChart.requestRedraw()
```

## Notes

PieChart with a hollow center (inner/outer radius); center label optional.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `slices` | `var` | Pie/donut slice descriptors |
| `thickness` | `real` | Donut ring thickness |
| `showCenterLabel` | `bool` | Show center label in donut |
| `centerText` | `string` | Donut center primary text |
| `centerSubText` | `string` | Donut center secondary text |
| `showLegend` | `bool` | Show chart legend |
| `interactive` | `bool` | Enable hover / click interaction |
| `animated` | `bool` | Play enter / reveal animation |
| `startAngle` | `real` | Arc start angle in degrees |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `hoverIndex` | `int` | Hovered item index |
| `selectedIndex` | `alias` | Selected index alias |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `isEmpty` | `bool` | True when there is no data |
| `total` | `real` | Sum of segment values |

### Signals

| Signature | Description |
| --- | --- |
| `sliceClicked(int index, real value)` | Emitted when a slice is clicked |

### Methods

| Signature | Description |
| --- | --- |
| `playReveal()` | Play entrance reveal animation |
| `requestRedraw()` | Request chart / canvas redraw |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
