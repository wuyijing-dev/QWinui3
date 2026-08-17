# Tumbler

Fluent styled Tumbler.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Tumbler.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Tumbler.qml)

**Category:** Styled controls · **Library:** v1.76

[← Component index](../components.md)

**Gallery:** `Tumbler` — [`src/gallery/pages/TumblerPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TumblerPage.qml)

## Example

```qml
Tumbler {
    id: hours
    model: 24
    currentIndex: 8
    visibleItemCount: 5
    onCurrentIndexChanged: applyHour(hours.currentIndex)
}
// --- API ---
// hours.model / currentIndex / visibleItemCount
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Tumbler.
Public API is the Qt Quick Controls Tumbler type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Tumbler` API (this file only supplies Fluent visuals / metrics).

### Inherited from `Tumbler`

- `model`
- `currentIndex`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
