# ProgressRing

Circular progress / busy ring.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ProgressRing.qml`](../../src/extras/QWinUI3/Extras/ProgressRing.qml)

[← Component index](../components.md)

## Usage

```qml
ProgressRing { indeterminate: true }
```

## Properties

- `value: real` — Current value
- `indeterminate: bool` — Show indeterminate animation when true
- `isActive: bool` — WinUI-style: Active sweeps; Paused holds a partial arc without spinning
- `strokeWidth: real` — Stroke thickness in px
- `fillColor: color` — Primary fill / progress color
- `trackColor: color` — Track / remaining color
- `showValue: bool` — Show numeric value label
- `valueLabel: string` — Optional value caption
- `size: real` — Diameter or box size in px
- `spinning: bool` — True while indeterminate ring spins
- `progressSweep: real` — Determinate arc sweep degrees
- `formattedValue: string` — Formatted value string
- `radius: real` — Corner radius
- `spinAngle: real` — Indeterminate spin angle
- `animatedSweep: real` — Animated sweep angle for gauges

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
