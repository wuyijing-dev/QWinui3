# AutomotiveCluster

Composed vehicle instrument cluster.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AutomotiveCluster.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/AutomotiveCluster.qml)

**Category:** Charts & gauges · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `AutomotiveCluster` — [`src/gallery/pages/AutomotiveClusterPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/AutomotiveClusterPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
AutomotiveCluster {
    speed: 86
    rpm: 3200
    fuel: 0.42
    coolant: 92
    gear: "D"
}
```

## Notes

Experimental compose host. Product dashboards still use the stable six.
Wires SpeedometerGauge, TachometerGauge, FuelGauge, CoolantGauge, GearIndicator,
OdometerGauge, TelltaleBar, VoltageGauge.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `speed` | `real` | — |
| `speedMax` | `real` | — |
| `speedUnit` | `string` | — |
| `rpm` | `real` | — |
| `rpmMax` | `real` | — |
| `redline` | `real` | — |
| `fuel` | `real` | — |
| `coolant` | `real` | — |
| `boost` | `real` | — |
| `voltage` | `real` | — |
| `gear` | `string` | — |
| `gearNumber` | `int` | — |
| `totalKm` | `real` | — |
| `tripKm` | `real` | — |
| `leftTurn` | `bool` | — |
| `rightTurn` | `bool` | — |
| `highBeam` | `bool` | — |
| `oil` | `bool` | — |
| `engine` | `bool` | — |
| `abs` | `bool` | — |
| `batteryWarn` | `bool` | — |
| `parkingBrake` | `bool` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `setSpeed(v)` | — |
| `setRpm(v)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
