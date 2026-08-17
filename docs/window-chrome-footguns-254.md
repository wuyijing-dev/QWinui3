# Window chrome footguns (2.54)

Targeted fixes for the three highest-count **caption / geometry / mixed-DPI** footguns — not a full chrome rewrite.

Related: [window-chrome.md](window-chrome.md) · [window-helper.md](window-helper.md) · [high-dpi.md](high-dpi.md) · [title-bar-cookbook.md](title-bar-cookbook.md)

---

## Goal

Product apps hit **maximize**, **mixed-DPI restore**, and **caption hit-test** bugs after shipping `NavigationWindow` / `ShellWindow`. **2.54** closes the top three with small platform fixes + troubleshooting rows.

---

## Top 3 footguns (fixed in 2.54)

| # | Symptom | Cause | Fix |
|---|---------|-------|-----|
| **1** | Maximize / restore caption buttons miss clicks | NC hit-test stale after `restoreWindowGeometry` + `Maximized` | **`geometryRestored`** signal → `WindowChrome.reportHitTest()`; visibility toggle refresh |
| **2** | Un-maximize restores tiny/wrong frame | Normal geometry not cached when session starts maximized | Restore sets **`_qwinui3_normalGeometry`** before `showMaximized()` |
| **3** | Wrong monitor / DPR after dock undock | Screen name stale; ShellWindow skipped hit-test on `screensChanged` | Geometry **schema v2** saves `devicePixelRatio`; ShellWindow re-reports hit-test on screen changes |

**Out:** Snap Layouts on Linux; full geometry JSON export; NavigationView pane-width persistence (**2.56** / capabilities doc).

---

## Deliverables

| Item | Location |
|------|----------|
| Geometry schema v2 | `WindowHelper.saveWindowGeometry` — `schemaVersion` + `devicePixelRatio` |
| Normal-geo cache on restore | `WindowHelper.restoreWindowGeometry` |
| Hit-test refresh | `ShellWindowSupport.geometryRestored` · `ShellWindow` / `StandardWindow` wiring |
| Troubleshooting rows | [window-chrome.md](window-chrome.md) failure matrix |
| Gallery checklist | **Pitfalls** — **2.54** block · **Window shells** / **High-DPI** pages |

---

## App checklist

- [ ] Unique **`geometryPersistenceKey`** per top-level role — never reuse for tool/dialog
- [ ] **`PlatformTitleBar.reportHitTest()`** after custom title-bar layout changes
- [ ] **`BackdropSolid`** on Linux; frost only on Windows with OpenGL — [graphics-backend.md](graphics-backend.md)
- [ ] Theme prefs in **`ThemePrefs` category** — not `WindowGeometry/*` — [settings-persistence.md](settings-persistence.md)
- [ ] Mixed-DPI soak: move window across monitors — [high-dpi.md](high-dpi.md)

**Next:** **2.55** forms unlike WinUI · **2.57** files on Linux
