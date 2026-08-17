# Consumer packaging & CMake (1.46 · find_package sketch 1.61)

End-to-end path for a **third-party app** on **Windows** and **Linux**. Prefer types in [stable-api.md](stable-api.md). Compatibility freeze: [compatibility-1xx.md](compatibility-1xx.md) · upgrades: [upgrade-notes.md](upgrade-notes.md) (**1.40**).

**Open this monorepo in Qt Creator** (Gallery / examples — CMake only, no `.pro`): [qt-creator.md](qt-creator.md) (1.35).

Consumers typically:

1. **Download** a Release shared package, or  
2. **Package** from this repo with `scripts/package_release_libs.py`, or  
3. **`add_subdirectory` / clone** the kit into their tree (static or shared), or  
4. **`find_package(QWinUI3 CONFIG)`** against a packaged tree — **1.61** sketch; **2.11** vcpkg/Conan ports — see [Path C](#path-c--find_package) · [Path D/E](packaging-vcpkg-conan.md).

> **vcpkg / Conan (2.11):** Official **in-repo** ports — [packaging-vcpkg-conan.md](packaging-vcpkg-conan.md). Zip + Path C remain valid; **2.02** still productizes `find_package` as the primary path without overlay.

**1.46 polish:** shared vs static matrix, windeploy/linuxdeploy notes, strip-restricted modules, and `scripts/check_shared_package.py`.  
**1.61 sketch:** `QWinUI3Config.cmake` + `examples/find-package-consumer` + `scripts/verify_find_package.py`.  
**2.34 v2:** consumer matrix (shared/static × Win/Linux) + CI job mapping below.

### Path picker (2.47 / FL-003)

Use this table before copying the Gallery monorepo tree. Full `find_package` productize remains **2.02**; vcpkg/Conan overlay is **2.11** ([packaging-vcpkg-conan.md](packaging-vcpkg-conan.md)).

| Your situation | Path | Doc anchor |
|----------------|------|------------|
| Learning / first Win11 shell app | **D** — `add_subdirectory` + [`examples/first-app/`](../examples/first-app/) (**2.52**) or [`gallery-shell/`](../examples/gallery-shell/) | [first-app-252.md](first-app-252.md) · [gallery-shell](../examples/gallery-shell/) |
| Shipping zip from GitHub Releases | **A** — download shared kit + deploy Qt | [What CI ships](#what-ci-ships-on-v-tags) |
| Packaging from this repo locally | **B** — `package_release_libs.py --shared` | [Shared vs static](#shared-vs-static) |
| Corporate mirror / reproducible ports | **E** — vcpkg overlay or Conan 2 | [packaging-vcpkg-conan.md](packaging-vcpkg-conan.md) |
| Installed prefix + CMake config (sketch) | **C** — `find_package(QWinUI3 CONFIG)` | [Path C](#path-c--find_package) (**1.61** sketch; **2.02** productize) |

**2.47 harden:** [field-harden-247.md](field-harden-247.md) · Pitfalls **FL-003** checklist · smoke loads `RecipesHubPage`.

---

## Shared vs static

| | **Shared** (`QWINUI3_BUILD_SHARED=ON` / `--shared`) | **Static** (default in-tree / Gallery) |
|--|--|--|
| **Artifact** | `bin/*.dll` + `lib/*.lib` (Win) or `lib/*.so*` (Linux) + `qml/` | `lib/*.lib` / `*.a` + QML plugins + `qml/` |
| **Link** | `qwinui3_theme` … only (import libs) | Same **plus** `qwinui3_*plugin` targets |
| **Runtime** | Ship QWinUI3 DLLs/.so next to the app (or PATH / `LD_LIBRARY_PATH` / rpath) | QWinUI3 code linked into your binary; still ship **Qt** runtime |
| **When to use** | Redistributable zip for third parties; multiple apps sharing one kit | Single app / Gallery-style; fewer loose files |
| **Package command** | `python scripts/package_release_libs.py --shared --archive` | omit `--shared` |

**Rule of thumb:** Release CI ships **shared** kits (`*-shared.zip` / `*.tar.gz`). The Gallery **binary** zip is a separate story (static QWinUI3 + full Qt deploy).

**CMake dependency note (1.46):** `qwinui3_style` and `qwinui3_extras` **PUBLIC**-link `qwinui3_platform`. Packaging presets `core` / `style` / `extras` therefore also collect the platform DLL/.so and `QWinUI3/Platform` QML (same runtime set as `shell` for style-based apps). Theme-only (`--modules theme`) stays the smallest shared kit.

Module presets (deps auto-included): `all` / `full` · `core` (theme+style, **+platform**) · `shell` · `extras` (theme+extras, **+platform**) · per-module names.  
List: `python scripts/package_release_libs.py --list-modules`.

Shared builds set `CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS` so C++ helpers such as `ThemeFonts::ensureLoaded` (used from `Bootstrap`) cross DLL boundaries on MSVC.

---

## Consumer matrix (2.34)

Maintainers and third-party integrators can map **how you link QWinUI3** to **what CI proves** on every relevant PR:

| | **Windows** | **Linux** |
|--|--|--|
| **Static** (default in-tree) | Build `qwinui3_example_gallery_shell` — Path D proxy (`add_subdirectory`, link `*plugin` targets) | same |
| **Shared** (`--shared` / `QWINUI3_BUILD_SHARED=ON`) | `package_release_libs.py --shared --preset shell` → `check_shared_package.py --dir …` → `verify_find_package.py` (Path C) | same |

| Workflow | When | Matrix cells |
|----------|------|--------------|
| [`.github/workflows/smoke.yml`](../.github/workflows/smoke.yml) | `push` / `PR` to `master` | Gallery Release build + catalog/`--smoke` (static kit in monorepo) |
| [`.github/workflows/consumer-matrix.yml`](../.github/workflows/consumer-matrix.yml) | packaging / examples / `src/` changes, manual | **Static + shared** consumer on **Win + Linux** (Qt **6.8**) |
| [`.github/workflows/release.yml`](../.github/workflows/release.yml) | `v*` tags / dispatch | Publishes shared zips + Gallery deploy (not the find_package sketch) |

**Static consumer (CI):** Release configure with `QWINUI3_BUILD_EXAMPLES=ON`, `QWINUI3_BUILD_SHARED=OFF`, build target `qwinui3_example_gallery_shell`. Same recipe as [gallery-shell](../examples/gallery-shell/) — product chrome without a packaged zip.

**Shared consumer (CI):** After `python scripts/package_release_libs.py --shared --preset shell --webview2 off`:

```bash
python scripts/check_shared_package.py --dir dist/qwinui3-<ver>-<plat>-x64-shared-theme+style+platform --expect-shared yes
python scripts/verify_find_package.py --package-dir dist/qwinui3-<ver>-<plat>-x64-shared-theme+style+platform --skip-package
```

Contract-only (no Qt): `python scripts/check_packaging_consumer_matrix.py` — also run from Gallery smoke (**2.34**).

Tag releases still ship the full shared archive; run the `--dir` check locally after download if you skip the consumer-matrix workflow.

---

## What CI ships on `v*` tags

[`.github/workflows/release.yml`](../.github/workflows/release.yml) builds **Release** packages when you push `vX.YY` (or via workflow dispatch). Assets on [GitHub Releases](https://github.com/wuyijing-dev/QWinui3/releases):

| Asset | Role |
|-------|------|
| `qwinui3-<ver>-windows-x64-shared.zip` | Shared DLLs + QML (`bin/` · `lib/` · `qml/`) |
| `qwinui3-<ver>-linux-x64-shared.tar.gz` | Shared `.so` + QML |
| `qwinui3-gallery-<ver>-windows-x64.zip` | Standalone Gallery + Qt runtime (`windeployqt`) |
| `qwinui3-gallery-<ver>-linux-x64.tar.gz` | Gallery AppDir + runner (`linuxdeploy`) |

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
  lib/cmake/QWinUI3/  # find_package sketch (1.61)
  include/QWinUI3/    # Bootstrap.h when platform is packaged
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

Validate a tree (Win or Linux):

```bash
python scripts/check_shared_package.py --dir dist/qwinui3-<ver>-windows-x64-shared
python scripts/check_shared_package.py --dir dist/qwinui3-<ver>-linux-x64-shared --expect-shared yes
```

Repo contract check (no build): `python scripts/check_shared_package.py` — also run from Gallery smoke (**1.46**).

---

## Path A — use a Release shared zip

### 1. Extract and point at Qt

You still need a **Qt 6.5+** install (recommended **6.8** matching CI) with Quick + QuickControls2 + LabsQmlModels.

### 2. Runtime (before `QGuiApplication`)

Prefer the **one-call bootstrap** from `qwinui3_platform` (`Bootstrap.h`):

```cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "Bootstrap.h"

QWINUI3_IMPORT_QML_PLUGINS

int main(int argc, char *argv[])
{
    QWinUI3::configureEnvironment(argv[0]); // style env + platform QPA/DPI
    QGuiApplication app(argc, argv);
    QWinUI3::configureApplication(QStringLiteral("org.example.myapp"));

    QQmlApplicationEngine engine;
    // Absolute path to the package's qml/ folder:
    engine.addImportPath(QStringLiteral("D:/deps/qwinui3-1.46-windows-x64-shared/qml"));
    // …
}
```

Manual equivalent:

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
    engine.addImportPath(QStringLiteral("D:/deps/qwinui3-1.46-windows-x64-shared/qml"));
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
set(QWINUI3_ROOT "D:/deps/qwinui3-1.46-windows-x64-shared" CACHE PATH "QWinUI3 shared package")

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

## Path C — find_package sketch (1.61)

**Experimental sketch (1.61).** Same shared zip as Path A; Config files live under `lib/cmake/QWinUI3/`. **vcpkg / Conan** consumers: [packaging-vcpkg-conan.md](packaging-vcpkg-conan.md) (Path D/E).

### 1. Package (or download) a shared kit

```bat
python scripts/package_release_libs.py --shared --preset shell --webview2 off
```

### 2. Consumer `CMakeLists.txt`

```cmake
cmake_minimum_required(VERSION 3.21)
project(MyFluentApp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Qt + extracted package root (contains lib/cmake/QWinUI3)
list(APPEND CMAKE_PREFIX_PATH
    "D:/Qt/6.8.0/msvc2022_64"
    "D:/deps/qwinui3-1.61-windows-x64-shared-theme+style+platform"
)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 LabsQmlModels Gui)
find_package(QWinUI3 CONFIG REQUIRED)

qt_standard_project_setup(REQUIRES 6.5)
qt_add_executable(myapp main.cpp)
qt_add_qml_module(myapp URI MyApp VERSION 1.0 QML_FILES Main.qml)

target_link_libraries(myapp PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    QWinUI3::theme
    QWinUI3::style
    QWinUI3::platform
)
# Or: target_link_libraries(myapp PRIVATE QWinUI3::QWinUI3)

qwinui3_target_setup(myapp)  # QWINUI3_QML_ROOT + copy bin/ DLLs on Windows
```

In `main.cpp` (shared kits — **do not** `QWINUI3_IMPORT_QML_PLUGINS`):

```cpp
#include <QWinUI3/Bootstrap.h>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QWinUI3::configureEnvironment(argv[0]);
    QGuiApplication app(argc, argv);
    QWinUI3::configureApplication(QStringLiteral("org.example.myapp"));
    QQmlApplicationEngine engine;
#ifdef QWINUI3_QML_ROOT
    engine.addImportPath(QString::fromUtf8(QWINUI3_QML_ROOT));
#endif
    engine.loadFromModule("MyApp", "Main");
    return app.exec();
}
```

### 3. Tiny verified sample

| Path | Role |
|------|------|
| [`examples/find-package-consumer/`](../examples/find-package-consumer/) | Standalone app (not in monorepo example build) |
| `scripts/verify_find_package.py` | Package shell kit → configure → Release build |

```bat
python scripts/verify_find_package.py
python scripts/verify_find_package.py --package-dir dist/qwinui3-<ver>-windows-x64-shared-theme+style+platform
```

Legacy lowercase targets (`qwinui3_theme`, …) remain as **aliases** of `QWinUI3::*` for older Path A snippets.

---

## Path B — package from this repo

```bat
REM Needs CMAKE_PREFIX_PATH / Qt6_DIR pointing at Qt 6.5+ (CI uses 6.8)
python scripts/package_release_libs.py --shared --archive
python scripts/package_release_libs.py --shared --preset shell --archive
python scripts/package_release_gallery.py
```

Output under `dist/`. Then follow **Path A**. Static packaging (`--shared` omitted) is for linking `.lib`/`.a` into your binary — you must also link the `*plugin` targets (see in-tree examples).

After packaging:

```bash
python scripts/check_shared_package.py --dir dist/qwinui3-<ver>-<plat>-x64-shared --expect-shared yes
```

---

## Path D — `add_subdirectory` (develop against source)

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

Copy an example under [`examples/`](../examples/) — prefer [`gallery-shell`](../examples/gallery-shell/) (**1.50**) for app chrome, [`floating-osk`](../examples/floating-osk/) (**1.84**) for `OnScreenKeyboardWindow`, [`multi-window`](../examples/multi-window/) (**1.56**) for secondary tool/dialog HWNDs, or `nav-settings` / `settings-cards` / `dashboard` for specialized recipes — and keep the same `IMPORTS` / `Q_IMPORT_QML_PLUGIN` pattern as that example’s `main.cpp`.

SIL Keyman Core sources ship **in the clone** at [`third_party/keyman`](../third_party/keyman) ([NOTICE-Keyman.md](NOTICE-Keyman.md)). WebView2 remains an optional NuGet fetch (`scripts/fetch_webview2.ps1`) — not required for the OSK example.

---

## Deploying **your** app (windeployqt / linuxdeploy)

QWinUI3 shared zips **do not** include the Qt runtime. Your installer must still ship Qt (and any optional Multimedia / WebView2 pieces you enable). `MediaPlayerElement` stays **experimental / deferred 1.67** — [media.md](media.md); Multimedia plugins are never a kit promise.

### Windows — `windeployqt`

1. Build your app **Release** against the same Qt major/minor as the QWinUI3 package.
2. Copy QWinUI3 `bin/*.dll` beside the `.exe` (POST_BUILD above) **or** leave them on `PATH` for local runs only.
3. Run `windeployqt` on the exe (Quick + QuickControls2). Example:

```bat
windeployqt --qmldir path\to\your\qml --release myapp.exe
```

4. Ensure `engine.addImportPath` / `QML_IMPORT_PATH` still sees the QWinUI3 package `qml/` (or copy that tree under your deploy folder and point there).
5. Run **strip-restricted** cleanup so GPL/Commercial Qt add-ons do not ride along (see below).

Gallery reference: `python scripts/package_release_gallery.py` (calls `windeployqt`, then strips restricted modules).

### Linux — `linuxdeploy` (+ qt plugin)

1. Prefer rpath into the shared package `lib/`, or set `LD_LIBRARY_PATH` for the installed layout.
2. Use [linuxdeploy](https://github.com/linuxdeploy/linuxdeploy) + `linuxdeploy-plugin-qt` to gather Qt libs/plugins/QML — same pattern as Gallery packaging.
3. Do **not** assume AppImage is required; a relocatable AppDir / tarball is enough for many LoB apps.
4. Strip restricted Qt modules from the staged tree after deploy.

Gallery reference: same `package_release_gallery.py` path on Linux.

---

## Strip-restricted Qt modules

QWinUI3 is **LGPL-3.0**. Desktop Qt kits / `windeployqt` / `linuxdeploy-plugin-qt` may copy **GPL or commercial** add-ons (notably **Virtual Keyboard**, Charts, WebEngine, Quick3D, …) into the deploy folder.

The in-app OSK (**1.73**) is QWinUI3 QML + SIL Keyman Core (**MIT**) for layouts, MIT pinyin-data for zh-Hans, romaji→kana for ja, and Unicode hangul for ko. It does **not** restore Qt Virtual Keyboard. See [on-screen-keyboard.md](on-screen-keyboard.md), [NOTICE-Keyman.md](NOTICE-Keyman.md), and [NOTICE-pinyin.md](NOTICE-pinyin.md).

**In this repo**

| Helper | Use |
|--------|-----|
| `cmake/StripRestrictedQtModules.cmake` → `qwinui3_strip_restricted_qt_modules(target)` | POST_BUILD remove from `$<TARGET_FILE_DIR:…>` (Gallery + examples) |
| `scripts/package_release_gallery.py` → `_strip_restricted()` | Cleans staged Gallery zip / AppDir |

**Consumer apps:** call the CMake helper on your executable target, or delete the same relative paths after `windeployqt` / linuxdeploy. `scripts/check_shared_package.py --dir …` fails if those restricted trees appear **inside** a QWinUI3 lib package (they should never be part of the kit zip).

---

## Qt Creator (consumer app)

1. Kit: Qt **6.5+** (6.8 recommended), MSVC 2022 x64 on Windows / gcc_64 on Linux.  
2. Set `QWINUI3_ROOT` in the project’s CMake configuration (or hardcode while prototyping).  
3. For Path C (`find_package`) or Path D (`add_subdirectory`), open **your** app’s `CMakeLists.txt` (not necessarily the QWinUI3 root).  
4. Run configuration: ensure `PATH` / `LD_LIBRARY_PATH` and `QML_IMPORT_PATH` include the package `bin`/`lib`/`qml` as needed.

Opening the **QWinUI3 monorepo** itself: [qt-creator.md](qt-creator.md).

---

## Checklist

| Step | Windows | Linux |
|------|---------|-------|
| Qt prefix | `CMAKE_PREFIX_PATH` → `…/msvc2022_64` | `…/gcc_64` |
| Library kind | Shared zip → copy `bin/`; Static → link `*plugin` | Shared → `lib/` on `LD_LIBRARY_PATH` / rpath |
| Style | `QT_QUICK_CONTROLS_STYLE=QWinUI3` | same |
| QML | `engine.addImportPath(…/qml)` | same |
| Qt runtime | `windeployqt` (+ strip-restricted) | `linuxdeploy` + qt plugin (+ strip) |
| Validate kit | `check_shared_package.py --dir …` | same |
| API surface | Prefer [stable-api.md](stable-api.md) | same |
| License | LGPL-3.0 (`LICENSE` / `COPYING` in package) | same |

---

## Smoke (maintainers)

```bash
# Contract + docs (no Qt) — also via smoke_gallery.py
python scripts/check_shared_package.py
python scripts/check_packaging_consumer_matrix.py   # 2.34 matrix + workflow anchors

# Static consumer (Path D proxy — matches consumer-matrix.yml)
cmake -S . -B build-static -G Ninja -DCMAKE_BUILD_TYPE=Release \
  -DQWINUI3_BUILD_EXAMPLES=ON -DQWINUI3_BUILD_WEBVIEW2=OFF
cmake --build build-static --config Release --target qwinui3_example_gallery_shell --parallel

# Windows shared artifact
python scripts/package_release_libs.py --shared --preset core --archive
python scripts/check_shared_package.py --dir dist/qwinui3-<ver>-windows-x64-shared-theme+style --expect-shared yes

# find_package sketch consumer (1.61 / 2.34 shared cell)
python scripts/verify_find_package.py
python scripts/verify_find_package.py --package-dir dist/qwinui3-<ver>-windows-x64-shared-theme+style+platform

# Linux (CI release job or local gcc_64 kit)
python scripts/package_release_libs.py --shared --archive
python scripts/check_shared_package.py --dir dist/qwinui3-<ver>-linux-x64-shared --expect-shared yes
```

CI **consumer-matrix** runs static + shared cells on Win/Linux for packaging-related changes; **release** still builds Win + Linux shared archives on `v*` tags.

---

## Out of scope

macOS packages, rewriting the CI module matrix, vendoring Qt through the port. **2.02** still makes Path C the primary documented `find_package` flow without overlay.
