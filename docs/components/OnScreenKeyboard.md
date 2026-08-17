# OnScreenKeyboard

Win11-style in-app touch keyboard (1.70).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OnScreenKeyboard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OnScreenKeyboard.qml)

**Category:** Input & forms · **Library:** v1.70

[← Component index](../components.md)

**Gallery:** `On-screen keyboard` — [`src/gallery/pages/OnScreenKeyboardPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/OnScreenKeyboardPage.qml)

**Extends** `Control`.

## Example

```qml
OnScreenKeyboard { }
// Host in CatalogPage.footer / Overlay / shell footer so keys stay docked.

// --- API ---
// engine.backend  "builtin" (en-US). Keyman Core (.kmx) is 1.71+.
// engine.commitText / backspace / enterKey
```

## Notes

Experimental. MIT Keyman Core is the layout engine for 1.71+; 1.70 injects
via KeyboardEngine (not Qt Virtual Keyboard / QT_IM_MODULE). Recipe:
docs/on-screen-keyboard.md. Keys use MouseArea (no focus steal).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbolsMode` | `bool` | — |
| `shiftLatched` | `bool` | — |
| `capsLock` | `bool` | — |
| `engine` | `alias` | — |
| `keyGap` | `real` | — |
| `keyH` | `real` | — |
| `letterW` | `real` | — |
| `letterRows` | `var` | — |
| `symbolRows` | `var` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `displayLetter(ch)` | — |
| `tapLetter(ch)` | — |
| `tapShift()` | — |
| `handleKey(k)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
