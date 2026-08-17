# 1.xx compatibility freeze (1.40 · revisited 1.51 · 1.60)

What QWinUI3 **will keep compatible** for the rest of the **1.xx** line—and what still may move.

This is the **gate** for later `1.4x` / `1.5x` / `1.6x` work: prefer additive APIs; do not silently rename or remove anything listed under **Will not break**. Breaking Theme / shell / stable-control changes belong in a future **2.00**, not a quiet `1.xx` bump.

**1.51 maturity checkpoint:** [maturity-1xx.md](maturity-1xx.md) — prefer harden over new surfaces for a while.  
**1.60 mid-horizon:** [checkpoint-160.md](checkpoint-160.md) — freeze still active; continue planned `1.61`…`1.70` (not 2.00).

Related: [stable-api.md](stable-api.md) (which types are stable) · [upgrade-notes.md](upgrade-notes.md) (consumer checklist) · [qt-version-compat.md](qt-version-compat.md) (Qt floors).

---

## Promise summary

| Surface | 1.xx promise |
|---------|----------------|
| Types on [stable-api.md](stable-api.md) | No silent remove / rename of public properties, signals, or methods without a roadmap note + this doc / upgrade notes |
| Theme token **names** below | Stay; values may refine for visual polish |
| Shell host APIs below | Stay on `StandardWindow` / `ShellWindow` family / `NavigationView` / `WindowHelper` entry points |
| Experimental / deferred | May change in any `1.xx` with docs callouts — [1.37 defer](stable-api.md#137-defer--wont-promote-for-now) |
| Internal / Style-private | Not covered |
| Qt floor | Remains **6.5+** (recommended **6.8 LTS**) unless a named slice says otherwise — not cut in 1.40 / 1.51 / 1.60 |

**Additive is OK** in 1.xx: new properties with defaults, new optional signals, new stable promotes (named on stable-api).

---

## Will not break — Theme tokens

Rely on these **names** from `QWinUI3.Theme` / `Theme` singleton. Prefer reading tokens over hard-coded hex.

### Knobs (writable)

| Token | Role |
|-------|------|
| `dark` | Light / dark ramps |
| `reducedMotion` / `highContrast` | A11y |
| `followSystemAccessibility` / `followSystemColorScheme` | OS mirroring |
| `density` (`standard` \| `compact`) | Control metrics scale — [density.md](density.md) |
| `uiScale` | Extra density multiplier |
| `devicePixelRatio` | Shells keep this in sync with the window screen |
| `accentPack` / `customAccent` / `setAccentPack()` | Brand accent — [theme-overrides.md](theme-overrides.md) |

### Color & type (readonly — names frozen)

| Group | Tokens |
|-------|--------|
| Accent | `accent`, `accentLight1`, `accentDark1`, `fillAccent*` |
| Text | `textPrimary`, `textSecondary`, `textDisabled`, `textOnAccent`, `textOnAccentSecondary` |
| Fill | `fillControl*`, `fillSubtle*` |
| Stroke / focus | `strokeControl*`, `strokeCard`, `strokeDivider`, `focusOuter`, `focusInner`, `strokeFocusOuter`, `strokeFocusInner` |
| Surfaces | `bgLayer`, `bgLayerAlt`, `bgSolid`, `bgCard`, `bgCardElevated`, `bgSmoke`, `bgAcrylic`, `bgMica` |
| System | `systemAttention*`, `systemSuccess*`, `systemCaution*`, `systemCritical*` |
| Type | `fontFamily*`, `fontCaption` … `fontTitleLarge`, `fontWeightRegular` / `SemiBold` |
| Motion | `motionFast` / `Normal` / `Slow` / `Flyout`, `easing*`, `duration()` |
| Geometry | `cornerControl`, `cornerOverlay`, `controlHeight`, `paddingControl*`, `spacing*`, `navPaneWidth`, `navPaneCompactWidth`, `strokeThin`, `strokeHairline` |
| Helpers | `dp()`, `controlFill()`, `accentFill()` |

**May change without a major bump:** exact pixel values / hex of readonly colors (visual polish); new tokens **added** beside these.

**Will not (in 1.xx):** rename `bgCard` → something else; make readonly colors assignable as the supported branding path (keep using `customAccent` / packs).

---

## Will not break — shell & chrome APIs

| API | Notes |
|-----|--------|
| `StandardWindow` host properties used by Gallery / examples (`backdrop`, `geometryPersistenceKey`, caption flags, header slot) | [window-chrome.md](window-chrome.md) |
| `ShellWindow` / `BlankWindow` / `NavigationWindow` / `MenuStatusWindow` public layout properties | [window-shells.md](window-shells.md) |
| `NavigationWindow` `pageModule` / `hostContent` / `pageTransition` / `navigateBack` / `canGoBack` | Gallery-style StackView shell — [examples/gallery-shell](../examples/gallery-shell/) (**1.50**) |
| `NavigationView`: `model`, `pageModule`, `openPage` / `selectKey` / `selectFooter`, `pageTransition`, `paneDisplayMode`, `footerComponent`, page cache props (1.39) | [navigation.md](navigation.md) · [performance.md](performance.md) |
| `WindowHelper`: backdrop enums + `resolveBackdrop`, geometry save/restore, `configurePlatformEnvironment` / Bootstrap `configureEnvironment` | [window-helper.md](window-helper.md) |
| `PlatformTitleBar` + embedded `TitleBar` recipe | Gallery Main / examples |
| `QWinUI3::configureEnvironment` / `configureApplication` | [packaging-consumer.md](packaging-consumer.md) |
| Icon glyph micro-motion knobs (`microMotionEnabled`, `hoverScale`, `pressScale`) on `FontIcon` / `IconicButton` | Additive defaults — [icons.md](icons.md) (**1.49**) |

**May change:** exotic paradigm / presenter edges still marked experimental; Snap Layouts / taskbar progress remain Windows-oriented with Linux no-ops.

---

## Will not break — stable controls

Everything listed as **Stable** on [stable-api.md](stable-api.md) (shells, forms, dialogs, commands, pickers, charts subset, system integration, …).

Rules for later `1.5x` / `1.6x` PRs:

1. Does this **rename or remove** a public member of a stable type? → **No** unless ROADMAP names a deprecation window and upgrade-notes get a row.
2. Does this change Theme token **names** in the freeze list? → **No**.
3. Additive API / new Gallery page / docs-only → **OK**.
4. Promote experimental → stable → **OK** (update stable-api changelog).
5. Prefer **field harden / docs** over new control families until [checkpoint-160.md](checkpoint-160.md) / [maturity-1xx.md](maturity-1xx.md) posture changes (**1.51** / **1.60**).

---

## Explicitly not frozen

| Area | Status |
|------|--------|
| `MediaPlayerElement` | Deferred **1.67** — [media.md](media.md) |
| ConnectedAnimation / entrance helpers | Experimental — [animations.md](animations.md) |
| TabView tear-out | Experimental |
| Niche charts beyond the stable six | Deferred **1.66** — [charts.md](charts.md) |
| WebView2 advanced Environment / multi-profile | Base host stable; advanced not |
| Gallery-only helpers in [shell-extras.md](shell-extras.md) demos | Not a product contract |
| Generated internal types | [components.md](components.md) Internal section |
| C++ ABI of private Platform helpers | Prefer documented QML / Bootstrap entry points |

---

## Gate for 1.41+ (still active at 1.60)

Before merging a slice that touches Theme, shells, or stable controls:

- [ ] Stable-api / this freeze list still accurate  
- [ ] If behavior changes for apps: row in [upgrade-notes.md](upgrade-notes.md)  
- [ ] No silent renames of frozen Theme or shell APIs  
- [ ] Maturity posture: harden-first when choosing scope — [maturity-1xx.md](maturity-1xx.md)

**2.00** is only when we truly need breaking Theme/API renames that cannot stay compatible in 1.xx — see [ROADMAP.md](../ROADMAP.md).
