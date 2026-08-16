# PersonPicture

Avatar from image or initials (WinUI IsGroup / BadgeImageSource).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PersonPicture.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/PersonPicture.qml)

**Category:** Collections & data · **Library:** v1.0.0

[← Component index](../components.md)

**Gallery:** `PersonPicture` — [`src/gallery/pages/PersonPicturePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/PersonPicturePage.qml)

**Extends** `Control`.

## Example

```qml
PersonPicture {
    id: avatar
    displayName: "Ada Lovelace"
    // profilePicture: "file:///…"
    isGroup: false
}
```

## Notes

Avatar from profilePicture/imageSource or displayName initials.
initials is settable (WinUI); empty uses computedInitials from displayName.
isGroup uses People glyph when empty; badgeImageSource paints an image badge.
isOutOfOffice (WinUI) shows a purple Clock presence badge when no other badge is set.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `displayName` | `string` | Person / avatar display name |
| `imageSource` | `url` | Image URL (WinUI ProfilePicture) |
| `profilePicture` | `alias` | WinUI ProfilePicture alias |
| `size` | `real` | Diameter or box size in px |
| `profileColor` | `color` | Fallback avatar fill |
| `isGroup` | `bool` | WinUI IsGroup — group avatar empty glyph |
| `isOutOfOffice` | `bool` | WinUI IsOutOfOffice — presence badge (Clock / purple) when no custom badge |
| `badgeVisible` | `bool` | Show avatar badge |
| `badgeColor` | `color` | Badge fill color |
| `badgeSymbol` | `var` | Badge FluentIcons symbol |
| `badgeGlyph` | `string` | Badge Fluent glyph string |
| `badgeImageSource` | `url` | WinUI BadgeImageSource — image in the badge (overrides glyph/text when set) |
| `badgeSeverity` | `int` | Badge severity |
| `badgeValue` | `int` | WinUI-style count / text overlay (takes precedence over glyph when set) |
| `badgeText` | `string` | Badge caption |
| `badgeMaxValue` | `int` | Badge max before + |
| `selected` | `bool` | Selected state |
| `initials` | `string` | WinUI Initials — settable; empty falls back to displayName-derived letters |
| `computedInitials` | `string` | Initials derived from displayName when initials is empty |
| `effectiveInitials` | `string` | Effective glyph letters for the avatar |

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
