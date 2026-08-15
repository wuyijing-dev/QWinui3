# TeachingTip

Anchored tip with title, subtitle, and actions.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TeachingTip.qml`](../../src/extras/QWinUI3/Extras/TeachingTip.qml)

[← Component index](../components.md)

## Usage

```qml
TeachingTip { target: btn; title: qsTr("Tip"); subtitle: qsTr("Hint") }
```

## Properties

- `target: Item` — Anchor item for placement
- `title: string` — Primary title text
- `subtitle: string` — Secondary subtitle text
- `actionText: string` — Optional action button label
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `isOpen: bool` — Open / visible state
- `isLightDismissEnabled: bool` — Close on outside click / Esc
- `isCloseButtonVisible: bool` — Alias of closable
- `preferredPlacement: int` — Preferred flyout placement
- `effectivePlacement: int` — Resolved flyout placement
- `heroContent: alias` — Hero content slot
- `effectiveIconGlyph: string` — Resolved glyph string

## Signals

- `actionClicked()` — Emitted when action is clicked
- `closedByUser()` — True when the user dismissed the dialog

## Methods

- `reanchor()` — Recompute popup anchor

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
