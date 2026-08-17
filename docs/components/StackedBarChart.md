# StackedBarChart

Stacked bar chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/StackedBarChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/StackedBarChart.qml)

**Category:** Charts & gauges · **Library:** v1.74

[← Component index](../components.md)

**Gallery:** `StackedBarChart` — [`src/gallery/pages/StackedBarChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/StackedBarChartPage.qml)

**Extends** `Control`.

## Example

```qml
StackedBarChart {
    id: stackedBarChart
    series: [{ values: [1, 2]
}] }

// --- API ---
// signals: onCategoryClicked
// methods: playReveal(), requestRedraw()
// stackedBarChart.playReveal()
// stackedBarChart.requestRedraw()
```

## Notes

Stacked series segments per category; series items supply stacked values.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `series` | `var` | Chart series array |
| `categories` | `var` | Category labels for bars |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `barRadius` | `real` | Bar corner radius |
| `barGap` | `real` | Gap between bars |
| `showBaseline` | `bool` | Show zero baseline |
| `showLegend` | `bool` | Show chart legend |
| `showCategoryLabels` | `bool` | Show category axis labels |
| `interactive` | `bool` | Enable hover / click interaction |
| `isInteractive` | `alias` | Alias of interactive (gauge / KPI naming parity) |
| `animated` | `bool` | Play enter / reveal animation |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `hoverCategory` | `int` | Hovered category index |
| `hoverSeries` | `int` | Hovered series index |
| `hoverText` | `string` | Tooltip / hover readout text |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `isEmpty` | `bool` | True when there is no data |

### Signals

| Signature | Description |
| --- | --- |
| `categoryClicked(int categoryIndex)` | Emitted when a category is clicked |

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
