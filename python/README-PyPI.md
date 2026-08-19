# qwinui3 (PyPI)

Fluent **Qt Quick** controls for **PySide6** and **PyQt6**, with a bundled platform shared kit (`qml/` + native plugins).

## Install

```bat
pip install qwinui3[pyside6]
qwinui3-gallery
```

Linux:

```bash
pip install qwinui3[pyside6]
qwinui3-gallery
```

Use `qwinui3[pyqt6]` if you prefer PyQt6. Match your binding Qt **major.minor** to the wheel (see docs).

## What you get

| Piece | Notes |
|-------|--------|
| `qwinui3` | Bootstrap — `configure_environment()`, `create_engine()`, runtime diagnostics |
| `qwinui3_gallery` | Full Gallery (`qwinui3-gallery` CLI) |
| Bundled kit | Platform wheel includes shared `qml/QWinUI3` + DLLs/.so |

## Documentation

Full consumer guide: [packaging-python.md](https://wuyijing-dev.github.io/QWinui3/packaging-python/)

```python
from qwinui3 import configure_environment, configure_application, create_engine, QtGui

kit = configure_environment()
app = QtGui.QGuiApplication([])
configure_application("org.example.app")
engine, _ = create_engine(kit=kit)
```

## License

Apache-2.0 — see [LICENSE](https://github.com/wuyijing-dev/QWinui3/blob/master/LICENSE).
