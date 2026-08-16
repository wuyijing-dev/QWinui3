# BulletChart

Compact KPI bullet (ranges + performance + target).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/BulletChart.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/BulletChart.qml)

**Category:** Charts & gauges · **Library:** v1.06

[← Component index](../components.md)

**Gallery:** `BulletChart` — [`src/gallery/pages/BulletChartPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/BulletChartPage.qml)

**Extends** `Control`.

## Example

```qml
BulletChart {
    id: bulletChart
    value: 70; target: 80; maximum: 100
}

// --- API ---
// methods: setValue(v), bandColor(index)
// bulletChart.setValue(v)
// bulletChart.bandColor(index)
```

## Notes

KPI bullet: qualitative bands + performance value + target marker.
setValue(v) clamps into range; bandColor(index) for band fills.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | Current value |
| `target` | `real` | Anchor item for placement |
| `maximum` | `real` | Maximum value |
| `minimum` | `real` | Minimum value |
| `ranges` | `var` | Bullet qualitative ranges |
| `rangeColors` | `var` | Colors for bullet ranges |
| `label` | `string` | Field label |
| `unit` | `string` | Value unit label (%, rpm, …) |
| `valuePrecision` | `int` | Digits after decimal for value text |
| `showValueText` | `bool` | Show value as text |
| `showTarget` | `bool` | Show target marker |
| `showTargetDelta` | `bool` | Show delta vs target |
| `targetMet` | `bool` | True when value meets target |
| `targetDelta` | `real` | Value minus target |
| `formattedValue` | `string` | Formatted value string |
| `formattedDelta` | `string` | Formatted target delta text |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `setValue(v)` | Set value (clamped / snapped) |
| `bandColor(index)` | Color for a qualitative band |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
