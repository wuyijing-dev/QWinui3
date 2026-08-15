# PageIndicator

Fluent styled PageIndicator.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/PageIndicator.qml`](../../src/style/QWinUI3/PageIndicator.qml)

[← Component index](../components.md)

## Example

```qml
SwipeView {
    id: pages
    Item {}
    Item {}
    Item {}
}
PageIndicator {
    id: dots
    count: pages.count
    currentIndex: pages.currentIndex
    interactive: true
    anchors.horizontalCenter: parent.horizontalCenter
}
// --- API ---
// dots.count / currentIndex / interactive
```

## Notes

Style-only Fluent chrome for Qt Quick Controls PageIndicator.
Public API is the Qt Quick Controls PageIndicator type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `PageIndicator` API (this file only supplies Fluent visuals / metrics).

### Inherited from `PageIndicator`

- `count`
- `currentIndex`
- `interactive`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
