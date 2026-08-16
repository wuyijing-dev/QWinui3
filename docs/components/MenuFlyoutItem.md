# MenuFlyoutItem

Menu row with glyph and accelerator text.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MenuFlyoutItem.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MenuFlyoutItem.qml)

**Category:** Dialogs & flyouts · **Library:** v1.13

[← Component index](../components.md)

**Gallery:** `MenuFlyoutItem` — [`src/gallery/pages/MenuFlyoutItemPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/MenuFlyoutItemPage.qml)

**Extends** `MenuItem`.

## Example

```qml
MenuFlyout {
    MenuFlyoutItem {
        text: qsTr("Copy")
        symbol: FluentIcons.Copy
        onClicked: copy()
    }
}
```

## Notes

MenuFlyout row; text + optional symbol; onClicked / triggered.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `keyboardAcceleratorText` | `string` | Accelerator caption (Ctrl+C) |
| `keyVisualAccelerator` | `bool` | When true, render accelerator as KeyChordVisual chrome instead of plain text. |
| `iconColor` | `color` | Icon color |
| `effectiveIconGlyph` | `string` | Resolved glyph string |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `MenuItem`

Also available (base type / Qt Quick Controls):

- `text`
- `triggered()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
