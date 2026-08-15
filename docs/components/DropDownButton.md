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

## Methods

- `open()` — Open / show
- `close()` — Close / dismiss
- `showMenu()` — Open the associated menu

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
