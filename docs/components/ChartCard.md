# ChartCard

Title/subtitle chrome around a chart child.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ChartCard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ChartCard.qml)

**Category:** Charts & gauges · **Library:** v1.09

[← Component index](../components.md)

**Gallery:** `ChartCard` — [`src/gallery/pages/ChartCardPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ChartCardPage.qml)

**Extends** `Control`.

## Example

```qml
ChartCard {
    title: qsTr("Revenue")
    LineChart { values: series }
}
```

## Notes

Title/subtitle chrome around a chart child; put the chart as content.
Layout.fillWidth defaults to true. Omit a chart child (or bind empty series)
for an empty card — charts own their empty states / units / click callbacks.

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
