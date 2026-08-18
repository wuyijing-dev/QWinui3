# WaffleChart

10×10 part-to-whole grid.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/WaffleChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/WaffleChart.qml)

**Category:** Charts & gauges · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `WaffleChart` — [`src/gallery/pages/WaffleChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/WaffleChartPage.qml)

**Extends** `Control`.

## Example

```qml
WaffleChart {
    slices: [
        { value: 42, label: qsTr("Used") },
        { value: 58, label: qsTr("Free") }
    ]
}
```

## Notes

Experimental 100-cell waffle. Prefer DonutChart for a compact part-to-whole.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `slices` | `var` | — |
| `values` | `var` | — |
| `title` | `string` | — |
| `emptyText` | `string` | — |
| `gridSize` | `int` | — |
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
