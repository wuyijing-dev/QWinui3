# PersonPicture

Avatar from image or initials.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PersonPicture.qml`](../../src/extras/QWinUI3/Extras/PersonPicture.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
PersonPicture {
    id: avatar
    displayName: "Ada Lovelace"
    // source: "file:///…"
}
// --- API ---
// avatar.initials / displayName / source
```

## Notes

Avatar from source image or displayName initials.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `displayName` | `string` | Person / avatar display name |
| `imageSource` | `url` | Image URL |
| `size` | `real` | Diameter or box size in px |
| `profileColor` | `color` | Fallback avatar fill |
| `badgeVisible` | `bool` | Show avatar badge |
| `badgeColor` | `color` | Badge fill color |
| `badgeSymbol` | `var` | Badge FluentIcons symbol |
| `badgeGlyph` | `string` | Badge Fluent glyph string |
| `badgeSeverity` | `int` | Badge severity |
| `badgeValue` | `int` | WinUI-style count / text overlay (takes precedence over glyph when set) |
| `badgeText` | `string` | Badge caption |
| `badgeMaxValue` | `int` | Badge max before + |
| `selected` | `bool` | Selected state |
| `initials` | `string` | Initials shown when no image |

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
