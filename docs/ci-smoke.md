# CI smoke (1.06 / 1.20 / 1.52 / 1.60 / 2.27 … 2.54 + strategy/icons track)

Lightweight regression gate — **not** a full test suite or screenshot farm.

| Workflow | When | What |
|----------|------|------|
| [`.github/workflows/smoke.yml`](../.github/workflows/smoke.yml) | `push` / `pull_request` to `master`, manual | Release configure → build `qwinui3_gallery` → catalog check + `--smoke` (Qt **6.8**) |
| [`.github/workflows/consumer-matrix.yml`](../.github/workflows/consumer-matrix.yml) | packaging / examples / `src/` changes, manual | Static + shared consumer builds on Win + Linux (Qt **6.8**) — [packaging-consumer.md](packaging-consumer.md) **2.34** |
| [`.github/workflows/qt-compat.yml`](../.github/workflows/qt-compat.yml) | src/CMake changes, weekly, manual | Release Gallery build on Qt **6.5 / 6.8 / 6.10** (Linux) — [qt-version-compat.md](qt-version-compat.md) |
| [`.github/workflows/release.yml`](../.github/workflows/release.yml) | `v*` tags / dispatch | Shared libs + Gallery packages (Qt **6.8**) |
| [`.github/workflows/docs.yml`](../.github/workflows/docs.yml) | docs changes | MkDocs / Pages |

---

## Local

```bat
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DQWINUI3_BUILD_EXAMPLES=OFF
cmake --build build --config Release --target qwinui3_gallery
python scripts/smoke_gallery.py --build-dir build
```

```bash
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DQWINUI3_BUILD_EXAMPLES=OFF
cmake --build build --config Release --target qwinui3_gallery
python scripts/smoke_gallery.py --build-dir build
```

`smoke_gallery.py` preflight (no Qt for the first six steps):

1. `scripts/smoke_catalog.py` — ControlCatalog sources + critical list sync  
2. `scripts/check_catalog_refresh.py` — component API index + version sync  
3. `scripts/check_gallery_translations.py` — `.ts` XML + `GalleryLanguage` wiring  
4. `scripts/check_docs_links.py` — recipe / ROADMAP / maturity markdown links  
5. `scripts/check_shared_package.py` — packaging contracts / docs (no `--dir`)  
6. `scripts/lint_qml_imports.py` — example QML stable-import guard (**2.51** / **2.52** first-app)  

Linux field matrix: [platform-linux-wayland.md](platform-linux-wayland.md) · top-3 fixes [linux-top3-253.md](linux-top3-253.md) (**2.53**). Chrome footguns: [window-chrome-footguns-254.md](window-chrome-footguns-254.md) (**2.54**).

Then launches `qwinui3_gallery --smoke`.

**Do not** add per-slice `scripts/check_*.py` validators — see `.cursor/rules/no-check-scripts.mdc`.

Optional after packaging a shared kit:

```bash
python scripts/check_shared_package.py --dir dist/qwinui3-<ver>-windows-x64-shared --expect-shared yes
```

See [packaging-consumer.md](packaging-consumer.md).

### Windows QPA pitfall

Desktop Qt kits / `windeployqt` trees often **only** ship `platforms/qwindows.dll`.
If the shell has `QT_QPA_PLATFORM=offscreen` (Cursor and some CI images do), Gallery
shows:

> Available platform plugins are: windows.

**Fixes (1.06):**

- Gallery **always** coerces foreign `QT_QPA_PLATFORM` values to `windows` on Win32
  (not only `--smoke`). Opt out with `QWINUI3_ALLOW_FOREIGN_QPA=1`.
- `scripts/smoke_gallery.py` ignores inherited `offscreen`/`minimal` and prepends the
  CMake `CMAKE_PREFIX_PATH` Qt `bin` so a second kit on `PATH` (CubeProgrammer, etc.)
  cannot load a mismatched `Qt6Core.dll`.

| Host | Default platform |
|------|------------------|
| Windows | `windows` |
| Linux CI | `offscreen` (build + `--smoke` only — **not** a Wayland compositor soak; see [platform-linux-wayland.md](platform-linux-wayland.md) **1.38**) |

