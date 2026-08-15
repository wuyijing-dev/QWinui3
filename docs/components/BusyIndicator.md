# BusyIndicator

Fluent styled BusyIndicator.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/BusyIndicator.qml`](../../src/style/QWinUI3/BusyIndicator.qml)

[← Component index](../components.md)

## Example

```qml
BusyIndicator {
    id: busy
    running: true
    // stop with: busy.running = false
}
// --- API ---
// inherits BusyIndicator: running
// Fluent ring visuals only — no extra public properties
```

## Notes

Style-only Fluent chrome for Qt Quick Controls BusyIndicator.
Public API is the Qt Quick Controls BusyIndicator type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `BusyIndicator` API (this file only supplies Fluent visuals / metrics).

### Inherited from `BusyIndicator`

- `running`
- `palette`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
