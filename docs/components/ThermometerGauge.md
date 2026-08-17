# ThermometerGauge

Classic bulb + stem temperature / level gauge.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ThermometerGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ThermometerGauge.qml)

**Category:** Charts & gauges · **Library:** v2.57

[← Component index](../components.md)

**Gallery:** `ThermometerGauge` — [`src/gallery/pages/ThermometerGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ThermometerGaugePage.qml)

**Extends** `Control`.

## Example

```qml
ThermometerGauge {
    id: thermo
    value: 36.5; minimum: 0; maximum: 50
    unit: "°C"
    title: qsTr("Ambient")
    target: 22
    showTickLabels: true
    cautionThreshold: 0.7
    criticalThreshold: 0.85
}

// --- API ---
// signals: onValueEdited
// methods: clampSnap(v), setValue(v), setValueFromNorm(n), nudge(delta)
// thermo.setValue(v); thermo.nudge(0.5); thermo.severity
```

## Notes

Classic thermometer: stem fill + bulb. Optional tick labels and target mark.
Drag/wheel/keys when interactive; thresholds tint mercury; severity is 0/1/2.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | Current value |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `stepSize` | `real` | Value step |
| `title` | `string` | Primary title text |
| `unit` | `string` | Value unit label (°C, °F, …) |
| `caption` | `string` | Caption under / beside the value |
| `valuePrecision` | `int` | Digits after decimal for value text |
| `fillColor` | `color` | Mercury / fill color |
| `trackColor` | `color` | Stem / shell stroke color |
| `stemWidth` | `real` | Stem width in px |
| `bulbSize` | `real` | Bulb diameter in px |
| `showTicks` | `bool` | Show tick marks along the stem |
| `showTickLabels` | `bool` | Show numeric labels next to ticks |
| `tickCount` | `int` | Major tick count |
| `showValue` | `bool` | Show numeric value label |
| `showMinMax` | `bool` | Show min/max labels |
| `target` | `real` | Target value (NaN to hide) |
| `showTarget` | `bool` | Show target marker when target is finite |
| `cautionThreshold` | `real` | Value where caution zone starts (0..1 norm) |
| `criticalThreshold` | `real` | Value where critical zone starts |
| `invertThresholds` | `bool` | Invert caution/critical threshold logic |
| `isInteractive` | `bool` | Alias of interactive |
| `interactive` | `alias` | Enable hover / click interaction |
| `interactionPadding` | `real` | Extra drag hit padding (px) |
| `normalized` | `real` | — |
| `percentage` | `real` | — |
| `severity` | `int` | — |
| `effectiveFillColor` | `color` | — |
| `hasTarget` | `bool` | — |
| `targetNorm` | `real` | — |
| `formattedValue` | `string` | — |
| `animatedValue` | `real` | — |
| `animatedNorm` | `real` | — |

### Signals

| Signature | Description |
| --- | --- |
| `valueEdited(real value)` | Emitted when user commits a value |

### Methods

| Signature | Description |
| --- | --- |
| `clampSnap(v)` | — |
| `setValue(v)` | — |
| `setValueFromNorm(n)` | — |
| `nudge(delta)` | — |
| `tickLabel(t)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
