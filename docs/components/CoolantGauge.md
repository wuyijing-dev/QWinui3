# CoolantGauge

Automotive C–H coolant temperature.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CoolantGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CoolantGauge.qml)

**Category:** Charts & gauges · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `CoolantGauge` — [`src/gallery/pages/CoolantGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CoolantGaugePage.qml)

**Extends** `Control`.

## Example

```qml
CoolantGauge { value: 92; unit: "°C" }

// --- API ---
// methods: setValue(v)
```

## Notes

Experimental. Prefer ThermometerGauge for a stem-and-bulb lab scale.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | — |
| `minimum` | `real` | — |
| `maximum` | `real` | — |
| `title` | `string` | — |
| `unit` | `string` | — |
| `coldNorm` | `real` | — |
| `hotNorm` | `real` | — |
| `startAngle` | `real` | — |
| `sweepTotal` | `real` | — |
| `isInteractive` | `bool` | — |
| `interactive` | `alias` | — |
| `animatedValue` | `real` | — |
| `animatedNorm` | `real` | — |
| `fillColor` | `color` | — |

### Signals

| Signature | Description |
| --- | --- |
| `valueEdited(real value)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `setValue(v)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
