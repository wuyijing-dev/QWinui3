# Consumer upgrade notes (1.40)

How to move a product app between **QWinUI3 `1.xx` minors** without surprises.

**Compatibility contract:** [compatibility-1xx.md](compatibility-1xx.md).  
**Stable types:** [stable-api.md](stable-api.md).  
**Qt floors:** [qt-version-compat.md](qt-version-compat.md).

---

## Template (copy per release)

Use this block when you ship a tagged `vX.YY` that consumers must react to. Skip rows that are N/A.

```markdown
## Upgrade X.YY → X.ZZ

**Product version:** X.ZZ (`QWINUI3_VERSION`)  
**Date:** YYYY-MM-DD  
**Qt:** still 6.5+ / recommended 6.8 (change only if true)

### Action required
| Area | Change | What to do |
|------|--------|------------|
| … | … | … |

### Optional / polish
- …

### No action (compatible)
- Stable Theme / shell / control APIs unchanged for this slice.
```

Maintainers: append a filled section below when a slice has consumer-visible breaks or important opt-ins. Pure docs / Gallery-only / additive defaults usually need only a one-line **No action** note.

---

## Checklist (every upgrade)

1. Bump / reinstall the kit (`QWINUI3_VERSION` / Release zip / `add_subdirectory` pin).
2. Confirm Qt major/minor still matches your linked kit — [packaging-consumer.md](packaging-consumer.md).
3. Skim [stable-api.md](stable-api.md) changelog for new **promotes** or **defer** notes.
4. Rebuild Release; run your smoke / Gallery `--smoke` if you vendor the Gallery binary.
5. If you fork Theme colors: keep using `customAccent` / packs — do not assign readonly `bgCard` etc.

---

## Recent minors (filled)

### Upgrade 1.90 → 2.00 (draft)

**Status:** **Draft only** — breaks ship in **2.00**, not in 1.90. Inventory finalized in [checkpoint-190.md](checkpoint-190.md).

**Product version target:** 2.00  
**Qt:** floor **6.8 LTS** (drop **6.5**); forward **6.10+** OK — [qt-version-compat.md](qt-version-compat.md)

#### Action required (at 2.00)

| Area | Change | What to do |
|------|--------|------------|
| **Qt** | Minimum **6.8** | Raise CI / installer Qt; rebuild Release; re-run deploy (`windeployqt` / `linuxdeploy`) |
| **Theme tokens** | Collapse duplicate stroke/focus aliases (exact list in 2.00 release notes) | Grep your app for legacy focus/stroke names; apply remap table from 2.00 tag |
| **Shell aliases** | Remove Gallery-era compatibility aliases | Prefer `NavigationWindow` / `StandardWindow` / documented Extras shells — [window-shells.md](window-shells.md) |
| **Experimental types** | Still experimental after **2.01** OSK may be promoted, moved, or removed | Pin 1.90 if you depend on undocumented experimental APIs |

#### Optional / polish

- Skim [performance.md](performance.md) arc (1.86…1.89) before tuning on the new floor.
- OSK / IME promote and consumer packaging: **2.01+**, not 2.00 by default — [ROADMAP.md](../ROADMAP.md).

#### Stay on 1.90 if

- You must keep **Qt 6.5** in production.
- You need the current 1.xx Theme / shell names without a migration window.

### Upgrade 1.89 → 1.90

**Product version:** 1.90  
**Date:** 2026-08-17  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **1.xx close-out:** [checkpoint-190.md](checkpoint-190.md) — docs audit, perf arc sign-off, **2.00 prep draft** (no breaking code).
- **Performance arc:** all four waves (1.86…1.89) documented in [performance.md](performance.md); smoke timing remains advisory — [ci-smoke.md](ci-smoke.md).

#### No action (compatible)

- Theme / shell / stable control APIs unchanged. **1.xx freeze ends at 2.00**, not at 1.90. Next planned major: **2.00** (after this tag).

