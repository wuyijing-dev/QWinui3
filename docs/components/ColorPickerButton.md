# ColorPickerButton

Color swatch button that opens ColorPicker.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ColorPickerButton.qml`](../../src/extras/QWinUI3/Extras/ColorPickerButton.qml)

[← Component index](../components.md)

## Usage

```qml
ColorPickerButton { selectedColor: Theme.accent }
```

## Properties

- `selectedColor: color` — Currently selected color
- `pickerOpen: bool` — Picker flyout open
- `isOpen: alias` — Open / visible state
- `showAlpha: bool` — Show alpha channel editor
- `showHexLabel: bool` — Show hex text on the button
- `flyoutPlacement: int` — MenuFlyout placement
- `hexText: string` — Formatted hex color text

## Signals

- `colorChosen(color color)` — Emitted when a color is chosen

## Methods

- `open()` — Open / show
- `close()` — Close / dismiss

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
