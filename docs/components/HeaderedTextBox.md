# HeaderedTextBox

TextBox with header and description.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/HeaderedTextBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/HeaderedTextBox.qml)

**Category:** Input & forms · **Library:** v1.12

[← Component index](../components.md)

**Gallery:** `HeaderedTextBox` — [`src/gallery/pages/HeaderedTextBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/HeaderedTextBoxPage.qml)

**Extends** `Control`.

## Example

```qml
HeaderedTextBox {
    id: headeredTextBox
    header: qsTr("Name"); placeholderText: qsTr("Required")
}

// --- API ---
// signals: onAccepted, onEditingFinished, onTextEdited, onCleared
// methods: clear(), focusField()
// headeredTextBox.clear()
// headeredTextBox.focusField()
```

## Notes

Label + TextField pair; header/headerPlacement and text/placeholderText aliases.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `header` | `string` | Header label above the control |
| `description` | `string` | Supporting description text |
| `errorMessage` | `string` | Validation error text |
| `headerPlacement` | `string` | WinUI HeaderPlacement: top \| left (FormLayout may push fieldHeaderPlacement) |
| `labelWidth` | `real` | Label column width when headerPlacement is left (FormLayout may push labelWidth) |
| `formBound` | `bool` | When true, FormLayout may push labelWidth / fieldHeaderPlacement |
| `clearButtonVisible` | `bool` | Show clear affordance |
| `characterLimit` | `int` | Soft character counter limit |
| `text` | `alias` | Display / input text |
| `placeholderText` | `alias` | Placeholder when empty |
| `echoMode` | `alias` | TextField echo mode |
| `readOnly` | `alias` | Read-only when true |
| `isReadOnly` | `alias` | Alias of readOnly |
| `maximumLength` | `alias` | Hard maximum text length |
| `validator` | `alias` | Optional input validator |
| `inputMethodHints` | `alias` | Qt input method hints |
| `acceptableInput` | `alias` | True when typed input is valid |
| `field` | `alias` | Inner text field |
| `hasError` | `bool` | True when validation failed |
| `characterCount` | `int` | Character count of the text |
| `overLimit` | `bool` | True when over the max limit |

### Signals

| Signature | Description |
| --- | --- |
| `accepted()` | Emitted on accept / submit |
| `editingFinished()` | Emitted when editing finishes |
| `textEdited()` | Emitted while text is being edited |
| `cleared()` | Emitted when content is cleared |

### Methods

| Signature | Description |
| --- | --- |
| `clear()` | Clear text or selection |
| `focusField()` | Move keyboard focus to the text field |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
