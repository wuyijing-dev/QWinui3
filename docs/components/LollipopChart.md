# LollipopChart

Stem-and-marker chart (compact bar alternative).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/LollipopChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/LollipopChart.qml)

**Category:** Charts & gauges · **Library:** v2.67

[← Component index](../components.md)

**Gallery:** `LollipopChart` — [`src/gallery/pages/LollipopChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/LollipopChartPage.qml)

**Extends** `Control`.

## Example

```qml
LollipopChart {
    values: [12, 28, 18, 34]
    labels: ["Q1", "Q2", "Q3", "Q4"]
}
```

## Notes

Experimental. Prefer BarChart for filled columns.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `values` | `var` | — |
| `labels` | `var` | — |
| `title` | `string` | — |
| `emptyText` | `string` | — |
| `horizontal` | `bool` | — |
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
