"""Python equivalent of QWinUI3::configureEnvironment / configureApplication.

Call configure_environment() before constructing QGuiApplication.
Then configure_application() and setup_engine().
"""

from __future__ import annotations

import os
import sys
from pathlib import Path

from . import _qt
from ._paths import bundled_kit_dir, dist_kit_dirs


def find_kit(explicit: str | os.PathLike[str] | None = None) -> Path:
    """Locate a packaged shared kit (`qml/` + `bin/` or `lib/`)."""
    candidates: list[Path] = []
    if explicit:
        candidates.append(Path(explicit))
    env = os.environ.get("QWINUI3_ROOT")
    if env:
        candidates.append(Path(env))
    bundled = bundled_kit_dir()
    if bundled is not None:
        candidates.append(bundled)
    candidates.extend(dist_kit_dirs())
    for c in candidates:
        p = c.expanduser()
        if p.is_file() and p.suffix.lower() in {".zip", ".gz"}:
            continue
        qml = p / "qml"
        if (qml / "QWinUI3").is_dir() or any(p.glob("qwinui3_*.dll")) or any(
            p.glob("libqwinui3_*.so*")
        ):
            return p.resolve()
    raise FileNotFoundError(
        "No QWinUI3 shared kit found.\n"
        "  pip install qwinui3[pyside6]   # wheel bundles platform kit\n"
        "  python scripts/package_release_libs.py --shared --archive  # dev checkout\n"
        "  set QWINUI3_ROOT=dist\\qwinui3-<ver>-<plat>-x64-shared\n"
        "Or pass kit= to configure_environment()."
    )


def configure_environment(
    *,
    kit: str | os.PathLike[str] | None = None,
    binding: str | None = None,
) -> Path:
    """Match C++ configureEnvironment — must run before QGuiApplication.

    Sets QT_QUICK_CONTROLS_STYLE, prefers system IME, sanitizes a foreign
    Windows QPA unless QWINUI3_ALLOW_FOREIGN_QPA is set.
    """
    _qt.init(binding)
    resolved = find_kit(kit)
    os.environ["QWINUI3_ROOT"] = str(resolved)

    if sys.platform == "win32" and not os.environ.get("QWINUI3_ALLOW_FOREIGN_QPA"):
        p = os.environ.get("QT_QPA_PLATFORM", "").strip().lower()
        if p and p not in ("windows", "direct2d"):
            os.environ["QT_QPA_PLATFORM"] = "windows"

    os.environ.pop("QT_IM_MODULE", None)
    os.environ["QT_QUICK_CONTROLS_STYLE"] = "QWinUI3"

    # High-DPI: set via API after QtGui import, still before QGuiApplication.
    QtGui = _qt.QtGui
    Qt = _qt.QtCore.Qt
    policy = Qt.HighDpiScaleFactorRoundingPolicy.PassThrough
    QtGui.QGuiApplication.setHighDpiScaleFactorRoundingPolicy(policy)

    _expose_native_libs(resolved)
    return resolved


def _expose_native_libs(kit: Path) -> None:
    """Make qwinui3_*.dll/.so visible after the Python Qt binding has loaded."""
    bin_dir = kit / "bin"
    lib_dir = kit / "lib"
    if sys.platform == "win32":
        search_dirs: list[Path] = []
        if bin_dir.is_dir():
            search_dirs.append(bin_dir)
        if lib_dir.is_dir():
            search_dirs.append(lib_dir)
        if not search_dirs and any(kit.glob("qwinui3_*.dll")):
            search_dirs.append(kit)
        for directory in search_dirs:
            if hasattr(os, "add_dll_directory"):
                os.add_dll_directory(str(directory))
        if search_dirs:
            extra = os.pathsep.join(str(d) for d in search_dirs)
            path = os.environ.get("PATH", "")
            if extra.lower() not in path.lower():
                os.environ["PATH"] = extra + os.pathsep + path
        return
    so_dir = lib_dir if lib_dir.is_dir() else bin_dir
    if not so_dir.is_dir():
        return
    key = "LD_LIBRARY_PATH"
    cur = os.environ.get(key, "")
    if str(so_dir) not in cur.split(os.pathsep):
        os.environ[key] = str(so_dir) + (os.pathsep + cur if cur else "")


def configure_application(app_id: str = "") -> None:
    """Match C++ configureApplication — after QGuiApplication exists."""
    _qt.init()
    _qt.QtQuickControls2.QQuickStyle.setStyle("QWinUI3")
    if not app_id:
        return
    app = _qt.QtGui.QGuiApplication.instance()
    if app is not None and hasattr(app, "setDesktopFileName"):
        app.setDesktopFileName(app_id)


def setup_engine(engine, kit: Path | None = None) -> Path:
    """Add the kit `qml/` import root (style + Theme + Platform + Extras)."""
    resolved = kit or find_kit()
    qml = resolved / "qml"
    if qml.is_dir():
        engine.addImportPath(str(qml))
    return resolved


def qt_version() -> str:
    _qt.init()
    return _qt.QtCore.qVersion()


def binding_name() -> str:
    return _qt.init()
