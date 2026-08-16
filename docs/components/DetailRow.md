# DetailRow

Compact label / value row for forms and settings summaries.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DetailRow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DetailRow.qml)

**Category:** Collections & data · **Library:** v1.13

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
DetailRow {
    label: qsTr("Account")
    value: qsTr("alex@example.com")
    symbol: FluentIcons.Contact
}
```

## Notes

Left label (+ optional symbol), right value or custom trailing slot.
Use inside SettingsGroup, ContentCard, or FormLayout footnotes.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `label` | `string` | Leading label |
| `value` | `string` | Trailing value text (ignored when trailing has children) |
| `symbol` | `var` | Optional Fluent symbol |
| `iconGlyph` | `string` | — |
| `trailing` | `alias` | Custom trailing content |
| `labelWidth` | `real` | Preferred label column width (FormLayout may push labelWidth) |
| `formBound` | `bool` | When true, FormLayout may push labelWidth |
| `effectiveSymbol` | `string` | — |

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
