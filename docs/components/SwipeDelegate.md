# SwipeDelegate

Fluent styled SwipeDelegate.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/SwipeDelegate.qml`](../../src/style/QWinUI3/SwipeDelegate.qml)

[← Component index](../components.md)

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

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `SwipeDelegate` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
