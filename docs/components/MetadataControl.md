# MetadataControl

Stacked or flowed label/value metadata block.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MetadataControl.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MetadataControl.qml)

**Category:** Other · **Library:** v2.58

[← Component index](../components.md)

**Gallery:** `MetadataControl` — [`src/gallery/pages/MetadataControlPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/MetadataControlPage.qml)

**Extends** `Control`.

## Example

```qml
MetadataControl {
    id: metadataControl
    MetadataItem { label: qsTr("Author"); value: "Ada" }
}

// --- API ---
// methods: syncChildren()
// metadataControl.syncChildren()
```

## Notes

Host for MetadataItem rows (label/value pairs).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `items` | `alias` | Item list / children model |
| `orientation` | `int` | Qt.Horizontal or Qt.Vertical |
| `itemSpacing` | `real` | Spacing between items |
| `header` | `string` | Header label above the control |
| `paddingEdges` | `int` | Edge paddings |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `syncChildren()` | Synchronize child item state |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
