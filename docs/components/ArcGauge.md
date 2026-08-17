# ArcGauge

Open-arc dashboard gauge with center value and thresholds.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ArcGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ArcGauge.qml)

**Category:** Charts & gauges · **Library:** v1.77

[← Component index](../components.md)

**Gallery:** `ArcGauge` — [`src/gallery/pages/ArcGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ArcGaugePage.qml)

**Extends** `Control`.

## Example

```qml
ArcGauge {
    id: arcGauge
    value: 64; minimum: 0; maximum: 100
}

// --- API ---
// signals: onValueEdited
// methods: clampSnap(v), setValue(v), setValueFromNorm(n), normFromPoint(px, py, cx, cy)
// arcGauge.clampSnap(v)
// arcGauge.setValue(v)
// arcGauge.setValueFromNorm(n)
// arcGauge.normFromPoint(px, py, cx, cy)
```

## Notes

Open-arc gauge; bind value/minimum/maximum/unit; setValue clamps+snaps.
interactive aliases isInteractive. thresholds / zones for colored ranges.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | Current value |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `stepSize` | `real` | Value step (e.g. 0.5 for half stars) |
| `title` | `string` | Primary title text |
| `unit` | `string` | Value unit label (%, rpm, …) |
| `caption` | `string` | Caption under / beside the value |
| `valuePrecision` | `int` | Digits after decimal for value text |
| `strokeWidth` | `real` | Stroke thickness in px |
| `fillColor` | `color` | Primary fill / progress color |
| `trackColor` | `color` | Track / remaining color |
| `startAngle` | `real` | Arc start angle in degrees |
| `sweepTotal` | `real` | Total sweep angle in degrees |
| `cautionThreshold` | `real` | Value where caution zone starts |
| `criticalThreshold` | `real` | Value where critical zone starts |
| `invertThresholds` | `bool` | Invert caution/critical threshold logic |
| `showValue` | `bool` | Show numeric value label |
| `showMinMax` | `bool` | Show min/max labels |
| `isInteractive` | `bool` | Alias of interactive |
| `interactive` | `alias` | Enable hover / click interaction |
| `interactionPadding` | `real` | Extra drag hit padding outside the face (px) |
| `percentage` | `real` | Value as 0..100 percentage |
| `effectiveFillColor` | `color` | Resolved fill color |
| `formattedValue` | `string` | Formatted value string |
| `animatedValue` | `real` | Animated display value |
| `animatedNorm` | `real` | Animated 0..1 normalized value |

### Signals

| Signature | Description |
| --- | --- |
| `valueEdited(real value)` | Emitted when user commits a value |

### Methods

| Signature | Description |
| --- | --- |
| `clampSnap(v)` | Clamp and snap a value to the valid range |
| `setValue(v)` | Set value (clamped / snapped) |
| `setValueFromNorm(n)` | Set value from a normalized 0..1 input |
| `normFromPoint(px, py, cx, cy)` | Normalize a pointer position to 0..1 |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
