# ComboBox

Fluent / WinUI 3 ComboBox with optional header, description, validation, and editable text.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ComboBox.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ComboBox.qml)

**Category:** Styled controls · **Library:** v3.17

[← Component index](../components.md)

**Gallery:** `ComboBox` — [`src/gallery/pages/ComboBoxPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ComboBoxPage.qml)

## Example

```qml
ComboBox {
    header: qsTr("Favorite color")
    description: qsTr("Used on your profile.")
    model: [qsTr("Red"), qsTr("Green"), qsTr("Blue")]
    onActivated: (index) => apply(index)
}

ComboBox {
    header: qsTr("Font family")
    editable: true
    model: ["Segoe UI", "Consolas", "Cascadia Code"]
}
```

## QWinUI3 properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `header` | `string` | `""` | Label above the field (WinUI Header) |
| `description` | `string` | `""` | Caption under the header (hidden while `errorMessage` is set) |
| `errorMessage` | `string` | `""` | Critical caption + error chrome |
| `hasError` | `bool` | `false` | Force error chrome without a message |
| `appearance` | `string` | `""` → `filled` | `filled` · `outline` |
| `lightScheme` | `bool` | | Readonly — `!Theme.dark` (legacy) |

## Inherited from Qt `ComboBox`

- `model` · `currentIndex` · `currentText` · `displayText` · `textRole` / `valueRole`
- `editable` · `editText` · `validator` · `inputMethodHints`
- `activated(index)` · `accepted()`

## Notes

Popup opens under the field chrome (not under the error footer). Checkmark pip marks the selected item. For **FormLayout** left-aligned labels use **HeaderedComboBox**. Honors `Theme.reducedMotion` on chevron, popup, and error shake.

---
*Updated for 3.17 header / editable / errorMessage.*
