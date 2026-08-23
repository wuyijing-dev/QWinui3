# DualRingGauge

Two independent concentric KPI rings.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DualRingGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DualRingGauge.qml)

**Category:** Charts & gauges · **Library:** v2.66

[← Component index](../components.md)

**Gallery:** `DualRingGauge` — [`src/gallery/pages/DualRingGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/DualRingGaugePage.qml)

**Extends** `Control`.

## Example

```qml
DualRingGauge {
    value: 72
    value2: 48
    title: qsTr("CPU")
    title2: qsTr("GPU")
}

// --- API ---
// methods: setValue(v), setValue2(v)
```

## Notes

Experimental. Prefer RingGauge.value2 when both rings share one min/max scale.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | — |
| `value2` | `real` | — |
| `minimum` | `real` | — |
| `maximum` | `real` | — |
| `title` | `string` | — |
| `title2` | `string` | — |
| `unit` | `string` | — |
| `fillColor` | `color` | — |
| `fillColor2` | `color` | — |
| `strokeWidth` | `real` | — |
| `strokeWidthInner` | `real` | — |
| `startAngle` | `real` | — |
| `sweepTotal` | `real` | — |
| `trackColor` | `color` | — |
| `animatedValue` | `real` | — |
| `animatedValue2` | `real` | — |
| `animatedNorm` | `real` | — |
| `animatedNorm2` | `real` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `setValue(v)` | — |
| `setValue2(v)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
