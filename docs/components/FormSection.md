# FormSection

Collapsible field group for FormLayout (2.67 D2).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FormSection.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/FormSection.qml)

**Category:** Input & forms · **Library:** v2.67

[← Component index](../components.md)

**Extends** `Pane`.

## Example

```qml
FormLayout {
    FormSection {
        title: qsTr("Billing")
        expanded: true
        HeaderedTextBox { header: qsTr("Card") }
    }
}
```

## Notes

Expands/collapses child fields; honors Theme.reducedMotion.
Set formBound: false on the section itself if you do not want labelWidth push
onto the header chrome (children still receive FormLayout defaults).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Section header title |
| `expanded` | `bool` | Expanded when true |
| `collapsible` | `bool` | Show expand/collapse chevron |
| `formFieldId` | `string` | Optional formFieldId for FormLayout.setFieldVisible |
| `content` | `alias` | Children / field slot |
| `formBound` | `bool` | Opt out of FormLayout labelWidth on the Pane chrome |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Pane`

Also available (base type / Qt Quick Controls):

- `padding`
- `background`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