```bat
REM After build.bat (windeploy) or with the build Qt bin first on PATH:
qwinui3_gallery.exe
qwinui3_gallery.exe --smoke
python scripts/smoke_gallery.py --build-dir build --platform windows
```

---

## What `--smoke` covers (1.20)

1. Load `QWinUI3.Gallery/Main` (modules + shell).
2. Instantiate each **critical page** once via `QQmlComponent` (no navigation, no pixels).
3. Print `QWinUI3 Gallery smoke OK (… pages=N, main=…ms, pages=…ms, total=…ms)` and exit `0`.

Timing is advisory (machine-dependent). Critical set only — not the full catalog. Cold-start tips: [performance.md](performance.md) (**1.39**). Interactive measure: `qwinui3_gallery --startup-log`.

**Performance arc (1.86…1.89):** smoke `--smoke` validates **page instantiate**, not frame time or navigation perf. After the arc, treat printed `main=…ms` / `pages=…ms` / `total=…ms` as a **regression hint only** — compare on the same machine/Release build; do not gate CI on absolute milliseconds. Arc sign-off: [checkpoint-190.md](checkpoint-190.md).

**Shell trim (2.28):** [performance.md](performance.md) **Shell & navigation wave 6** documents `sameKeySkipCount` / `samePageSkipCount` on `NavigationView` and forwarded aliases on `NavigationWindow`. Use `--startup-log` with `--smoke` locally when validating cache or skip-trim edits — advisory only.

### Critical page set

Keep these three in sync when editing:

| Location | Role |
|----------|------|
| `src/gallery/main.cpp` (`kCriticalPages`) | Runtime page create |
| `ControlCatalog.smokeCriticalComponents()` | QML documentation helper |
| `scripts/smoke_catalog.py` (`CRITICAL`) | File existence + main.cpp sync |

Current set:

- `HomePage`, `ButtonPage`
- `ContentDialogPage`, `DialogsFlyoutsPage`, `AnimationsPage`
- `DataTablePage`, `FormValidationPage`
- `CommandPalettePage`, `AccessibilityPage`
- `SystemIntegrationPage`, `WebView2Page`
- `ChartsPage`, `I18nRtlPage`
- `FontIconPage`, `PitfallsPage`, `ExamplesTemplatesPage` (**1.52** — recent recipe harden)
- `SearchRecipesPage`, `HighDpiPage` (**1.60** — mid-horizon smoke bump)
- `MultiWindowPage`, `StyleSpotCheckPage` (**2.19** — 2.14 / 2.17 recipe smoke)
- `RecipesHubPage`, `PerformancePage` (**2.47** — docs hub + FrameStats diagnostics)

Regenerate component API after QML comment changes:

```bash
python scripts/generate_component_docs.py
python scripts/check_catalog_refresh.py
```

**Catalog integrity only:**

```bash
python scripts/smoke_catalog.py
python scripts/smoke_catalog.py --list-critical
```

---

## Gallery catalog UX (1.20)

| Affordance | Where |
|------------|-------|
| Title-bar search | Matches title, **component id**, description, category |
| Pane search | NavigationView `paneSearchModel` |
| Recent / Favorites | Home pills + `GalleryHistory` (persisted) |
| Page favorite star | `PageHeader` when `CatalogPage.componentId` is set (Main on open) |
| Recently shipped | Home section via `ControlCatalog.recentlyShipped()` (curated; **2.39** tops **2.38 → 2.21**) |
| Catalog matrix | [gallery-catalog-expansion.md](gallery-catalog-expansion.md) (**2.39**) |

See also [gallery-catalog-page.md](gallery-catalog-page.md).

---

## Scope

**In smoke:** Windows + Linux, Qt **6.8**, Gallery only, examples/WebView2 off for CI speed; catalog file check; translation seeds; shared packaging contracts; docs link check (**1.52**); critical page create.

**Not in smoke:** Screenshot / visual golden diffs, building shared Release zips (use `package_release_libs.py` + `check_shared_package.py --dir` locally / Release workflow). Media decode is not required (`MediaPlayerElement` deferred **1.67** — [media.md](media.md)).

**Multi-Qt (1.14):** use [qt-compat.yml](../.github/workflows/qt-compat.yml) / [qt-version-compat.md](qt-version-compat.md) — does not replace smoke.
