# RatingControl

Star rating; stepSize supports halves (WinUI InitialSetValue / ItemInfo).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RatingControl.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/RatingControl.qml)

**Category:** Input & forms · **Library:** v1.04

[← Component index](../components.md)

**Gallery:** `RatingControl` — [`src/gallery/pages/RatingControlPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/RatingControlPage.qml)

**Extends** `Control`.

## Example

```qml
RatingControl {
    id: ratingControl
    value: 0
    initialSetValue: 3
    stepSize: 0.5
    emptyGlyph: FluentIcons.OutlineStar
    filledGlyph: FluentIcons.FavoriteStarFill
}

// --- API ---
// signals: onValueEdited
// methods: clampValue(v), valueFromPos(x), commitValue(next)
```

## Notes

Star rating; value / maxRating; isReadOnly disables input.
initialSetValue applies on first pick when value is unset; empty/filled/placeholder glyphs customize ItemInfo.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `value` | `real` | Current value |
| `placeholderValue` | `real` | Shown when value unset |
| `initialSetValue` | `real` | WinUI InitialSetValue — used for the first commit when value is unset (≤0) |
| `maxRating` | `int` | Maximum star count |
| `readOnly` | `bool` | Read-only when true |
| `isReadOnly` | `alias` | Alias of readOnly |
| `isClearEnabled` | `bool` | Allow clearing the rating |
| `stepSize` | `real` | 1 = whole, 0.5 = half, 0.1 / 0.25 = fine-grained mouse pick |
| `previewEnabled` | `bool` | Preview value on hover |
| `previewValue` | `real` | Hovered preview value |
| `caption` | `string` | Caption under / beside the value |
| `emptyGlyph` | `string` | WinUI ItemInfo — empty / outline glyph |
| `filledGlyph` | `string` | WinUI ItemInfo — filled glyph |
| `placeholderGlyph` | `string` | Glyph used for placeholder (unset) fill |
| `disabledGlyph` | `string` | WinUI RatingItemInfo.DisabledGlyph — used when !enabled |

### Signals

| Signature | Description |
| --- | --- |
| `valueEdited(real value)` | Emitted when user commits a value |

### Methods

| Signature | Description |
| --- | --- |
| `nudge(dir)` | — |
| `clampValue(v)` | Clamp value into min..max |
| `valueFromPos(x)` | Map a pointer position to a value |
| `commitValue(next)` | Commit the edited value |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
