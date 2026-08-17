# AnimatedIcon

Thin state glyph swap (1.53). Not Lottie / WinUI AnimatedIcon parity.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/AnimatedIcon.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/AnimatedIcon.qml)

**Category:** Other · **Library:** v2.54

[← Component index](../components.md)

**Gallery:** `AnimatedIcon` — [`src/gallery/pages/AnimatedIconPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/AnimatedIconPage.qml)

**Extends** `Item`.

## Example

```qml
AnimatedIcon {
    id: playIcon
    checked: playing
    symbol: FluentIcons.Play
    symbolChecked: FluentIcons.Pause
    accessibleName: playing ? qsTr("Pause") : qsTr("Play")
}

// Multi-state map:
AnimatedIcon {
    iconState: expanded ? "open" : "closed"
    iconStates: [
        { name: "closed", symbol: FluentIcons.ChevronDown },
        { name: "open", symbol: FluentIcons.ChevronUp }
    ]
}

// --- API ---
// iconState / iconStates / checked / symbol / symbolChecked / fontSize / iconColor
// microMotionEnabled (1.49) · honors Theme.reducedMotion
```

## Notes

Crossfade + light scale between FluentIcons glyphs. Experimental — no Lottie runtime.
Prefer named FluentIcons; set accessibleName (never the raw PUA glyph).
Uses iconState/iconStates (not Item.state/states) to avoid Qt Quick state machine clash.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `iconState` | `string` | Current state key ("" → use checked / normal). Not Item.state. |
| `iconStates` | `var` | Optional multi-state table: [{ name, symbol\|glyph }, …]. Not Item.states. |
| `checked` | `bool` | Two-state convenience (when iconStates is empty) |
| `symbol` | `var` | FluentIcons for unchecked / normal |
| `symbolChecked` | `var` | FluentIcons for checked |
| `glyph` | `string` | Raw glyph fallbacks |
| `glyphChecked` | `string` | — |
| `fontSize` | `real` | Font size in px |
| `iconColor` | `color` | Icon color |
| `mirrorGlyph` | `bool` | Mirror glyph for RTL |
| `fontWeight` | `int` | Font weight |
| `toolTipText` | `string` | Tooltip text |
| `accessibleName` | `string` | Accessible name override |
| `microMotionEnabled` | `bool` | Hover/press micro-motion on the visible glyph (1.49) |
| `hoverScale` | `real` | — |
| `pressScale` | `real` | — |
| `transitionScale` | `real` | Transition scale kick (1 = none); ignored when Theme.reducedMotion |
| `effectiveState` | `string` | — |
| `effectiveGlyph` | `string` | — |
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
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
