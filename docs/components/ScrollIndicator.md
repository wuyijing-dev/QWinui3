# ScrollIndicator

Fluent styled ScrollIndicator.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ScrollIndicator.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ScrollIndicator.qml)

**Category:** Styled controls · **Library:** v1.05

[← Component index](../components.md)

## Example

```qml
Flickable {
    id: flick
    contentHeight: 2000
    ScrollIndicator.vertical: ScrollIndicator {
        id: indicator
    }
}
// --- API ---
// indicator.active / size / position
```

## Notes

Style-only Fluent chrome for Qt Quick Controls ScrollIndicator.
Public API is the Qt Quick Controls ScrollIndicator type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `ScrollIndicator` API (this file only supplies Fluent visuals / metrics).

### Inherited from `ScrollIndicator`

- `active`
- `size` / `position`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
