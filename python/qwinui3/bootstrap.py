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
from .welcome import print_welcome_banner


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

    # Product version from kit folder name when present (qwinui3-2.67-…).
    version = "dev"
    for part in resolved.name.split("-"):
        if len(part) >= 3 and part[0].isdigit() and "." in part:
            version = part
            break
    print_welcome_banner(version=version, qt=qt_version(), support="Qt 6.5+")

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

    # Match C++ configureEnvironment — soft RHI default when unset (no probe).
    # Opt in to probe+fallback with QWINUI3_RHI_PROBE=1.
    if not os.environ.get("QSG_RHI_BACKEND"):
        from . import rhi as _rhi

        probe = os.environ.get("QWINUI3_RHI_PROBE", "").strip() not in (
            "",
            "0",
            "false",
            "False",
        )
        if probe:
            _rhi.apply(_rhi.default_backend())
        else:
            _rhi.apply_direct(_rhi.preferred_platform_backend())

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
    from . import fonts as _fonts

    _fonts.apply_application_font()
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


def create_engine(
    *,
    kit: str | os.PathLike[str] | None = None,
    extra_import_paths: list[str | os.PathLike[str]] | None = None,
):
    """Create QQmlApplicationEngine pre-wired with the QWinUI3 import root."""
    _qt.init()
    engine = _qt.QtQml.QQmlApplicationEngine()
    resolved = setup_engine(engine, Path(kit) if kit is not None else None)
    for import_path in extra_import_paths or ():
        engine.addImportPath(str(Path(import_path)))
    return engine, resolved


def runtime_report(kit: Path | None = None) -> dict[str, object]:
    """Structured runtime info for app diagnostics and bug reports."""
    resolved = kit or find_kit()
    qml_root = resolved / "qml"
    return {
        "binding": binding_name(),
        "qt_version": qt_version(),
        "kit": str(resolved),
        "qml_root": str(qml_root),
        "has_qml_root": qml_root.is_dir(),
        "style": os.environ.get("QT_QUICK_CONTROLS_STYLE", ""),
        "qpa_platform": os.environ.get("QT_QPA_PLATFORM", ""),
    }


def validate_runtime(kit: Path | None = None) -> dict[str, object]:
    """Raise a readable error when the located kit is incomplete."""
    report = runtime_report(kit)
    qml_root = Path(str(report["qml_root"]))
    if not qml_root.is_dir():
        raise FileNotFoundError(
            f"QWinUI3 kit is missing its qml/ import root: {qml_root}\n"
            "Rebuild or reinstall the shared kit, or point QWINUI3_ROOT at a valid package."
        )
    if not (qml_root / "QWinUI3").is_dir():
        raise FileNotFoundError(
            f"QWinUI3 kit is missing qml/QWinUI3: {qml_root}\n"
            "The package looks incomplete; rebuild the shared kit or reinstall qwinui3."
        )
    return report


def qt_version() -> str:
    _qt.init()
    return _qt.QtCore.qVersion()


def binding_name() -> str:
    return _qt.init()
