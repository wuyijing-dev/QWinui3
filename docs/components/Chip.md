# Chip

Compact selectable tag; optional close affordance.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Chip.qml`](../../src/extras/QWinUI3/Extras/Chip.qml)

[← Component index](../components.md)

## Usage

```qml
Chip {
    text: qsTr("Tag")
    closable: true
    onCloseClicked: remove()
}
```

## Properties

- `closable: bool` — Shows a trailing close affordance
- `isCloseButtonVisible: alias` — Alias of closable
- `highlighted: bool` — Emphasized / selected chrome
- `flat: bool` — Flat chrome without fill
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `avatarText: string` — Initials / short avatar text instead of an icon
- `appearance: string` — filled | outline
- `chipSize: string` — small | medium
- `effectiveIconGlyph: string` — Resolved glyph string

## Signals

- `closeClicked()` — Fired when the close glyph is clicked (does not uncheck)

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
