# SpeedometerGauge

Vehicle speed needle (km/h or mph).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SpeedometerGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SpeedometerGauge.qml)

**Category:** Charts & gauges · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `SpeedometerGauge` — [`src/gallery/pages/SpeedometerGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SpeedometerGaugePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
SpeedometerGauge {
    value: 86
    maximum: 240
    unit: "km/h"
}

// --- API ---
// methods: setValue(v)
```

## Notes

Experimental automotive speedo. Prefer RadialGauge for a generic needle scale.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | — |
| `minimum` | `real` | — |
| `maximum` | `real` | — |
| `majorTick` | `int` | — |
| `title` | `string` | — |
| `unit` | `string` | — |
| `fillColor` | `color` | — |
| `startAngle` | `real` | — |
| `sweepTotal` | `real` | — |
| `isInteractive` | `bool` | — |
| `interactive` | `alias` | — |
| `animatedValue` | `real` | — |
| `animatedNorm` | `real` | — |

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
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
