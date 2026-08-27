# TachometerGauge

RPM-style needle with a redline band.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TachometerGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TachometerGauge.qml)

**Category:** Charts & gauges · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `TachometerGauge` — [`src/gallery/pages/TachometerGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TachometerGaugePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
TachometerGauge {
    value: 4200
    maximum: 8000
    redline: 6500
    unit: "rpm"
}

// --- API ---
// methods: setValue(v)
```

## Notes

Experimental. Prefer RadialGauge for a general needle scale; this type adds a redline arc.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | — |
| `minimum` | `real` | — |
| `maximum` | `real` | — |
| `redline` | `real` | — |
| `title` | `string` | — |
| `unit` | `string` | — |
| `fillColor` | `color` | — |
| `redlineColor` | `color` | — |
| `startAngle` | `real` | — |
| `sweepTotal` | `real` | — |
| `isInteractive` | `bool` | — |
| `interactive` | `alias` | — |
| `animatedValue` | `real` | — |
| `animatedNorm` | `real` | — |
| `redlineNorm` | `real` | — |

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
