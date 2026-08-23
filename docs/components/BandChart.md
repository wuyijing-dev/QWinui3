# BandChart

High/low envelope with an optional mid line.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/BandChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/BandChart.qml)

**Category:** Charts & gauges · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `BandChart` — [`src/gallery/pages/BandChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/BandChartPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
BandChart {
    high: [42, 48, 45]
    low: [30, 28, 32]
    mid: [36, 38, 37]
}
```

## Notes

Experimental range band. Prefer LineChart.showArea for a single filled series.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `high` | `var` | — |
| `low` | `var` | — |
| `mid` | `var` | — |
| `xAxisLabels` | `var` | — |
| `title` | `string` | — |
| `emptyText` | `string` | — |
| `bandColor` | `color` | — |
| `midColor` | `color` | — |
| `interactive` | `bool` | — |
| `isInteractive` | `alias` | — |
| `hoverIndex` | `int` | — |
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
