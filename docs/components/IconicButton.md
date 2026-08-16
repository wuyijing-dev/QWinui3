# IconicButton

Base icon + label button used by AppBar* / IconButton.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/IconicButton.qml`](../../src/extras/QWinUI3/Extras/IconicButton.qml)

[← Component index](../components.md)

**Extends** `AbstractButton`.

## Example

```qml
IconicButton {
    id: btn
    text: qsTr("Open")
    symbol: FluentIcons.Open
    onClicked: open()
}
```

## Notes

Button with leading Fluent symbol + text. Prefer IconButton / AppBarButton
for specialized layouts; this type is usable standalone.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `iconSize` | `real` | Icon size in px |
| `toolTipText` | `string` | Tooltip text |
| `badgeVisible` | `bool` | Show avatar badge |
| `badgeValue` | `int` | Numeric badge value (-1 hides count) |
| `badgeText` | `string` | Badge caption |
| `badgeMaxValue` | `int` | Badge max before + |
| `highlighted` | `bool` | Emphasized / selected chrome |
| `flat` | `bool` | Flat chrome without fill |
| `effectiveIconGlyph` | `string` | Resolved glyph string |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `AbstractButton`

Also available (base type / Qt Quick Controls):

- `text`
- `enabled`
- `down` / `pressed` / `hovered`
- `clicked()`
- `pressAndHold()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
