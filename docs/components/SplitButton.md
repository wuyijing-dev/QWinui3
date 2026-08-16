# SplitButton

Primary action + chevron menu.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/SplitButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/SplitButton.qml)

**Category:** Buttons & commands · **Library:** v1.03

[← Component index](../components.md)

**Gallery:** `SplitButton` — [`src/gallery/pages/SplitButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SplitButtonPage.qml)

**Extends** `AbstractButton`.

## Example

```qml
SplitButton {
    id: split
    text: qsTr("Save")
    onClicked: save()
    MenuFlyout {
        MenuFlyoutItem { text: qsTr("Save as…"); onClicked: saveAs() }
    }
}
// --- API ---
// split.open() / close() flyout half
// signals: onClicked (primary)
```

## Notes

Primary click + chevron MenuFlyout; put MenuFlyoutItem children for the menu half.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `menu` | `alias` | Attached / owned Menu |
| `menuData` | `alias` | Menu children slot |
| `highlighted` | `bool` | Emphasized / selected chrome |
| `flat` | `bool` | Flat chrome without fill |
| `flyoutPlacement` | `int` | MenuFlyout placement |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `isOpen` | `alias` | Open / visible state |
| `effectiveIconGlyph` | `string` | Resolved glyph string |
| `lightScheme` | `bool` | True in light theme |
| `accented` | `bool` | Use accent chrome |
| `anyHovered` | `bool` | True if any child is hovered |
| `anyDown` | `bool` | True if any child is pressed |

### Signals

| Signature | Description |
| --- | --- |
| `primaryClicked()` | Primary button clicked |

### Methods

| Signature | Description |
| --- | --- |
| `showMenu()` | Open the associated menu |
| `closeMenu()` | Dismiss the menu |

### Inherited from `AbstractButton`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `down` / `pressed` / `hovered`
- `clicked()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
