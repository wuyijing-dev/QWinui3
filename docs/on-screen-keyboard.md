# On-screen keyboard & in-app IME (1.70…1.73)

Win11 / Fluent **touch keyboard chrome we own**. This is **not** Qt Virtual Keyboard, and it is **not** a hardware-shortcut cookbook ([keyboard.md](keyboard.md)).

**Status:** **1.70 shipped** (en-US OSK, experimental, **builtin** inject). **1.71…1.73** still planned (layouts → Chinese IME → full in-app IME).  
**License:** 1.70 engine + UI are this repo (LGPL-3.0). SIL Keyman Core (**MIT**) is the layout engine from **1.71** — not linked in 1.70.

| Slice | What ships |
|-------|------------|
| **1.70** | Win11 dock + en-US letters/symbols |
| **1.71** | Extra layouts (de/fr/es/ru/RTL…) — still no candidate window |
| **1.72** | Chinese IME — pinyin composition + **our** candidate bar |
| **1.73** | Full in-app IME — ja / ko + more Keyman packs, shared candidate host |
| **1.74** | Long-horizon checkpoint (not IME work) |

---

## Why this split

Qt Virtual Keyboard is **GPL-3.0 or commercial**. QWinUI3 is **LGPL-3.0**. `Bootstrap::configureEnvironment` already clears `QT_IM_MODULE` so desktop kits do not pull that GPL plugin ([packaging-consumer.md](packaging-consumer.md) strip notes).

A MIT QML keyboard that also ships its own look (SomcoKeyboard, OpenVirtualKeyboard, UnivKbd) would fight Theme tokens and Win11 chrome. We only want their **idea** (in-process OSK), not their UI.

| Piece | Owner | License | Role |
|-------|--------|---------|------|
| Key caps, layers, acrylic dock, Theme | QWinUI3 QML | LGPL-3.0 | Win11-style panel |
| Key → text (shift, caps, dead keys, layouts) | **SIL Keyman Core** (`libkeymancore`) from **1.71** | **MIT** | Engine only — no UI. **1.70** uses builtin en-US in `KeyboardEngine` |
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
           │  QKeyEvent for Enter / Tab / Backspace
           │
  KeyboardEngine  (C++, QML_ELEMENT)     ← our adapter
           │
           │  1.70: builtin en-US (this repo)
           │  1.71+: km_core_process_event → libkeymancore (MIT)
           ▼
  OnScreenKeyboard.qml   ← our Fluent / Win11 chrome (Theme tokens)
