# BulletChart

Compact KPI bullet (ranges + performance + target).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/BulletChart.qml`](../../src/extras/QWinUI3/Extras/BulletChart.qml)

[← Component index](../components.md)

## Usage

```qml
BulletChart { value: 70; target: 80; maximum: 100 }
```

## Properties

- `value: real` — Current value
- `target: real` — Anchor item for placement
- `maximum: real` — Maximum value
- `minimum: real` — Minimum value
- `ranges: var` — Bullet qualitative ranges
- `rangeColors: var` — Colors for bullet ranges
- `label: string` — Field label
- `unit: string` — Value unit label (%, rpm, …)
- `valuePrecision: int` — Digits after decimal for value text
- `showValueText: bool` — Show value as text
- `showTarget: bool` — Show target marker
- `showTargetDelta: bool` — Show delta vs target
- `targetMet: bool` — True when value meets target
- `targetDelta: real` — Value minus target
- `formattedValue: string` — Formatted value string
- `formattedDelta: string` — Formatted target delta text
- `index: int`
- `modelData: var`
- `prev: real` — Previous animated value
- `cur: real` — Current animated value

## Methods

- `setValue(v)` — Set Value
- `bandColor(index)` — Band Color

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
