# PasswordBox

Password field with reveal toggle.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PasswordBox.qml`](../../src/extras/QWinUI3/Extras/PasswordBox.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
PasswordBox {
    id: passwordBox
    placeholderText: qsTr("Password")
}

// --- API ---
// signals: onAccepted, onCleared
// methods: clear(), focusField()
// passwordBox.clear()
// passwordBox.focusField()
```

## Notes

Password TextField with reveal glyph; revealPassword / revealButtonVisible.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `text` | `alias` | Display / input text |
| `placeholderText` | `alias` | Placeholder when empty |
| `maximumLength` | `alias` | Hard maximum text length |
| `header` | `string` | Header label above the control |
| `description` | `string` | Supporting description text |
| `errorMessage` | `string` | Validation error text |
| `headerPlacement` | `string` | WinUI HeaderPlacement: top \| left |
| `labelWidth` | `real` | Label column width when headerPlacement is left |
| `clearButtonVisible` | `bool` | Show clear affordance |
| `passwordRevealMode` | `string` | WinUI PasswordRevealMode: peek \| hidden \| visible |
| `revealPassword` | `bool` | True while password is revealed |
| `revealButtonVisible` | `bool` | Show password reveal button |
| `canPasteClipboardContent` | `bool` | WinUI CanPasteClipboardContent — block paste when false |
| `echoMode` | `alias` | TextField echo mode |
| `field` | `alias` | Inner text field |
| `hasError` | `bool` | True when validation failed |

### Signals

| Signature | Description |
| --- | --- |
| `accepted()` | Emitted on accept / submit |
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
