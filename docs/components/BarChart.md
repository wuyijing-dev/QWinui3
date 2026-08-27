# BarChart

Vertical bar chart with reveal animation.

`import QWinUI3.Extras.Charts` · [`src/extras/QWinUI3/Extras/BarChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/BarChart.qml)

**Category:** Charts & gauges · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `BarChart` — [`src/gallery/pages/BarChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/BarChartPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
BarChart {
    id: barChart
    values: [4, 2, 7, 3]
}

// Histogram from raw samples (3.06 G3 — prefer over HistogramChart):
BarChart {
    samples: [1.2, 3.4, 2.1, …]
    binCount: 12
    binLabelPrecision: 1
}

// --- API ---
// signals: onBarClicked
// methods: playReveal(), requestRedraw(), setBinsFromSamples(), applyBins(), clearBins()
// barChart.playReveal()
// barChart.requestRedraw()
```

## Notes

Prefer values: number[] or bars: [{ value, label?, color? }].
samples + binCount (>0) bins via ChartUtils.histogramBins into columns + range labels.
unit aliases valueUnit. interactive / isInteractive aliases. playReveal() for enter.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `values` | `var` | Numeric values array |
| `bars` | `var` | Bar descriptors |
| `samples` | `var` | Raw samples for histogram binning (3.06 G3). Used when binCount > 0. |
| `binCount` | `int` | Number of bins; 0 disables sample binning |
| `binLabelPrecision` | `int` | Digits for auto range labels (from–to) |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `barRadius` | `real` | Bar corner radius |
| `barGap` | `real` | Gap between bars |
| `showBaseline` | `bool` | Show zero baseline |
| `showValueLabels` | `bool` | Show value labels on bars |
| `interactive` | `bool` | Enable hover / click interaction |
| `isInteractive` | `alias` | Alias of interactive (gauge / KPI naming parity) |
| `animated` | `bool` | Play enter / reveal animation |
| `animateDataUpdates` | `bool` | Lerp displayed values on series updates (2.68 B4); first paint still uses playReveal |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `dataProgress` | `real` | 0..1 data-update tween progress |
| `hoverIndex` | `int` | Hovered item index |
| `selectedIndex` | `alias` | Selected index alias |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `valueUnit` | `string` | Unit appended to value text |
| `unit` | `alias` | Alias of valueUnit (gauge / KPI naming parity) |
| `horizontal` | `bool` | Draw bars left-to-right instead of bottom-up |
| `stacked` | `bool` | Stack series on the same category (requires series) |
| `series` | `var` | Multi-series [{ name, values, color? }] — grouped when stacked is false |
| `labels` | `var` | Category labels (used with series / plain bars; overridden when binning) |
| `bins` | `var` | Computed histogram bins [{ from, to, count, value }] when samples + binCount |
| `binningActive` | `bool` | — |
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
| `setBinsFromSamples(sampleValues, count)` | Bind samples + binCount (histogram mode) |
| `clearBins()` | Drop histogram mode (keeps existing values/bars) |
| `applyBins(binList)` | Apply precomputed bins [{ from, to, count\|value, label? }] as plain values + labels |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
