# EmptyState

Placeholder illustration + title + optional action.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/EmptyState.qml`](../../src/extras/QWinUI3/Extras/EmptyState.qml)

[← Component index](../components.md)

## Usage

```qml
EmptyState {
    title: qsTr("Nothing here")
    description: qsTr("Try another filter.")
}
```

## Properties

- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `glyph: string` — Fluent glyph drawn in the button
- `title: string` — Primary title text
- `message: string` — Body / message text
- `actionText: string` — Optional action button label
- `secondaryActionText: string` — Secondary action button label
- `compact: bool` — Compact layout density
- `bordered: bool` — Draw a border when true
- `glyphColor: color` — Glyph color
- `showGlyph: bool` — Show leading glyph
- `effectiveGlyph: string` — Resolved glyph string

## Signals

- `actionClicked()` — Emitted when action is clicked
- `secondaryActionClicked()` — Secondary action clicked

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
