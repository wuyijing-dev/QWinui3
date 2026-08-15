# ActionCard

Clickable card with symbol, title, description, and chevron.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ActionCard.qml`](../../src/extras/QWinUI3/Extras/ActionCard.qml)

[← Component index](../components.md)

## Usage

```qml
ActionCard {
    title: qsTr("Accounts")
    description: qsTr("Manage profiles")
    onClicked: open()
}
```

## Properties

- `title: string` — Primary title text
- `description: string` — Supporting description text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `glyph: string` — Fluent glyph drawn in the button
- `glyphColor: color` — Glyph color
- `glyphBackground: color` — Glyph plate background
- `showChevron: bool` — Show trailing chevron
- `badgeVisible: bool` — Show avatar badge
- `badgeValue: int` — Numeric badge value (-1 hides count)
- `badgeText: string` — Badge caption
- `badgeSeverity: int` — Badge severity
- `effectiveGlyph: string` — Resolved glyph string

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
