# VerticalHeaderView

Fluent styled VerticalHeaderView.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/VerticalHeaderView.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/VerticalHeaderView.qml)

**Category:** Styled controls · **Library:** v1.19

[← Component index](../components.md)

## Example

```qml
TableView {
    id: table
}
VerticalHeaderView {
    id: vheader
    syncView: table
    clip: true
}
// --- API ---
// vheader.syncView / model / clip
```

## Notes

Style-only Fluent chrome for Qt Quick Controls VerticalHeaderView.
Public API is the Qt Quick Controls VerticalHeaderView type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `VerticalHeaderView` API (this file only supplies Fluent visuals / metrics).

### Inherited from `VerticalHeaderView`

- `syncView`
- `model`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
