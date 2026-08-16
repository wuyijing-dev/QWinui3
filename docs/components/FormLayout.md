# FormLayout

Vertical form stack that collects field errorMessage values.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FormLayout.qml`](../../src/extras/QWinUI3/Extras/FormLayout.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
FormLayout {
    id: form
    labelWidth: 140
    fieldHeaderPlacement: "left"
    ValidationSummary { errors: form.errors }
    HeaderedTextBox { id: nameField; header: qsTr("Name") }
    NumberBox { id: ageField; header: qsTr("Age") }
    Button {
        text: qsTr("Submit")
        onClicked: {
            nameField.errorMessage = nameField.text.length ? "" : qsTr("Required")
            if (form.validate()) { /* ok */ }
        }
    }
}
```

## Notes

Host pushes `labelWidth` / `fieldHeaderPlacement` onto formBound children — fields do not
walk the parent chain. Set `formBound: false` on a field to opt out.
`validate()` gathers non-empty `errorMessage` (and `hasError`) from descendants.
Pair with ValidationSummary for a page-level error list.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `labelWidth` | `real` | Preferred label column width (pushed to descendants) |
| `fieldHeaderPlacement` | `string` | Optional default `headerPlacement` (`left` \| `top`) |
| `fieldSpacing` | `real` | Vertical spacing between fields |
| `errors` | `var` | Collected error strings after validate() / collectErrors() |
| `contentData` | `alias` | Default children / field slot |

### Methods

| Signature | Description |
| --- | --- |
| `applyDefaults()` | Push labelWidth / fieldHeaderPlacement onto formBound fields |
| `applyLabelWidth()` | Compat alias of applyDefaults() |
| `collectErrors()` | Return string[] of current field errors |
| `validate()` | Refresh errors; returns true when there are none |
| `clearErrors()` | Clear errorMessage on descendant fields |
