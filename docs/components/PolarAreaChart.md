# PolarAreaChart

Coxcomb / polar-area sectors (radius encodes value).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PolarAreaChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/PolarAreaChart.qml)

**Category:** Charts & gauges · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `PolarAreaChart` — [`src/gallery/pages/PolarAreaChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/PolarAreaChartPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
PolarAreaChart {
    values: [8, 12, 6, 14, 9]
    labels: ["CPU", "Mem", "Disk", "Net", "GPU"]
}
```

## Notes

Experimental. Prefer RadarChart for equal-radius polygons; DonutChart for part-to-whole.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `values` | `var` | — |
| `labels` | `var` | — |
| `title` | `string` | — |
| `emptyText` | `string` | — |
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
