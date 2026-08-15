# ApplicationWindow

Fluent ApplicationWindow chrome defaults.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ApplicationWindow.qml`](../../src/style/QWinUI3/ApplicationWindow.qml)

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

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `ApplicationWindow` API (this file only supplies Fluent visuals / metrics).

### Inherited from `ApplicationWindow`

- `title`
- `visible`
- `menuBar` / `header` / `footer`
- `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
