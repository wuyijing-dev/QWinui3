# ScrollBar

Fluent styled ScrollBar.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ScrollBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ScrollBar.qml)

**Category:** Styled controls · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `ScrollBar` — [`src/gallery/pages/ScrollBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ScrollBarPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
Flickable {
    id: flick
    contentHeight: 2000
    ScrollBar.vertical: ScrollBar {
        id: vbar
        policy: ScrollBar.AsNeeded
    }
}
// --- API ---
// vbar.policy / size / position / increase() / decrease()
```

## Notes

Style-only Fluent chrome for Qt Quick Controls ScrollBar.
Public API is the Qt Quick Controls ScrollBar type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `ScrollBar` API (this file only supplies Fluent visuals / metrics).

### Inherited from `ScrollBar`

- `policy`
- `size` / `position`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
