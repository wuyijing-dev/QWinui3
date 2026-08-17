# SegmentedGauge

Segmented progress / capacity gauge.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SegmentedGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SegmentedGauge.qml)

**Category:** Charts & gauges · **Library:** v1.71

[← Component index](../components.md)

**Gallery:** `SegmentedGauge` — [`src/gallery/pages/SegmentedGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SegmentedGaugePage.qml)

**Extends** `Control`.

## Example

```qml
SegmentedGauge {
    id: segmentedGauge
    value: 3; maximum: 5
}

// --- API ---
// signals: onValueEdited, onSegmentClicked
// methods: clampSnap(v), setValue(v), setSegment(index)
// segmentedGauge.clampSnap(v)
// segmentedGauge.setValue(v)
// segmentedGauge.setSegment(index)
```

## Notes

Discrete segment fill (progress pills); value vs maximum segment count.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | Current value |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `stepSize` | `real` | Value step (e.g. 0.5 for half stars) |
| `segmentCount` | `int` | Number of gauge segments |
| `gapDegrees` | `real` | Gap between segments in degrees |
| `strokeWidth` | `real` | Stroke thickness in px |
| `title` | `string` | Primary title text |
| `unit` | `string` | Value unit label (%, rpm, …) |
| `caption` | `string` | Caption under / beside the value |
| `valuePrecision` | `int` | Digits after decimal for value text |
| `showValue` | `bool` | Show numeric value label |
| `fillColor` | `color` | Primary fill / progress color |
| `trackColor` | `color` | Track / remaining color |
| `cautionThreshold` | `real` | Value where caution zone starts |
| `criticalThreshold` | `real` | Value where critical zone starts |
| `invertThresholds` | `bool` | Invert caution/critical threshold logic |
| `startAngle` | `real` | Arc start angle in degrees |
| `fillMode` | `string` | discrete \| partial — partial fills the leading segment proportionally |
| `isInteractive` | `bool` | Alias of interactive |
| `interactive` | `alias` | Enable hover / click interaction |
| `interactionPadding` | `real` | Extra tap hit padding outside the face (px) |
| `percentage` | `real` | Value as 0..100 percentage |
| `effectiveFillColor` | `color` | Resolved fill color |
| `formattedValue` | `string` | Formatted value string |
| `animatedValue` | `real` | Animated display value |
| `animatedNorm` | `real` | Animated 0..1 normalized value |
| `filledExact` | `real` | Exactly filled segment count |
| `filledSegments` | `int` | Filled segment count |
| `partialAmount` | `real` | Partial fill amount 0..1 |

### Signals

| Signature | Description |
| --- | --- |
| `valueEdited(real value)` | Emitted when user commits a value |
| `segmentClicked(int index)` | Emitted when a segment is clicked |

### Methods

| Signature | Description |
| --- | --- |
| `clampSnap(v)` | Clamp and snap a value to the valid range |
| `setValue(v)` | Set value |
| `setSegment(index)` | Set segment |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
