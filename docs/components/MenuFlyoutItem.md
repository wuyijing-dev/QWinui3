# MenuFlyoutItem

Menu row with glyph and accelerator text.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MenuFlyoutItem.qml`](../../src/extras/QWinUI3/Extras/MenuFlyoutItem.qml)

[← Component index](../components.md)

## Usage

```qml
MenuFlyoutItem { text: qsTr("Paste"); keyboardAcceleratorText: "Ctrl+V" }
```

## Properties

- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `keyboardAcceleratorText: string` — Accelerator caption (Ctrl+C)
- `keyVisualAccelerator: bool` — When true, render accelerator as KeyChordVisual chrome instead of plain text.
- `iconColor: color` — Icon color
- `effectiveIconGlyph: string` — Resolved glyph string

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
