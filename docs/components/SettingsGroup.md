# SettingsGroup

Section header + card stack for settings pages.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SettingsGroup.qml`](../../src/extras/QWinUI3/Extras/SettingsGroup.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
SettingsGroup {
    title: qsTr("Appearance")
    description: qsTr("Theme and motion preferences.")
    SettingsCard { title: qsTr("Dark mode"); action: Switch {} }
    SettingsCard { title: qsTr("Density"); action: ComboBox {} }
}
```

## Notes

Groups SettingsCard / SettingsExpander rows under a Fluent section title.
Children go in the default content slot (ColumnLayout). Use with FormLayout
or a ScrollView ColumnLayout on settings pages.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Section title |
| `header` | `alias` | Toolkit Header alias |
| `description` | `string` | Supporting description under the title |
| `symbol` | `var` | Optional Fluent symbol before the title |
| `iconGlyph` | `string` | Raw glyph fallback |
| `contentSpacing` | `real` | Spacing between child cards |
| `contentData` | `alias` | Default children / card stack |
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
