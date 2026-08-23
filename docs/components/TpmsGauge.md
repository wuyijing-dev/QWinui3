# TpmsGauge

Four-corner tire pressure.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TpmsGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TpmsGauge.qml)

**Category:** Charts & gauges · **Library:** v2.67

[← Component index](../components.md)

**Gallery:** `TpmsGauge` — [`src/gallery/pages/TpmsGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TpmsGaugePage.qml)

**Extends** `Control`.

## Example

```qml
TpmsGauge { fl: 2.3; fr: 2.3; rl: 2.4; rr: 2.1 }
```

## Notes

Experimental TPMS. Prefer KpiTile for a single pressure KPI.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | — |
| `unit` | `string` | — |
| `fl` | `real` | — |
| `fr` | `real` | — |
| `rl` | `real` | — |
| `rr` | `real` | — |
| `warnBelow` | `real` | — |
| `warnAbove` | `real` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
