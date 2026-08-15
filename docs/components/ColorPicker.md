# ColorPicker

Spectrum + RGB/Hex color editor.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ColorPicker.qml`](../../src/extras/QWinUI3/Extras/ColorPicker.qml)

[← Component index](../components.md)

## Usage

```qml
ColorPicker { selectedColor: "#005FB8" }
```

## Properties

- `selectedColor: color` — Currently selected color
- `hue: real` — Hue 0..360
- `saturation: real` — Saturation 0..1
- `value: real` — Current value
- `showAlpha: bool` — Show alpha channel editor
- `alpha: real` — Alpha 0..1
- `colorModel: int` — rgb | hsv | hex editor mode
- `isColorSpectrumVisible: bool` — Show color spectrum
- `isColorPreviewVisible: bool` — Show color preview swatch
- `isColorChannelTextInputVisible: bool` — Show channel text inputs

## Signals

- `colorChosen(color color)` — Emitted when a color is chosen

## Methods

- `copyHex()` — Copy the current color hex to the clipboard
- `clamp01(x)` — Clamp to 0..1
- `hsvToRgb(h, s, v)` — Convert HSV to RGB components
- `rgbToHsv(r, g, b)` — Convert RGB to HSV components
- `hsvToColor(h, s, v, a)` — Convert HSV to a QColor
- `hexString(c)` — Format color as #RRGGBB[AA]
- `byteHex(n)` — Format a 0..255 channel as two hex digits
- `parseHex(text)` — Parse a hex color string
- `applyHsv(emitSignal)`
- `syncFromColor(c, emitSignal)`
- `syncInputsFromColor()`
- `commitRgbFields()`
- `commitHsvFields()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
