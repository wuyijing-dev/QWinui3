# ItemDelegate

Fluent styled ItemDelegate.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ItemDelegate.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ItemDelegate.qml)

**Category:** Styled controls · **Library:** v1.49

[← Component index](../components.md)

## Example

```qml
ListView {
    model: 5
    delegate: ItemDelegate {
        text: "Item " + index
        width: ListView.view.width
        onClicked: select(index)
    }
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls ItemDelegate.
Public API is the Qt Quick Controls ItemDelegate type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `ItemDelegate` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
