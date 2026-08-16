# RingGauge

Closed-ring dashboard gauge with center value and thresholds.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RingGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/RingGauge.qml)

**Category:** Charts & gauges · **Library:** v1.11

[← Component index](../components.md)

**Gallery:** `RingGauge` — [`src/gallery/pages/RingGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RingGaugePage.qml)

**Extends** `Control`.

## Example

```qml
RingGauge {
    id: ring
    value: 72; minimum: 0; maximum: 100
    unit: "%"
    title: qsTr("CPU")
    target: 80
    cautionThreshold: 0.7
    criticalThreshold: 0.9
    isInteractive: true
}

// --- API ---
// signals: onValueEdited
// methods: clampSnap(v), setValue(v), setValueFromNorm(n), normFromPoint(px, py, cx, cy), nudge(delta)
// ring.setValue(v); ring.nudge(1); ring.severity
```

## Notes

Full (or near-full) progress ring with center readout; distinct from ArcGauge (open) and RadialGauge (needle).
Optional target tick; severity 0/1/2 from thresholds; wheel/keys when interactive; setValue clamps+snaps.

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
| `showTrack` | `bool` | Show background track ring |
| `showGlow` | `bool` | Soft glow under the progress arc |
| `startAngle` | `real` | Arc start angle in degrees (PathAngleArc: 0° at 3 o'clock) |
| `sweepTotal` | `real` | Total sweep angle in degrees (use <360 for a small visual gap) |
| `target` | `real` | Target value (NaN to hide); drawn as a tick on the ring |
| `showTarget` | `bool` | Show target marker when target is finite |
| `cautionThreshold` | `real` | Value where caution zone starts (normalized 0..1) |
| `criticalThreshold` | `real` | Value where critical zone starts |
| `invertThresholds` | `bool` | Invert caution/critical threshold logic |
| `showValue` | `bool` | Show numeric value label |
| `showThumb` | `bool` | Show drag thumb (defaults on when interactive) |
| `isInteractive` | `bool` | Alias of interactive |
| `interactive` | `alias` | Enable hover / click interaction |
| `interactionPadding` | `real` | Extra drag hit padding outside the face (px) |
| `normalized` | `real` | Normalized 0..1 (live value, not animated) |
| `percentage` | `real` | Value as 0..100 percentage |
| `severity` | `int` | 0 = ok, 1 = caution, 2 = critical |
| `effectiveFillColor` | `color` | Resolved fill color |
| `hasTarget` | `bool` | — |
| `targetNorm` | `real` | — |
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
| `nudge(delta)` | Nudge value by delta (respects stepSize when set) |
| `normFromPoint(px, py, cx, cy)` | Normalize a pointer position to 0..1 along the ring sweep |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
