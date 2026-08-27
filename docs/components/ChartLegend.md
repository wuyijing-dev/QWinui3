# ChartLegend

Fluent legend for series/slices.

`import QWinUI3.Extras.Charts` · [`src/extras/QWinUI3/Extras/ChartLegend.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ChartLegend.qml)

**Category:** Charts & gauges · **Library:** v3.56

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Item`.

## Example

```qml
ChartLegend {
    id: chartLegend
    items: [{ label: "A", color: Theme.accent
}] }

// --- API ---
// signals: onItemClicked, onItemHovered
// methods: select(index), clearSelection()
// chartLegend.select(index)
// chartLegend.clearSelection()
```

## Notes

items: [{ label, color, selected? }]; select(index) / itemHovered for interaction.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `items` | `var` | Item list / children model |
| `hoverIndex` | `int` | Hovered item index |
| `selectedIndex` | `int` | Selected index alias |
| `interactive` | `bool` | Enable hover / click interaction |
| `isInteractive` | `alias` | Alias of interactive (gauge / KPI naming parity) |
| `orientation` | `int` | Qt.Horizontal or Qt.Vertical |
| `showValue` | `bool` | Show numeric value label |
| `header` | `string` | Header label above the control |

### Signals

| Signature | Description |
| --- | --- |
| `itemClicked(int index)` | Emitted when an item is clicked |
| `itemHovered(int index)` | Emitted when a legend item is hovered |

### Methods

| Signature | Description |
| --- | --- |
| `select(index)` | Select item by index |
| `clearSelection()` | Clear the current selection |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
