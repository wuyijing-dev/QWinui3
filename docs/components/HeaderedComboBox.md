# HeaderedComboBox

ComboBox with header, description, and FormLayout binding.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/HeaderedComboBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/HeaderedComboBox.qml)

**Category:** Input & forms · **Library:** v1.11

[← Component index](../components.md)

**Gallery:** `HeaderedComboBox` — [`src/gallery/pages/HeaderedComboBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/HeaderedComboBoxPage.qml)

**Extends** `Control`.

## Example

```qml
HeaderedComboBox {
    header: qsTr("Plan")
    model: [qsTr("Free"), qsTr("Pro")]
    currentIndex: 0
}

// --- API ---
// signals: onActivated, onAccepted
// inherits Control; formBound fields accept FormLayout labelWidth push
```

## Notes

Label + ComboBox pair matching HeaderedTextBox (error icon + critical underline).
headerPlacement top|left; FormLayout may push labelWidth / fieldHeaderPlacement
when formBound is true. See docs/forms.md.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `header` | `string` | — |
| `description` | `string` | — |
| `errorMessage` | `string` | — |
| `headerPlacement` | `string` | — |
| `labelWidth` | `real` | — |
| `formBound` | `bool` | — |
| `model` | `alias` | — |
| `currentIndex` | `alias` | — |
| `currentText` | `alias` | — |
| `currentValue` | `alias` | — |
| `textRole` | `alias` | — |
| `valueRole` | `alias` | — |
| `editable` | `alias` | — |
| `editText` | `alias` | — |
| `count` | `alias` | — |
| `comboBox` | `alias` | — |
| `hasError` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `activated(int index)` | — |
| `accepted()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `focusField()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
