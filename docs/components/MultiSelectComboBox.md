# MultiSelectComboBox

Combo that keeps the popup open for multi-select.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MultiSelectComboBox.qml`](../../src/extras/QWinUI3/Extras/MultiSelectComboBox.qml)

[← Component index](../components.md)

**Extends** `AbstractButton`.

## Example

```qml
MultiSelectComboBox {
    id: multiSelectComboBox
   model: items; selectedIndexes: [0, 2]
}

// --- API ---
// signals: onSelectionChanged
// methods: toggleAt(index), ensureObjectModel(), selectAll(), clearSelection()
// multiSelectComboBox.toggleAt(index)
// multiSelectComboBox.ensureObjectModel()
// multiSelectComboBox.selectAll()
// multiSelectComboBox.clearSelection()
// inherits AbstractButton (+ Qt Quick Controls base API)
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | Data model / item list for this control |
| `placeholderText` | `string` | Placeholder when empty |
| `header` | `string` | Header label above the control |
| `menuOpen` | `bool` | Menu currently open |
| `isOpen` | `alias` | Open / visible state |
| `selectedItems` | `var` | Currently selected items |
| `displayText` | `string` | Text shown to the user |

### Signals

| Signature | Description |
| --- | --- |
| `selectionChanged(var selected)` | Selection changed |

### Methods

| Signature | Description |
| --- | --- |
| `toggleAt(index)` | Toggle item at index |
| `ensureObjectModel()` | Ensure model is an ObjectModel |
| `selectAll()` | Select all items |
| `clearSelection()` | Clear the current selection |

### Inherited from `AbstractButton`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `down` / `pressed` / `hovered`
- `clicked()`
- `pressAndHold()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
