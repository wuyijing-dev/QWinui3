# TelltaleBar

Cluster warning / indicator lamps.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TelltaleBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TelltaleBar.qml)

**Category:** Charts & gauges · **Library:** v2.67

[← Component index](../components.md)

**Gallery:** `TelltaleBar` — [`src/gallery/pages/TelltaleBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TelltaleBarPage.qml)

**Extends** `Control`.

## Example

```qml
TelltaleBar { oil: true; leftTurn: true }
```

## Notes

Experimental telltales. Prefer InfoBadge for app status dots.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | — |
| `leftTurn` | `bool` | — |
| `rightTurn` | `bool` | — |
| `highBeam` | `bool` | — |
| `oil` | `bool` | — |
| `engine` | `bool` | — |
| `abs` | `bool` | — |
| `battery` | `bool` | — |
| `parkingBrake` | `bool` | — |
| `doors` | `bool` | — |
| `belt` | `bool` | — |
| `blinkMs` | `int` | — |

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
