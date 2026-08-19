# ToggleSplitButton

Toggle primary + menu SplitButton.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ToggleSplitButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ToggleSplitButton.qml)

**Category:** Buttons & commands · **Library:** v2.64

[← Component index](../components.md)

**Gallery:** `ToggleSplitButton` — [`src/gallery/pages/ToggleSplitButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ToggleSplitButtonPage.qml)

**Extends** `AbstractButton`.

## Example

```qml
ToggleSplitButton {
    id: toggleSplitButton
    text: qsTr("Format")
}

// --- API ---
// signals: onPrimaryClicked
// methods: showMenu(), closeMenu()
// toggleSplitButton.showMenu()
// toggleSplitButton.closeMenu()
// inherits AbstractButton (+ Qt Quick Controls base API)
```

## Notes

Checkable SplitButton; checked toggles the primary half.

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
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
