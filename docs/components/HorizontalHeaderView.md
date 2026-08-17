# HorizontalHeaderView

Fluent styled HorizontalHeaderView.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/HorizontalHeaderView.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/HorizontalHeaderView.qml)

**Category:** Styled controls · **Library:** v1.80

[← Component index](../components.md)

## Example

```qml
TableView {
    id: table
    // …
}
HorizontalHeaderView {
    id: header
    syncView: table
    clip: true
}
// --- API ---
// header.syncView / model / clip
```

## Notes

Style-only Fluent chrome for Qt Quick Controls HorizontalHeaderView.
Public API is the Qt Quick Controls HorizontalHeaderView type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `HorizontalHeaderView` API (this file only supplies Fluent visuals / metrics).

### Inherited from `HorizontalHeaderView`

- `syncView`
- `model`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
