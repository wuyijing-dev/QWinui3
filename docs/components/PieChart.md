# PieChart

Pie chart with legend.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PieChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/PieChart.qml)

**Category:** Charts & gauges · **Library:** v0.1.0

[← Component index](../components.md)

**Gallery:** `PieChart` — [`src/gallery/pages/PieChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/PieChartPage.qml)

**Extends** `Control`.

## Example

```qml
PieChart {
    id: pieChart
    slices: [{ value: 1, label: "A"
}] }

// --- API ---
// signals: onSliceClicked
// methods: playReveal(), requestRedraw()
// pieChart.playReveal()
// pieChart.requestRedraw()
```

## Notes

Slices from values or { label, value, color? } items; donut via innerRadius.
interactive emits slice hover/click; showLegend for ChartLegend.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `slices` | `var` | Pie/donut slice descriptors |
| `showLegend` | `bool` | Show chart legend |
| `interactive` | `bool` | Enable hover / click interaction |
| `animated` | `bool` | Play enter / reveal animation |
| `startAngle` | `real` | Arc start angle in degrees |
| `padAngle` | `real` | Padding angle between pie slices |
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
