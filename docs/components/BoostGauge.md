# BoostGauge

Turbo vacuum / boost with zero at center-left of the scale.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/BoostGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/BoostGauge.qml)

**Category:** Charts & gauges · **Library:** v2.67

[← Component index](../components.md)

**Gallery:** `BoostGauge` — [`src/gallery/pages/BoostGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/BoostGaugePage.qml)

**Extends** `Control`.

## Example

```qml
BoostGauge { value: 0.6; minimum: -1; maximum: 1.5; unit: "bar" }

// --- API ---
// methods: setValue(v)
```

## Notes

Experimental. Prefer RadialGauge when boost is just another linear scale.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | — |
| `minimum` | `real` | — |
| `maximum` | `real` | — |
| `title` | `string` | — |
| `unit` | `string` | — |
| `startAngle` | `real` | — |
| `sweepTotal` | `real` | — |
| `isInteractive` | `bool` | — |
| `interactive` | `alias` | — |
| `animatedValue` | `real` | — |
| `animatedNorm` | `real` | — |
| `zeroNorm` | `real` | — |

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
