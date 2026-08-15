# Dial

Fluent styled Dial.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Dial.qml`](../../src/style/QWinUI3/Dial.qml)

[← Component index](../components.md)

## Usage

```qml
Dial { from: 0; to: 100; value: 30 }
```

## Properties

- `title: string` — Title text
- `unit: string` — Value unit label (%, rpm, …)
- `showValue: bool` — Show numeric value label
- `valuePrecision: int` — Digits after decimal for value text
- `tickCount: int` — Number of ticks
- `showTicks: bool` — Show tick marks
- `formattedValue: string` — Formatted value string
- `stroke: real` — Stroke width for dial arc
- `r: real` — Radius
- `index: int`
- `t: real` — Normalized 0..1 parameter
- `angDeg: real` — Angle in degrees
- `ang: real` — Angle in degrees
- `rr: real` — Resolved radius

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
