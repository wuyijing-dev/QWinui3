# `qwinui3_gallery`

Full Gallery from Python — stage QWinUI3.Gallery QML, register Gallery helpers via @QmlElement / @QmlSingleton, and run the same smoke path as the C++ exe.

Source: [`python/qwinui3_gallery/`](https://github.com/wuyijing-dev/QWinui3/tree/master/python/qwinui3_gallery) · Library **v2.80** · [← Python API index](../python-api.md)

Install:

```bash
pip install qwinui3[pyside6]   # or PyQt6 + QWINUI3_QT_BINDING=pyqt6
```

## Gallery entry

```bash
qwinui3-gallery
python -m qwinui3_gallery --smoke
```

Stages `src/gallery` into a filesystem `QWinUI3.Gallery` module and registers Python `@QmlElement` types (`GraphicsBackend`, `GalleryLanguage`, `DemoTreeModel`).

## `__init__`

[`python/qwinui3_gallery/__init__.py`](https://github.com/wuyijing-dev/QWinui3/blob/master/python/qwinui3_gallery/__init__.py)

QWinUI3 Gallery loaded from Python (PySide6 / PyQt6).

## `main`

[`python/qwinui3_gallery/main.py`](https://github.com/wuyijing-dev/QWinui3/blob/master/python/qwinui3_gallery/main.py)

Python port of src/gallery/main.cpp — load QWinUI3.Gallery/Main.

### Functions

| Signature | Description |
| --- | --- |
| `main(argv=…)` | — |

## `qml_module`

[`python/qwinui3_gallery/qml_module.py`](https://github.com/wuyijing-dev/QWinui3/blob/master/python/qwinui3_gallery/qml_module.py)

Stage Gallery QML into a filesystem QWinUI3.Gallery module for Python.

### Functions

| Signature | Description |
| --- | --- |
| `gallery_qml_source()` | Bundled wheel copy, or repo `src/gallery`. |
| `default_stage_root()` | Where to materialize the QWinUI3.Gallery import tree. |
| `gallery_module_dir(stage_root=…)` | — |
| `get_module_dir()` | Module directory after `stage_gallery_qml()` (or the default path). |
| `stage_gallery_qml(src=…, dest=…)` | Copy Gallery QML and write qmldir. Returns import-path root. |

## `types`

[`python/qwinui3_gallery/types.py`](https://github.com/wuyijing-dev/QWinui3/blob/master/python/qwinui3_gallery/types.py)

Import Gallery Python types so @QmlElement / @QmlSingleton register on QWinUI3.Gallery.

### Functions

| Signature | Description |
| --- | --- |
| `register_types(_engine)` | Ensure decorated Gallery types are imported before QML load. |

## `graphics_backend`

[`python/qwinui3_gallery/graphics_backend.py`](https://github.com/wuyijing-dev/QWinui3/blob/master/python/qwinui3_gallery/graphics_backend.py)

Python port of src/gallery/GraphicsBackend.cpp — QML singleton GraphicsBackend.

### Functions

| Signature | Description |
| --- | --- |
| `apply_early(argv=…)` | Must run before QGuiApplication / any QQuickWindow (env + RHI only). |
| `sync_after_app()` | — |
| `instance()` | — |

### Types

#### `GraphicsBackend` · QML singleton · `QWinUI3.Gallery 1.0`

| Member | Kind | Description |
| --- | --- | --- |
| `create(_engine, _script_engine)` | method | — |
| `active()` | method | — |
| `property preferred` | property | — |
| `available()` | method | — |
| `restartRequired()` | method | — |
| `hint()` | method | — |
| `restartApplication()` | slot | — |

## `gallery_language`

[`python/qwinui3_gallery/gallery_language.py`](https://github.com/wuyijing-dev/QWinui3/blob/master/python/qwinui3_gallery/gallery_language.py)

Python port of src/gallery/GalleryLanguage.cpp — QML singleton GalleryLanguage.

### Functions

| Signature | Description |
| --- | --- |
| `normalize_locale(locale)` | — |
| `set_startup_locale_override(locale)` | — |
| `instance()` | — |

### Types

#### `GalleryLanguage` · QML singleton · `QWinUI3.Gallery 1.0`

| Member | Kind | Description |
| --- | --- | --- |
| `create(engine, _script_engine)` | method | — |
| `set_engine(engine)` | method | — |
| `property currentLocale` | property | — |
| `availableLocales()` | method | — |
| `localeLabels()` | method | — |
| `translatorActive()` | method | — |
| `labelForLocale(locale)` | slot | — |
| `indexOfLocale(locale)` | slot | — |
| `applyLocale(locale)` | slot | — |

## `demo_tree_model`

[`python/qwinui3_gallery/demo_tree_model.py`](https://github.com/wuyijing-dev/QWinui3/blob/master/python/qwinui3_gallery/demo_tree_model.py)

Python port of src/gallery/DemoTreeModel.cpp — QML type DemoTreeModel.

### Types

#### `DemoTreeModel` · QML type · `QWinUI3.Gallery 1.0`

## `rhi`

[`python/qwinui3_gallery/rhi.py`](https://github.com/wuyijing-dev/QWinui3/blob/master/python/qwinui3_gallery/rhi.py)

Re-export kit RHI helpers for Gallery (same as Compat::Rhi).

---
*Generated from `python/` sources by `scripts/generate_component_docs.py` — do not edit by hand.*
