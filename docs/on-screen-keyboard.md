# On-screen keyboard & in-app IME (1.70…1.77)

Win11 / Fluent **touch keyboard chrome we own**. This is **not** Qt Virtual Keyboard, and it is **not** a hardware-shortcut cookbook ([keyboard.md](keyboard.md)).

**Status:** **1.77** hardware shipped; **1.78** checkpoint records OSK/IME **still experimental**; **1.79** Wayland CapsLock tracking for hardware path (still experimental). **Next:** field-driven `1.80+` or pause.  
**License:** OSK chrome is this repo (LGPL-3.0). SIL Keyman Core (**MIT**) for layouts. Pinyin tables are [mozillazg/pinyin-data](https://github.com/mozillazg/pinyin-data) (**MIT**) — [NOTICE-pinyin.md](NOTICE-pinyin.md). Japanese is a Hepburn romaji→kana map (**no kanji** — no MIT reading lexicon). Korean is Unicode hangul composition (not a lexicon). Keyman `cs_pinyin` IMX is **not** used.

| Slice | What ships |
|-------|------------|
| **1.70** | Win11 dock + en-US letters/symbols (builtin inject) |
| **1.71** | Keyman Core + extra layouts (de/fr/es/ru/ar) — still no candidate window |
| **1.72** | Chinese IME — pinyin composition + **our** candidate bar |
| **1.73** | Full in-app IME — ja romaji/kana, ko hangul, emoji layer, shared candidate host |
| **1.74** | Soak / harden — Gallery checklist + a11y + romaji fixes; **still experimental** |
| **1.75** | Extra documented Keyman `.kmx` — en-GB / it / pt / pl / sv / tr (**named** subset) |
| **1.76** | IME deepen (MIT): pinyin prefix phrases, hangul peel/Space; **ja kanji skipped** |
| **1.77** | App-scoped hardware keys → same engine (**not** OS-wide SendInput) |
| **1.78** | Long-horizon checkpoint |
| **1.79** | Wayland field harden (portal parent + CapsLock); OSK still experimental |

---

## Why this split

Qt Virtual Keyboard is **GPL-3.0 or commercial**. QWinUI3 is **LGPL-3.0**. `Bootstrap::configureEnvironment` already clears `QT_IM_MODULE` so desktop kits do not pull that GPL plugin ([packaging-consumer.md](packaging-consumer.md) strip notes).

A MIT QML keyboard that also ships its own look (SomcoKeyboard, OpenVirtualKeyboard, UnivKbd) would fight Theme tokens and Win11 chrome. We only want their **idea** (in-process OSK), not their UI.

| Piece | Owner | License | Role |
|-------|--------|---------|------|
| Key caps, layers, acrylic dock, Theme | QWinUI3 QML | LGPL-3.0 | Win11-style panel |
| Key → text (shift, caps, dead keys, layouts) | **SIL Keyman Core** (`libkeymancore`) | **MIT** | Engine only — no UI. Builtin en-US fallback if Core is not fetched |
| Insert into the focused control | QWinUI3 C++ adapter | LGPL-3.0 | `QInputMethodEvent` / a few `QKeyEvent`s |
| Qt Virtual Keyboard / `QT_IM_MODULE=qtvirtualkeyboard` | — | GPL / commercial | **Forbidden** |

Engine source: [keymanapp/keyman `core/`](https://github.com/keymanapp/keyman/tree/master/core) ([MIT](https://github.com/keymanapp/keyman/blob/master/LICENSE.md)).  
API: [Keyman Core](https://help.keyman.com/developer/core/current-version/) (`km_core_process_event`, actions). Layouts: [keymanapp/keyboards](https://github.com/keymanapp/keyboards) (community `.kmx`, MIT).  
Notice: [NOTICE-Keyman.md](NOTICE-Keyman.md).

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
           │  km_core_process_event → libkeymancore (MIT, static)  — layouts
           │  PinyinLexicon / RomajiKana / HangulComposer         — in-app IME
           │  fallback: builtin en-US if Core sources are missing
           ▼
  OnScreenKeyboard.qml   ← our Fluent / Win11 chrome (Theme tokens)
  ImeCandidateBar.qml    ← shared candidate strip (zh/ja/ko)
```

Keep `QT_IM_MODULE` unset. Do **not** ship a `platforminputcontexts` plugin in 1.70…1.77 — an in-window dock is enough to theme, test, and stay off the GPL IM module path. Extra languages are more `.kmx` (**1.75**) or MIT IME tables (**1.76**), not a second engine.

---

## Engine choice

**Pick: SIL Keyman Core.** It is a C API keyboard processor: load a keyboard, feed virtual keys, get insert/delete actions. Windows is first-class. UI is explicitly a “platform layer” the consumer writes.

| Candidate | License | UI? | Windows | Why not (or why) |
|-----------|---------|-----|---------|------------------|
| **Keyman Core** | MIT | No | Yes | **Use this** |
| libxkbcommon | MIT | No | Weak | Hardware XKB/Wayland keymaps, not a touch OSK |
| Qt Virtual Keyboard | GPL / commercial | Yes | Yes | **License conflict** |
| SomcoKeyboard / OpenVirtualKeyboard | MIT | Yes (QML) | Yes | We own chrome; do not vendor their QML |

**How we build Core:** sparse-clone `core/` + `common/` via `scripts/fetch_keyman_core.py` into gitignored `third_party/keyman` (`QWINUI3_FETCH_KEYMAN=ON` at configure). CMake target `qwinui3_keymancore` is **static**, `KM_CORE_LIBRARY_STATIC`, **`KMN_NO_ICU=1`**. NFC/NFD uses Qt (`src/extras/keyman_shims/util_normalize_qt.cpp`). LDML regex is stubbed — basic `.kmx` packs do not need it. Do not vendor the Keyman monorepo UI.

---

## UI we write (Win11)

Follow Windows 11 Touch Keyboard: bottom dock, large hit targets, rounded keys, wide Space / Enter / Backspace, light and dark from `Theme`.

| Layer | Keys |
|-------|------|
| Letters | Physical US VKs; labels from `previewVk`; Shift latch / Caps |
| Symbols | Numbers + punctuation |
| Globe | Cycles en-US/GB · de/fr/es/it/pt/pl/sv/tr · ru/ar · zh/ja/ko |
| Emoji | Optional layer (**1.73** shipped) — `commitText` only, no engine |

Tokens: `Theme.bgCard` / `controlFill` / `cornerControl` / `strokeHairline` / `Theme.dp(48)` hit size ([density.md](density.md) · [touch-pointer.md](touch-pointer.md)). Reuse `FluentIcons` for Globe — do not invent a second icon font.

Suggested Extra: `OnScreenKeyboard` (experimental). Host in `Overlay.overlay` or a shell footer; show when a text control is focused **or** when the app sets `visible` (kiosk).

---

## Language & IME ladder

Keyman Core already knows thousands of community keyboards. Extending languages is **load another `.kmx` + draw the matching chrome**, not rewrite Qt Virtual Keyboard.

| Kind | Examples | When | What we add |
|------|----------|------|-------------|
| Direct layouts | en-US/GB, de, fr, es, it, pt, pl, sv, tr, ru, ar | **1.71 + 1.75** | Globe switcher; dead keys via Core; RTL mirroring |
| Composition IME | zh-Hans pinyin | **1.72 shipped** | Preedit + candidate strip (QML we write); MIT pinyin-data |
| More IMEs | ja romaji/kana, ko hangul | **1.73 shipped** | Same candidate host; hangul compositor + romaji map (not Keyman IMX) |
| Soak | zh / ja / ko + 1.71 layouts | **1.74 shipped** | Gallery checklist + a11y; still experimental (not promote-green) |
| Extra layouts | more MIT `.kmx` | **1.75 shipped** | Named subset (en-GB/it/pt/pl/sv/tr) + BYO recipe; not CJK IMX |
| IME deepen | MIT tables only | **1.76 shipped** | Prefix phrases + hangul polish; ja stays kana (no MIT kanji) |
| Not this product | Handwriting, dictation, cloud lexicon, OS-wide IME | Parking lot | — |

**Chinese / CJK** needs a candidate UI we own (Win11). Keyman Core does **not** run Chinese IMX, Japanese Mozc, or Korean dictionaries. zh uses MIT pinyin-data; ja is romaji→kana; ko is 2-beolsik hangul. Kanji conversion is out (no GPL Mozc, no hand-written 词库).

**Honest limit:** this is an **in-app** IME for QWinUI3 fields. It does not replace Microsoft Pinyin for the whole desktop, and 1.73–1.76 will not match a cloud IME’s phrase quality.

System IME remains available alongside the panel until a later minor explicitly documents otherwise.

## 1.70 (shipped)

**In**

- Experimental `OnScreenKeyboard` + `KeyboardEngine` inject adapter  
- en-US letters + Shift/Caps + symbols; dark/light (builtin backend)  
- Gallery footer dock + this recipe  
- Same inject path Keyman Core uses in **1.71** (`engine.backend`)  

**Out**

- Qt Virtual Keyboard / any GPL IM plugin  
- Vendoring third-party QML keyboards  
- Extra layouts / CJK IME (**1.71…1.76**)  
- Handwriting, dictation  
- Global `SendInput` into other processes (security)  
- Promoting to stable in the same minor  

## 1.71 (shipped)

**In**

- Static-link SIL Keyman Core (`qwinui3_keymancore`) when sources are fetched  
- Bundled `.kmx`: `basic_kbdus`, `basic_kbdgr`, `basic_kbdfr`, `basic_kbdes`, `basic_kbdru`, `basic_kbda1`  
- Globe key + Gallery ComboBox; `LayoutMirroring` on Arabic  
- `KeyboardEngine.backend` is `"keyman"` when Core is linked; `"builtin"` otherwise  

**Out**

- Candidate window / pinyin (**1.72**)  
- ICU / meson (we use `KMN_NO_ICU` + Qt normalize)  
- Qt Virtual Keyboard  

### Add a layout pack

1. Drop a MIT `.kmx` in `src/extras/QWinUI3/Extras/keyboards/`.  
2. Add the file to `qt_add_resources` in `src/extras/QWinUI3/Extras/CMakeLists.txt`.  
3. Map a layout id → filename in `KeyboardEngine` (`kLayoutIds` + `kmxResource`).  

---

## 1.72 (shipped)

**In**

- zh-Hans on the globe; `engine.backend === "pinyin"`  
- Preedit via `QInputMethodEvent` + `ImeCandidateBar` (Theme tokens)  
- Lexicon generated from mozillazg **pinyin-data** / **phrase-pinyin-data** (MIT) — not a hand-written table, not GPL libpinyin, not Keyman IMX  
- Space / 1–9 / tap confirm; honest limit: in-app, not Microsoft Pinyin quality  

**Out**

- ja / ko (**1.73 shipped**)  
- Cloud lexicon / handwriting  
- Replacing the desktop OS IME  

---

## 1.73 (shipped)

**In**

- ja-JP on the globe; `engine.backend === "romaji"` — Hepburn longest-match → hiragana; katakana as second candidate; Space / 1–2 / tap confirm  
- ko-KR on the globe; `engine.backend === "hangul"` — 2-beolsik on US VKs; Unicode syllable compose; incomplete cluster as preedit  
- Shared `ImeCandidateBar` for zh/ja/ko  
- Emoji layer (`FluentIcons.Emoji`); `commitText` only  
- Gallery ComboBox language matrix (en/de/fr/es/ru/ar/zh/ja/ko)  
- Shipped Keyman packs remain the **1.71** set (`basic_kbdus/gr/fr/es/ru/da1`). Further `.kmx` is bring-your-own (see 1.71 “Add a layout pack”). ja/ko are **not** extra Keyman packs  

**Out**

- OS-wide IME / `platforminputcontexts`  
- Kanji / hangul-word dictionaries (Mozc, Anthy, libhangul dicts)  
- Cloud lexicon / handwriting / dictation  
- Promote to stable  

1.73 architecture:

```text
  TextField  ←  QInputMethodEvent (preedit + commit)
  ImeCandidateBar.qml     ← our Win11 candidate strip
  OnScreenKeyboard.qml    ← same Fluent dock + emoji layer
  KeyboardEngine          ← pinyin (MIT) / romaji-kana / hangul / km_core_process_event
  libkeymancore (MIT)     ← layouts only; CJK is not Keyman IMX
```

---

## Consumer notes (when shipped)

- Link `qwinui3_extras` as today; `OnScreenKeyboard` is experimental.  
- First configure fetches Core unless `QWINUI3_FETCH_KEYMAN=OFF`.  
- Strip Qt Virtual Keyboard from `windeployqt` trees as already documented.  
- Through **1.71** this panel is a touch OSK; **1.72** adds in-app pinyin; **1.73** adds ja/ko + emoji. System IME (Microsoft Pinyin, etc.) stays the desktop CJK default.  
- `KeyboardEngine.backend` is `"pinyin"` / `"romaji"` / `"hangul"` on those layouts, `"keyman"` when Core is linked for direct layouts, `"builtin"` if you skipped the fetch.

---

## 1.74 (shipped) — soak

**Verdict:** soak **written** for manual Gallery verification. **Not** promote-green. `OnScreenKeyboard` stays experimental.

**Shipped**

- Gallery **On-screen keyboard** language-matrix checklist (en/de/fr/es/ru/ar/zh/ja/ko + emoji + backend readout)
- `ImeCandidateBar` accessible names for composition, candidates (`Candidate N …`), page buttons; description mentions Space / 1–9
- Romaji: finalize trailing `n` → `ん` on display / candidates / pick; small kana (`xtu`/`xa`/…), `ye`/`wi`/`we`, `v*`/`f*`
- `keyboards/README.md` lists shipped `.kmx` vs BYO three-step; IME backends named

**Manual checklist** (Gallery footer dock)

- [ ] en-US letters / Shift / Caps / symbols (`keyman` or `builtin`)
- [ ] de / fr / es / ru labels; ar RTL
- [ ] 中文 `nihao` + Space/1–9; `nv` → 女
- [ ] 日本語 `konnichiwa`; trailing `n` → ん; `xtu` → っ; hiragana + katakana
- [ ] 한국어 2-beolsik `dkssud` → 안녕; Shift doubles; incomplete cluster preedit
- [ ] Emoji layer; keys never steal focus
- [ ] Candidate bar page buttons when many pinyin hits

**Out**

- Promote to stable  
- Extra `.kmx` (**1.75 shipped**) / kanji (**1.76**) / OS IME  

## 1.75 (shipped) — extra Keyman packs

**Shipped**

- Named MIT subset (not every keyboard): `basic_kbduk` (en-GB), `basic_kbdit`, `basic_kbdpo`, `basic_kbdpl`, `basic_kbdsw`, `basic_kbdtuq` (tr-TR Turkish-Q)
- Globe / Gallery ComboBox; full shipped table in `src/extras/QWinUI3/Extras/keyboards/README.md`
- Re-fetch: `python scripts/fetch_keyman_keyboards.py`
- Still `engine.backend === "keyman"` for these; Arabic RTL and 1.71 packs unchanged

**Out**

- Vendoring the whole keymanapp/keyboards tree  
- CJK via Keyman IMX  
- IME deepen (**1.76**)  

## 1.76 (shipped) — IME deepen (MIT-only)

**Shipped**

- zh: regenerated mozillazg MIT tables (phrases 2–6 chars, more candidates); **prefix phrase** lookup (
iha → 你好); consumeLength for partial picks
- ko: Backspace peels compound vowels (ㅘ/ㅙ/ㅚ/ㅝ/ㅞ/ㅟ/ㅢ) and double finals; Space commits + inserts a word break; Caps does not double jamo (Shift only)
- ja: extra Hepburn rows (thi/dhi/ts*/wh*/fyu…); **kanji not shipped** — JMdict / KANJIDIC are CC-BY-SA, not MIT. Gap is intentional under the MIT-only rule

**Out**

- Mozc / Anthy / libpinyin / hand-written 词库  
- Promote to stable

## 1.77 (shipped) — app hardware input

**Shipped**

- KeyboardEngine.hardwareInput (default **on**) — physical keys in this process feed processVk / Keyman (AltGr supported)
- Candidate keys: 1–9, Esc cancel, PageUp/PageDown page
- Ctrl / Meta shortcuts pass through; Gallery Switch to disable
- Honest limit: **in-app only**. No SendInput into other processes. Not a desktop IME replacement.

**Out**

- OS-wide / system input method
- platforminputcontexts plugin

