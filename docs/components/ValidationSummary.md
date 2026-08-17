# ValidationSummary

Lists form-level validation errors (pairs with FormLayout).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ValidationSummary.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ValidationSummary.qml)

**Category:** Input & forms · **Library:** v1.77

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
FormLayout {
    id: form
    ValidationSummary {
        errors: form.errors
        visible: form.errors.length > 0
    }
    HeaderedTextBox { … }
}
```

## Notes

Error banner + bullet list. Bind errors to FormLayout.errors after validate().
Optional title; uses Theme.systemCritical for severity styling.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `errors` | `var` | Error strings to display |
| `title` | `string` | Banner title |
| `forceVisible` | `bool` | Show even when errors is empty (for layout testing) |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
