# GearIndicator

PRNDS / manual gear readout for a cluster.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/GearIndicator.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/GearIndicator.qml)

**Category:** Charts & gauges · **Library:** v2.66

[← Component index](../components.md)

**Gallery:** `GearIndicator` — [`src/gallery/pages/GearIndicatorPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/GearIndicatorPage.qml)

**Extends** `Control`.

## Example

```qml
GearIndicator { gear: "D"; gearNumber: 4 }
```

## Notes

Experimental. Compose in AutomotiveCluster. Not a stable-six type.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `gear` | `string` | — |
| `gearNumber` | `int` | — |
| `title` | `string` | — |
| `gears` | `var` | — |
| `displayText` | `string` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `setGear(g, n)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
