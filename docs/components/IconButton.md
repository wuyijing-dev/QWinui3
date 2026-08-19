# IconButton

Icon-only button helper.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/IconButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/IconButton.qml)

**Category:** Buttons & commands · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `IconButton` — [`src/gallery/pages/IconButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/IconButtonPage.qml)

**Extends** `IconicButton`.

## Example

```qml
IconButton {
    id: btn
    symbol: FluentIcons.Settings
    accentIcon: true   // accent-colored icon (alias of highlighted; ratings, favorites)
    onClicked: openSettings()
}
// --- API ---
// inherits Button: enabled, clicked()
```

## Notes

Icon-only Button helper; set symbol / iconGlyph; inherits clicked().
Glyph hover/press micro-motion via IconicButton (1.49); Theme.reducedMotion disables.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `accentIcon` | `alias` | Accent-colored icon (rating stars, favorited toolbar). Alias of highlighted. |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
