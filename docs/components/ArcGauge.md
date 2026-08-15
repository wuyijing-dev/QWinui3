# ArcGauge

Open-arc dashboard gauge with center value and thresholds.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ArcGauge.qml`](../../src/extras/QWinUI3/Extras/ArcGauge.qml)

[← Component index](../components.md)

## Usage

```qml
ArcGauge { value: 64; minimum: 0; maximum: 100 }
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
- `strokeWidth: real` — Stroke thickness in px
- `fillColor: color` — Primary fill / progress color
- `trackColor: color` — Track / remaining color
- `startAngle: real` — Arc start angle in degrees
- `sweepTotal: real` — Total sweep angle in degrees
- `cautionThreshold: real` — Value where caution zone starts
- `criticalThreshold: real` — Value where critical zone starts
- `invertThresholds: bool` — Invert caution/critical threshold logic
- `showValue: bool` — Show numeric value label
- `showMinMax: bool` — Show min/max labels
- `isInteractive: bool` — Alias of interactive
- `interactive: alias` — Enable hover / click interaction
- `percentage: real` — Value as 0..100 percentage
- `effectiveFillColor: color` — Resolved fill color
- `formattedValue: string` — Formatted value string
- `animatedValue: real` — Animated display value
- `animatedNorm: real` — Animated 0..1 normalized value
- `cx: real` — Center X
- `cy: real` — Center Y
- `radius: real` — Corner radius
- `sweep: real` — Sweep angle in degrees
- `ang: real` — Angle in degrees

## Signals

- `valueEdited(real value)` — Emitted when user commits a value

## Methods

- `clampSnap(v)` — Clamp and snap a value to the valid range
- `setValue(v)` — Set value (clamped / snapped)
- `setValueFromNorm(n)` — Set value from a normalized 0..1 input
- `normFromPoint(px, py, cx, cy)`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
