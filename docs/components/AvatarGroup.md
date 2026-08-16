# AvatarGroup

Overlapping PersonPicture stack with overflow count.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AvatarGroup.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/AvatarGroup.qml)

**Category:** Collections & data · **Library:** v1.13

[← Component index](../components.md)

**Gallery:** `AvatarGroup` — [`src/gallery/pages/AvatarGroupPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/AvatarGroupPage.qml)

**Extends** `Control`.

## Example

```qml
AvatarGroup {
    id: avatars
    model: [
        { displayName: "Ada" },
        { displayName: "Bob" },
        { displayName: "Cara" }
    ]
    maxVisible: 2
    onPersonClicked: (index) => { /* … */ }
    onOverflowClicked: { /* … */ }
}
// --- API ---
// avatars.overflowCount
```

## Notes

Overlapping PersonPicture stack; maxVisible + overflowCount chip.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | Data model / item list for this control |
| `size` | `real` | Diameter or box size in px |
| `overlap` | `real` | Avatar stack overlap in px |
| `maxVisible` | `int` | Max visible items before overflow |
| `showOverflowCount` | `bool` | Show +N overflow chip |
| `layoutDirection` | `int` | Qt layout direction |
| `overflowCount` | `int` | Hidden avatar count |

### Signals

| Signature | Description |
| --- | --- |
| `personClicked(int index, var item)` | Avatar clicked |
| `overflowClicked()` | Overflow chip clicked |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
