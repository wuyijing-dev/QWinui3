# FormLayout

Vertical form stack that collects field errorMessage values.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FormLayout.qml`](../../src/extras/QWinUI3/Extras/FormLayout.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
FormLayout {
    id: form
    ValidationSummary { id: summary }
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
// --- API ---
// methods: validate(), clearErrors(), collectErrors()
// form.validate()
// form.clearErrors()
// form.collectErrors()
```

## Notes

ColumnLayout wrapper for HeaderedTextBox / NumberBox / PasswordBox.
labelWidth is pushed to descendants that expose a labelWidth property
(use headerPlacement: "left" on fields).
validate() gathers non-empty errorMessage (and hasError) from descendants.
Pair with ValidationSummary for a page-level error list.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `labelWidth` | `real` | Preferred label column width for left-header fields (applied to descendants) |
| `fieldSpacing` | `real` | Vertical spacing between fields |
| `errors` | `var` | Collected error strings after validate() / collectErrors() |
| `contentData` | `alias` | Default children / field slot |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `applyLabelWidth()` | Push labelWidth onto descendant fields that expose the property |
| `collectErrors()` | Return string[] of current field errors (does not mutate fields) |
| `validate()` | Refresh errors; returns true when there are none |
| `clearErrors()` | Clear errorMessage on descendant fields that expose it |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
