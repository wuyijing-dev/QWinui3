# ListTile

List row: leading, title, subtitle, trailing.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ListTile.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ListTile.qml)

**Category:** Collections & data · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `ListTile` — [`src/gallery/pages/ListTilePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ListTilePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

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
| `density` | `string` | Row density: compact \| normal \| spacious \| "" (follow Theme.density) — 2.67 A3 |
| `tileDensity` | `alias` | Compat alias |
| `leadingPreset` | `string` | Leading preset: "icon" (default) \| "avatar" \| "checkbox" \| "none" — 2.67 A3 |
| `avatarName` | `string` | Avatar initials / PersonPicture displayName when leadingPreset is avatar |
| `avatarSource` | `url` | Avatar image source (optional) — aliases PersonPicture.imageSource |
| `profilePicture` | `alias` | — |
| `effectiveGlyph` | `string` | Resolved glyph string |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
