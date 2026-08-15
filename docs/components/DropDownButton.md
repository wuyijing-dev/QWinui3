# DropDownButton

Button that opens a MenuFlyout of actions.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DropDownButton.qml`](../../src/extras/QWinUI3/Extras/DropDownButton.qml)

[← Component index](../components.md)

**Extends** `AbstractButton`.

## Example

```qml
DropDownButton {
    id: dropDownButton
    text: qsTr("Options")
    MenuFlyoutItem { text: qsTr("A") }
}

// --- API ---
// methods: open(), close(), showMenu()
// dropDownButton.open()
// dropDownButton.close()
// dropDownButton.showMenu()
// inherits AbstractButton (+ Qt Quick Controls base API)
```

## Notes

Button that opens a MenuFlyout of children items.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `menu` | `alias` | Attached / owned Menu |
| `menuData` | `alias` | Menu children slot |
| `highlighted` | `bool` | Emphasized / selected chrome |
| `flyoutPlacement` | `int` | MenuFlyout placement |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `isOpen` | `alias` | Open / visible state |
| `effectiveIconGlyph` | `string` | Resolved glyph string |
| `lightScheme` | `bool` | True in light theme |
| `menuOpen` | `bool` | Menu currently open |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `open()` | Open / show |
| `close()` | Close / dismiss |
| `showMenu()` | Open the associated menu |

### Inherited from `AbstractButton`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `down` / `pressed` / `hovered`
- `clicked()`
- `pressAndHold()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
