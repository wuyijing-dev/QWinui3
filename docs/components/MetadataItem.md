# MetadataItem

One label/value pair for MetadataControl.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MetadataItem.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MetadataItem.qml)

**Category:** Other · **Library:** v2.66

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
MetadataControl {
    MetadataItem { label: qsTr("Author"); value: "Ada" }
    MetadataItem { label: qsTr("Size"); value: "12 KB" }
}
```

## Notes

Single label/value row inside MetadataControl.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `label` | `string` | Field label |
| `value` | `string` | Current value |
| `secondary` | `string` | Secondary value line |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `orientation` | `int` | Qt.Horizontal or Qt.Vertical |
| `valueColor` | `color` | Value / series color |
| `effectiveIconGlyph` | `string` | Resolved glyph string |

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
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
