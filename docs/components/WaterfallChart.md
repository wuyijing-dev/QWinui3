# WaterfallChart

Waterfall chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/WaterfallChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/WaterfallChart.qml)

**Category:** Charts & gauges · **Library:** v1.79

[← Component index](../components.md)

**Gallery:** `WaterfallChart` — [`src/gallery/pages/WaterfallChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/WaterfallChartPage.qml)

**Extends** `Control`.

## Example

```qml
WaterfallChart {
    id: waterfallChart
    values: [10, -3, 5]
}

// --- API ---
// signals: onStepClicked
// methods: playReveal(), requestRedraw(), clearHover()
// waterfallChart.playReveal()
// waterfallChart.requestRedraw()
// waterfallChart.clearHover()
```

## Notes

values are signed deltas; total/connector styling via chart props.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `steps` | `var` | Waterfall step descriptors |
| `values` | `var` | Numeric values array |
| `showConnector` | `bool` | Show connectors between steps |
| `showLabels` | `bool` | Show item labels |
| `interactive` | `bool` | Enable hover / click interaction |
| `isInteractive` | `alias` | Alias of interactive (gauge / KPI naming parity) |
| `animated` | `bool` | Play enter / reveal animation |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `hoverIndex` | `int` | Hovered item index |
| `selectedIndex` | `alias` | Selected index alias |
| `totalColor` | `color` | Waterfall total bar color |
| `showTotal` | `bool` | Show total column |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `valueUnit` | `string` | Unit appended to value text |
| `unit` | `alias` | Alias of valueUnit (gauge / KPI naming parity) |
| `isEmpty` | `bool` | True when there is no data |

### Signals

| Signature | Description |
| --- | --- |
| `stepClicked(int index, real value)` | Emitted when a step is clicked |

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
