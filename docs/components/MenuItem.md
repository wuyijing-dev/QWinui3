# MenuItem

Fluent styled MenuItem.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/MenuItem.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/MenuItem.qml)

**Category:** Styled controls · **Library:** v1.52

[← Component index](../components.md)

## Example

```qml
Menu {
    id: menu
    MenuItem {
        id: item
        text: qsTr("Copy")
        enabled: true
        onTriggered: copy()
    }
}
// --- API ---
// item.text / enabled / checkable / triggered()
```

## Notes

Style-only Fluent chrome for Qt Quick Controls MenuItem.
Public API is the Qt Quick Controls MenuItem type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `MenuItem` API (this file only supplies Fluent visuals / metrics).

### Inherited from `MenuItem`

- `text`
- `triggered()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
