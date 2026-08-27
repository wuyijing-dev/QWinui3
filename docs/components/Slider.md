# Slider

Fluent / WinUI 3 styled Slider.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Slider.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Slider.qml)

**Category:** Styled controls · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `Slider` — [`src/gallery/pages/SliderPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SliderPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
Slider {
    from: 0; to: 100; value: 50; stepSize: 25
    tickMarksVisible: true
    tickPlacement: "both"   // horizontal: top | bottom | both
}

Slider {
    orientation: Qt.Vertical
    height: 220
    from: 0; to: 100; value: 33; stepSize: 25
    tickMarksVisible: true
    tickPlacement: "both"   // vertical: left | right | both
}
```

## Notes

WinUI-style track fill, ring thumb, and step tick marks on both sides of the track.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `tickMarksVisible` | `bool` | Draw step ticks (requires stepSize > 0, or auto 10 steps across from..to) |
| `tickPlacement` | `string` | Tick side(s): horizontal top\|bottom\|both · vertical left\|right\|both · "" → both |
| `verticalFillThickness` | `real` | Vertical filled track width (WinUI thick active rail) |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
