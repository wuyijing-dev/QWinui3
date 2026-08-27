# Slider

Fluent / WinUI 3 styled Slider with optional step tick marks and vertical fill rail.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Slider.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Slider.qml)

**Category:** Styled controls · **Library:** v3.13

[← Component index](../components.md)

**Gallery:** `Slider` — [`src/gallery/pages/SliderPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SliderPage.qml)

## Example

```qml
// Horizontal — ticks above and below (WinUI)
Slider {
    from: 0
    to: 100
    stepSize: 25
    value: 50
    tickMarksVisible: true
    tickPlacement: "both"
    snapMode: Slider.SnapAlways
}

// Vertical — thick accent fill below thumb, ticks left/right
Slider {
    orientation: Qt.Vertical
    height: 220
    from: 0
    to: 100
    stepSize: 25
    value: 33
    tickMarksVisible: true
    tickPlacement: "both"
}
```

## QWinUI3 properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `tickMarksVisible` | `bool` | `false` | Draw step ticks along the track |
| `tickPlacement` | `string` | `""` → `"both"` | Horizontal: `top` · `bottom` · `both`. Vertical: `left` · `right` · `both` |
| `verticalFillThickness` | `real` | `8` | Active rail width when `orientation: Qt.Vertical` |

Ticks use `stepSize` when &gt; 0; otherwise ~10 steps across `from..to`.

## Inherited from Qt `Slider`

- `from` / `to` / `value` / `stepSize` / `orientation`
- `snapMode` · `live` · `wheelEnabled`
- `moved()` · `pressed` · `visualPosition`

## Notes

Ring thumb with accent dot; inactive rail is thin grey; vertical active fill is thicker accent bar from the bottom. Honors `Theme.reducedMotion` on thumb/track motion.

---
*Updated for 3.13 tick marks + vertical rail.*
