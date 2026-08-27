# SwitchDelegate

Fluent styled SwitchDelegate.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/SwitchDelegate.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/SwitchDelegate.qml)

**Category:** Styled controls · **Library:** v3.56

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
ListView {
    model: 3
    delegate: SwitchDelegate {
        text: "Flag " + index
        width: ListView.view.width
    }
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls SwitchDelegate.
Public API is the Qt Quick Controls SwitchDelegate type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `SwitchDelegate` API (this file only supplies Fluent visuals / metrics).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
