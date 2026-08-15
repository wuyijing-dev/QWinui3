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

- `copyHex()` — Copy Hex
- `clamp01(x)` — Clamp01
- `hsvToRgb(h, s, v)` — Hsv To Rgb
- `rgbToHsv(r, g, b)` — Rgb To Hsv
- `hsvToColor(h, s, v, a)` — Hsv To Color
- `hexString(c)` — Hex String
- `byteHex(n)` — Byte Hex
- `parseHex(text)` — Parse Hex
- `applyHsv(emitSignal)`
- `syncFromColor(c, emitSignal)`
- `syncInputsFromColor()`
- `commitRgbFields()`
- `commitHsvFields()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
