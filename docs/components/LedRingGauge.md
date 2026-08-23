# LedRingGauge

Circular LED / peak-hold ring.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/LedRingGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/LedRingGauge.qml)

**Category:** Charts & gauges · **Library:** v2.67

[← Component index](../components.md)

**Gallery:** `LedRingGauge` — [`src/gallery/pages/LedRingGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/LedRingGaugePage.qml)

**Extends** `Control`.

## Example

```qml
LedRingGauge { value: 0.72; peakHold: true }

// --- API ---
// methods: setValue(v)
```

## Notes

Experimental. Prefer VuMeter for a linear LED stack; SegmentedGauge for a thick arc.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | — |
| `minimum` | `real` | — |
| `maximum` | `real` | — |
| `segmentCount` | `int` | — |
| `title` | `string` | — |
| `peakHold` | `bool` | — |
| `peakHoldMs` | `int` | — |
| `cautionThreshold` | `real` | — |
| `criticalThreshold` | `real` | — |
| `isInteractive` | `bool` | — |
| `interactive` | `alias` | — |
| `normalized` | `real` | — |
| `peakNorm` | `real` | — |

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
