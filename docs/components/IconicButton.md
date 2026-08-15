# IconicButton

Base icon + label button used by AppBar*.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/IconicButton.qml`](../../src/extras/QWinUI3/Extras/IconicButton.qml)

[← Component index](../components.md)

## Usage

```qml
IconicButton { text: qsTr("Action"); symbol: FluentIcons.Add }
```

## Properties

- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `iconSize: real` — Icon size in px
- `toolTipText: string` — Tooltip text
- `badgeVisible: bool` — Show avatar badge
- `badgeValue: int` — Numeric badge value (-1 hides count)
- `badgeText: string` — Badge caption
- `badgeMaxValue: int` — Badge max before +
- `highlighted: bool` — Emphasized / selected chrome
- `flat: bool` — Flat chrome without fill
- `effectiveIconGlyph: string` — Resolved glyph string

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
