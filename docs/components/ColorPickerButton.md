# ColorPickerButton

Color swatch button that opens ColorPicker.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ColorPickerButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ColorPickerButton.qml)

**Category:** Buttons & commands · **Library:** v1.07

[← Component index](../components.md)

**Gallery:** `ColorPickerButton` — [`src/gallery/pages/ColorPickerButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ColorPickerButtonPage.qml)

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

## Notes

Swatch button that opens ColorPicker; bind selectedColor.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `selectedColor` | `color` | Currently selected color |
| `pickerOpen` | `bool` | Picker flyout open |
| `isOpen` | `alias` | Open / visible state |
| `showAlpha` | `bool` | Show alpha channel editor |
| `isAlphaEnabled` | `alias` | WinUI IsAlphaEnabled |
| `colorSpectrumShape` | `string` | WinUI ColorSpectrumShape: box \| ring |
| `previousColor` | `color` | WinUI PreviousColor |
| `isPreviousColorVisible` | `bool` | — |
| `showHexLabel` | `bool` | Show hex text on the button |
| `flyoutPlacement` | `int` | MenuFlyout placement |
| `shouldConstrainToRootBounds` | `bool` | WinUI ShouldConstrainToRootBounds for the picker popup |
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

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
