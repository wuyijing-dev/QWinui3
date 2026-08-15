# HyperlinkButton

Link-styled button.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/HyperlinkButton.qml`](../../src/extras/QWinUI3/Extras/HyperlinkButton.qml)

[← Component index](../components.md)

**Extends** `AbstractButton`.

## Example

```qml
HyperlinkButton { text: qsTr("Learn more"); onClicked: Qt.openUrlExternally(url) }

// --- API ---
// signals: onNavigateRequested
// inherits AbstractButton (+ Qt Quick Controls base API)
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `url` | `url` | URL / source URL |
| `navigateUri` | `alias` | Navigate to a URI |
| `underlineStyle` | `string` | always \| onHover \| never |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `visited` | `bool` | True when the step was visited |
| `showExternalGlyph` | `bool` | Show external-link glyph |
| `navigateMode` | `string` | "external" opens the URL; "signal" only emits clicked / navigateRequested |
| `effectiveIconGlyph` | `string` | Resolved glyph string |

### Signals

| Signature | Description |
| --- | --- |
| `navigateRequested(url target)` | Emitted to request navigation |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `AbstractButton`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `down` / `pressed` / `hovered`
- `clicked()`
- `pressAndHold()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
