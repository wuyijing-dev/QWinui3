# ViolinChart

Density violin from sample groups.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ViolinChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ViolinChart.qml)

**Category:** Charts & gauges · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `ViolinChart` — [`src/gallery/pages/ViolinChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ViolinChartPage.qml)

**Extends** `Control`.

## Example

```qml
ViolinChart {
    groups: [{ label: qsTr("A"), values: samples }]
}
```

## Notes

Experimental. ChartUtils.violinWidths. Prefer BoxPlotChart for five-number summaries.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `groups` | `var` | — |
| `binCount` | `int` | — |
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
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
