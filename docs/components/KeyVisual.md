# KeyVisual

Single keyboard key chrome.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/KeyVisual.qml`](../../src/extras/QWinUI3/Extras/KeyVisual.qml)

[← Component index](../components.md)

## Usage

```qml
KeyVisual { keyText: "Ctrl" }
```

## Properties

- `keyText: string` — Display label for the key (e.g. "Ctrl", "P", "Esc").
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `size: string` — "small" | "medium" | "large"
- `emphasized: bool` — Emphasized chrome
- `toolTipText: string` — Tooltip text
- `minWidth: real` — Min Width
- `effectiveIconGlyph: string` — Resolved glyph string

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
