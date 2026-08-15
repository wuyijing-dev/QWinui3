# DropDownButton

Button that opens a MenuFlyout of actions.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DropDownButton.qml`](../../src/extras/QWinUI3/Extras/DropDownButton.qml)

[← Component index](../components.md)

## Usage

```qml
DropDownButton {
    text: qsTr("Options")
    MenuFlyoutItem { text: qsTr("A") }
}
```

## Properties

- `menu: alias` — Attached / owned Menu
- `menuData: alias` — Menu children slot
- `highlighted: bool` — Emphasized / selected chrome
- `flyoutPlacement: int` — MenuFlyout placement
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `isOpen: alias` — Open / visible state
- `effectiveIconGlyph: string` — Resolved glyph string
- `lightScheme: bool` — True in light theme
- `menuOpen: bool` — Menu currently open
- `hasSolidStroke: bool` — Draw solid stroke chrome
- `hasGradientStroke: bool` — Draw gradient stroke chrome
- `topStroke: color` — Top edge stroke width
- `bottomStroke: color` — Bottom edge stroke width
- `inset: bool` — Content inset

## Methods

- `open()` — Open
- `close()` — Close
- `showMenu()` — Show Menu

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
