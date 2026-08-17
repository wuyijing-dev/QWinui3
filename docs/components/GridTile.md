# GridTile

Icon + title tile for launchers / galleries.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/GridTile.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/GridTile.qml)

**Category:** Collections & data · **Library:** v2.63

[← Component index](../components.md)

**Gallery:** `GridTile` — [`src/gallery/pages/GridTilePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/GridTilePage.qml)

**Extends** `AbstractButton`.

## Example

```qml
GridTile {
    id: tile
    title: qsTr("Photos")
    subtitle: qsTr("12 items")
    symbol: FluentIcons.Photo
    onClicked: open()
}
// --- API ---
// inherits AbstractButton: text/enabled/clicked
```

## Notes

Icon + title tile for grids; onClicked.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Primary title text |
| `subtitle` | `string` | Secondary subtitle text |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `glyph` | `string` | Fluent glyph drawn in the button |
| `source` | `url` | Image / media source |
| `tileWidth` | `real` | Tile width |
| `tileHeight` | `real` | Tile height |
| `isSelected` | `alias` | Selected state |
| `badgeText` | `string` | Badge caption |
| `badgeVisible` | `bool` | Show avatar badge |
| `effectiveGlyph` | `string` | Resolved glyph string |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `AbstractButton`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `down` / `pressed` / `hovered`
- `clicked()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
