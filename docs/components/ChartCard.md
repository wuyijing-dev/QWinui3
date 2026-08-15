# ChartCard

Title/subtitle chrome around a chart child.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ChartCard.qml`](../../src/extras/QWinUI3/Extras/ChartCard.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
ChartCard {
    title: qsTr("Revenue")
    LineChart { values: series }
}
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Primary title text |
| `subtitle` | `string` | Secondary subtitle text |
| `footer` | `string` | Footer text |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `animated` | `bool` | Play enter / reveal animation |
| `elevated` | `bool` | Stronger elevation / card tint |
| `bordered` | `bool` | Draw a border when true |
| `headerActions` | `alias` | Trailing header actions slot |
| `content` | `alias` | Content slot / children host |
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
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