### Upgrade 1.88 → 1.89

**Product version:** 1.89  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Performance wave 4 (style/charts):** ElevatedChrome shadow defer; Style idle Behavior trim; chart reveal budget + coalesced redraw; Gallery heavy-page deferrals. [performance.md](performance.md).

#### No action (compatible)

- Theme / shell API unchanged. Interaction animations unchanged. Next: **1.90** close-out.

### Upgrade 1.87 → 1.88

**Product version:** 1.88  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Performance wave 3 (lists):** `DataTable` debounces filter rebuilds; `ItemsView` / `ListDetailsView` / `ItemsRepeater` optional `filterText` on JS arrays. [performance.md](performance.md).

#### No action (compatible)

- Theme / shell API unchanged. Animations unchanged. Next: **1.89** style/charts perf wave.

### Upgrade 1.86 → 1.87

**Product version:** 1.87  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Performance wave 2 (navigation):** `NavigationView` StackView transitions skip no-op x/y/scale animators per mode (slide/fade look the same). Compact flyout defers shadow until open. `TabView` idle tab strip behaviors trimmed. Gallery Settings **Performance arc** card. [performance.md](performance.md).

#### No action (compatible)

- Theme / shell API unchanged. Pane collapse animation unchanged. Next: **1.88** lists perf wave.

### Upgrade 1.85 → 1.86

**Product version:** 1.86  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- **Performance wave 1 (shell):** Solid `StandardWindow` hosts clear with layer fill (not `Qt::white`); Windows `DWMWA_BORDER_COLOR` matches fill; Solid windows skip focus-in DWM timer bursts (restore feels snappier). [performance.md](performance.md) · [window-chrome.md](window-chrome.md).

#### No action (compatible)

- Theme / shell API unchanged. OSK stays experimental. Next: **1.87** navigation perf wave.

### Upgrade 1.84 → 1.85

**Product version:** 1.85  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- ContentDialog / Flyout / CommandBarFlyout return focus to the opener on close. InfoBar announces on open (`Accessible.announce` on Qt 6.8+). ImeCandidateBar announces candidates without taking focus. Gallery **Accessibility** wave 3 sample. [accessibility.md](accessibility.md).

#### No action (compatible)

- Theme / shell / stable control APIs unchanged. OSK stays experimental.

### Upgrade 1.83 → 1.84

**Product version:** 1.84  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Copy [`examples/floating-osk`](../examples/floating-osk/) for `OnScreenKeyboardWindow` (not the Gallery). Keyman Core is in `third_party/keyman` with the clone. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.82 → 1.83

**Product version:** 1.83  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: floating host no-activate soak (`WM_MOUSEACTIVATE` / no `raise()`); long-press flyout stays in-window on Qt 6.8+. Gallery checklist vs dock. Honest limits: elevated / UIPI / UWP / games may ignore `SendInput`. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Theme / shell / stable controls unchanged. OSK stays experimental. Docked `systemWide` still defaults **off**.

### Upgrade 1.81 → 1.82

**Product version:** 1.82  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: `OnScreenKeyboardWindow` floating host; Windows `SendInput` into the focused desktop app (`systemWide`, default **on** for the floating window; dock stays off). [on-screen-keyboard.md](on-screen-keyboard.md).
- Gallery: removed unused `--visual-smoke` / `scripts/smoke_visual.py` (1.62 opt-in subset). CI `--smoke` unchanged. [ci-smoke.md](ci-smoke.md).

#### No action (compatible)

- Theme / shell / stable controls unchanged. OSK stays experimental. Docked `OnScreenKeyboard.systemWide` still defaults **off**.

### Upgrade 1.80 → 1.81

**Product version:** 1.81  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: Windows **11** behavior (not Win10 classic) — long-press digit hints + punctuation alt flyout, `keyboardSize` Small/Default/Large, clipboard strip, emoji category chips, rounder press-scale keys. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.79 → 1.80

