# ComboChart

Bars plus an overlay line (volume vs price).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ComboChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ComboChart.qml)

**Category:** Input & forms · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `ComboChart` — [`src/gallery/pages/ComboChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ComboChartPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
ComboChart {
    bars: [12, 18, 9, 22]
    line: [40, 42, 38, 51]
}
```

## Notes

Dual-axis Canvas chart. Bars use the left scale; line uses the right scale.
Experimental — compose on ChartCard. Not a new stable-six name.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `bars` | `var` | Column values (left axis) |
| `line` | `var` | Overlay line values (right axis) |
| `labels` | `var` | Category labels |
| `barUnit` | `string` | Left-axis unit |
| `lineUnit` | `string` | Right-axis unit |
| `barName` | `string` | Left series name |
| `lineName` | `string` | Right series name |
| `showLegend` | `bool` | Show legend |
| `showGrid` | `bool` | Show grid |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `interactive` | `bool` | Enable hover |
| `isInteractive` | `alias` | — |
| `hoverIndex` | `int` | — |
| `isEmpty` | `bool` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `requestRedraw()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
