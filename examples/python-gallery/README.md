# Python Gallery (PySide6 / PyQt6)

Loads the **same Gallery** as `src/gallery` from Python. Controls come from a **shared kit** in `dist/`.

## One command

From repo root:

```bat
pip install PySide6
python scripts/qwinui3.py python
```

Or double-click **`python-gallery.cmd`** (Windows).

First run packages the shared kit into `dist/` if it is missing (needs Qt + compiler — same as `package_release_libs.py`). Later runs skip packaging.

Smoke:

```bat
python scripts/qwinui3.py python --smoke
```

Check environment:

```bat
python scripts/qwinui3.py doctor
```

Full recipe: [`docs/packaging-python.md`](../../docs/packaging-python.md).

## Manual path (advanced)

```bat
python scripts/package_release_libs.py --shared --archive
python examples/python-gallery/main.py
```

`QWINUI3_ROOT` is optional when `dist/qwinui3-*-shared` exists.
