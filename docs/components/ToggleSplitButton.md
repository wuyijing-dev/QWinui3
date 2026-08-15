# ToggleSplitButton

Toggle primary + menu SplitButton.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ToggleSplitButton.qml`](../../src/extras/QWinUI3/Extras/ToggleSplitButton.qml)

[← Component index](../components.md)

## Usage

```qml
ToggleSplitButton { text: qsTr("Format") }
```

## Properties

- `menu: alias` — Attached / owned Menu
- `menuData: alias` — Menu children slot
- `highlighted: bool` — Emphasized / selected chrome
- `flat: bool` — Flat chrome without fill
- `flyoutPlacement: int` — MenuFlyout placement
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `isOpen: alias` — Open / visible state
- `effectiveIconGlyph: string` — Resolved glyph string
- `lightScheme: bool` — True in light theme
- `accented: bool` — Use accent chrome
- `anyHovered: bool` — True if any child is hovered
- `anyDown: bool` — True if any child is pressed

## Signals

- `primaryClicked()` — Primary button clicked

## Methods

- `showMenu()` — Open the associated menu
- `closeMenu()` — Dismiss the menu

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
