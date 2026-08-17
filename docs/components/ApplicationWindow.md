# ApplicationWindow

Fluent ApplicationWindow chrome defaults.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ApplicationWindow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ApplicationWindow.qml)

**Category:** Styled controls · **Library:** v1.51

[← Component index](../components.md)

## Example

```qml
ApplicationWindow {
    id: win
    width: 1024; height: 720
    title: qsTr("App")
    visible: true
}
```

## Notes

Style-only Fluent chrome for Qt Quick Controls ApplicationWindow.
Public API is the Qt Quick Controls ApplicationWindow type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `ApplicationWindow` API (this file only supplies Fluent visuals / metrics).

### Inherited from `ApplicationWindow`

- `title`
- `menuBar` / `header` / `footer`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
