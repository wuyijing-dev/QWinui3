# AccentButton

Always-accent primary CTA with optional Fluent symbol.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AccentButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/AccentButton.qml)

**Category:** Buttons & commands · **Library:** v2.58

[← Component index](../components.md)

**Gallery:** `AccentButton` — [`src/gallery/pages/AccentButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/AccentButtonPage.qml)

**Extends** `Button`.

## Example

```qml
AccentButton {
    id: saveBtn
    text: qsTr("Save")
    symbol: FluentIcons.Save
    enabled: true
    onClicked: save()
}

// --- API ---
// properties: symbol, iconGlyph, iconSize, effectiveIconGlyph
// inherits Button: text, enabled, highlighted, clicked(), pressAndHold()
// saveBtn.clicked → onClicked; no custom methods
```

## Notes

Always-accent primary Button; prefer symbol: FluentIcons.* over iconGlyph.
Inherits Button: text, enabled, clicked().

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `iconSize` | `real` | Icon size in px |
| `effectiveIconGlyph` | `string` | Resolved glyph string |
| `lightScheme` | `bool` | True in light theme |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Button`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `flat` / `highlighted`
- `clicked()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
