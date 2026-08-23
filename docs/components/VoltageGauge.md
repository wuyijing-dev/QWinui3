# VoltageGauge

12 V vehicle electrical system.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/VoltageGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/VoltageGauge.qml)

**Category:** Charts & gauges · **Library:** v2.65

[← Component index](../components.md)

**Gallery:** `VoltageGauge` — [`src/gallery/pages/VoltageGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/VoltageGaugePage.qml)

**Extends** `Control`.

## Example

```qml
VoltageGauge { value: 13.8; unit: "V" }

// --- API ---
// methods: setValue(v)
```

## Notes

Experimental 8–16 V cluster meter. Prefer LinearGauge for a generic track.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | — |
| `minimum` | `real` | — |
| `maximum` | `real` | — |
| `title` | `string` | — |
| `unit` | `string` | — |
| `lowWarn` | `real` | — |
| `highWarn` | `real` | — |
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
