# Consumer packaging & CMake (1.12)

End-to-end path for a **third-party app** on **Windows** and **Linux**. Prefer types in [stable-api.md](stable-api.md). Gallery / monorepo open: [qt-creator.md](qt-creator.md).

There is **no** `find_package(QWinUI3)` Config yet — consumers either:

1. **Download** a Release shared package, or  
2. **Package** from this repo with `scripts/package_release_libs.py`, or  
3. **`add_subdirectory` / clone** the kit into their tree (static or shared).

---

## What CI ships on `v*` tags

[`.github/workflows/release.yml`](../.github/workflows/release.yml) builds **Release** packages when you push `vX.YY` (or via workflow dispatch). Assets on [GitHub Releases](https://github.com/wuyijing-dev/QWinui3/releases):

| Asset | Role |
|-------|------|
| `qwinui3-<ver>-windows-x64-shared.zip` | Shared DLLs + QML (`bin/` · `lib/` · `qml/`) |
| `qwinui3-<ver>-linux-x64-shared.tar.gz` | Shared `.so` + QML |
| `qwinui3-gallery-<ver>-windows-x64.zip` | Standalone Gallery + Qt runtime (`windeployqt`) |
| `qwinui3-gallery-<ver>-linux-x64.tar.gz` | Gallery AppDir + runner |

- CI Qt pin: **6.8.x** (see workflow `QT_VERSION`). Apps may target **Qt 6.5+**; match major/minor ABI to the kit you link against.
- Tag pushes package **all** modules. Manual dispatch can pass `modules` (`all` \| `core` \| `shell` \| …).
- Product version = `QWINUI3_VERSION` (`X.YY`) in root `CMakeLists.txt`.

---

## Package layout (shared)

After extract (or `python scripts/package_release_libs.py --shared --archive`):

```text
qwinui3-<ver>-…-shared/
  bin/     # Windows: runtime DLLs (also copy beside your .exe or on PATH)
  lib/     # Import libs (.lib) / shared objects (.so) / plugins
  qml/     # QML trees: QWinUI3/, QWinUI3/Theme, QWinUI3/Platform, QWinUI3/Extras
  README.md
  LICENSE · COPYING
```

| Module | CMake target | QML under `qml/` |
|--------|--------------|------------------|
| `theme` | `qwinui3_theme` | `QWinUI3/Theme` |
| `style` | `qwinui3_style` | `QWinUI3` (Controls style) |
| `platform` | `qwinui3_platform` | `QWinUI3/Platform` |
| `extras` | `qwinui3_extras` | `QWinUI3/Extras` |

**Presets** (deps auto-included): `all` / `full` · `core` (theme+style) · `shell` (+platform) · `extras` (theme+extras) · per-module names.  
List: `python scripts/package_release_libs.py --list-modules`.

---

## Path A — use a Release shared zip

### 1. Extract and point at Qt

You still need a **Qt 6.5+** install (recommended **6.8** matching CI) with Quick + QuickControls2 + LabsQmlModels.

### 2. Runtime (before `QGuiApplication`)

```cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
    qputenv("QT_QUICK_CONTROLS_STYLE", "QWinUI3");
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle(QStringLiteral("QWinUI3"));

    QQmlApplicationEngine engine;
    // Absolute path to the package's qml/ folder:
    engine.addImportPath(QStringLiteral("D:/deps/qwinui3-1.12-windows-x64-shared/qml"));
    // …
}
```

**Windows:** ensure `bin/*.dll` (or copies of the DLLs) are next to the `.exe` or on `PATH`.  
**Linux:** add `lib/` to `LD_LIBRARY_PATH`, or embed `rpath` to that directory.

Env alternatives: `QML_IMPORT_PATH` / `QML2_IMPORT_PATH` including the package `qml/` directory (same effect as `addImportPath`).

### 3. Minimal consumer `CMakeLists.txt` (shared package)

```cmake
cmake_minimum_required(VERSION 3.21)
project(MyFluentApp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Extracted shared package root (contains bin/, lib/, qml/)
set(QWINUI3_ROOT "D:/deps/qwinui3-1.12-windows-x64-shared" CACHE PATH "QWinUI3 shared package")

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 LabsQmlModels Gui)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(myapp main.cpp)
qt_add_qml_module(myapp
    URI MyApp
    VERSION 1.0
    QML_FILES Main.qml
)

target_link_directories(myapp PRIVATE "${QWINUI3_ROOT}/lib")
target_link_libraries(myapp PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    qwinui3_theme
    qwinui3_style
    qwinui3_platform
    qwinui3_extras
)

# Bake the QML import path for local runs (optional; also set at runtime)
target_compile_definitions(myapp PRIVATE
    QWINUI3_QML_ROOT=u8"${QWINUI3_ROOT}/qml"
)

# Windows: copy runtime DLLs next to the exe after build (optional helper)
if(WIN32)
    add_custom_command(TARGET myapp POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_directory
            "${QWINUI3_ROOT}/bin" $<TARGET_FILE_DIR:myapp>
        COMMENT "Copy QWinUI3 DLLs beside myapp"
    )
endif()
```

In `main.cpp`, if you used the define:

```cpp
engine.addImportPath(QString::fromUtf8(QWINUI3_QML_ROOT));
```

Link only the modules you packaged (`core` → theme+style only). On **Linux**, library names are typically `libqwinui3_theme.so` — `target_link_libraries(… qwinui3_theme)` still works if `lib/` is on the link path.

### 4. QML side

```qml
import QtQuick
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

ApplicationWindow { /* or StandardWindow from Platform */ }
```

Keep `QT_QUICK_CONTROLS_STYLE=QWinUI3` so styled Controls pick up the Fluent chrome.

---

## Path B — package from this repo

```bat
REM Needs CMAKE_PREFIX_PATH / Qt6_DIR pointing at Qt 6.5+ (CI uses 6.8)
python scripts/package_release_libs.py --shared --archive
python scripts/package_release_libs.py --shared --preset shell --archive
python scripts/package_release_gallery.py
```

Output under `dist/`. Then follow **Path A**. Static packaging (`--shared` omitted) is for linking `.lib`/`.a` into your binary — you must also link the `*plugin` targets (see in-tree examples).

---

## Path C — `add_subdirectory` (develop against source)

Best when you want CMake targets (`qwinui3_theme`, …) without a zip:

```cmake
set(QWINUI3_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
# Default OFF = static into your app (same as Gallery). ON = shared DLLs/.so
# set(QWINUI3_BUILD_SHARED ON CACHE BOOL "" FORCE)
add_subdirectory(third_party/QWinui3)

target_link_libraries(myapp PRIVATE
    Qt6::Quick Qt6::QuickControls2
    qwinui3_theme qwinui3_style qwinui3_platform qwinui3_extras
)
if(NOT QWINUI3_BUILD_SHARED)
    target_link_libraries(myapp PRIVATE
        qwinui3_themeplugin qwinui3_styleplugin
        qwinui3_platformplugin qwinui3_extrasplugin
    )
endif()
```

Copy an example under [`examples/`](../examples/) (`nav-settings`, `settings-cards`, `dashboard`) and keep the same `IMPORTS` / `Q_IMPORT_QML_PLUGIN` pattern as that example’s `main.cpp`.

---

## Qt Creator (consumer app)

1. Kit: Qt **6.5+** (6.8 recommended), MSVC 2022 x64 on Windows / gcc_64 on Linux.  
2. Set `QWINUI3_ROOT` in the project’s CMake configuration (or hardcode while prototyping).  
3. For Path C, open **your** app’s `CMakeLists.txt` (not necessarily the QWinUI3 root).  
4. Run configuration: ensure `PATH` / `LD_LIBRARY_PATH` and `QML_IMPORT_PATH` include the package `bin`/`lib`/`qml` as needed.

Opening the **QWinUI3 monorepo** itself: [qt-creator.md](qt-creator.md).

---

## Checklist

| Step | Windows | Linux |
|------|---------|-------|
| Qt prefix | `CMAKE_PREFIX_PATH` → `…/msvc2022_64` | `…/gcc_64` |
| Style | `QT_QUICK_CONTROLS_STYLE=QWinUI3` | same |
| QML | `engine.addImportPath(…/qml)` | same |
| Native libs | `bin/` DLLs beside exe or on `PATH` | `lib/` on `LD_LIBRARY_PATH` / rpath |
| API surface | Prefer [stable-api.md](stable-api.md) | same |
| License | LGPL-3.0 (`LICENSE` / `COPYING` in package) | same |

---

## Out of scope (1.12)

`find_package(QWinUI3)` Config/export graph, macOS packages, new archive formats, rewriting CI module matrix.
