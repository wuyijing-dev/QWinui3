# FontIcon

FluentIcons glyph as Text.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FontIcon.qml`](../../src/extras/QWinUI3/Extras/FontIcon.qml)

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
FontIcon { symbol: FluentIcons.Home; font.pixelSize: 16 }
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `icon` | `var` | Icon glyph or source |
| `glyph` | `string` | Fluent glyph drawn in the button |
| `fontSize` | `real` | Font size in px |
| `iconColor` | `color` | Icon color |
| `mirrorGlyph` | `bool` | Mirror glyph for RTL |
| `fontWeight` | `int` | Font weight |
| `toolTipText` | `string` | Tooltip text |
| `accessibleName` | `string` | Accessible name override |
| `effectiveGlyph` | `string` | Resolved glyph string |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors` / `x` / `y`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
