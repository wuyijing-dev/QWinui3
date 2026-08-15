# TwoPaneView

Responsive dual-pane layout.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TwoPaneView.qml`](../../src/extras/QWinUI3/Extras/TwoPaneView.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
TwoPaneView {
    id: twoPaneView
    pane1: Rectangle { }
    pane2: Rectangle { }
}

// --- API ---
// methods: showPane1(), showPane2(), toggleSinglePane(), swapPanes()
// twoPaneView.showPane1()
// twoPaneView.showPane2()
// twoPaneView.toggleSinglePane()
// twoPaneView.swapPanes()
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `pane1` | `Item` | First pane content |
| `pane2` | `Item` | Second pane content |
| `panePriorityWidth` | `real` | Width threshold for pane priority |
| `pane1Length` | `alias` | Primary pane length |
| `minWideWidth` | `real` | Minimum width for wide layout |
| `preferredMode` | `int` | Preferred display mode |
| `panePriority` | `int` | Which pane takes priority when collapsing |
| `mode` | `int` | Display / interaction mode |
| `singlePaneIndex` | `int` | Which pane is shown in single-pane mode |
| `modeName` | `string` | Human-readable mode name |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `showPane1()` | Show primary pane |
| `showPane2()` | Show secondary pane |
| `toggleSinglePane()` | Toggle single-pane mode |
| `swapPanes()` | Swap primary / secondary panes |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
