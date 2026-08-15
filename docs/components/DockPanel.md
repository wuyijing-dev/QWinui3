# DockPanel

Dock children Top/Bottom/Left/Right/Fill.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DockPanel.qml`](../../src/extras/QWinUI3/Extras/DockPanel.qml)

[← Component index](../components.md)

## Usage

```qml
DockPanel {
    Rectangle { DockPanel.dock: DockPanel.Top; height: 40 }
    Rectangle { DockPanel.dock: DockPanel.Fill }
}
```

## Properties

- `contentData: alias` — Default children / content slot
- `lastChildFill: bool` — WinUI LastChildFill: last non-edge child fills the remaining region
- `paddingEdges: int` — Edge paddings
- `childCount: int` — Number of children

## Methods

- `dockOf(item)` — Dock Of
- `relayout()` — Relayout

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
