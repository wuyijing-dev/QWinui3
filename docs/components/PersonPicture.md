# PersonPicture

Avatar from image or initials.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PersonPicture.qml`](../../src/extras/QWinUI3/Extras/PersonPicture.qml)

[← Component index](../components.md)

## Usage

```qml
PersonPicture { displayName: "Ada"; size: 48 }
```

## Properties

- `displayName: string` — Person / avatar display name
- `imageSource: url` — Image URL
- `size: real` — Diameter or box size in px
- `profileColor: color` — Fallback avatar fill
- `badgeVisible: bool` — Show avatar badge
- `badgeColor: color` — Badge fill color
- `badgeSymbol: var` — Badge Symbol
- `badgeGlyph: string` — Badge Glyph
- `badgeSeverity: int` — Badge severity
- `badgeValue: int` — WinUI-style count / text overlay (takes precedence over glyph when set)
- `badgeText: string` — Badge caption
- `badgeMaxValue: int` — Badge max before +
- `selected: bool` — Selected state
- `initials: string` — Initials

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