**Product version:** 1.80  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: Win11 default touch **layout** chrome (Esc/Tab/dual Shift, lang chip 英/中/あ/한, number hints, settings/grab/close). `navigateKey` / `pasteClipboard` on `KeyboardEngine`. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Theme / shell / stable controls unchanged. OSK stays experimental. Mic / Win keys remain chrome-only.

### Upgrade 1.78 → 1.79

**Product version:** 1.79  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Linux / Wayland: stronger portal `parent_window` (Qt `portalWindowIdentifier` when GuiPrivate is available; window realized before export); Bootstrap detects `WAYLAND_SOCKET`; experimental OSK CapsLock tracking on Linux. [platform-linux-wayland.md](platform-linux-wayland.md).

#### No action (compatible)

- Theme / shell / stable controls unchanged. OSK stays experimental. Rebuild Linux kits with `qt*-private-dev` / GuiPrivate for the best Wayland parent export.

### Upgrade 1.77 → 1.78

**Product version:** 1.78  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Docs / posture

- Long-horizon checkpoint: [checkpoint-178.md](checkpoint-178.md). Prefer **field harden / pause vs new surfaces**; `1.79+` only for field-driven P0s or park. OSK/IME **stays experimental** (not promoted in 1.74 / 1.76 / 1.77).

#### No action (compatible)

- Theme / shell / stable controls unchanged. Freeze (1.40) still active.

### Upgrade 1.76 → 1.77

**Product version:** 1.77  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: `hardwareInput` (default on) routes physical keyboard keys in **this app** through the same engine as the dock. Not OS-wide. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental. Set `hardwareInput: false` to leave keys to the system IME.

### Upgrade 1.75 → 1.76

**Product version:** 1.76  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK IME deepen (MIT-only): pinyin prefix phrases + regenerated tables; hangul compound peel / Space word-break; Japanese stays kana — kanji skipped (no MIT lexicon). [on-screen-keyboard.md](on-screen-keyboard.md) · [NOTICE-pinyin.md](NOTICE-pinyin.md).

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.74 → 1.75

**Product version:** 1.75  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: more Keyman layouts — English (UK), Italiano, Português, Polski, Svenska, Türkçe. Re-fetch with `python scripts/fetch_keyman_keyboards.py`. [on-screen-keyboard.md](on-screen-keyboard.md) · [NOTICE-Keyman.md](NOTICE-Keyman.md).

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.73 → 1.74

**Product version:** 1.74  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK soak: Gallery language-matrix checklist, candidate-bar a11y, romaji trailing-`n` / small kana. Still experimental — not promoted. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.72 → 1.73

**Product version:** 1.73  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: **日本語** (romaji→kana) and **한국어** (2-beolsik hangul) share `ImeCandidateBar`. Emoji layer has no engine. Keyman Core is still layouts only. [on-screen-keyboard.md](on-screen-keyboard.md).

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.71 → 1.72

**Product version:** 1.72  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental OSK: switch to **中文** for in-app pinyin (`ImeCandidateBar`). Lexicon is MIT pinyin-data, not Microsoft Pinyin. [on-screen-keyboard.md](on-screen-keyboard.md) · [NOTICE-pinyin.md](NOTICE-pinyin.md).

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.70 → 1.71

**Product version:** 1.71  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental `OnScreenKeyboard` now feeds **SIL Keyman Core** (MIT, static). Globe / ComboBox switches en/de/fr/es/ru/ar `.kmx`. [on-screen-keyboard.md](on-screen-keyboard.md) · [NOTICE-Keyman.md](NOTICE-Keyman.md).
- Configure fetches Core into gitignored `third_party/keyman` (`scripts/fetch_keyman_core.py`, `QWINUI3_FETCH_KEYMAN`). Without it, `engine.backend` stays `"builtin"`.
- Still not Qt Virtual Keyboard; `QT_IM_MODULE` stays unset.

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK stays experimental.