```

Keep `QT_IM_MODULE` unset. Do **not** ship a `platforminputcontexts` plugin in 1.70…1.73 — an in-window dock is enough to theme, test, and stay off the GPL IM module path. Language packs are extra `.kmx` files + UI, not a second engine.

---

## Engine choice

**Pick: SIL Keyman Core.** It is a C API keyboard processor: load a keyboard, feed virtual keys, get insert/delete actions. Windows is first-class. UI is explicitly a “platform layer” the consumer writes.

| Candidate | License | UI? | Windows | Why not (or why) |
|-----------|---------|-----|---------|------------------|
| **Keyman Core** | MIT | No | Yes | **Use this** |
| libxkbcommon | MIT | No | Weak | Hardware XKB/Wayland keymaps, not a touch OSK |
| Qt Virtual Keyboard | GPL / commercial | Yes | Yes | **License conflict** |
| SomcoKeyboard / OpenVirtualKeyboard | MIT | Yes (QML) | Yes | We own chrome; do not vendor their QML |

**1.70** ships a builtin en-US map so the dock types without fetching Core. **1.71** should FetchContent / vendor **only** `core/` (`libkeymancore`), not the whole Keyman monorepo. Same `KeyboardEngine` inject API.

---

## UI we write (Win11)

Follow Windows 11 Touch Keyboard: bottom dock, large hit targets, rounded keys, wide Space / Enter / Backspace, light and dark from `Theme`.

| Layer | Keys |
|-------|------|
| Letters | QWERTY; Shift latch / Caps |
| Symbols | Numbers + punctuation |
| Optional later | Emoji panel (**1.73**, no engine required) |

Tokens: `Theme.bgCard` / `controlFill` / `cornerControl` / `strokeHairline` / `Theme.dp(48)` hit size ([density.md](density.md) · [touch-pointer.md](touch-pointer.md)). Reuse `FluentIcons` for Backspace / Enter / Shift — do not invent a second icon font.

Suggested Extra: `OnScreenKeyboard` (experimental). Host in `Overlay.overlay` or a shell footer; show when a text control is focused **or** when the app sets `visible` (kiosk).

---

## Language & IME ladder

Keyman Core already knows thousands of community keyboards. Extending languages is **load another `.kmx` + draw the matching chrome**, not rewrite Qt Virtual Keyboard.

| Kind | Examples | When | What we add |
|------|----------|------|-------------|
| Direct layouts | en, de, fr, es, ru, ar | **1.71** | Globe switcher; dead keys / AltGr; RTL mirroring |
| Composition IME | zh-Hans pinyin | **1.72** | Preedit + candidate strip (QML we write) |
| More IMEs | ja romaji/kana, ko hangul | **1.73** | Same candidate host; extra packs |
| Not this product | Handwriting, dictation, cloud lexicon, OS-wide IME | Parking lot | — |

**Chinese / CJK** is a later slice because a layout key is not enough: the user types `zhong`, sees candidates, then commits 中. That candidate UI is ours (Win11), the mapping stays in Core.

**Honest limit:** this is an **in-app** IME for QWinUI3 fields. It does not replace Microsoft Pinyin for the whole desktop, and 1.73 will not match a cloud IME’s phrase quality.

System IME remains available alongside the panel until a later minor explicitly documents otherwise.

## 1.70 (shipped)

**In**

- Experimental `OnScreenKeyboard` + `KeyboardEngine` inject adapter  
- en-US letters + Shift/Caps + symbols; dark/light (builtin backend)  
- Gallery footer dock + this recipe  
- Same inject path Keyman Core will use in **1.71** (`engine.backend`)  

**Out**

- Qt Virtual Keyboard / any GPL IM plugin  
- Vendoring third-party QML keyboards  
- Extra layouts / CJK IME (**1.71…1.73**)  
- Handwriting, dictation  
- Global `SendInput` into other processes (security)  
- Promoting to stable in the same minor  

---

## 1.71…1.73 (named on the roadmap)

Full in/out/exit lists live in [ROADMAP.md](../ROADMAP.md). Short form:

- **1.71** — extra `.kmx` + globe language switcher; dead keys / RTL; **no** candidate list yet  
- **1.72** — zh-Hans pinyin preedit + candidate bar (QML we write); ja/ko wait  
- **1.73** — ja/ko + documented pack subset + optional emoji; still experimental unless soak is written  

1.72+ architecture adds a candidate host next to the dock:

```text
  TextField  ←  QInputMethodEvent (preedit + commit)
  ImeCandidateBar.qml     ← our Win11 candidate strip
  OnScreenKeyboard.qml    ← same Fluent dock
  KeyboardEngine          ← km_core_process_event
  libkeymancore (MIT)
```

---

## Consumer notes (when shipped)

- Link `qwinui3_extras` as today; `OnScreenKeyboard` is experimental.  
- Strip Qt Virtual Keyboard from `windeployqt` trees as already documented.  
- Through **1.70 / 1.71** this panel is a touch OSK; system IME (Microsoft Pinyin, etc.) stays the CJK default.  
- From **1.72** the panel can compose Hanzi **in-app** — it still does not replace the desktop OS IME.  
- `KeyboardEngine.backend` is `"builtin"` in 1.70; `"keyman"` when Core is linked (1.71+).
