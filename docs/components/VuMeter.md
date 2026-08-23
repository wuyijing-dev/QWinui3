# VuMeter

Linear LED / peak-hold meter (audio, signal, load).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/VuMeter.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/VuMeter.qml)

**Category:** Charts & gauges · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `VuMeter` — [`src/gallery/pages/VuMeterPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/VuMeterPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
VuMeter { value: 0.72; peakHold: true }
```

## Notes

Experimental. Prefer LinearGauge for a single analog track.
SegmentedGauge is the circular LED sibling.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | Current level 0…maximum |
| `minimum` | `real` | Minimum value |
| `maximum` | `real` | Maximum value |
| `segmentCount` | `int` | LED segment count |
| `orientation` | `int` | Qt.Horizontal or Qt.Vertical |
| `title` | `string` | Primary title text |
| `unit` | `string` | — |
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
