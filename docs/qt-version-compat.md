# Qt version compatibility (C++)

QWinUI3 supports **Qt 6.5+**. Recommended: **6.8 LTS**. Forward: **6.10+**.

Version-sensitive Qt APIs are wrapped in **`qwinui3_qtcompat`** so application and module code does not scatter `#if QT_VERSION`.

## CI matrix (1.14)

| Workflow | Qt versions | What |
|----------|-------------|------|
| [`.github/workflows/smoke.yml`](../.github/workflows/smoke.yml) | **6.8.3** (pin) | Release Gallery + `--smoke` (Win + Linux) |
| [`.github/workflows/qt-compat.yml`](../.github/workflows/qt-compat.yml) | **6.5.3**, **6.8.3**, **6.10.0** | Release configure + build `qwinui3_gallery` (Linux) |
| [`.github/workflows/release.yml`](../.github/workflows/release.yml) | **6.8.3** (pin) | Shared libs + Gallery packages |

Compat CI runs on `master` / PR when `src/**`, root CMake, or this doc / workflow change; weekly Monday soak; and `workflow_dispatch`.  
`fail-fast: false` so one Qt cell does not cancel the others — the job still fails if any cell fails.

**Not in the matrix:** every patch of every Qt, Debug builds, screenshot suites, packaging inside compat CI.

If a new Qt minor breaks configure/build, fix a shim under `src/compat/` (below) or adjust the matrix pin in `qt-compat.yml`, then note the resolution in this page.

### Known cells

| Qt | Status | Notes |
|----|--------|-------|
| 6.5.3 | Required | Floor — `find_package(Qt6 6.5 …)`; D3D12 RHI helpers gated off (`QWINUI3_HAVE_RHI_D3D12` false below 6.6) |
| 6.8.3 | Required | Same pin as Smoke / Release |
| 6.10.0 | Required | Forward pin — bump patch in the workflow when CI mirrors ship a newer 6.10.x |

## Headers

| Header | Role |
|--------|------|
| `QWinUI3/Compat/QtCompatVersion.h` | `QWINUI3_QT_AT_LEAST`, `QWINUI3_HAVE_RHI_D3D12`, `QWINUI3_HAVE_QUICK_EFFECTS` |
| `QWinUI3/Compat/QtCompatRhi.h` | RHI backend normalize / apply / D3D12 gating — ship recipe [graphics-backend.md](graphics-backend.md) (1.31) |
| `QWinUI3/Compat/QtCompatQml.h` | Support-range strings / REQUIRES floor helpers |
| `QWinUI3/Compat/QtCompatEffects.h` | Effects availability query |

Include via the public path (linked through `qwinui3_qtcompat`):

```cpp
#include <QWinUI3/Compat/QtCompatRhi.h>
#include <QWinUI3/Compat/QtCompatVersion.h>

QWinUI3::Compat::Rhi::apply(QStringLiteral("opengl"));
```

## CMake capabilities

Root [`CMakeLists.txt`](../CMakeLists.txt) sets:

- `QWINUI3_HAVE_QUICK_EFFECTS` — `ON` when `Qt6::QuickEffects` / `Qt6::QuickEffectsPrivate` exists, or when `qml/QtQuick/Effects/qmldir` is present under the Qt prefix  
- `QWINUI3_HAVE_RHI_D3D12` — `ON` when `Qt6_VERSION >= 6.6`

These are exported as compile definitions on `qwinui3_qtcompat` (PUBLIC).

`ElevatedChrome` uses MultiEffect when Effects is available; otherwise CMake installs [`ElevatedChrome_Simple.qml`](../src/theme/QWinUI3/Theme/ElevatedChrome_Simple.qml) as `ElevatedChrome.qml`.

## Adding a new shim

1. Prefer a small helper in `src/compat/QWinUI3/Compat/`.
2. Gate with `QWINUI3_QT_AT_LEAST` or a new `QWINUI3_HAVE_*` set in root CMake.
3. Call the helper from Gallery / Platform / Theme — do **not** add raw `QT_VERSION` checks in those files.
4. Document the capability row in this page.
5. Confirm the [Qt compat](../.github/workflows/qt-compat.yml) matrix still builds Gallery on 6.5 / 6.8 / 6.10.

## Configure floor

```cmake
find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 LabsQmlModels Gui)
qt_standard_project_setup(REQUIRES 6.5)
```
