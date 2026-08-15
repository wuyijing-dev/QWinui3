# WrapPanel

Flow / wrap layout.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/WrapPanel.qml`](../../src/extras/QWinUI3/Extras/WrapPanel.qml)

[← Component index](../components.md)

## Usage

```qml
WrapPanel {
    Repeater { model: 8; Chip { text: modelData } }
}
```

## Properties

- `contentData: alias` — Default children / content slot
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `itemWidth: real` — Item Width
- `itemHeight: real` — Item Height
- `paddingEdges: int` — Edge paddings
- `layoutDirection: int` — Qt layout direction
- `childCount: int` — Number of children

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
