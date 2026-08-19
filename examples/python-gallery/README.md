# Python Gallery (PySide6 / PyQt6)

Loads the **same Gallery** as `src/gallery` from Python: QML is copied from `src/gallery` at startup; `main.cpp` / `GraphicsBackend` / `GalleryLanguage` / `DemoTreeModel` are Python.

Controls still come from a **shared kit** (`QWinUI3.Theme` / Style / Platform / Extras). This is not a subprocess of `qwinui3_gallery.exe`.

Recipe: [`docs/packaging-python.md`](../../docs/packaging-python.md).

## Prerequisites

1. `pip install PySide6` (preferred) or `pip install PyQt6`
2. A **shared** kit whose Qt **major.minor** matches the bindings (`from PySide6.QtCore import qVersion`):

```bat
python scripts/package_release_libs.py --shared --archive
```

Pair PySide6 **6.11** with a kit built against official Qt **6.11**, not 6.8/6.10.

## Run

```bat
set QWINUI3_ROOT=dist\qwinui3-2.64-windows-x64-shared
python examples/python-gallery/main.py
```

Or:

```bat
python -m qwinui3_gallery
```

(`PYTHONPATH=python` or run from the wrapper above.)

```bat
python examples/python-gallery/main.py --smoke
python examples/python-gallery/main.py --lang zh_CN
python examples/python-gallery/main.py --rhi opengl
```

Force PyQt6:

```bat
set QWINUI3_QT_BINDING=pyqt6
python examples/python-gallery/main.py --binding pyqt6
```

Verify import + optional smoke:

```bat
python scripts/verify_python.py
python scripts/verify_python.py --smoke
```
