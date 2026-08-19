# QWinUI3 Python modules

Source-only Python consumer support (**2.64**). Not on PyPI yet (**2.72**).

**Full documentation:** [docs/packaging-python.md](../docs/packaging-python.md) (also on [GitHub Pages](https://wuyijing-dev.github.io/QWinui3/packaging-python/)).

## Packages

| Directory | Import | Purpose |
|-----------|--------|---------|
| `qwinui3/` | `from qwinui3 import configure_environment, …` | Bootstrap for any PySide6/PyQt6 + shared kit app |
| `qwinui3_gallery/` | `python -m qwinui3_gallery` | Full Gallery (same QML as `src/gallery`) |

## Quick run

```bat
pip install PySide6
python scripts/package_release_libs.py --shared --archive
set QWINUI3_ROOT=dist\qwinui3-2.64-windows-x64-shared
set PYTHONPATH=python
python examples/python-gallery/main.py
python scripts/verify_python.py --smoke
```

## Layout on `PYTHONPATH`

Add the repo `python/` directory (not `python/qwinui3` alone):

```python
sys.path.insert(0, str(REPO_ROOT / "python"))
```

See [`examples/python-gallery/main.py`](../examples/python-gallery/main.py).
