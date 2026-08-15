# LinearGauge

Horizontal/vertical track gauge with thresholds.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/LinearGauge.qml`](../../src/extras/QWinUI3/Extras/LinearGauge.qml)

[← Component index](../components.md)

## Usage

```qml
LinearGauge { value: 42; minimum: 0; maximum: 100 }
```

## Properties

- `value: real` — Current value
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `stepSize: real` — Value step (e.g. 0.5 for half stars)
- `title: string` — Primary title text
- `unit: string` — Value unit label (%, rpm, …)
- `caption: string` — Caption under / beside the value
- `valuePrecision: int` — Digits after decimal for value text
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `trackThickness: real` — Track thickness in px
- `showValue: bool` — Show numeric value label
- `showTicks: bool` — Show tick marks
- `showMinMax: bool` — Show min/max labels
- `tickCount: int` — Major tick count
- `showThumb: bool` — Show draggable thumb
- `isInteractive: bool` — Alias of interactive
- `interactive: alias` — Enable hover / click interaction
- `fillColor: color` — Primary fill / progress color
- `trackColor: color` — Track / remaining color
- `cautionThreshold: real` — Value where caution zone starts
- `criticalThreshold: real` — Value where critical zone starts
- `invertThresholds: bool` — When true, low values map to caution/critical (battery-style).
- `horizontal: bool` — Horizontal orientation when true
- `percentage: real` — Value as 0..100 percentage
- `effectiveFillColor: color` — Resolved fill color
- `formattedValue: string` — Formatted value string
- `animatedValue: real` — Animated display value
- `animatedNorm: real` — Animated 0..1 normalized value

## Signals

- `valueEdited(real value)` — Emitted when user commits a value

## Methods

- `clampSnap(v)` — Clamp and snap a value to the valid range
- `setValue(v)` — Set value
- `setValueFromNorm(n)` — Set value from norm

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
