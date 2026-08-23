# BoxPlotChart

Tukey box-and-whisker groups.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/BoxPlotChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/BoxPlotChart.qml)

**Category:** Charts & gauges · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `BoxPlotChart` — [`src/gallery/pages/BoxPlotChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/BoxPlotChartPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
BoxPlotChart {
    groups: [
        { label: qsTr("A"), values: [12, 14, 15, 18, 22] },
        { label: qsTr("B"), min: 8, q1: 11, median: 14, q3: 17, max: 21 }
    ]
}
```

## Notes

Experimental. Pass values[] for auto stats (ChartUtils.boxPlotStats) or precomputed min/q1/median/q3/max.
Not part of the stable six.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `groups` | `var` | Group descriptors { label?, values? \| min,q1,median,q3,max, color? } |
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
