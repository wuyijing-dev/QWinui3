# KeyVisual

Single keyboard key chrome.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/KeyVisual.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/KeyVisual.qml)

**Category:** Other · **Library:** v1.20

[← Component index](../components.md)

**Gallery:** `KeyVisual` — [`src/gallery/pages/KeyVisualPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/KeyVisualPage.qml)

**Extends** `AbstractButton`.

## Example

```qml
KeyVisual {
    id: key
    text: "Ctrl"
}
// --- API ---
// key.text / keySize
```

## Notes

Single keyboard key glyph (e.g. Ctrl); text is the caption.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `keyText` | `string` | Display label for the key (e.g. "Ctrl", "P", "Esc"). |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `size` | `string` | "small" \| "medium" \| "large" |
| `emphasized` | `bool` | Emphasized chrome |
| `toolTipText` | `string` | Tooltip text |
| `minWidth` | `real` | Minimum width |
| `effectiveIconGlyph` | `string` | Resolved glyph string |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `AbstractButton`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `down` / `pressed` / `hovered`
- `clicked()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
