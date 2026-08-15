# EmptyState

Placeholder illustration + title + optional action.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/EmptyState.qml`](../../src/extras/QWinUI3/Extras/EmptyState.qml)

[← Component index](../components.md)

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

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `glyph` | `string` | Fluent glyph drawn in the button |
| `title` | `string` | Primary title text |
| `message` | `string` | Body / message text |
| `actionText` | `string` | Optional action button label |
| `secondaryActionText` | `string` | Secondary action button label |
| `compact` | `bool` | Compact layout density |
| `bordered` | `bool` | Draw a border when true |
| `glyphColor` | `color` | Glyph color |
| `showGlyph` | `bool` | Show leading glyph |
| `effectiveGlyph` | `string` | Resolved glyph string |

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
