# TextField

Fluent / WinUI 3 TextBox-style single-line input with header, description, validation, and character limit.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/TextField.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/TextField.qml)

**Category:** Styled controls · **Library:** v3.16

[← Component index](../components.md)

**Gallery:** `TextField` — [`src/gallery/pages/TextFieldPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TextFieldPage.qml)

## Example

```qml
TextField {
    header: qsTr("Email")
    description: qsTr("We'll never share this.")
    placeholderText: qsTr("name@example.com")
    leadingSymbol: FluentIcons.Mail
    clearButtonVisible: true
    characterLimit: 64
    errorMessage: looksInvalid ? qsTr("Enter a valid email.") : ""
}
```

## QWinUI3 properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `header` | `string` | `""` | Label above the field (WinUI Header) |
| `description` | `string` | `""` | Caption under the header (hidden while `errorMessage` is set) |
| `errorMessage` | `string` | `""` | Critical caption + error chrome |
| `characterLimit` | `int` | `0` | Soft counter (`n / limit`); over-limit is critical |
| `hasError` | `bool` | `false` | Force error chrome without a message |
| `appearance` | `string` | `""` → `filled` | `filled` · `outline` |
| `leadingSymbol` / `leadingGlyph` | `var` / `string` | | Leading Fluent icon |
| `clearButtonVisible` | `bool` | `true` | Clear affordance when editable and non-empty |
| `isReadOnly` | alias | | Alias of Qt `readOnly` |

Readonly helpers: `characterCount`, `overLimit`, `_error` (internal).

## Inherited from Qt `TextField`

- `text` · `placeholderText` · `echoMode` · `readOnly` · `maximumLength` · `validator`
- `accepted()` · `editingFinished()` · `textEdited()`

## Notes

For **FormLayout** left-aligned labels (`headerPlacement: "left"`), use **HeaderedTextBox**. Prefer **PasswordBox** when you need a reveal toggle. Honors `Theme.reducedMotion` on focus underline and error shake.

---
*Updated for 3.16 header / description / errorMessage / characterLimit.*
