# ListTile

List row: leading, title, subtitle, trailing.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ListTile.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ListTile.qml)

**Category:** Collections & data · **Library:** v2.58

[← Component index](../components.md)

**Gallery:** `ListTile` — [`src/gallery/pages/ListTilePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ListTilePage.qml)

**Extends** `ItemDelegate`.

## Example

```qml
ListTile {
    title: qsTr("Item")
    subtitle: qsTr("Detail")
    symbol: FluentIcons.Document
}
```

## Notes

List row tile with leading symbol and trailing slot.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Primary title text |
| `subtitle` | `string` | Secondary subtitle text |
| `description` | `alias` | Supporting description text |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `glyph` | `string` | Fluent glyph drawn in the button |
| `leading` | `alias` | Leading content slot |
| `trailing` | `alias` | Trailing slot |
| `showChevron` | `bool` | Show trailing chevron |
| `isSelected` | `bool` | Selected state |
| `effectiveGlyph` | `string` | Resolved glyph string |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
