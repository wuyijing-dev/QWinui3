# MetadataControl

Stacked or flowed label/value metadata block.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MetadataControl.qml`](../../src/extras/QWinUI3/Extras/MetadataControl.qml)

[← Component index](../components.md)

## Usage

```qml
MetadataControl {
    MetadataItem { label: qsTr("Author"); value: "Ada" }
}
```

## Properties

- `items: alias` — Item list / children model
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `itemSpacing: real` — Spacing between items
- `header: string` — Header label above the control
- `paddingEdges: int` — Edge paddings

## Methods

- `syncChildren()` — Synchronize child item state

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
