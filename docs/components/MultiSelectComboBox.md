# MultiSelectComboBox

Combo that keeps the popup open for multi-select.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MultiSelectComboBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MultiSelectComboBox.qml)

**Category:** Input & forms · **Library:** v1.80

[← Component index](../components.md)

**Gallery:** `MultiSelectComboBox` — [`src/gallery/pages/MultiSelectComboBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/MultiSelectComboBoxPage.qml)

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

## Notes

ComboBox with multi-check selection; selectedIndexes / selectedItems.
exclusive mode behaves like a normal combo.

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
| `selectedIndexes` | `var` | WinUI SelectedIndexes — writable list of checked indices |
| `displayText` | `string` | Text shown to the user |

### Signals

| Signature | Description |
| --- | --- |
| `selectionChanged(var selected)` | Selection changed |

### Methods

| Signature | Description |
| --- | --- |
| `setSelectedIndexes(indexes)` | — |
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

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
