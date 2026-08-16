# Qt version compatibility (C++)

QWinUI3 supports **Qt 6.5+**. Recommended: **6.8 LTS**. Forward: **6.10+**.

Version-sensitive Qt APIs are wrapped in **`qwinui3_qtcompat`** so application and module code does not scatter `#if QT_VERSION`.

## Headers

| Header | Role |
|--------|------|
| `QWinUI3/Compat/QtCompatVersion.h` | `QWINUI3_QT_AT_LEAST`, `QWINUI3_HAVE_RHI_D3D12`, `QWINUI3_HAVE_QUICK_EFFECTS` |
| `QWinUI3/Compat/QtCompatRhi.h` | RHI backend normalize / apply / D3D12 gating |
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

## Configure floor

```cmake
find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 LabsQmlModels Gui)
qt_standard_project_setup(REQUIRES 6.5)
```
