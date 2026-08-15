# ListTile

List row: leading, title, subtitle, trailing.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ListTile.qml`](../../src/extras/QWinUI3/Extras/ListTile.qml)

[← Component index](../components.md)

## Usage

```qml
ListTile {
    title: qsTr("Item")
    subtitle: qsTr("Detail")
    symbol: FluentIcons.Document
}
```

## Properties

- `title: string` — Primary title text
- `subtitle: string` — Secondary subtitle text
- `description: alias` — Supporting description text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `glyph: string` — Fluent glyph drawn in the button
- `leading: alias` — Leading content slot
- `trailing: alias` — Trailing slot
- `showChevron: bool` — Show trailing chevron
- `isSelected: bool` — Selected state
- `effectiveGlyph: string` — Resolved glyph string

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
