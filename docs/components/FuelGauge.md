# FuelGauge

Empty/full arc with E–F marks.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FuelGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/FuelGauge.qml)

**Category:** Charts & gauges · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `FuelGauge` — [`src/gallery/pages/FuelGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/FuelGaugePage.qml)

**Extends** `Control`.

## Example

```qml
FuelGauge { value: 0.28 }

// --- API ---
// methods: setValue(v)
```

## Notes

Experimental. Prefer RingGauge for a generic closed KPI ring.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | — |
| `minimum` | `real` | — |
| `maximum` | `real` | — |
| `title` | `string` | — |
| `startAngle` | `real` | — |
| `sweepTotal` | `real` | — |
| `cautionThreshold` | `real` | — |
| `criticalThreshold` | `real` | — |
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
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
