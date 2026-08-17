# On-screen keyboard (1.70)

Win11 / Fluent **touch keyboard chrome we own**, plus an **MIT C++ keyboard engine** we do not own. This is **not** Qt Virtual Keyboard, and it is **not** a hardware-shortcut cookbook ([keyboard.md](keyboard.md)).

**Status:** planned **1.70** — experimental when it ships.  
**License split:** engine MIT (third-party) · UI LGPL-3.0 (this repo).

---

## Why this split

Qt Virtual Keyboard is **GPL-3.0 or commercial**. QWinUI3 is **LGPL-3.0**. `Bootstrap::configureEnvironment` already clears `QT_IM_MODULE` so desktop kits do not pull that GPL plugin ([packaging-consumer.md](packaging-consumer.md) strip notes).

A MIT QML keyboard that also ships its own look (SomcoKeyboard, OpenVirtualKeyboard, UnivKbd) would fight Theme tokens and Win11 chrome. We only want their **idea** (in-process OSK), not their UI.

| Piece | Owner | License | Role |
|-------|--------|---------|------|
| Key caps, layers, acrylic dock, Theme | QWinUI3 QML | LGPL-3.0 | Win11-style panel |
| Key → text (shift, caps, dead keys, layouts) | **SIL Keyman Core** (`libkeymancore`) | **MIT** | Engine only — no UI |
| Insert into the focused control | QWinUI3 C++ adapter | LGPL-3.0 | `QInputMethodEvent` / a few `QKeyEvent`s |
| Qt Virtual Keyboard / `QT_IM_MODULE=qtvirtualkeyboard` | — | GPL / commercial | **Forbidden** |

Engine source: [keymanapp/keyman `core/`](https://github.com/keymanapp/keyman/tree/master/core) ([MIT](https://github.com/keymanapp/keyman/blob/master/LICENSE.md)).  
API: [Keyman Core](https://help.keyman.com/developer/core/current-version/) (`km_core_process_event`, actions). Layouts: [keymanapp/keyboards](https://github.com/keymanapp/keyboards) (community `.kmx`, MIT).

---

## Architecture

```text
  focused TextField / TextArea
           ▲
           │  QInputMethodEvent (commit / backspace)
           │  QKeyEvent only for Enter / Tab / arrows
           │
  KeyboardEngine  (C++, QML_ELEMENT)     ← our thin adapter
           │
           │  km_core_process_event(vk, modifiers, down)
           ▼
  libkeymancore   (MIT, no Qt, no QML)
           │
           ▼
  OnScreenKeyboard.qml   ← our Fluent / Win11 chrome (Theme tokens)
```

Keep `QT_IM_MODULE` unset. Do **not** ship a `platforminputcontexts` plugin in 1.70 — an in-window dock is enough to theme, test, and stay off the GPL IM module path.

---

## Engine choice

**Pick: SIL Keyman Core.** It is a C API keyboard processor: load a keyboard, feed virtual keys, get insert/delete actions. Windows is first-class. UI is explicitly a “platform layer” the consumer writes.

| Candidate | License | UI? | Windows | Why not (or why) |
|-----------|---------|-----|---------|------------------|
| **Keyman Core** | MIT | No | Yes | **Use this** |
| libxkbcommon | MIT | No | Weak | Hardware XKB/Wayland keymaps, not a touch OSK |
| Qt Virtual Keyboard | GPL / commercial | Yes | Yes | **License conflict** |
| SomcoKeyboard / OpenVirtualKeyboard | MIT | Yes (QML) | Yes | We own chrome; do not vendor their QML |

Do not reimplement a second engine for en-US “to keep it small.” Vendor or FetchContent **only** `core/` (libkeymancore), not the whole Keyman monorepo.

---

## UI we write (Win11)

Follow Windows 11 Touch Keyboard: bottom dock, large hit targets, rounded keys, wide Space / Enter / Backspace, light and dark from `Theme`.

| Layer | Keys |
|-------|------|
| Letters | QWERTY; Shift latch / Caps |
| Symbols | Numbers + punctuation |
| Optional later | Emoji panel (no engine required) |

Tokens: `Theme.bgCard` / `controlFill` / `cornerControl` / `strokeHairline` / `Theme.dp(48)` hit size ([density.md](density.md) · [touch-pointer.md](touch-pointer.md)). Reuse `FluentIcons` for Backspace / Enter / Shift — do not invent a second icon font.

Suggested Extra: `OnScreenKeyboard` (experimental). Host in `Overlay.overlay` or a shell footer; show when a text control is focused **or** when the app sets `visible` (kiosk).

---

## 1.70 scope

**In**

- Experimental `OnScreenKeyboard` + `KeyboardEngine` adapter  
- en-US layout via a shipped Keyman keyboard  
- Letters + Shift/Caps + symbols; dark/light  
- Gallery page + this recipe  
- CMake opt-in if Core is missing (stub like `MediaPlayerElement`)  

**Out**

- Qt Virtual Keyboard / any GPL IM plugin  
- Vendoring third-party QML keyboards  
- Full CJK IME, handwriting, dictation  
- Global `SendInput` into other processes (security)  
- Promoting to stable in the same minor  

---

## Consumer notes (when shipped)

- Link `qwinui3_extras` as today; Core is an implementation detail.  
- Strip Qt Virtual Keyboard from `windeployqt` trees as already documented.  
- System IME (Microsoft Pinyin, etc.) remains the default for CJK; this panel is a **touch OSK**, not a replacement IME.
