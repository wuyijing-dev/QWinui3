# vcpkg & Conan consumer packaging (2.11)

Official **overlay vcpkg port** and **Conan 2 recipe** for a shared Release kit with `find_package(QWinUI3 CONFIG)`. Builds on the **1.61** Config layout — see [packaging-consumer.md](packaging-consumer.md) Path C.

**Prerequisite:** Qt **6.5+** (recommended **6.8 LTS**) from your package manager or existing install. Ports **do not** vendor Qt.

**Still planned:** full **2.02** productize (`find_package` as the primary documented path without overlay) — [friction-log.md](planning/friction-log.md) **FL-003**.

---

## Supported triplets / platforms

| Package manager | Windows | Linux |
|-----------------|---------|-------|
| **vcpkg** | `x64-windows` | `x64-linux` |
| **Conan** | `Windows` + MSVC | `Linux` + gcc/clang |

macOS is **not** in scope (same as the kit).

---

## Path D — vcpkg overlay

Port files: [`ports/qwinui3/`](../ports/qwinui3/) · overview [`ports/README.md`](../ports/README.md).

### Install (from a clone)

```bat
vcpkg install qwinui3 --overlay-ports=./ports --triplet x64-windows
```

```bash
vcpkg install qwinui3 --overlay-ports=./ports --triplet x64-linux
```

When `ports/qwinui3/../../CMakeLists.txt` exists, the port **builds the enclosing tree** (no GitHub download). After a `vX.YY` tag, registry submission uses `vcpkg hash git …` — see `ports/README.md`.

### Features

| Feature | Default | Modules |
|---------|---------|---------|
| `extras` | **on** | Full kit (theme + style + platform + extras) |
| *(extras off)* | — | `shell` preset only |
| `media` | off | + `MediaPlayerElement` (experimental) |
| `webview2` | off | + `WebView2Host` (Windows) |

```bat
vcpkg install qwinui3[media] --overlay-ports=./ports --triplet x64-windows
```

### Consumer CMake

Point `CMAKE_PREFIX_PATH` at the vcpkg installed prefix (or use a manifest that depends on `qwinui3`):

```cmake
find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2 LabsQmlModels Gui)
find_package(QWinUI3 CONFIG REQUIRED)

target_link_libraries(myapp PRIVATE QWinUI3::theme QWinUI3::style QWinUI3::platform)
qwinui3_target_setup(myapp)
```

QML imports: `${QWinUI3_QML_DIR}` from the Config (under the installed prefix). Runtime still needs **Qt** deploy (`windeployqt` / `linuxdeploy`) — [packaging-consumer.md](packaging-consumer.md).

---

## Path E — Conan 2

Recipe: [`conan/conanfile.py`](../conan/conanfile.py).

### Create / install (from repo root)

```bat
conan create conan/conanfile.py --build=missing -s build_type=Release
```

Options: `-o qwinui3:extras=False` (shell preset), `-o qwinui3:media=True`, `-o qwinui3:webview2=True` (Windows).

Requires a **ConCenter** (or custom remote) **`qt/6.8.x`** package. Override in your profile if your org pins a different patch.

### Consumer CMake (CMakeDeps)

```cmake
find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 LabsQmlModels Gui)
find_package(QWinUI3 CONFIG REQUIRED)
# … same as Path D …
```

Add the Conan `generators` / `CMakeDeps` layout to `CMAKE_PREFIX_PATH` per your Conan profile.

---

## Layout (both paths)

Same as a Release shared zip:

```text
<prefix>/
  bin/                  # Windows runtime DLLs
  lib/                  # import libs / .so + lib/cmake/QWinUI3/
  include/QWinUI3/      # Bootstrap.h (platform)
  qml/                  # QWinUI3 import trees
```

Validate:

```bash
python scripts/check_shared_package.py --dir <prefix> --expect-shared yes
python scripts/verify_find_package.py --package-dir <prefix>
```

---

## Maintainer checks

```bash
python scripts/check_ports.py
python scripts/check_shared_package.py
```

Registry / ConCenter publication is **optional follow-up** — this slice ships **in-repo** ports with documented triplets.

---

## Related

| Doc | Role |
|-----|------|
| [packaging-consumer.md](packaging-consumer.md) | Zip / add_subdirectory / Path C |
| [upgrade-notes.md](upgrade-notes.md) | Version-to-version |
| [examples/find-package-consumer/](../examples/find-package-consumer/) | Minimal consumer |
