# OnScreenKeyboard

Win11 touch-keyboard chrome + layouts (1.80).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OnScreenKeyboard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OnScreenKeyboard.qml)

**Category:** Input & forms · **Library:** v1.80

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
// langBadge  short IME chip (英 / 中 / あ / 한 / …)
// closeRequested / settingsRequested
```

## Notes

Experimental. Matches Windows 11 default touch layout (Esc/Tab/dual Shift,
&123 · Ctrl · Win · Alt · lang · Space · mic · arrows; top-row number hints).
App-scoped hardware input (not OS-wide). SIL Keyman Core (MIT) for named .kmx;
zh/ja/ko in-app IME. Not Qt Virtual Keyboard. Keys use MouseArea (no focus steal).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbolsMode` | `bool` | — |
| `emojiMode` | `bool` | — |
| `shiftLatched` | `bool` | — |
| `capsLock` | `bool` | — |
| `showChrome` | `bool` | — |
| `engine` | `alias` | — |
| `layoutId` | `alias` | — |
| `hardwareInput` | `alias` | — |
| `shiftOn` | `bool` | — |
| `keyGap` | `real` | — |
| `keyH` | `real` | — |
| `letterShift` | `bool` | — |
| `langBadge` | `string` | Short Win11-style language chip on the bottom row. |
| `letterWFallback` | `real` | — |
| `letterRows` | `var` | Windows 11 default touch keyboard (letters). |
| `symbolRows` | `var` | — |
| `emojiRows` | `var` | — |

### Signals

| Signature | Description |
| --- | --- |
| `closeRequested()` | — |
| `settingsRequested()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `unitWidthFor(row)` | — |
| `keyWidth(row, k)` | — |
| `vkOf(ch)` | — |
| `keyLabel(vk)` | — |
| `punctLabel(k)` | — |
| `punctChar(k)` | — |
| `tapVk(vk)` | — |
| `tapShift()` | — |
| `iconFor(k)` | — |
| `labelFor(k)` | — |
| `accentFor(k)` | — |
| `handleKey(k)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
