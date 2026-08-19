# Python consumer packaging (PySide6 / PyQt6)

**Status:** Shipped on **2.64** (early slice; PyPI remains **2.72**).

Load the **same QWinUI3 Gallery** as `src/gallery` from Python — not a subprocess of `qwinui3_gallery.exe`. Gallery QML is copied from `src/gallery` at launch; `GraphicsBackend`, `GalleryLanguage`, and `DemoTreeModel` are Python ports of the C++ Gallery helpers.

Controls still come from a **shared kit** (`qml/` + `bin/` or `lib/`). See [packaging-consumer.md](packaging-consumer.md) **Path E**.

---

## Prerequisites

| Requirement | Notes |
|-------------|--------|
| **PySide6** or **PyQt6** | Qt **6.5+**; match kit **major.minor** to `qVersion()` |
| **Shared kit** | `python scripts/package_release_libs.py --shared --archive` |
| **Same Qt ABI** | Import bindings **first**; kit DLLs via `os.add_dll_directory` (handled by `qwinui3.configure_environment`) |

On Windows with PySide6 **6.11**, build/package the kit against official Qt **6.11** — do not mix 6.8/6.10 DLLs with 6.11 bindings.

---

## Quick start — Gallery

```bat
pip install PySide6
python scripts/package_release_libs.py --shared --archive
set QWINUI3_ROOT=dist\qwinui3-2.64-windows-x64-shared
python examples/python-gallery/main.py
```

Smoke (CI-style gate):

```bat
python examples/python-gallery/main.py --smoke
python scripts/verify_python.py --smoke
```

Force PyQt6:

```bat
set QWINUI3_QT_BINDING=pyqt6
python examples/python-gallery/main.py --binding pyqt6
```

---

## Layout

| Path | Role |
|------|------|
| [`python/qwinui3/`](../python/qwinui3/) | Bootstrap — `configure_environment`, `setup_engine`, kit discovery |
| [`python/qwinui3_gallery/`](../python/qwinui3_gallery/) | Gallery entry + C++ type ports + QML staging |
| [`examples/python-gallery/`](../examples/python-gallery/) | Thin launcher (`main.py`) |
| `examples/python-gallery/.qml-module/` | Generated `QWinUI3.Gallery` tree (gitignored) |

At startup, `stage_gallery_qml()` copies `src/gallery/**/*.qml` into `.qml-module/QWinUI3/Gallery/`, writes `qmldir`, and injects `import QWinUI3.Gallery 1.0` into `pages/*.qml` so on-demand page compiles match the C++ module.

Python types use `@QmlElement` / `@QmlSingleton` (PySide6 / PyQt6) on URI `QWinUI3.Gallery` — do **not** use raw `qmlRegisterSingletonInstance` (breaks kit QML load).

---

## Bootstrap sketch (your app)

```python
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "python"))

from qwinui3 import (
    QtGui, QtQml, QtCore,
    configure_environment, configure_application, setup_engine,
)

kit = configure_environment()          # before QGuiApplication
app = QtGui.QGuiApplication(sys.argv)
configure_application("org.example.myapp")
engine = QtQml.QQmlApplicationEngine()
setup_engine(engine, kit)
engine.load(QUrl.fromLocalFile("Main.qml"))
app.exec()
```

Gallery adds: `apply_early` / `sync_after_app` (RHI), `register_types(engine)`, Gallery import path, `loadFromModule("QWinUI3.Gallery", "Main")`.

---

## CLI flags (Gallery)

Same as C++ Gallery where applicable:

| Flag | Purpose |
|------|---------|
| `--smoke` | Load Main + critical pages, exit 0 |
| `--lang <locale>` | Startup translator (e.g. `zh_CN`) |
| `--rhi opengl\|vulkan\|d3d11\|d3d12` | RHI backend before `QGuiApplication` |
| `--startup-log` | Timing lines to stdout |
| `--kit <path>` | Shared kit root |
| `--binding pyside6\|pyqt6` | Force Qt binding |

`FrameStatsMonitor` ships in the **Platform** plugin — attach from QML as in C++ Gallery; no Python port required when the shared kit loads.

---

## Verification

```bat
python scripts/verify_python.py
python scripts/verify_python.py --smoke
```

Import check only, or full Gallery smoke via `examples/python-gallery`.

---

## Out of scope (2.64)

- PyPI wheels (**2.72**)
- Shiboken wrappers for every C++ helper
- Subprocess / embed `qwinui3_gallery.exe`

Related: [packaging-pyside6.md](packaging-pyside6.md) (redirect) · [friction-log.md](planning/friction-log.md) **FL-011** · [roadmap.md](roadmap.md) **2.71** note.
