# RadialGauge

Circular gauge with needle and zones.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RadialGauge.qml`](../../src/extras/QWinUI3/Extras/RadialGauge.qml)

[← Component index](../components.md)

## Usage

```qml
RadialGauge { value: 72; minimum: 0; maximum: 100 }
```

## Properties

- `value: real` — Current value
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `stepSize: real` — Value step (e.g. 0.5 for half stars)
- `strokeWidth: real` — Stroke thickness in px
- `showValue: bool` — Show numeric value label
- `unit: string` — Value unit label (%, rpm, …)
- `title: string` — Primary title text
- `caption: string` — Caption under / beside the value
- `valuePrecision: int` — Digits after decimal for value text
- `tickCount: int` — Major tick count
- `trackColor: color` — Track / remaining color
- `fillColor: color` — Primary fill / progress color
- `showNeedle: bool` — Show needle indicator
- `startAngle: real` — Arc start angle in degrees
- `sweepTotal: real` — Total sweep angle in degrees
- `cautionThreshold: real` — Value where caution zone starts
- `criticalThreshold: real` — Value where critical zone starts
- `invertThresholds: bool` — Invert caution/critical threshold logic
- `isInteractive: bool` — Alias of interactive
- `interactive: alias` — Enable hover / click interaction
- `percentage: real` — Value as 0..100 percentage
- `effectiveFillColor: color` — Resolved fill color
- `normalized: real` — Normalized
- `formattedValue: string` — Formatted value string
- `animatedValue: real` — Animated display value
- `animatedNorm: real` — Animated 0..1 normalized value
- `radius: real` — Corner radius
- `sweep: real` — Sweep angle in degrees
- `index: int`
- `angDeg: real` — Angle in degrees
- `ang: real` — Angle in degrees

## Signals

- `valueEdited(real value)` — Emitted when user commits a value

## Methods

- `setValue(v)` — Set Value
- `setValueFromNorm(n)` — Set Value From Norm
- `normFromPoint(px, py)` — Norm From Point

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
