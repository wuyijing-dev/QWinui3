# OnScreenKeyboard

Win11-style in-app touch keyboard (1.71).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OnScreenKeyboard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OnScreenKeyboard.qml)

**Category:** Input & forms · **Library:** v1.71

[← Component index](../components.md)

**Gallery:** `On-screen keyboard` — [`src/gallery/pages/OnScreenKeyboardPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/OnScreenKeyboardPage.qml)

**Extends** `Control`.

## Example

```qml
OnScreenKeyboard { }
// Host in CatalogPage.footer / Overlay / shell footer so keys stay docked.

// --- API ---
// engine.backend  "keyman" when libkeymancore is linked; else "builtin"
// engine.layoutId / cycleLayout / processVk
```

## Notes

Experimental. SIL Keyman Core (MIT) processes .kmx; chrome is ours (LGPL).
Not Qt Virtual Keyboard / QT_IM_MODULE. Recipe: docs/on-screen-keyboard.md.
Keys use MouseArea (no focus steal). Globe cycles en/de/fr/es/ru/ar.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbolsMode` | `bool` | — |
| `shiftLatched` | `bool` | — |
| `capsLock` | `bool` | — |
| `engine` | `alias` | — |
| `layoutId` | `alias` | — |
| `shiftOn` | `bool` | — |
| `keyGap` | `real` | — |
| `keyH` | `real` | — |
| `letterCount` | `int` | — |
| `letterW` | `real` | — |
| `letterRows` | `var` | — |
| `symbolRows` | `var` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `vkOf(ch)` | — |
| `keyLabel(vk)` | — |
| `tapVk(vk)` | — |
| `tapShift()` | — |
| `handleKey(k)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
