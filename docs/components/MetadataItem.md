# MetadataItem

One label/value pair for MetadataControl.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MetadataItem.qml`](../../src/extras/QWinUI3/Extras/MetadataItem.qml)

[← Component index](../components.md)

## Usage

```qml
MetadataItem { label: qsTr("Size"); value: "12 KB" }
```

## Properties

- `label: string` — Field label
- `value: string` — Current value
- `secondary: string` — Secondary value line
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `orientation: int` — Qt.Horizontal or Qt.Vertical
- `valueColor: color` — Value Color
- `effectiveIconGlyph: string` — Resolved glyph string

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
