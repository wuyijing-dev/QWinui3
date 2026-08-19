# GMeterGauge

Lateral / longitudinal G-force plot.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/GMeterGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/GMeterGauge.qml)

**Category:** Charts & gauges · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `GMeterGauge` — [`src/gallery/pages/GMeterGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/GMeterGaugePage.qml)

**Extends** `Control`.

## Example

```qml
GMeterGauge { lateral: 0.25; longitudinal: -0.1 }
```

## Notes

Experimental. Prefer ScatterChart for a generic XY plot.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `lateral` | `real` | — |
| `longitudinal` | `real` | — |
| `maxG` | `real` | — |
| `title` | `string` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `setG(lat, lon)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
