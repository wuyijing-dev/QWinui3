# CI smoke (1.06 / 1.20)

Lightweight regression gate — **not** a full test suite or screenshot farm.

| Workflow | When | What |
|----------|------|------|
| [`.github/workflows/smoke.yml`](../.github/workflows/smoke.yml) | `push` / `pull_request` to `master`, manual | Release configure → build `qwinui3_gallery` → catalog check + `--smoke` (Qt **6.8**) |
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

`smoke_gallery.py` first runs `scripts/smoke_catalog.py` (ControlCatalog sources + critical list sync), then launches `qwinui3_gallery --smoke`.

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
3. Print `QWinUI3 Gallery smoke OK (… pages=N)` and exit `0`.

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
| Recently shipped | Home section via `ControlCatalog.recentlyShipped()` (curated 1.xx recipes) |

See also [gallery-catalog-page.md](gallery-catalog-page.md).

---

## Scope

**In smoke:** Windows + Linux, Qt **6.8**, Gallery only, examples/WebView2 off for CI speed; catalog file check; critical page create.

**Not in smoke:** Screenshot diffs, full catalog page-load of every control, packaging.

**Multi-Qt (1.14):** use [qt-compat.yml](../.github/workflows/qt-compat.yml) / [qt-version-compat.md](qt-version-compat.md) — does not replace smoke.
