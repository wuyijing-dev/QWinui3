# RangeSlider

Fluent / WinUI 3 styled dual-thumb Slider.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/RangeSlider.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/RangeSlider.qml)

**Category:** Styled controls · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `RangeSlider` — [`src/gallery/pages/RangeSliderPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RangeSliderPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
RangeSlider {
    from: 0; to: 100
    first.value: 20; second.value: 80
    stepSize: 10
    tickMarksVisible: true
    tickPlacement: "both"
}

RangeSlider {
    orientation: Qt.Vertical
    height: 220
    from: 0; to: 100
    first.value: 25; second.value: 75
    tickMarksVisible: true
}
```

## Notes

WinUI-style ring thumbs, accent range fill, and step ticks on both sides of the track.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `tickMarksVisible` | `bool` | Draw step ticks (requires stepSize > 0, or auto 10 steps across from..to) |
| `tickPlacement` | `string` | Tick side(s): horizontal top\|bottom\|both · vertical left\|right\|both · "" → both |
| `verticalFillThickness` | `real` | Vertical filled track width (WinUI thick active rail between thumbs) |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
