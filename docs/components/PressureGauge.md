# PressureGauge

Industrial needle with green / caution / red zones.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PressureGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/PressureGauge.qml)

**Category:** Charts & gauges · **Library:** v2.65

[← Component index](../components.md)

**Gallery:** `PressureGauge` — [`src/gallery/pages/PressureGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/PressureGaugePage.qml)

**Extends** `Control`.

## Example

```qml
PressureGauge {
    value: 6.2
    maximum: 10
    unit: "bar"
}

// --- API ---
// methods: setValue(v)
```

## Notes

Experimental zoned needle. Prefer RadialGauge for a generic scale.

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
| `cautionNorm` | `real` | — |
| `criticalNorm` | `real` | — |
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
