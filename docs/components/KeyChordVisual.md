# KeyChordVisual

Renders Ctrl+K style shortcuts as KeyVisuals.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/KeyChordVisual.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/KeyChordVisual.qml)

**Category:** Other · **Library:** v1.69

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
KeyChordVisual {
    id: chord
    keys: ["Ctrl", "K"]
}
// --- API ---
// chord.keys / chordText
```

## Notes

Chord of KeyVisuals from keys: string[]; chordText for a11y.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `shortcut` | `string` | Raw accelerator string: "Ctrl+Shift+P" or multi-stroke "Ctrl+K, Ctrl+S" |
| `keys` | `var` | Explicit key labels; when set, overrides shortcut parsing. |
| `size` | `string` | Diameter or box size in px |
| `emphasized` | `bool` | Emphasized chrome |
| `separator` | `string` | Separator item / glyph |
| `keySpacing` | `real` | Spacing between keys |
| `toolTipText` | `string` | Tooltip text |
| `chordText` | `string` | Keyboard chord display text |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
