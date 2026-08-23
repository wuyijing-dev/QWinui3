# High-DPI & multi-monitor (1.58 · 2.15 wave 3)

Wave-2 cookbook for mixed scaling, geometry restore, and Gallery diagnostics. Builds on **1.04** (DPI reapply / hit-test) and **1.32** (geometry clamp).

Related: [window-chrome.md](window-chrome.md) · [window-helper.md](window-helper.md) · [window-shells.md](window-shells.md) · [graphics-backend.md](graphics-backend.md) · [platform-linux-wayland.md](platform-linux-wayland.md).

Gallery: **High-DPI & monitors** · **Window shells** · **System integration** (screens list) · Settings → Graphics backend.

---

## Win + Linux matrix (1.58)

| Topic | Windows | Linux (Wayland / X11) | Ship note |
|-------|---------|------------------------|-----------|
| Logical layout units | Qt high-DPI scaling | Same | Prefer `Theme.*` / `Theme.dp` — not raw physical pixels |
| `Theme.devicePixelRatio` | Synced from **window** screen | Synced from window screen | Hairlines via `Theme.strokeHairline` / `Theme.hairline()` |
| `WindowHelper.devicePixelRatio` | **Primary** screen DPR | Primary DPR | Diagnostics only — prefer per-window API |
| `devicePixelRatioForWindow(w)` | That window’s screen DPR | Same | Use after restore / drag across monitors |
| Fractional scale | Per-monitor awareness | Wayland: Bootstrap `PassThrough` | [platform-linux-wayland.md](platform-linux-wayland.md) · **2.15** `fractionalScale` readout |
| Geometry restore | Clamp + **setScreen** (1.58) | Clamp + setScreen | See [restore recipe](#geometry-restore-recipe) |
| Caption hit-test | Screen-logical `mapToGlobal` × DPR | QML caption (no NC) | Re-report on `screensChanged` |
| Mica / Acrylic after DPI change | Reapply on `WM_DPICHANGED` | Coerced → Solid | Pin OpenGL for frost — [graphics-backend.md](graphics-backend.md) |
| RHI vs DPI | Independent knobs | Independent | DPI bugs ≠ RHI bugs; check both |

Do **not** rewrite the Qt platform plugin for per-monitor awareness — stay on supported `WindowHelper` / shell recipes.

---

## Geometry restore recipe

Supported path (product apps):

```qml
StandardWindow {
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "MainWindow"   // unique per top-level role
}
```

On restore (`WindowHelper.restoreWindowGeometry` / shell `restoreGeometry()`):

1. Load normal frame + optional screen **name** + maximized flag from `QSettings` → `WindowGeometry/<key>`.
2. **`clampGeometryToScreens`**: preferred screen by name → intersecting `availableGeometry` → primary center; min **160×120**; fit taskbar-safe area.
3. **`setScreen`** to the monitor that owns the clamped center (or saved name) so mixed-DPI DPR updates (**1.58**).
4. `setGeometry` + visibility (windowed / maximized).

Undock / rearrange monitors cannot leave the window permanently off-screen. Multi-window keys: [window-shells.md](window-shells.md#multi-window--secondary-shells-156).

```qml
// Reset layout
window.clearSavedGeometry()
// or
WindowHelper.clearWindowGeometry("MainWindow")
```

---

## Gallery DPI readout

**High-DPI & monitors** shows:

- Window `Screen.devicePixelRatio` vs `Theme.devicePixelRatio` vs primary `WindowHelper.devicePixelRatio`
- **`WindowHelper.highDpiScaleFactorRoundingPolicy()`** — active Qt rounding (`PassThrough` when `configureEnvironment` ran early)
- `WindowHelper.screensInfo()` rows: name, primary, dpr, **`fractionalScale`**, geometry, **availableGeometry**
- Clear Gallery Main geometry (`GalleryMain`) for restore experiments
- **Per-monitor geometry soak** (2.15): drag window across monitors; verify Theme DPR + geometry rows
- Checklist for 125%↔150%, dock undock, secondary monitor open, Wayland fractional scale

Also: System integration screens dump · Window shells persistence callout · Settings RHI (unrelated but often confused with “blurry”).

---

## Wave 3 — fractional scale & per-monitor soak (2.15)

**API additions**

| API | Purpose |
|-----|---------|
| `WindowHelper.highDpiScaleFactorRoundingPolicy()` | Read active Qt policy string (`PassThrough`, `Round`, …) |
| `screensInfo()[].fractionalScale` | `true` when `devicePixelRatio` is not an integer (typical Wayland fractional scale) |

**Bootstrap**

`QWinUI3::configureEnvironment` sets `HighDpiScaleFactorRoundingPolicy::PassThrough` before `QGuiApplication`. Apps that skip early configure may see `Round` — check the Gallery readout.

**Per-monitor geometry soak**

1. Open Gallery **High-DPI & monitors**.
2. Note primary + secondary rows from `screensInfo()` (geometry + availableGeometry).
3. Drag the Gallery window to each monitor; confirm Theme DPR matches window screen DPR.
4. On fractional-scale Wayland, expect non-integer DPR and `fractionalScale: true`.
5. Clear `GalleryMain` geometry, move/resize on each monitor, restart — restore clamps and `setScreen` still bind the correct monitor.

### Wave 4 — fractional text sharpening (2.70 F6)

At **125% / 150%** (and other non-integer DPR), `ThemeFonts` applies `QFont::PreferVerticalHinting` so UI glyphs stay crisp on Wayland and Windows fractional scales. Theme exposes `fractionalScale` / `fractionalTextSharpening` for app diagnostics. Prefer `ThemeFonts.uiFontFor` / application font from Bootstrap rather than raw `Font.PreferFullHinting` + bitmap mono families.


## Failure modes (P0 paths)

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Restores off-screen after undock | Stale coords, no clamp | `geometryPersistenceKey` (clamp recipe above) |
| Wrong DPR / blurry chrome after restore to other monitor | Window still bound to old `QScreen` | **1.58** `setScreen` on restore; verify Theme DPR updates on `onScreenChanged` |
| Caption misses after scale change | Stale NC rects | `PlatformTitleBar.reportHitTest()` + `screensChanged` — [window-chrome.md](window-chrome.md) |
| Mica gone after 125%↔150% | DWM cleared on DPI change | Solid default; or rely on 1.04 reapply + OpenGL |
| “Blurry” on Wayland fractional scale | Rounding / SSD | Bootstrap `configureEnvironment` — [platform-linux-wayland.md](platform-linux-wayland.md) |

---

## App author checklist

1. Call `QWinUI3::configureEnvironment` before `QGuiApplication`.
2. Ship `BackdropSolid` unless you own frost + OpenGL.
3. Set a unique `geometryPersistenceKey` per top-level window.
4. Prefer `Theme.devicePixelRatio` / `hairline()` for 1-px strokes — sync comes from shells.
5. After custom chrome layout, call `reportHitTest()` on resize / screen change.
6. Diagnose with Gallery **High-DPI & monitors** before inventing a second settings schema.

---

## Out of scope (1.58 · 2.15)

Per-monitor Qt platform plugin rewrite; inventing a second geometry store; macOS Spaces.
