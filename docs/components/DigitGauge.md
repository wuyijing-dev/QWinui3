# DigitGauge

Seven-segment numeric readout.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DigitGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DigitGauge.qml)

**Category:** Charts & gauges · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `DigitGauge` — [`src/gallery/pages/DigitGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/DigitGaugePage.qml)

**Extends** `Control`.

## Example

```qml
DigitGauge { value: 42.8; digits: 4; valuePrecision: 1 }

// --- API ---
// methods: setValue(v)
```

## Notes

Experimental LED digits. Prefer KpiTile for dashboard KPI text.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | — |
| `digits` | `int` | — |
| `valuePrecision` | `int` | — |
| `title` | `string` | — |
| `unit` | `string` | — |
| `fillColor` | `color` | — |
| `faceColor` | `color` | Dark LED face — inactive segments use dim fillColor, not strokeDivider on a light card. |
| `offSegmentOpacity` | `real` | — |
| `animatedValue` | `real` | — |
| `formattedValue` | `string` | — |

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
