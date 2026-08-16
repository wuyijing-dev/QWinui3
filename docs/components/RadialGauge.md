# RadialGauge

Toolkit-style circular needle gauge (CommunityToolkit.WinUI.Controls.RadialGauge).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RadialGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/RadialGauge.qml)

**Category:** Input & forms · **Library:** v1.16

[← Component index](../components.md)

**Gallery:** `RadialGauge` — [`src/gallery/pages/RadialGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RadialGaugePage.qml)

**Extends** `Control`.

## Example

```qml
RadialGauge {
    id: radial
    value: 120; minimum: 0; maximum: 240
    minAngle: -150; maxAngle: 150
    isInteractive: true
    stepSize: 5
    tickSpacing: 20
    scaleWidth: 12
    needleLength: 0.72
    valueStringFormat: "N0"
    unit: "rpm"
}

// --- API ---
// signals: onValueEdited
// methods: setValue(v), setValueFromNorm(n), setAngleRange(minA, maxA), nudge(delta), normFromPoint(px, py)
// radial.valueAngle / radial.severity / radial.nudge(1)
```

## Notes

Aligned with Community Toolkit RadialGauge: MinAngle/MaxAngle, ScaleWidth, NeedleLength/Width,
TickSpacing/Length/Width/Padding, ScalePadding, ValueStringFormat, Trail/Scale/Needle brushes.
startAngle/sweepTotal remain as aliases of the angle range. Wheel/keys when isInteractive.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | Current value |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `stepSize` | `real` | Rounding interval for Value (Toolkit StepSize) |
| `valueStringFormat` | `string` | Value string format: "N0", "N1", "F1", or empty to use valuePrecision |
| `valuePrecision` | `int` | Digits after decimal when valueStringFormat is empty |
| `unit` | `string` | Displayed unit measure (Toolkit Unit) |
| `title` | `string` | Primary title text |
| `caption` | `string` | Caption under / beside the value |
| `showValue` | `bool` | Show numeric value label |
| `minAngle` | `real` | Start angle of the scale (Toolkit MinAngle) |
| `maxAngle` | `real` | End angle of the scale (Toolkit MaxAngle) |
| `startAngle` | `alias` | Back-compat alias of minAngle |
| `sweepTotal` | `real` | Sweep angle (= maxAngle − minAngle); assigning updates maxAngle |
| `scaleWidth` | `real` | Width of the scale arc in px (Toolkit ScaleWidth) |
| `strokeWidth` | `alias` | Back-compat alias of scaleWidth |
| `scalePadding` | `real` | Inset of the scale from the outer radius, in px (Toolkit ScalePadding) |
| `scaleBrush` | `color` | Scale / remaining track color (Toolkit ScaleBrush) |
| `trackColor` | `alias` | — |
| `trailBrush` | `color` | Trail / progress color (Toolkit TrailBrush) |
| `fillColor` | `alias` | — |
| `showGlow` | `bool` | Soft glow under the trail |
| `showNeedle` | `bool` | Show needle indicator |
| `needleLength` | `real` | Needle length as fraction of radius (0..1); Toolkit uses % — pass 0.6 for 60 |
| `needleWidth` | `real` | Needle width in px |
| `needleBrush` | `color` | Needle color |
| `tickSpacing` | `real` | Tick spacing in value units (0 = use tickCount evenly) |
| `tickCount` | `int` | Legacy evenly spaced tick count when tickSpacing <= 0 |
| `tickLength` | `real` | Outer tick length in px |
| `tickWidth` | `real` | Outer tick width in px |
| `tickPadding` | `real` | Distance from scale to outer ticks in px |
| `scaleTickWidth` | `real` | Width of ticks carved into the scale (0 = hide scale ticks) |
| `tickBrush` | `color` | Outer tick color (Toolkit TickBrush) |
| `scaleTickBrush` | `color` | Scale-tick color (Toolkit ScaleTickBrush) |
| `showTicks` | `bool` | Show outer ticks |
| `cautionThreshold` | `real` | --- Thresholds (QWinUI3 extension) --- |
| `criticalThreshold` | `real` | — |
| `invertThresholds` | `bool` | — |
| `isInteractive` | `bool` | --- Interaction (Toolkit IsInteractive) --- |
| `interactive` | `alias` | — |
| `interactionPadding` | `real` | Extra drag hit padding outside the face (px) |
| `valueAngle` | `real` | Toolkit ValueAngle — current needle angle between minAngle and maxAngle |
| `normalizedMinAngle` | `real` | — |
| `normalizedMaxAngle` | `real` | — |
| `normalized` | `real` | — |
| `percentage` | `real` | — |
| `severity` | `int` | — |
| `effectiveFillColor` | `color` | — |
| `formattedValue` | `string` | — |
| `animatedValue` | `real` | — |
| `animatedNorm` | `real` | — |

### Signals

| Signature | Description |
| --- | --- |
| `valueEdited(real value)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `setAngleRange(minA, maxA)` | — |
| `setValue(v)` | — |
| `setValueFromNorm(n)` | — |
| `setValueAngle(angle)` | Set value from Toolkit-style ValueAngle |
| `nudge(delta)` | — |
| `normFromPoint(px, py)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
