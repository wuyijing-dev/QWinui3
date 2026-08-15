# ColorPickerButton

Color swatch button that opens ColorPicker.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ColorPickerButton.qml`](../../src/extras/QWinUI3/Extras/ColorPickerButton.qml)

[← Component index](../components.md)

**Extends** `AbstractButton`.

## Example

```qml
ColorPickerButton {
    id: colorPickerButton
   selectedColor: Theme.accent
}

// --- API ---
// signals: onColorChosen
// methods: open(), close()
// colorPickerButton.open()
// colorPickerButton.close()
// inherits AbstractButton (+ Qt Quick Controls base API)
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `selectedColor` | `color` | Currently selected color |
| `pickerOpen` | `bool` | Picker flyout open |
| `isOpen` | `alias` | Open / visible state |
| `showAlpha` | `bool` | Show alpha channel editor |
| `showHexLabel` | `bool` | Show hex text on the button |
| `flyoutPlacement` | `int` | MenuFlyout placement |
| `hexText` | `string` | Formatted hex color text |

### Signals

| Signature | Description |
| --- | --- |
| `colorChosen(color color)` | Emitted when a color is chosen |

### Methods

| Signature | Description |
| --- | --- |
| `open()` | Open / show |
| `close()` | Close / dismiss |

### Inherited from `AbstractButton`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `down` / `pressed` / `hovered`
- `clicked()`
- `pressAndHold()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
