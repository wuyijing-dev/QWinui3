# SegmentedGauge

Segmented progress / capacity gauge.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SegmentedGauge.qml`](../../src/extras/QWinUI3/Extras/SegmentedGauge.qml)

[← Component index](../components.md)

## Usage

```qml
SegmentedGauge { value: 3; maximum: 5 }
```

## Properties

- `value: real` — Current value
- `minimum: real` — Minimum value
- `maximum: real` — Maximum value
- `stepSize: real` — Value step (e.g. 0.5 for half stars)
- `segmentCount: int` — Number of gauge segments
- `gapDegrees: real` — Gap between segments in degrees
- `strokeWidth: real` — Stroke thickness in px
- `title: string` — Primary title text
- `unit: string` — Value unit label (%, rpm, …)
- `caption: string` — Caption under / beside the value
- `valuePrecision: int` — Digits after decimal for value text
- `showValue: bool` — Show numeric value label
- `fillColor: color` — Primary fill / progress color
- `trackColor: color` — Track / remaining color
- `cautionThreshold: real` — Value where caution zone starts
- `criticalThreshold: real` — Value where critical zone starts
- `invertThresholds: bool` — Invert caution/critical threshold logic
- `startAngle: real` — Arc start angle in degrees
- `fillMode: string` — discrete | partial — partial fills the leading segment proportionally
- `isInteractive: bool` — Alias of interactive
- `interactive: alias` — Enable hover / click interaction
- `percentage: real` — Value as 0..100 percentage
- `effectiveFillColor: color` — Resolved fill color
- `formattedValue: string` — Formatted value string
- `animatedValue: real` — Animated display value
- `animatedNorm: real` — Animated 0..1 normalized value
- `filledExact: real` — Exactly filled segment count
- `filledSegments: int` — Filled segment count
- `partialAmount: real` — Partial fill amount 0..1
- `radius: real` — Corner radius
- `segSweep: real` — Segment sweep angle
- `index: int`
- `fullyFilled: bool` — True when all segments are filled
- `isPartial: bool` — True for a partially filled segment
- `segStart: real` — Segment start value
- `drawSweep: real` — Draw the gauge sweep arc

## Signals

- `valueEdited(real value)` — Emitted when user commits a value
- `segmentClicked(int index)` — Emitted when a segment is clicked

## Methods

- `clampSnap(v)` — Clamp and snap a value to the valid range
- `setValue(v)`
- `setSegment(index)`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
