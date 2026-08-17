# MultiSelectComboBox

Combo that keeps the popup open for multi-select.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MultiSelectComboBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MultiSelectComboBox.qml)

**Category:** Input & forms · **Library:** v2.61

[← Component index](../components.md)

**Gallery:** `MultiSelectComboBox` — [`src/gallery/pages/MultiSelectComboBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/MultiSelectComboBoxPage.qml)

**Extends** `Control`.

## Example

```qml
MultiSelectComboBox {
    id: multiSelectComboBox
    header: qsTr("Teams")
    model: items; selectedIndexes: [0, 2]
}

// --- API ---
// signals: onSelectionChanged
// methods: toggleAt(index), ensureObjectModel(), selectAll(), clearSelection(), focusField()
// inherits Control (+ Qt Quick Controls base API)
```

## Notes

ComboBox with multi-check selection; selectedIndexes / selectedItems.
header / description / errorMessage for FormLayout (2.25).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | — |
| `placeholderText` | `string` | — |
| `header` | `string` | — |
| `description` | `string` | — |
| `errorMessage` | `string` | — |
| `headerPlacement` | `string` | — |
| `labelWidth` | `real` | — |
| `formBound` | `bool` | — |
| `hasError` | `bool` | — |
| `menuOpen` | `bool` | — |
| `isOpen` | `alias` | — |
| `selectedItems` | `var` | — |
| `selectedIndexes` | `var` | — |
| `displayText` | `string` | — |

### Signals

| Signature | Description |
| --- | --- |
| `selectionChanged(var selected)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `focusField()` | — |
| `setSelectedIndexes(indexes)` | — |
| `toggleAt(index)` | — |
| `ensureObjectModel()` | — |
| `selectAll()` | — |
| `clearSelection()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
