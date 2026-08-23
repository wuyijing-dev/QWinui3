# OdometerGauge

Total and trip distance.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OdometerGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OdometerGauge.qml)

**Category:** Charts & gauges · **Library:** v2.66

[← Component index](../components.md)

**Gallery:** `OdometerGauge` — [`src/gallery/pages/OdometerGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/OdometerGaugePage.qml)

**Extends** `Control`.

## Example

```qml
OdometerGauge { totalKm: 12480.3; tripKm: 36.2 }

// --- API ---
// methods: setTotal(v), setTrip(v), resetTrip()
```

## Notes

Experimental cluster odometer. Prefer DigitGauge for a generic numeric face.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `totalKm` | `real` | — |
| `tripKm` | `real` | — |
| `title` | `string` | — |
| `unit` | `string` | — |
| `tripPrecision` | `int` | — |
| `totalPrecision` | `int` | — |
| `formattedTotal` | `string` | — |
| `formattedTrip` | `string` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `setTotal(v)` | — |
| `setTrip(v)` | — |
| `resetTrip()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
