# FormLayout

Vertical form stack that collects field errorMessage values.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FormLayout.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/FormLayout.qml)

**Category:** Input & forms · **Library:** v0.1.0

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
// --- API ---
// methods: validate(), clearErrors(), collectErrors(), applyDefaults(), applyLabelWidth()
```

## Notes

ColumnLayout host for HeaderedTextBox / HeaderedComboBox / NumberBox / PasswordBox / DetailRow.
Pushes labelWidth (+ optional fieldHeaderPlacement) onto children — fields do not
walk parents. Set formBound: false on a field to opt out.
validate() gathers non-empty errorMessage (and hasError) from descendants.
Pair with ValidationSummary for a page-level error list.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `labelWidth` | `real` | Preferred label column width for left-header fields |
| `fieldHeaderPlacement` | `string` | Default headerPlacement pushed to formBound fields ("left"\|"top"; empty = leave field) |
| `fieldSpacing` | `real` | Vertical spacing between fields |
| `errors` | `var` | Collected error strings after validate() / collectErrors() |
| `contentData` | `alias` | Default children / field slot |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `applyDefaults()` | Push labelWidth / fieldHeaderPlacement onto formBound descendants |
| `applyLabelWidth()` | Compat alias of applyDefaults() |
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