### Upgrade 1.69 → 1.70

**Product version:** 1.70  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental `OnScreenKeyboard` dock + `KeyboardEngine` (en-US). Host in a shell footer / `CatalogPage.footer`. [on-screen-keyboard.md](on-screen-keyboard.md).
- Do not enable Qt Virtual Keyboard; `QT_IM_MODULE` stays unset.

#### No action (compatible)

- Existing Theme / shell / stable controls unchanged. OSK is additive and experimental.

### Upgrade 1.68 → 1.69

**Product version:** 1.69  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Theme knobs are kit-wide: drop `ThemeAppearanceSettings` on your Settings page; copy `Theme.recipeText()` into another app. Shells run `ThemeSync` (follow system a11y / color). [theme-overrides.md](theme-overrides.md).
- Persist Theme with `ThemePrefs` (`persist: true`) — keep geometry on `geometryPersistenceKey`.

#### No action (compatible)

- Existing `Theme.dark` / `followSystem*` assignments still work. Gallery Main no longer special-cases OS sync.

### Upgrade 1.67 → 1.68

**Product version:** 1.68  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Linux portal harden: [platform-linux-wayland.md](platform-linux-wayland.md) / [system-integration.md](system-integration.md) — FilePicker no longer falls back to zenity after a portal timeout; filters + save `current_name`; reveal OpenURI fallback; `WindowHelper.portalParentWindow()`.
- Gallery **System integration** live `parent_window` readout.

#### No action (compatible)

- FilePicker QML signatures unchanged. Pass `Window.window` as before.

### Upgrade 1.66 → 1.67

**Product version:** 1.67  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Media cookbook: [media.md](media.md) — soak checklist + **honest defer** for remaining 1.xx (`MediaPlayerElement` stays experimental).
- Gallery **MediaPlayerElement** decision callout.

#### No action (compatible)

- No promote; stub / real player behavior unchanged. Apps already using Multimedia keep the same API.

### Upgrade 1.65 → 1.66

**Product version:** 1.66  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Charts cookbook: [charts.md](charts.md) — remaining siblings/gauges **deferred** for remaining 1.xx (prefer Line/Bar/Donut + RingGauge + KpiTile + ChartCard).
- Gallery **Charts** / **Dashboard** hubs split stable vs deferred; `examples/dashboard` now uses all six stable types.

#### No action (compatible)

- Stable six unchanged; no new chart engine. Deferred types still ship (experimental).

### Upgrade 1.64 → 1.65

**Product version:** 1.65  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Settings persistence cookbook: [settings-persistence.md](settings-persistence.md) — `Settings` / QSettings, portable Ini, honest “roaming”, `schemaVersion`; keep geometry on `geometryPersistenceKey`.
- Gallery **Settings persistence**; examples `form-settings` + `gallery-shell` prefs.

#### No action (compatible)

- Docs + Gallery / example patterns only; no Theme or shell API breaks.

### Upgrade 1.63 → 1.64

**Product version:** 1.64  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Security & trust cookbook: [security-trust.md](security-trust.md) — WebView2 user-data / app-side URL allowlists, FileDropZone filters, FilePicker ownership (not a sandbox product).
- Gallery **Security & trust** + Pitfalls / WebView2 / FileDropZone callouts.

#### No action (compatible)

- Docs + Gallery only; WebView2Host / FileDropZone APIs unchanged.

### Upgrade 1.62 → 1.63

**Product version:** 1.63  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Print / share / export cookbook: [print-share.md](print-share.md) — grabToImage → FilePicker.saveFile → revealFileInFolder; optional app-side PrintSupport.
- Gallery **Print / share / export** interactive demo.

#### No action (compatible)

- Docs + Gallery only; no new kit PrintSupport dependency.

### Upgrade 1.61 → 1.62

