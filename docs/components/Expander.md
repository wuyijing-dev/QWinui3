# Expander

Collapsible header with expandable content.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Expander.qml`](../../src/extras/QWinUI3/Extras/Expander.qml)

[← Component index](../components.md)

## Usage

```qml
Expander {
    header: qsTr("Details")
    Label { text: qsTr("Body") }
}
```

## Properties

- `title: string` — Primary title text
- `subtitle: string` — Secondary subtitle text
- `expanded: bool` — Expanded state
- `isExpanded: alias` — Alias of expanded
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `headerIcon: var` — Header icon glyph
- `expandDirection: string` — WinUI ExpandDirection: down | up
- `contentData: alias` — Default children / content slot
- `effectiveHeaderIcon: string` — Resolved header icon

## Signals

- `expanding()` — True while expanding
- `collapsing()` — True while collapsing

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
