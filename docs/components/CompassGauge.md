# CompassGauge

Heading / bearing compass (0–360°, wraparound).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CompassGauge.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CompassGauge.qml)

**Category:** Charts & gauges · **Library:** v2.65

[← Component index](../components.md)

**Gallery:** `CompassGauge` — [`src/gallery/pages/CompassGaugePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CompassGaugePage.qml)

**Extends** `Control`.

## Example

```qml
CompassGauge { heading: 42 }
```

## Notes

Experimental. Prefer RadialGauge for non-wrapping scales. Dual-use as a heading readout.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `heading` | `real` | Heading in degrees (0 = N, clockwise) |
| `title` | `string` | Primary title text |
| `caption` | `string` | Caption under the value |
| `showCardinals` | `bool` | — |
| `needleBrush` | `color` | — |
| `isInteractive` | `bool` | — |
| `interactive` | `alias` | — |
| `normalizedHeading` | `real` | — |
| `cardinal` | `string` | — |

### Signals

| Signature | Description |
| --- | --- |
| `valueEdited(real value)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `setHeading(v)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
