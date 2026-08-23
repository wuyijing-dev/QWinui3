# FormLayout

Vertical form stack that collects field errorMessage values.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FormLayout.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/FormLayout.qml)

**Category:** Input & forms · **Library:** v2.67

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
// methods: validate(), validateDeferred(), beginValidate(), endValidate(),
//           clearErrors(), collectErrors(), focusFirstError(), applyDefaults(), applyLabelWidth()
```

## Notes

ColumnLayout host for HeaderedTextBox / HeaderedComboBox / NumberBox / PasswordBox /
RadioButtons / TokenizingTextBox / DetailRow.
Pushes labelWidth (+ optional fieldHeaderPlacement) onto children — fields do not
walk parents. Set formBound: false on a field to opt out.
Apps set field.errorMessage, then validate() / collectErrors() read descendants
(children + contentChildren). clearErrors() clears the same tree.
Pair with ValidationSummary. See docs/forms.md.
Accessibility (1.19): Accessible.Form + accessibleName; description lists error count.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `labelWidth` | `real` | Preferred label column width for left-header fields |
| `fieldHeaderPlacement` | `string` | Default headerPlacement pushed to formBound fields ("left"\|"top"; empty = leave field) |
| `fieldAppearance` | `string` | Push appearance to TextField / TextArea / ComboBox descendants (filled \| outline) — 2.66 A2 |
| `readOnly` | `bool` | When true, push readOnly onto descendant editors that expose it — 2.66 A2 |
| `fieldSpacing` | `real` | Vertical spacing between fields |
| `errors` | `var` | Collected error strings after validate() / collectErrors() |
| `validating` | `bool` | True while async validation runs (2.55 — pair with beginValidate/endValidate) |
| `accessibleName` | `string` | Screen-reader name for the form region (1.19) |
| `contentData` | `alias` | Default children / field slot |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `setFieldVisible(fieldId, visible)` | Show/hide a descendant by formFieldId (2.67 D2) |
| `applyDefaults()` | Push labelWidth / fieldHeaderPlacement onto formBound descendants |
| `applyLabelWidth()` | Compat alias of applyDefaults() |
| `collectErrors()` | Return string[] of current field errors (does not mutate fields) |
| `validate()` | Refresh errors; returns true when there are none |
| `clearErrors()` | Clear errorMessage on descendant fields that expose it (+ NumberBox inputInvalid, 2.55) |
| `beginValidate()` | Mark validating before async rules; pair with endValidate() |
| `endValidate()` | Collect errors after async rules; clears validating and returns validate() result |
| `validateDeferred(callback)` | Defer validate() to next event-loop tick (rules set in same handler) |
| `focusFirstError()` | Focus first descendant field with an error (WinUI focus-first-error, 2.55) |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
