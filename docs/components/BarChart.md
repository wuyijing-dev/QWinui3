# BarChart

Vertical bar chart with reveal animation.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/BarChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/BarChart.qml)

**Category:** Charts & gauges · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `BarChart` — [`src/gallery/pages/BarChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/BarChartPage.qml)

**Extends** `Control`.

## Example

```qml
BarChart {
    id: barChart
    values: [4, 2, 7, 3]
}

// --- API ---
// signals: onBarClicked
// methods: playReveal(), requestRedraw()
// barChart.playReveal()
// barChart.requestRedraw()
```

## Notes

Prefer values: number[] or bars: [{ value, label?, color? }].
unit aliases valueUnit. interactive / isInteractive aliases. playReveal() for enter.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `values` | `var` | Numeric values array |
| `bars` | `var` | Bar descriptors |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `barRadius` | `real` | Bar corner radius |
| `barGap` | `real` | Gap between bars |
| `showBaseline` | `bool` | Show zero baseline |
| `showValueLabels` | `bool` | Show value labels on bars |
| `interactive` | `bool` | Enable hover / click interaction |
| `isInteractive` | `alias` | Alias of interactive (gauge / KPI naming parity) |
| `animated` | `bool` | Play enter / reveal animation |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `hoverIndex` | `int` | Hovered item index |
| `selectedIndex` | `alias` | Selected index alias |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `valueUnit` | `string` | Unit appended to value text |
| `unit` | `alias` | Alias of valueUnit (gauge / KPI naming parity) |
| `horizontal` | `bool` | Draw bars left-to-right instead of bottom-up |
| `stacked` | `bool` | Stack series on the same category (requires series) |
| `series` | `var` | Multi-series [{ name, values, color? }] — grouped when stacked is false |
| `labels` | `var` | Category labels (used with series) |
| `isEmpty` | `bool` | True when there is no data |

### Signals

| Signature | Description |
| --- | --- |
| `barClicked(int index, real value)` | Emitted when a bar is clicked |

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
