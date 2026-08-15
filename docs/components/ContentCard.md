# ContentCard

Surface card with title, subtitle, symbol, and body slot.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ContentCard.qml`](../../src/extras/QWinUI3/Extras/ContentCard.qml)

[← Component index](../components.md)

## Usage

```qml
ContentCard {
    title: qsTr("Card")
    Label { text: qsTr("Body") }
}
```

## Properties

- `title: string` — Primary title text
- `subtitle: string` — Secondary subtitle text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `headerIcon: string` — Header icon glyph
- `footer: alias` — Footer text
- `isClickable: bool` — Emit clicked when activated
- `contentData: alias` — Default children / content slot
- `effectiveHeaderIcon: string` — Resolved header icon

## Signals

- `clicked()` — Emitted when clicked

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
