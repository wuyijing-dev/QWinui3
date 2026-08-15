# BarChart

Vertical bar chart with reveal animation.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/BarChart.qml`](../../src/extras/QWinUI3/Extras/BarChart.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
BarChart {
    id: barChart
    values: [4, 2, 7, 3]
}

// --- API ---
// signals: onBarClicked
// methods: playReveal(), requestRedraw()
// barChart.playReveal()
// barChart.requestRedraw()
```

## Notes

Vertical bars from values or series; playReveal() for enter animation.
category labels via categories / labels; interactive for hover/click.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `values` | `var` | Numeric values array |
| `bars` | `var` | Bar descriptors |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `barRadius` | `real` | Bar corner radius |
| `barGap` | `real` | Gap between bars |
| `showBaseline` | `bool` | Show zero baseline |
| `showValueLabels` | `bool` | Show value labels on bars |
| `interactive` | `bool` | Enable hover / click interaction |
| `animated` | `bool` | Play enter / reveal animation |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `hoverIndex` | `int` | Hovered item index |
| `selectedIndex` | `alias` | Selected index alias |
| `title` | `string` | Primary title text |
| `emptyText` | `string` | Placeholder when there is no data |
| `valueUnit` | `string` | Unit appended to value text |
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

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
