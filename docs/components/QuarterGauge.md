# QuarterGauge

90° dashboard quadrant meter.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/QuarterGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/QuarterGauge.qml)

**Category:** Charts & gauges · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `QuarterGauge` — [`src/gallery/pages/QuarterGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/QuarterGaugePage.qml)

**Extends** `Control`.

## Example

```qml
QuarterGauge { value: 72; unit: "%" }

// --- API ---
// methods: setValue(v)
```

## Notes

Experimental. Prefer RadialGauge when a full needle scale is needed.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | — |
| `minimum` | `real` | — |
| `maximum` | `real` | — |
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
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
