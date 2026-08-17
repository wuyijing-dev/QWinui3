# Dial

Fluent Dial with WinUI arc track and accent thumb.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Dial.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Dial.qml)

**Category:** Styled controls · **Library:** v2.63

[← Component index](../components.md)

**Gallery:** `Dial` — [`src/gallery/pages/DialPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/DialPage.qml)

## Example

```qml
Dial {
    id: dial
    from: 0; to: 100; value: 35
    onMoved: apply(dial.value)
}
// --- API ---
// dial.from / to / value / moved() / wrapped
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Dial.
Public API is the Qt Quick Controls Dial type; this file supplies visuals/metrics only.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Title text |
| `unit` | `string` | Value unit label (%, rpm, …) |
| `showValue` | `bool` | Show numeric value label |
| `valuePrecision` | `int` | Digits after decimal for value text |
| `tickCount` | `int` | Number of ticks |
| `showTicks` | `bool` | Show tick marks |
| `formattedValue` | `string` | Formatted value string |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
