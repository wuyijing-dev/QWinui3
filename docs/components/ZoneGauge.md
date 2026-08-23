# ZoneGauge

Gauge with colored zones.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ZoneGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ZoneGauge.qml)

**Category:** Charts & gauges · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `ZoneGauge` — [`src/gallery/pages/ZoneGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ZoneGaugePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
ZoneGauge {
    id: zoneGauge
    value: 55; minimum: 0; maximum: 100
}

// --- API ---
// signals: onValueEdited
// methods: zoneColor(z, index), clampSnap(v), setValue(v), setValueFromNorm(n), normFromPoint(px, py)
// zoneGauge.zoneColor(z, index)
// zoneGauge.clampSnap(v)
// zoneGauge.setValue(v)
// zoneGauge.setValueFromNorm(n)
```

## Notes

Gauge with explicit colored zones; activeZoneIndex/Color/Label track the needle.
Toolkit-aligned aliases: minAngle/maxAngle, scaleWidth, needleLength/Width, valueStringFormat.

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
| `strokeWidth` | `real` | Stroke thickness in px (Toolkit ScaleWidth) |
| `scaleWidth` | `alias` | — |
| `showNeedle` | `bool` | Show needle indicator |
| `needleLength` | `real` | Needle length as fraction of radius (or 0–100 Toolkit percent) |
| `needleWidth` | `real` | — |
| `needleBrush` | `color` | — |
| `showValue` | `bool` | Show numeric value label |
| `valueStringFormat` | `string` | Toolkit-style format: "N0", "N1", … |
| `showTicks` | `bool` | Show tick marks |
| `tickCount` | `int` | Major tick count |
| `tickSpacing` | `real` | Tick spacing in value units (0 = use tickCount) |
| `startAngle` | `real` | Arc start / end (Toolkit MinAngle / MaxAngle) |
| `sweepTotal` | `real` | — |
| `minAngle` | `alias` | — |
| `maxAngle` | `real` | — |
| `isInteractive` | `bool` | Alias of interactive |
| `interactive` | `alias` | Enable hover / click interaction |
| `interactionPadding` | `real` | Extra drag hit padding outside the face (px) |
| `zones` | `var` | Colored gauge zones |
| `percentage` | `real` | Value as 0..100 percentage |
| `activeZoneIndex` | `int` | Index of the active gauge zone |
| `activeZoneLabel` | `string` | Label of the active gauge zone |
| `activeZoneColor` | `color` | Color of the active gauge zone |
| `formattedValue` | `string` | Formatted value string |
| `valueAngle` | `real` | Toolkit ValueAngle |
| `animatedValue` | `real` | Animated display value |
| `animatedNorm` | `real` | Animated 0..1 normalized value |

### Signals

| Signature | Description |
| --- | --- |
| `valueEdited(real value)` | Emitted when user commits a value |

### Methods

| Signature | Description |
| --- | --- |
| `zoneColor(z, index)` | Zone color |
| `clampSnap(v)` | Clamp and snap a value to the valid range |
| `setValue(v)` | Set value |
| `setValueFromNorm(n)` | Set value from norm |
| `normFromPoint(px, py)` | Normalize a pointer position to 0..1 |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
