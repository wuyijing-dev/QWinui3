# ParetoChart

Ranked bars plus cumulative percent line.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ParetoChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ParetoChart.qml)

**Category:** Charts & gauges · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `ParetoChart` — [`src/gallery/pages/ParetoChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ParetoChartPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
ParetoChart {
    values: [42, 18, 12, 8, 5]
    labels: ["A", "B", "C", "D", "E"]
}
```

## Notes

Experimental. ChartUtils.paretoRows sorts descending and computes cumulative share.
Prefer ComboChart when the order is already fixed.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `values` | `var` | — |
| `labels` | `var` | — |
| `title` | `string` | — |
| `emptyText` | `string` | — |
| `valueUnit` | `string` | — |
| `unit` | `alias` | — |
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
