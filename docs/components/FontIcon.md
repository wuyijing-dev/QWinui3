# FontIcon

FluentIcons glyph as Text.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/FontIcon.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/FontIcon.qml)

**Category:** Media & platform · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `Iconography` — [`src/gallery/pages/FontIconPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/FontIconPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Item`.

## Example

```qml
FontIcon {
    id: icon
    symbol: FluentIcons.Home
    fontSize: 20
}
// --- API ---
// icon.symbol / iconGlyph / fontSize
// microMotionEnabled / hoverScale / pressScale (1.49)
```

## Notes

FluentIcons symbol / glyph text; fontSize for px size.
Accessible: set accessibleName or toolTipText — never use the raw PUA glyph (1.29).
Hover/press micro-motion honors Theme.reducedMotion (1.49).

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
| `autoMirror` | `bool` | When true, mirror directional glyphs under LayoutMirroring (2.67 — I9) |
| `fontWeight` | `int` | Font weight |
| `toolTipText` | `string` | Tooltip text |
| `accessibleName` | `string` | Accessible name override |
| `microMotionEnabled` | `bool` | WinUI-style hover/press micro-motion (1.49) |
| `hoverScale` | `real` | Hover glyph scale when microMotionEnabled |
| `pressScale` | `real` | Pressed glyph scale when microMotionEnabled |
| `iconOffsetX` | `real` | Manual optical offset (px); NaN → Theme.iconOpticalOffset(fontSize) |
| `iconOffsetY` | `real` | — |
| `iconContext` | `string` | Size band hint: caption \| chrome \| nav \| appbar \| "" (auto from fontSize) |
| `chevronRotation` | `real` | Chevron expand rotation (deg); use with FluentIcons.Chevron* (2.66 — I4) |
| `selected` | `bool` | Selected / emphasized glyph (accent + motion — 2.66 — I3) |
| `effectiveOffsetX` | `real` | — |
| `effectiveOffsetY` | `real` | — |
| `effectiveIconColor` | `color` | — |
| `effectiveDisabledOpacity` | `real` | — |
| `effectiveGlyph` | `string` | — |
| `effectiveMirror` | `bool` | — |
| `effectiveIconScale` | `real` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
