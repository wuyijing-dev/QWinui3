# MeterBar

Multi-segment stacked meter (e.g. disk usage).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MeterBar.qml`](../../src/extras/QWinUI3/Extras/MeterBar.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
MeterBar { segments: [{ value: 40, color: Theme.accent }] }

// --- API ---
// signals: onSegmentClicked
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `segments` | `var` | Meter / stacked segment descriptors |
| `maximum` | `real` | Maximum value |
| `trackHeight` | `real` | Meter track height |
| `showLegend` | `bool` | Show chart legend |
| `interactive` | `bool` | Enable hover / click interaction |
| `hoverIndex` | `int` | Hovered item index |
| `header` | `string` | Header label above the control |
| `showRemaining` | `bool` | Show remaining segment |
| `remainingLabel` | `string` | Label for remaining segment |
| `remainingColor` | `color` | Color for remaining segment |
| `showTotal` | `bool` | Show total column |
| `total` | `real` | Sum of segment values |
| `remaining` | `real` | Remaining count / time |

### Signals

| Signature | Description |
| --- | --- |
| `segmentClicked(int index, real value)` | Emitted when a segment is clicked |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
