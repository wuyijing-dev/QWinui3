# ActionCard

Clickable card with symbol, title, description, and chevron.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ActionCard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ActionCard.qml)

**Category:** Layout · **Library:** v1.13

[← Component index](../components.md)

**Gallery:** `ActionCard` — [`src/gallery/pages/ActionCardPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ActionCardPage.qml)

**Extends** `AbstractButton`.

## Example

```qml
ActionCard {
    title: qsTr("Accounts")
    description: qsTr("Manage profiles")
    onClicked: open()
}

// --- API ---
// inherits AbstractButton (+ Qt Quick Controls base API)
```

## Notes

Clickable settings-style card with chevron; onClicked for navigation.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Primary title text |
| `description` | `string` | Supporting description text |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `glyph` | `string` | Fluent glyph drawn in the button |
| `glyphColor` | `color` | Glyph color |
| `glyphBackground` | `color` | Glyph plate background |
| `showChevron` | `bool` | Show trailing chevron |
| `badgeVisible` | `bool` | Show avatar badge |
| `badgeValue` | `int` | Numeric badge value (-1 hides count) |
| `badgeText` | `string` | Badge caption |
| `badgeSeverity` | `int` | Badge severity |
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
