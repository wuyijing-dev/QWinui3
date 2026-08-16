# DockPanel

Dock children Top/Bottom/Left/Right/Fill.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DockPanel.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DockPanel.qml)

**Category:** Layout · **Library:** v1.21

[← Component index](../components.md)

**Gallery:** `DockPanel` — [`src/gallery/pages/DockPanelPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/DockPanelPage.qml)

**Extends** `Control`.

## Example

```qml
DockPanel {
    id: dockPanel
    Rectangle { DockPanel.dock: DockPanel.Top; height: 40 }
    Rectangle { DockPanel.dock: DockPanel.Fill }
}

// --- API ---
// methods: dockOf(item), relayout()
// dockPanel.dockOf(item)
// dockPanel.relayout()
```

## Notes

Dock children to edges (DockPanel.dock attached); last child fills.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `contentData` | `alias` | Default children / content slot |
| `lastChildFill` | `bool` | WinUI LastChildFill: last non-edge child fills the remaining region |
| `paddingEdges` | `int` | Edge paddings |
| `childCount` | `int` | Number of children |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `dockOf(item)` | Dock edge for a child |
| `relayout()` | Recompute layout |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
