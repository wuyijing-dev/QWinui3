# SwipeDelegate

Fluent styled SwipeDelegate.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/SwipeDelegate.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/SwipeDelegate.qml)

**Category:** Styled controls · **Library:** v1.12

[← Component index](../components.md)

**Gallery:** `SwipeDelegate` — [`src/gallery/pages/SwipeDelegatePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SwipeDelegatePage.qml)

## Example

```qml
ListView {
    model: 3
    delegate: SwipeDelegate {
        text: "Row " + index
        swipe.right: Label { text: qsTr("Delete"); padding: 12 }
    }
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls SwipeDelegate.
Public API is the Qt Quick Controls SwipeDelegate type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `SwipeDelegate` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
