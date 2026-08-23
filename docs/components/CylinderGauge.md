# CylinderGauge

Isometric cylinder level.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CylinderGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CylinderGauge.qml)

**Category:** Charts & gauges · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `CylinderGauge` — [`src/gallery/pages/CylinderGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CylinderGaugePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
CylinderGauge { value: 62; unit: "%" }

// --- API ---
// methods: setValue(v)
```

## Notes

Experimental. Prefer TankGauge for a 2D reservoir.

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
