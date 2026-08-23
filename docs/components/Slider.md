# Slider

Fluent styled Slider.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Slider.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Slider.qml)

**Category:** Styled controls · **Library:** v2.66

[← Component index](../components.md)

**Gallery:** `Slider` — [`src/gallery/pages/SliderPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SliderPage.qml)

## Example

```qml
Slider {
    id: slider
    from: 0; to: 100; value: 40
    onMoved: apply(slider.value)
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Slider.
Public API is the Qt Quick Controls Slider type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Slider` API (this file only supplies Fluent visuals / metrics).

### Inherited from `Slider`

- `from` / `to`
- `value`
- `moved()`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
