# TwoPaneView

Responsive dual-pane layout.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TwoPaneView.qml`](../../src/extras/QWinUI3/Extras/TwoPaneView.qml)

[← Component index](../components.md)

## Usage

```qml
TwoPaneView {
    pane1: Rectangle { }
    pane2: Rectangle { }
}
```

## Properties

- `pane1: Item` — First pane content
- `pane2: Item` — Second pane content
- `panePriorityWidth: real` — Pane Priority Width
- `pane1Length: alias` — Pane1 Length
- `minWideWidth: real` — Min Wide Width
- `preferredMode: int` — Preferred Mode
- `panePriority: int` — Pane Priority
- `mode: int` — Mode
- `singlePaneIndex: int` — Single Pane Index
- `modeName: string` — Mode Name

## Methods

- `showPane1()` — Show Pane1
- `showPane2()` — Show Pane2
- `toggleSinglePane()` — Toggle Single Pane
- `swapPanes()` — Swap Panes
- `reparentPanes()` — Reparent Panes
- `layoutPanes()` — Layout Panes

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
