# GridTile

Icon + title tile for launchers / galleries.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/GridTile.qml`](../../src/extras/QWinUI3/Extras/GridTile.qml)

[← Component index](../components.md)

## Usage

```qml
GridTile { title: qsTr("Photos"); symbol: FluentIcons.Photo }
```

## Properties

- `title: string` — Primary title text
- `subtitle: string` — Secondary subtitle text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `glyph: string` — Fluent glyph drawn in the button
- `source: url` — Image / media source
- `tileWidth: real` — Tile width
- `tileHeight: real` — Tile height
- `isSelected: alias` — Selected state
- `badgeText: string` — Badge caption
- `badgeVisible: bool` — Show avatar badge
- `effectiveGlyph: string` — Resolved glyph string

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
