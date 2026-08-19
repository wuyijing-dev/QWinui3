# HistogramChart

Frequency bins from a numeric series.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/HistogramChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/HistogramChart.qml)

**Category:** Charts & gauges · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `HistogramChart` — [`src/gallery/pages/HistogramChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/HistogramChartPage.qml)

**Extends** `Control`.

## Example

```qml
HistogramChart {
    values: samples
    binCount: 12
}
```

## Notes

Experimental. Uses ChartUtils.histogramBins then draws as columns.
Prefer BarChart when bins are already computed.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `values` | `var` | Raw samples |
| `binCount` | `int` | Number of bins |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | — |
| `interactive` | `bool` | — |
| `isInteractive` | `alias` | — |
| `hoverIndex` | `int` | — |
| `fillColor` | `color` | — |
| `isEmpty` | `bool` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
