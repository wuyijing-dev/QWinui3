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

Track those only under a future **2.00** plan in [ROADMAP.md](../ROADMAP.md).
