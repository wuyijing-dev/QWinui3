# EmptyState

Placeholder illustration + title + optional action.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/EmptyState.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/EmptyState.qml)

**Category:** Status & feedback · **Library:** v1.10

[← Component index](../components.md)

**Gallery:** `EmptyState` — [`src/gallery/pages/EmptyStatePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/EmptyStatePage.qml)

**Extends** `Control`.

## Example

```qml
EmptyState {
    title: qsTr("Nothing here")
    description: qsTr("Try another filter.")
}

// --- API ---
// signals: onActionClicked, onSecondaryActionClicked
```

## Notes

Placeholder for empty lists; title/message (description alias) + optional action.
Neutral Document default (not Warning); bordered false by default for a lighter Fluent look.
illustration slot replaces the circular glyph when set.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `glyph` | `string` | Fluent glyph drawn in the button |
| `title` | `string` | Primary title text |
| `message` | `string` | Body / message text |
| `description` | `alias` | WinUI / docs alias of message |
| `actionText` | `string` | Optional action button label |
| `secondaryActionText` | `string` | Secondary action button label |
| `compact` | `bool` | Compact layout density |
| `bordered` | `bool` | Draw a border when true (default false — lighter empty surface) |
| `glyphColor` | `color` | Glyph color |
| `showGlyph` | `bool` | Show leading glyph (ignored when illustration has children) |
| `illustration` | `alias` | Custom illustration slot (replaces circular glyph) |
| `effectiveGlyph` | `string` | Resolved glyph string — neutral Document, not Warning |

### Signals

| Signature | Description |
| --- | --- |
| `actionClicked()` | Emitted when action is clicked |
| `secondaryActionClicked()` | Secondary action clicked |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