**Product version:** 1.62  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Visual smoke subset: `python scripts/smoke_visual.py --build-dir build` (Gallery `--visual-smoke`); [ci-smoke.md](ci-smoke.md).
- Not part of default `smoke_gallery.py` — keep CI fast. Hash `--compare` is best-effort.

#### No action (compatible)

- Default `--smoke` path unchanged.

### Upgrade 1.60 → 1.61

**Product version:** 1.61  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- `find_package(QWinUI3 CONFIG)` sketch: [packaging-consumer.md](packaging-consumer.md) Path C; shared zips ship `lib/cmake/QWinUI3/` + `include/QWinUI3/Bootstrap.h`.
- Tiny consumer: `examples/find-package-consumer/`; verify with `python scripts/verify_find_package.py`.
- **Not** an official vcpkg/Conan port.

#### No action (compatible)

- Existing Path A / `add_subdirectory` flows unchanged; Config is additive in packages.

### Upgrade 1.59 → 1.60

**Product version:** 1.60  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Mid-horizon checkpoint: [checkpoint-160.md](checkpoint-160.md) — still 1.xx; 1.61+ order confirmed.
- Gallery **Pitfalls** mid-horizon checklist; smoke critical pages include Search recipes + High-DPI.

#### No action (compatible)

- Docs / Gallery / smoke list only; APIs unchanged.

### Upgrade 1.58 → 1.59

**Product version:** 1.59  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- In-app search cookbook: [search.md](search.md) — AutoSuggestBox / SearchBox / filter-above vs CommandPalette.
- Gallery **Search recipes** interactive demo; AutoSuggest / SearchBox / commands cross-links.

#### No action (compatible)

- Docs + Gallery only; existing controls unchanged.

### Upgrade 1.57 → 1.58

**Product version:** 1.58  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- High-DPI / multi-monitor cookbook: [high-dpi.md](high-dpi.md); Gallery **High-DPI & monitors** readout.
- Geometry restore now `setScreen`s after clamp so mixed-DPI DPR updates ([window-helper.md](window-helper.md)).

#### No action (compatible)

- Additive restore behavior + docs; existing keys unchanged.

### Upgrade 1.56 → 1.57

**Product version:** 1.57  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Touch / pen cookbook: [touch-pointer.md](touch-pointer.md) — target floors, scroll vs drag, stylus hover notes.
- Gallery **Touch & pointer** page + callouts on Button / Slider / Nav / FileDropZone / SwipeControl; density & a11y cross-links.

#### No action (compatible)

- Docs + Gallery only; no new input stack.

### Upgrade 1.55 → 1.56

**Product version:** 1.56  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Multi-window recipe: secondary `ToolShellWindow` / owned `DialogShellWindow`, distinct `geometryPersistenceKey`s, shared Theme — [window-shells.md](window-shells.md).
- Runnable [`examples/multi-window`](../examples/multi-window/); Gallery **Multi-window** page.

#### No action (compatible)

- Additive example + docs; existing single-window shells unchanged.

### Upgrade 1.54 → 1.55

**Product version:** 1.55  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Gallery **Onboarding coach** — sequenced `TeachingTip`s, focus handoff, “don’t show again” via `QtCore.Settings` — [feedback.md](feedback.md).
- Cross-links in [keyboard.md](keyboard.md) / [dialogs-flyouts.md](dialogs-flyouts.md).

#### No action (compatible)

- Recipe-only; no new required control family.

### Upgrade 1.53 → 1.54

**Product version:** 1.54  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Second Gallery seed locale **`ja_JP`** alongside `zh_CN` — [i18n-rtl.md](i18n-rtl.md).
- `scripts/check_gallery_translations.py` requires the `ja_JP` catalog; Gallery i18n page locale ComboBox + `--lang` copy.

#### No action (compatible)

- Additive seed + docs; no API breaks.

### Upgrade 1.52 → 1.53

