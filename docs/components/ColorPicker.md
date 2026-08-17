# ColorPicker

Spectrum + RGB/Hex color editor.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ColorPicker.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ColorPicker.qml)

**Category:** Input & forms · **Library:** v2.54

[← Component index](../components.md)

**Gallery:** `ColorPicker` — [`src/gallery/pages/ColorPickerPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ColorPickerPage.qml)

**Extends** `Control`.

## Example

```qml
ColorPicker {
    id: colorPicker
    selectedColor: "#005FB8"
}

// --- API ---
// signals: onColorChosen
// methods: copyHex(), clamp01(x), hsvToRgb(h, s, v), rgbToHsv(r, g, b), hsvToColor(h, s, v, a), hexString(c), parseHex(text), applyHsv(emitSignal), syncFromColor(c, emitSignal), syncInputsFromColor()
// colorPicker.copyHex()
// colorPicker.clamp01(x)
// colorPicker.hsvToRgb(h, s, v)
// colorPicker.rgbToHsv(r, g, b)
```

## Notes

Edits selectedColor via spectrum + RGB/HSV/hex fields.
copyHex() writes #RRGGBB to the clipboard.
Bind selectedColor; channel props (hue/saturation/value/alpha) stay in sync.
previousColor + isPreviousColorVisible show a restore swatch (WinUI PreviousColor).
colorSpectrumShape: box | ring; isAlphaEnabled aliases showAlpha.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `selectedColor` | `color` | Currently selected color |
| `hue` | `real` | Hue 0..360 |
| `saturation` | `real` | Saturation 0..1 |
| `value` | `real` | Current value |
| `showAlpha` | `bool` | Show alpha channel editor |
| `isAlphaEnabled` | `alias` | WinUI IsAlphaEnabled |
| `alpha` | `real` | Alpha 0..1 |
| `colorModel` | `int` | rgb \| hsv \| hex editor mode |
| `isColorSpectrumVisible` | `bool` | Show color spectrum |
| `colorSpectrumShape` | `string` | WinUI ColorSpectrumShape: box \| ring |
| `isColorPreviewVisible` | `bool` | Show color preview swatch |
| `isColorChannelTextInputVisible` | `bool` | Show channel text inputs |
| `isColorSliderVisible` | `bool` | Show value (brightness) slider |
| `isHexInputVisible` | `bool` | Show hex field row |
| `previousColor` | `color` | WinUI PreviousColor — shown above the current swatch; click restores it |
| `isPreviousColorVisible` | `bool` | When true, always show the previous-color half of the previewer |

### Signals

| Signature | Description |
| --- | --- |
| `colorChosen(color color)` | Emitted when a color is chosen |

### Methods

| Signature | Description |
| --- | --- |
| `copyHex()` | Copy the current color hex to the clipboard |
| `clamp01(x)` | Clamp to 0..1 |
| `hsvToRgb(h, s, v)` | Convert HSV to RGB components |
| `rgbToHsv(r, g, b)` | Convert RGB to HSV components |
| `hsvToColor(h, s, v, a)` | Convert HSV to a QColor |
| `hexString(c)` | Format color as #RRGGBB[AA] |
| `parseHex(text)` | Parse a hex color string |
| `applyHsv(emitSignal)` | Apply HSV channels to selectedColor |
| `syncFromColor(c, emitSignal)` | Sync From color |
| `syncInputsFromColor()` | Sync Inputs From color |
| `commitRgbFields()` | Commit RGB text fields into selectedColor |
| `commitHsvFields()` | Commit HSV text fields into selectedColor |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
