# RangeSlider

Fluent / WinUI 3 styled dual-thumb range slider with optional tick marks and vertical fill rail.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/RangeSlider.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/RangeSlider.qml)

**Category:** Styled controls · **Library:** v3.14

[← Component index](../components.md)

**Gallery:** `RangeSlider` — [`src/gallery/pages/RangeSliderPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RangeSliderPage.qml)

## Example

```qml
// Horizontal range with ticks
RangeSlider {
    from: 0
    to: 100
    stepSize: 10
    first.value: 20
    second.value: 80
    tickMarksVisible: true
    tickPlacement: "both"
    snapMode: RangeSlider.SnapAlways
}

// Vertical range — thick accent fill between thumbs
RangeSlider {
    orientation: Qt.Vertical
    height: 220
    from: 0
    to: 100
    stepSize: 25
    first.value: 25
    second.value: 75
    tickMarksVisible: true
}
```

## QWinUI3 properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `tickMarksVisible` | `bool` | `false` | Draw step ticks along the track |
| `tickPlacement` | `string` | `""` → `"both"` | Horizontal: `top` · `bottom` · `both`. Vertical: `left` · `right` · `both` |
| `verticalFillThickness` | `real` | `8` | Active rail width when `orientation: Qt.Vertical` |

Ticks use `stepSize` when &gt; 0; otherwise ~10 steps across `from..to`.

## Inherited from Qt `RangeSlider`

- `from` / `to` / `stepSize` / `orientation` / `snapMode`
- `first` / `second` (`.value`, `.visualPosition`, `.pressed`, `.hovered`)
- `live` · `wheelEnabled`

## Notes

Ring thumbs with accent dots; inactive rail is thin grey; selected span uses accent fill. Honors `Theme.reducedMotion` on thumb/track motion.

---
*Updated for 3.14 tick marks + vertical rail.*
