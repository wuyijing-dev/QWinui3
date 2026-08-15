# HyperlinkButton

Link-styled button.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/HyperlinkButton.qml`](../../src/extras/QWinUI3/Extras/HyperlinkButton.qml)

[← Component index](../components.md)

## Usage

```qml
HyperlinkButton { text: qsTr("Learn more"); onClicked: Qt.openUrlExternally(url) }
```

## Properties

- `url: url` — URL / source URL
- `navigateUri: alias` — Navigate to a URI
- `underlineStyle: string` — always | onHover | never
- `symbol: var` — FluentIcons symbol (preferred over iconGlyph)
- `iconGlyph: string` — Raw Fluent glyph string fallback
- `visited: bool` — True when the step was visited
- `showExternalGlyph: bool` — Show external-link glyph
- `navigateMode: string` — "external" opens the URL; "signal" only emits clicked / navigateRequested
- `effectiveIconGlyph: string` — Resolved glyph string

## Signals

- `navigateRequested(url target)` — Emitted to request navigation

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
