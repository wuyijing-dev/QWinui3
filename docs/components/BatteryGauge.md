# BatteryGauge

Battery silhouette with charge fill and optional charging bolt.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/BatteryGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/BatteryGauge.qml)

**Category:** Charts & gauges · **Library:** v2.67

[← Component index](../components.md)

**Gallery:** `BatteryGauge` — [`src/gallery/pages/BatteryGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/BatteryGaugePage.qml)

**Extends** `Control`.

## Example

```qml
BatteryGauge {
    value: 28
    charging: false
}

// --- API ---
// methods: setValue(v)
```

## Notes

Experimental 0–100 battery. Prefer RingGauge for a generic closed KPI ring.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | — |
| `minimum` | `real` | — |
| `maximum` | `real` | — |
| `title` | `string` | — |
| `unit` | `string` | — |
| `charging` | `bool` | — |
| `cautionThreshold` | `real` | — |
| `criticalThreshold` | `real` | — |
| `bodyRadius` | `real` | — |
| `animatedValue` | `real` | — |
| `animatedNorm` | `real` | — |
| `severity` | `int` | — |
| `fillColor` | `color` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

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
