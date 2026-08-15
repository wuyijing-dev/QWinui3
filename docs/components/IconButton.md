# IconButton

Icon-only button helper.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/IconButton.qml`](../../src/extras/QWinUI3/Extras/IconButton.qml)

[← Component index](../components.md)

**Extends** `IconicButton`.

## Example

```qml
IconButton {
    id: btn
    symbol: FluentIcons.Settings
    onClicked: openSettings()
}
// --- API ---
// inherits Button: enabled, clicked()
```

## Notes

Icon-only Button helper; set symbol / iconGlyph; inherits clicked().

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
