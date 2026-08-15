# Sparkline

Inline mini line chart.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Sparkline.qml`](../../src/extras/QWinUI3/Extras/Sparkline.qml)

[← Component index](../components.md)

## Usage

```qml
Sparkline { values: [1, 3, 2, 5, 4] }
```

## Properties

- `values: var` — Numeric values array
- `strokeColor: color` — Stroke color
- `fillColor: color` — Primary fill / progress color
- `strokeWidth: real` — Stroke thickness in px
- `filled: bool` — Fill under line / area
- `showEndMarker: bool` — Show end-point marker
- `animated: bool` — Play enter / reveal animation
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `revealProgress: real` — 0..1 reveal animation progress
- `caption: string` — Caption under / beside the value
- `showDelta: bool` — Show delta vs first point
- `lastValue: real` — Last series value
- `firstValue: real` — First series value
- `delta: real` — Delta from target / previous
- `deltaPositive: bool` — True when delta is positive

## Methods

- `playReveal()` — Play entrance reveal animation
- `X(i)`
- `Y(v)`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
