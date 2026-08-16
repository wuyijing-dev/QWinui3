# TankGauge

Vertical / horizontal tank / reservoir level gauge.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TankGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TankGauge.qml)

**Category:** Charts & gauges · **Library:** v1.0.0

[← Component index](../components.md)

**Gallery:** `TankGauge` — [`src/gallery/pages/TankGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TankGaugePage.qml)

**Extends** `Control`.

## Example

```qml
TankGauge {
    id: tank
    value: 68; minimum: 0; maximum: 100
    unit: "%"
    title: qsTr("Coolant")
    target: 50
    showMarks: true
    cautionThreshold: 0.35
    criticalThreshold: 0.15
    invertThresholds: true
}

// --- API ---
// signals: onValueEdited
// methods: clampSnap(v), setValue(v), setValueFromNorm(n), nudge(delta)
// tank.setValue(v); tank.nudge(-5); tank.severity
```

## Notes

Liquid-level tank (vertical or horizontal); fill tracks value. Target line + level marks optional.
Use invertThresholds for low=critical. Wheel/keys when interactive; setValue clamps+snaps.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | Current value |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `stepSize` | `real` | Value step |
| `title` | `string` | Primary title text |
| `unit` | `string` | Value unit label |
| `caption` | `string` | Caption under / beside the value |
| `valuePrecision` | `int` | Digits after decimal for value text |
| `fillColor` | `color` | Primary fill / progress color |
| `trackColor` | `color` | Tank shell / track color |
| `tankRadius` | `real` | Corner radius of the tank shell |
| `shellWidth` | `real` | Shell stroke width |
| `orientation` | `int` | Qt.Vertical (default) or Qt.Horizontal |
| `showValue` | `bool` | Show numeric value label |
| `showMinMax` | `bool` | Show min/max labels |
| `showMarks` | `bool` | Show evenly spaced level marks |
| `markCount` | `int` | Major mark count |
| `showThresholdBands` | `bool` | Tint threshold bands inside the shell |
| `target` | `real` | Target value (NaN to hide) |
| `showTarget` | `bool` | Show target marker when target is finite |
| `cautionThreshold` | `real` | Value where caution zone starts (0..1 norm) |
| `criticalThreshold` | `real` | Value where critical zone starts |
| `invertThresholds` | `bool` | Invert caution/critical threshold logic |
| `isInteractive` | `bool` | Alias of interactive |
| `interactive` | `alias` | Enable hover / click interaction |
| `interactionPadding` | `real` | Extra drag hit padding (px) |
| `horizontal` | `bool` | — |
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

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
