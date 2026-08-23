# `qwinui3`

PySide6 or PyQt6 bootstrap — locate a shared kit, configure environment, and wire QQmlApplicationEngine import paths (mirrors C++ Bootstrap).

Source: [`python/qwinui3/`](https://github.com/wuyijing-dev/QWinui3/tree/master/python/qwinui3) · Library **v2.81** · [← Python API index](../python-api.md)

Install:

```bash
pip install qwinui3[pyside6]   # or PyQt6 + QWINUI3_QT_BINDING=pyqt6
```

## Quick start

```python
from qwinui3 import (
    configure_environment, configure_application, setup_engine,
    QtGui, QtQml,
)

configure_environment()  # before QGuiApplication
app = QtGui.QGuiApplication([])
configure_application("org.example.app")
engine = QtQml.QQmlApplicationEngine()
setup_engine(engine)
engine.load("Main.qml")
app.exec()
```

QML controls (`QWinUI3.Theme`, `QWinUI3.Extras`, …) load from the shared kit after `setup_engine()`. See [Component API](../components.md) for every control.

## `__init__`

[`python/qwinui3/__init__.py`](https://github.com/wuyijing-dev/QWinui3/blob/master/python/qwinui3/__init__.py)

QWinUI3 Python consumer — PySide6 or PyQt6 + a shared kit (`qml/` + DLLs/.so).

## `bootstrap`

[`python/qwinui3/bootstrap.py`](https://github.com/wuyijing-dev/QWinui3/blob/master/python/qwinui3/bootstrap.py)

Python equivalent of QWinUI3::configureEnvironment / configureApplication.

### Functions

| Signature | Description |
| --- | --- |
| `find_kit(explicit=…)` | Locate a packaged shared kit (`qml/` + `bin/` or `lib/`). |
| `configure_environment(kit, binding)` | Match C++ configureEnvironment — must run before QGuiApplication. |
| `configure_application(app_id=…)` | Match C++ configureApplication — after QGuiApplication exists. |
| `setup_engine(engine, kit=…)` | Add the kit `qml/` import root (style + Theme + Platform + Extras). |
| `create_engine(kit, extra_import_paths)` | Create QQmlApplicationEngine pre-wired with the QWinUI3 import root. |
| `runtime_report(kit=…)` | Structured runtime info for app diagnostics and bug reports. |
| `validate_runtime(kit=…)` | Raise a readable error when the located kit is incomplete. |
| `qt_version()` | — |
| `binding_name()` | — |

## `rhi`

[`python/qwinui3/rhi.py`](https://github.com/wuyijing-dev/QWinui3/blob/master/python/qwinui3/rhi.py)

Python port of QWinUI3::Compat::Rhi (QtCompatRhi.cpp).

### Functions

| Signature | Description |
| --- | --- |
| `normalize(name)` | — |
| `platform_backends()` | — |
| `fallback_order()` | — |
| `is_runtime_supported(backend)` | — |
| `coerce_available(backend, fallback=…)` | — |
| `default_backend()` | — |
| `graphics_api_for(backend)` | — |
| `apply(backend)` | — |

## `fonts`

[`python/qwinui3/fonts.py`](https://github.com/wuyijing-dev/QWinui3/blob/master/python/qwinui3/fonts.py)

WinUI LanguageFont-style UI stacks (locale-aware), mirroring ThemeFonts.

### Functions

| Signature | Description |
| --- | --- |
| `ui_families(locale=…)` | — |
| `apply_application_font(pixel_size=…, locale=…)` | — |
| `apply_for_ui_locale(locale)` | — |

## Internal modules

Not part of the stable consumer surface: `_qt`, `_paths`, `welcome`.

---
*Generated from `python/` sources by `scripts/generate_component_docs.py` — do not edit by hand.*
