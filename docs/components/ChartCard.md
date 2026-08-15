# ChartCard

Title/subtitle chrome around a chart child.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ChartCard.qml`](../../src/extras/QWinUI3/Extras/ChartCard.qml)

[← Component index](../components.md)

## Usage

```qml
ChartCard {
    title: qsTr("Revenue")
    LineChart { values: series }
}
```

## Properties

- `title: string` — Primary title text
- `subtitle: string` — Secondary subtitle text
- `footer: string` — Footer text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `animated: bool` — Play enter / reveal animation
- `elevated: bool` — Stronger elevation / card tint
- `bordered: bool` — Draw a border when true
- `headerActions: alias` — Trailing header actions slot
- `content: alias` — Content slot / children host
- `effectiveIconGlyph: string` — Resolved glyph string

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
