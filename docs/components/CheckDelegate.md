# CheckDelegate

Fluent styled CheckDelegate.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/CheckDelegate.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/CheckDelegate.qml)

**Category:** Styled controls · **Library:** v1.02

[← Component index](../components.md)

## Example

```qml
ListView {
    model: 3
    delegate: CheckDelegate {
        text: "Option " + index
        width: ListView.view.width
    }
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls CheckDelegate.
Public API is the Qt Quick Controls CheckDelegate type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `CheckDelegate` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