**Product version:** 1.53  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Experimental [`AnimatedIcon`](components/AnimatedIcon.md) for glyph state swaps — [icons.md](icons.md). Use `checked` or `iconState`/`iconStates` (not Qt Quick `Item.state`).
- Gallery **AnimatedIcon** page; honors `Theme.reducedMotion`.

#### No action (compatible)

- Additive experimental type; no Lottie dependency.

### Upgrade 1.51 → 1.52

**Product version:** 1.52  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Local/CI smoke now also runs `scripts/check_docs_links.py` and loads `FontIconPage` / `PitfallsPage` / `ExamplesTemplatesPage` as critical pages — [ci-smoke.md](ci-smoke.md).
- No open field P0s were reported after 1.51; this buffer shipped CI/docs harden instead of skipping.

#### No action (compatible)

- Additive smoke coverage only.

### Upgrade 1.50 → 1.51

**Product version:** 1.51  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Read [maturity-1xx.md](maturity-1xx.md) — stay on 1.xx; prefer harden / `gallery-shell` / stable-api.
- Freeze doc revisited: [compatibility-1xx.md](compatibility-1xx.md) (still the merge gate).

#### No action (compatible)

- Docs + Gallery Pitfalls checklist only; no API renames.

### Upgrade 1.49 → 1.50

**Product version:** 1.50  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Prefer [`examples/gallery-shell`](../examples/gallery-shell/) as the product app frame (keep-vs-delete in its README).
- `NavigationWindow` now exposes `pageModule` / `hostContent` / `pageTransition` / `navigateBack()` for Gallery-style StackView pages.

#### No action (compatible)

- Default `hostContent: true` + `content:` slot unchanged for existing NavigationWindow demos.

### Upgrade 1.48 → 1.49

**Product version:** 1.49  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Glyph hover/press micro-motion on `FontIcon` / `IconButton` / `AppBarButton` — see [icons.md](icons.md).
- Opt out with `microMotionEnabled: false`; tune `hoverScale` / `pressScale`.
- Gallery **Iconography** micro-motion strip + IconButton / AppBarButton pages.

#### No action (compatible)

- Defaults are additive; `Theme.reducedMotion` still forces scale `1`.
- IconButton no longer scales the whole control — only the glyph (visual polish).

### Upgrade 1.47 → 1.48

**Product version:** 1.48  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Follow [dialogs-flyouts.md](dialogs-flyouts.md) for 2+ queued dialogs, owner `Overlay.overlay`, and Esc/`onClosing` patterns.
- Gallery ContentDialog page: **Enqueue A → B → C** stress demo (critical smoke).

#### Action required (behavior fix)

| Area | Change | What to do |
|------|--------|------------|
| `ContentDialogQueue.replaceCurrent` | No longer pumps the pending queue while replacing | If you relied on the old race (pending opening mid-replace), switch to explicit `show()` after close |

#### No action (compatible)

- FIFO `show()` / `cancel` / `clearQueue` semantics unchanged for the common path.

### Upgrade 1.46 → 1.47

**Product version:** 1.47  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Follow [shell-extras.md](shell-extras.md) for Snap Layouts toggle, taskbar export loop, and attention/reveal patterns.
- Gallery System integration page hosts the demos (critical smoke).

#### No action (compatible)

- Additive docs + Gallery UX; stable taskbar / attention / reveal / idle APIs unchanged. Snap Layouts remains experimental.

### Upgrade 1.45 → 1.46

**Product version:** 1.46  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Follow [packaging-consumer.md](packaging-consumer.md) shared vs static matrix, windeploy/linuxdeploy, and strip-restricted steps.
- Validate kits with `python scripts/check_shared_package.py` (optionally `--dir` after packaging).

#### No action (compatible)

- Additive docs + smoke check; archive layout and CMake targets unchanged.

### Upgrade 1.44 → 1.45

