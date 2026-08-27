# IconButton

Icon-only button helper.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/IconButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/IconButton.qml)

**Category:** Buttons & commands · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `IconButton` — [`src/gallery/pages/IconButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/IconButtonPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `IconicButton`.

## Example

```qml
IconButton {
    id: btn
    symbol: FluentIcons.Settings
    accentIcon: true   // accent-colored icon (alias of highlighted; ratings, favorites)
    loading: true       // inline ring; defers press animation (2.67 — I5/M11)
    onClicked: openSettings()
}
```

## Notes

Icon-only Button helper; set symbol / iconGlyph; inherits clicked().
Glyph hover/press micro-motion via FontIcon (1.49); Theme.reducedMotion disables.
Touch floor ≥ 40×40 logical px (M11).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `accentIcon` | `alias` | Accent-colored icon (rating stars, favorited toolbar). Alias of highlighted. |
| `loading` | `bool` | Async action — shows ProgressRing, disables click (2.67 — I5/M11) |
| `toggleMode` | `bool` | When true, the icon behaves like a toggle (uses `checked` state). |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
