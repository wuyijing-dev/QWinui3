# ZoneGauge

Gauge with colored zones.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ZoneGauge.qml`](../../src/extras/QWinUI3/Extras/ZoneGauge.qml)

[← Component index](../components.md)

## Usage

```qml
ZoneGauge { value: 55; minimum: 0; maximum: 100 }
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
- `showNeedle: bool` — Show needle indicator
- `showValue: bool` — Show numeric value label
- `showTicks: bool` — Show tick marks
- `tickCount: int` — Major tick count
- `startAngle: real` — Arc start angle in degrees
- `sweepTotal: real` — Total sweep angle in degrees
- `isInteractive: bool` — Alias of interactive
- `interactive: alias` — Enable hover / click interaction
- `zones: var` — Colored gauge zones
- `percentage: real` — Value as 0..100 percentage
- `activeZoneIndex: int` — Index of the active gauge zone
- `activeZoneLabel: string` — Label of the active gauge zone
- `activeZoneColor: color` — Color of the active gauge zone
- `formattedValue: string` — Formatted value string
- `animatedValue: real` — Animated display value
- `animatedNorm: real` — Animated 0..1 normalized value

## Signals

- `valueEdited(real value)` — Emitted when user commits a value

## Methods

- `zoneColor(z, index)` — Zone color
- `clampSnap(v)` — Clamp and snap a value to the valid range
- `setValue(v)` — Set value
- `setValueFromNorm(n)` — Set value from norm
- `normFromPoint(px, py)` — Normalize a pointer position to 0..1

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
