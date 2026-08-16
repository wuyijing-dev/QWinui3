# Sparkline

Inline mini line chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Sparkline.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/Sparkline.qml)

**Category:** Charts & gauges · **Library:** v1.10

[← Component index](../components.md)

**Gallery:** `Sparkline` — [`src/gallery/pages/SparklinePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SparklinePage.qml)

**Extends** `Control`.

## Example

```qml
Sparkline {
    id: sparkline
    values: [1, 3, 2, 5, 4]
}

// --- API ---
// methods: playReveal()
// sparkline.playReveal()
```

## Notes

Compact inline sparkline; values: number[]; minimal chrome, no axes by default.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `values` | `var` | Numeric values array |
| `strokeColor` | `color` | Stroke color |
| `fillColor` | `color` | Primary fill / progress color |
| `strokeWidth` | `real` | Stroke thickness in px |
| `filled` | `bool` | Fill under line / area |
| `showEndMarker` | `bool` | Show end-point marker |
| `animated` | `bool` | Play enter / reveal animation |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `revealProgress` | `real` | 0..1 reveal animation progress |
| `caption` | `string` | Caption under / beside the value |
| `showDelta` | `bool` | Show delta vs first point |
| `lastValue` | `real` | Last series value |
| `firstValue` | `real` | First series value |
| `delta` | `real` | Delta from target / previous |
| `deltaPositive` | `bool` | True when delta is positive |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `playReveal()` | Play entrance reveal animation |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
