# RadioButtons

Grouped RadioButton list from a model.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RadioButtons.qml`](../../src/extras/QWinUI3/Extras/RadioButtons.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
RadioButtons {
    id: radioButtons
   header: qsTr("Choice"); model: ["A", "B"]
}

// --- API ---
// signals: onSelected, onSelectionChanged
// methods: select(index)
// radioButtons.select(index)
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `header` | `string` | Header label above the control |
| `description` | `string` | Supporting description text |
| `model` | `var` | Data model / item list for this control |
| `currentIndex` | `int` | Selected index |
| `selectedIndex` | `alias` | Selected index alias |
| `horizontal` | `bool` | Horizontal orientation when true |

### Signals

| Signature | Description |
| --- | --- |
| `selected(int index, var item)` | Selected state |
| `selectionChanged(int index)` | Selection changed |

### Methods

| Signature | Description |
| --- | --- |
| `select(index)` | Select item by index |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
