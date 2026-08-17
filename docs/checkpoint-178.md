# Long-horizon checkpoint (1.78)

Close-out audit of the **1.49…1.78** arc (keyboard soak / packs / deepen / hardware slipped the old 1.74 checkpoint here). **Still 1.xx — not 2.00.**

Earlier: [maturity-1xx.md](maturity-1xx.md) (1.51) · [checkpoint-160.md](checkpoint-160.md) (1.60 mid-horizon) · [compatibility-1xx.md](compatibility-1xx.md) · [stable-api.md](stable-api.md) · [on-screen-keyboard.md](on-screen-keyboard.md) · [ROADMAP.md](../ROADMAP.md).

---

## Verdict

| Question | Answer (1.78) |
|----------|----------------|
| Stay on **1.xx**? | **Yes** — do **not** draft 2.00 |
| Next posture? | **Prefer field harden / pause vs new surfaces** — open `1.79+` only for field-driven P0s or park |
| Promote OSK / IME to stable? | **No** — stayed **experimental** through **1.74** soak, **1.76** deepen, **1.77** hardware |
| Reorder parking lot into mega-minors? | **No** — keep named, one-theme slices |
| Freeze (1.40)? | **Still active** — no silent Theme / shell / stable renames |

---

## Audit snapshot (1.78)

| Check | Result |
|-------|--------|
| Recipe + ROADMAP `docs/*.md` links | **OK** (`python scripts/check_docs_links.py`) |
| Gallery catalog page ids | **~196** |
| Component docs (`docs/components/*.md`) | **225** pages · **214** public (`docs/components.json`) |
| Product version | **1.78** |
| Starter path | Still **`examples/gallery-shell`** (+ **`examples/multi-window`**) |
| Stable map vs Gallery | Stable list = product contract; Gallery also demos experimental (incl. OSK) — unlisted public types stay experimental |

### Absorbed since 1.60 (theme summary)

| Slice | Theme |
|-------|--------|
| **1.61…1.69** | CMake sketch → visual smoke → a11y / Theme prefs (see ROADMAP) |
| **1.70** | Win11 OSK (en-US builtin) |
| **1.71** | Keyman Core + de/fr/es/ru/ar |
| **1.72** | zh-Hans pinyin + candidate bar |
| **1.73** | ja romaji/kana + ko hangul + emoji |
| **1.74** | OSK/IME soak (checklist written; **not** promote-green) |
| **1.75** | Named Keyman `.kmx` subset |
| **1.76** | MIT-only IME deepen; ja kanji gap documented |
| **1.77** | App-scoped hardware input (**not** OS-wide) |
| **1.78** | This long-horizon checkpoint |

---

## OSK / IME status (explicit)

| Milestone | Promote? |
|-----------|----------|
| **1.74** soak | Checklist for Gallery — **did not** promote |
| **1.76** deepen | Stronger MIT IME — **still experimental** |
| **1.77** hardware | In-app physical keys — **still experimental** |
| **1.78** (now) | Record: **stay experimental** until a later named minor runs a **green** soak and says promote |

Honest limits remain: in-app only; no `SendInput` into other processes; no GPL Mozc; ja is kana-only (no MIT kanji lexicon).

---

## Posture for `1.79+`

Until a later checkpoint says otherwise:

1. **Ship on stable** — Theme tokens, shells, types on [stable-api.md](stable-api.md).
2. **Copy `gallery-shell`**, not the full Gallery tree.
3. **Field harden first** — portal / DPI / tray / WebView2 / packaging / IME regressions beat new control families. (**1.79** shipped Wayland portal / session / CapsLock harden.)
4. **Pause is OK** — if no field P0s, prefer docs / soak / parking-lot polish over inventing surfaces.
5. **Promote only in named minors** — update stable-api changelog; OSK promote needs an explicit green soak.
6. **Do not draft 2.00** — breaking Theme / shell / stable renames stay parked for a future major.

Unscheduled candidates (accessibility wave 3, IME promote, locale packs, Lottie deepen, vcpkg/Conan, macOS) stay on the ROADMAP parking lot — pick only inside a named minor.

---

## Consumer checklist

- [ ] Pin / rebuild **1.79** Release (or **1.78** if you have not taken the Wayland harden yet)
- [ ] Skim [upgrade-notes.md](upgrade-notes.md) `1.78` → `1.79`
- [ ] Prefer [stable-api.md](stable-api.md) + `examples/gallery-shell`
- [ ] Treat `OnScreenKeyboard` as **experimental** unless a later minor promotes it
- [ ] Optional: `python scripts/smoke_gallery.py --build-dir build --platform windows`

---

## Re-run audits

```bat
python scripts/check_docs_links.py
```
