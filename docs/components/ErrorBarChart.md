# ErrorBarChart

Mean (or value) with ± error whiskers.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ErrorBarChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ErrorBarChart.qml)

**Category:** Charts & gauges · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `ErrorBarChart` — [`src/gallery/pages/ErrorBarChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ErrorBarChartPage.qml)

**Extends** `Control`.

## Example

```qml
ErrorBarChart {
    points: [
        { label: qsTr("A"), value: 42, error: 4 },
        { label: qsTr("B"), value: 31, low: 26, high: 38 }
    ]
}
```

## Notes

Experimental. Prefer BoxPlotChart when the full distribution is available.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `points` | `var` | — |
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
