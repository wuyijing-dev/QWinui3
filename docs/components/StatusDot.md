# StatusDot

Colored status indicator dot.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/StatusDot.qml`](../../src/extras/QWinUI3/Extras/StatusDot.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
StatusDot {
    id: dot
    status: "available"   // available | busy | away | offline
}
// --- API ---
// dot.status / statusColor
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `offline` | `int` | Offline status constant |
| `available` | `int` | Available status constant |
| `away` | `int` | Away status constant |
| `busy` | `int` | Busy status constant |
| `unknown` | `int` | Unknown status constant |
| `status` | `int` | Current status enum |
| `pulse` | `bool` | Animate a pulse when true |
| `size` | `real` | Diameter or box size in px |
| `label` | `string` | Field label |
| `showLabel` | `bool` | Show text label beside the dot |
| `statusName` | `string` | Status name string |
| `statusColor` | `color` | Status indicator color |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
