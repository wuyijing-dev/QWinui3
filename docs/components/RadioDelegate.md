# RadioDelegate

Fluent styled RadioDelegate.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/RadioDelegate.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/RadioDelegate.qml)

**Category:** Styled controls · **Library:** v2.60

[← Component index](../components.md)

## Example

```qml
ListView {
    model: 3
    delegate: RadioDelegate {
        text: "Choice " + index
        width: ListView.view.width
    }
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls RadioDelegate.
Public API is the Qt Quick Controls RadioDelegate type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `RadioDelegate` API (this file only supplies Fluent visuals / metrics).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
