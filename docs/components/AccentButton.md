# AccentButton

Always-accent primary CTA with optional Fluent symbol.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AccentButton.qml`](../../src/extras/QWinUI3/Extras/AccentButton.qml)

[← Component index](../components.md)

## Usage

```qml
AccentButton {
    text: qsTr("Save")
    symbol: FluentIcons.Save
    onClicked: save()
}
```

## Properties

- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `iconSize: real` — Icon size in px
- `effectiveIconGlyph: string` — Resolved glyph string
- `lightScheme: bool` — True in light theme

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
