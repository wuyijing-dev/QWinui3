# OnScreenKeyboard

Win11-style in-app touch keyboard (1.75).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OnScreenKeyboard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OnScreenKeyboard.qml)

**Category:** Input & forms · **Library:** v1.75

[← Component index](../components.md)

**Gallery:** `On-screen keyboard` — [`src/gallery/pages/OnScreenKeyboardPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/OnScreenKeyboardPage.qml)

**Extends** `Control`.

## Example

```qml
OnScreenKeyboard { }
// Host in CatalogPage.footer / Overlay / shell footer so keys stay docked.

// --- API ---
// engine.backend  "pinyin" | "romaji" | "hangul" | "keyman" | "builtin"
// engine.layoutId / cycleLayout / processVk
```

## Notes

Experimental. SIL Keyman Core (MIT) for layouts (named .kmx subset incl.
en-GB/it/pt/pl/sv/tr); zh pinyin / ja romaji / ko hangul are in-app IME.
Chrome is ours (LGPL). Not Qt Virtual Keyboard / QT_IM_MODULE.
Keys use MouseArea (no focus steal). Emoji layer has no engine.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbolsMode` | `bool` | — |
| `emojiMode` | `bool` | — |
| `shiftLatched` | `bool` | — |
| `capsLock` | `bool` | — |
| `engine` | `alias` | — |
| `layoutId` | `alias` | — |
| `shiftOn` | `bool` | — |
| `keyGap` | `real` | — |
| `keyH` | `real` | — |
| `letterCount` | `int` | — |
| `letterW` | `real` | — |
| `letterShift` | `bool` | — |
| `letterRows` | `var` | — |
| `symbolRows` | `var` | — |
| `emojiRows` | `var` | — |

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
