# HorizontalBarChart

Horizontal bar chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/HorizontalBarChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/HorizontalBarChart.qml)

**Category:** Charts & gauges · **Library:** v1.06

[← Component index](../components.md)

**Gallery:** `HorizontalBarChart` — [`src/gallery/pages/HorizontalBarChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/HorizontalBarChartPage.qml)

**Extends** `Control`.

## Example

```qml
HorizontalBarChart {
    id: horizontalBarChart
    values: [3, 5, 2]
}

// --- API ---
// signals: onBarClicked
// methods: playReveal(), requestRedraw()
// horizontalBarChart.playReveal()
// horizontalBarChart.requestRedraw()
```

## Notes

Horizontal bars; same data shape as BarChart (values / series / categories).

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
| `showLabels` | `bool` | Show item labels |
| `showValueLabels` | `bool` | Show value labels on bars |
| `interactive` | `bool` | Enable hover / click interaction |
| `animated` | `bool` | Play enter / reveal animation |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `hoverIndex` | `int` | Hovered item index |
| `selectedIndex` | `alias` | Selected index alias |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `valueUnit` | `string` | Unit appended to value text |
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
