# KeyChordVisual

Renders Ctrl+K style shortcuts as KeyVisuals.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/KeyChordVisual.qml`](../../src/extras/QWinUI3/Extras/KeyChordVisual.qml)

[← Component index](../components.md)

## Usage

```qml
KeyChordVisual { shortcut: "Ctrl+Shift+P" }
```

## Properties

- `shortcut: string` — Raw accelerator string: "Ctrl+Shift+P" or multi-stroke "Ctrl+K, Ctrl+S"
- `keys: var` — Explicit key labels; when set, overrides shortcut parsing.
- `size: string` — Diameter or box size in px
- `emphasized: bool` — Emphasized chrome
- `separator: string` — Separator item / glyph
- `keySpacing: real` — Spacing between keys
- `toolTipText: string` — Tooltip text
- `chordText: string` — Keyboard chord display text

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