**Product version:** 1.45  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Use [i18n-rtl.md](i18n-rtl.md) for lupdate/lrelease and Gallery `--lang zh_CN` after generating `.qm`.
- CI/smoke runs `scripts/check_gallery_translations.py` on seed `.ts` files.

#### No action (compatible)

- Additive docs + optional CLI; no default language auto-switch.

### Upgrade 1.43 → 1.44

**Product version:** 1.44  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Follow [keyboard.md](keyboard.md) for Ctrl+K / dialog Esc-Enter / list arrows end-to-end.
- Gallery Accessibility page hosts the keyboard tour checklist.

#### No action (compatible)

- Docs + Gallery callouts; existing CommandPalette / dialog APIs unchanged.

### Upgrade 1.42 → 1.43

**Product version:** 1.43  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Use `Theme.contrastRatio` / `contrastPassesAA` when picking `customAccent` — [color-contrast.md](color-contrast.md).
- Gallery **Theme overrides** shows a live AA table.

#### No action (compatible)

- Additive Theme helpers + docs; existing branding knobs unchanged.

### Upgrade 1.41 → 1.42

**Product version:** 1.42  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Use [adaptive-layout.md](adaptive-layout.md) for TwoPaneView / ListDetailsView / Nav `auto` breakpoints.
- Prefer documented defaults (`minWideWidth: 720`, `autoCompactThreshold: 1008`).

#### No action (compatible)

- Additive docs + Gallery; existing TwoPane / ListDetails APIs unchanged.

### Upgrade 1.40 → 1.41

**Product version:** 1.41  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Optional / polish

- Prefer [drag-drop.md](drag-drop.md) for FileDropZone + FilePicker browse + CopyButton / `WindowHelper` clipboard.
- Gallery FileDropZone / CopyButton pages updated.

#### No action (compatible)

- Additive docs + Gallery; `FileDropZone` / `CopyButton` / clipboard helpers unchanged in shape.

### Upgrade 1.39 → 1.40

**Product version:** 1.40  
**Qt:** unchanged (6.5+ / recommended 6.8)

#### Action required

| Area | Change | What to do |
|------|--------|------------|
| Docs gate | Published [compatibility-1xx.md](compatibility-1xx.md) | Prefer frozen Theme / shell / stable APIs for new code; treat this doc as the 1.4x gate |

#### Optional / polish

- Link your internal “supported kit” page to compatibility-1xx + stable-api.
- Gallery **Pitfalls** page points at the freeze (no API change).

#### No action (compatible)

- No Theme token renames, no shell API removals, no stable control breaks in 1.40.

### Upgrade 1.38 → 1.39

**Product version:** 1.39

#### Optional / polish

- Apps using `NavigationView` page stacks: consider `pageCacheLimit` (default **24**) and `initialPageTransition: "none"` for cold start — [performance.md](performance.md).
- `clearPageCache()` available after long browse sessions.

#### No action (compatible)

- Existing NavigationView call sites keep working; cache limit only evicts least-recently-used **Components** (not a public type rename).

### Upgrade 1.37 → 1.38

**Product version:** 1.38

#### Optional / polish

- Linux field hosts: read [platform-linux-wayland.md](platform-linux-wayland.md) failure matrix (SSD, portal parent, SNI).

#### No action (compatible)

- Docs / Gallery System integration callouts only.

---

## When we would break (2.00 territory)

Examples that **do not** belong in a quiet 1.xx:

- Renaming `Theme.bgCard` or stable `NavigationView.openPage`
- Dropping Qt 6.5 without a named roadmap decision
- Removing a type listed as Stable on stable-api without a deprecation window

Track those under the **2.00** plan in [ROADMAP.md](../ROADMAP.md) (**after 1.90**). Draft remap table: [upgrade-notes.md](upgrade-notes.md) **Upgrade 1.90 → 2.00 (draft)** and [checkpoint-190.md](checkpoint-190.md); the breaks land in **2.00**. Apps that cannot leave Qt 6.5 stay on **1.90**.
