# HeaderedContentControl

Labeled content host.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/HeaderedContentControl.qml`](../../src/extras/QWinUI3/Extras/HeaderedContentControl.qml)

[← Component index](../components.md)

## Usage

```qml
HeaderedContentControl { header: qsTr("Section"); Label { text: "…" } }
```

## Properties

- `header: string` — Header label above the control
- `description: string` — Supporting description text
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `headerComponent: Component` — Optional header component
- `headerPlacement: string` — top | left
- `contentData: alias` — Default children / content slot
- `effectiveIconGlyph: string` — Resolved glyph string

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
