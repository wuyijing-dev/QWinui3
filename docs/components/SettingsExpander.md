# SettingsExpander

Expandable settings group.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SettingsExpander.qml`](../../src/extras/QWinUI3/Extras/SettingsExpander.qml)

[← Component index](../components.md)

## Usage

```qml
SettingsExpander {
    title: qsTr("Advanced")
    SettingsCard { title: qsTr("Option") }
}
```

## Properties

- `title: string` — Primary title text
- `description: string` — Supporting description text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `headerIcon: var` — Header icon glyph
- `expanded: bool` — Expanded state
- `isExpanded: alias` — Alias of expanded
- `expandDirection: string` — WinUI ExpandDirection: down | up
- `action: alias` — Custom action slot
- `contentData: alias` — Default children / content slot
- `effectiveHeaderIcon: string` — Resolved header icon

## Signals

- `expanding()` — True while expanding
- `collapsing()` — True while collapsing

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
