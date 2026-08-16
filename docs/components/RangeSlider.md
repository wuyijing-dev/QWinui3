# RangeSlider

Fluent styled RangeSlider.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/RangeSlider.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/RangeSlider.qml)

**Category:** Styled controls · **Library:** v1.18

[← Component index](../components.md)

**Gallery:** `RangeSlider` — [`src/gallery/pages/RangeSliderPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RangeSliderPage.qml)

## Example

```qml
RangeSlider {
    id: range
    from: 0; to: 100
    first.value: 20
    second.value: 80
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls RangeSlider.
Public API is the Qt Quick Controls RangeSlider type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `RangeSlider` API (this file only supplies Fluent visuals / metrics).

### Inherited from `RangeSlider`

- `from` / `to`
- `first` / `second`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
