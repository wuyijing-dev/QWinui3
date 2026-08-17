# LinearGauge

Horizontal/vertical track gauge with thresholds.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/LinearGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/LinearGauge.qml)

**Category:** Charts & gauges · **Library:** v2.53

[← Component index](../components.md)

**Gallery:** `LinearGauge` — [`src/gallery/pages/LinearGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/LinearGaugePage.qml)

**Extends** `Control`.

## Example

```qml
LinearGauge {
    id: linearGauge
    value: 42; minimum: 0; maximum: 100
}

// --- API ---
// signals: onValueEdited
// methods: clampSnap(v), setValue(v), setValueFromNorm(n)
// linearGauge.clampSnap(v)
// linearGauge.setValue(v)
// linearGauge.setValueFromNorm(n)
```

## Notes

Horizontal/vertical bar gauge; value/min/max/unit + interactive / isInteractive.
Same zone patterns as ArcGauge / RadialGauge.

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
| `orientation` | `int` | Qt.Horizontal or Qt.Vertical |
| `trackThickness` | `real` | Track thickness in px |
| `showValue` | `bool` | Show numeric value label |
| `showTicks` | `bool` | Show tick marks |
| `showMinMax` | `bool` | Show min/max labels |
| `tickCount` | `int` | Major tick count |
| `showThumb` | `bool` | Show draggable thumb |
| `interactionPadding` | `real` | Extra hit padding around the track for easier drag (px) |
| `isInteractive` | `bool` | Alias of interactive |
| `interactive` | `alias` | Enable hover / click interaction |
| `fillColor` | `color` | Primary fill / progress color |
| `trackColor` | `color` | Track / remaining color |
| `cautionThreshold` | `real` | Value where caution zone starts |
| `criticalThreshold` | `real` | Value where critical zone starts |
| `invertThresholds` | `bool` | When true, low values map to caution/critical (battery-style). |
| `horizontal` | `bool` | Horizontal orientation when true |
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
| `setValue(v)` | Set value |
| `setValueFromNorm(n)` | Set value from norm |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
