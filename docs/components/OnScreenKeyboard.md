# OnScreenKeyboard

Win11-style in-app touch keyboard (1.77).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OnScreenKeyboard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OnScreenKeyboard.qml)

**Category:** Input & forms · **Library:** v1.78

[← Component index](../components.md)

**Gallery:** `On-screen keyboard` — [`src/gallery/pages/OnScreenKeyboardPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/OnScreenKeyboardPage.qml)

**Extends** `Control`.

## Example

```qml
OnScreenKeyboard { }
// Host in CatalogPage.footer / Overlay / shell footer so keys stay docked.

// --- API ---
// engine.backend  "pinyin" | "romaji" | "hangul" | "keyman" | "builtin"
// engine.hardwareInput  physical keys in this app → same engine (default on)
// engine.layoutId / cycleLayout / processVk
```

## Notes

Experimental. App-scoped hardware input (not OS-wide SendInput). SIL Keyman
Core (MIT) for named .kmx; zh/ja/ko in-app IME. Not Qt Virtual Keyboard.
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
| `hardwareInput` | `alias` | — |
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
