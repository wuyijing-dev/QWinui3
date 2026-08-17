# OnScreenKeyboard

Windows 11 touch keyboard parity (1.81).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OnScreenKeyboard.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OnScreenKeyboard.qml)

**Category:** Input & forms · **Library:** v1.81

[← Component index](../components.md)

**Gallery:** `On-screen keyboard` — [`src/gallery/pages/OnScreenKeyboardPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/OnScreenKeyboardPage.qml)

**Extends** `Control`.

## Example

```qml
OnScreenKeyboard { }
// Host in CatalogPage.footer / Overlay / shell footer so keys stay docked.

// --- API ---
// keyboardSize  "default" | "small" | "wide"  (Win11 size modes — not Win10 classic)
// engine.layoutId / cycleLayout / hardwareInput / pasteClipboard
// langBadge  英 / 中 / あ / 한 / …
// closeRequested / settingsRequested
```

## Notes

Experimental. Targets Windows 11 Touch Keyboard behavior (not Win10):
long-press number hints, secondary-char flyout, rounder keys + press scale,
size modes, clipboard strip, emoji categories. In-app only — not OS-wide.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `symbolsMode` | `bool` | — |
| `emojiMode` | `bool` | — |
| `shiftLatched` | `bool` | — |
| `capsLock` | `bool` | — |
| `showChrome` | `bool` | — |
| `keyboardSize` | `string` | Win11 keyboard size (Settings → Typing → Touch keyboard). Not Win10 "full" classic. |
| `settingsOpen` | `bool` | — |
| `clipboardOpen` | `bool` | — |
| `emojiCategory` | `int` | — |
| `statusBanner` | `string` | — |
| `engine` | `alias` | — |
| `layoutId` | `alias` | — |
| `hardwareInput` | `alias` | — |
| `shiftOn` | `bool` | — |
| `keyGap` | `real` | — |
| `keyH` | `real` | — |
| `keyRadius` | `real` | Win11 keys are noticeably rounder than Win10 / Theme.cornerControl (4). |
| `letterShift` | `bool` | — |
| `langBadge` | `string` | — |
| `emojiCategoryModel` | `var` | — |
| `letterWFallback` | `real` | — |
| `letterRows` | `var` | Windows 11 default touch keyboard (letters) — not Win10 classic with always-on number row. |
| `symbolRows` | `var` | — |
| `emojiGridRows` | `var` | — |

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
| `keyLabel(vk)` | — |
| `punctLabel(k)` | — |
| `punctChar(k)` | — |
| `tapVk(vk)` | — |
| `tapShift()` | — |
| `commitHint(k)` | — |
| `commitAlt(ch)` | — |
| `flashBanner(text)` | — |
| `openAltFlyout(item, alts)` | — |
| `altsFor(k)` | — |
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
