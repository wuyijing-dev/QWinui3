"""Python port of src/gallery/GraphicsBackend.cpp — QML singleton GraphicsBackend."""

from __future__ import annotations

import os
import sys

from qwinui3 import _qt

from . import rhi

_qt.init()

QtCore = _qt.QtCore
QObject = _qt.QtCore.QObject
Property = _qt.Property
Signal = _qt.Signal
Slot = _qt.Slot
QmlElement = _qt.QmlElement
QmlSingleton = _qt.QmlSingleton

QML_IMPORT_NAME = "QWinUI3.Gallery"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0

_instance: GraphicsBackend | None = None
_early_backend = ""


def _default_backend() -> str:
    return "opengl"


def _read_stored_preferred() -> str:
    if QtCore.QCoreApplication.instance() is None:
        return ""
    settings = QtCore.QSettings("QWinUI3", "Gallery")
    return rhi.normalize(str(settings.value("graphics/rhiBackend", "") or ""))


def _write_stored_preferred(backend: str) -> None:
    if QtCore.QCoreApplication.instance() is None:
        return
    settings = QtCore.QSettings("QWinUI3", "Gallery")
    settings.setValue("graphics/rhiBackend", backend)


def _parse_cli(argv: list[str]) -> str:
    chosen = ""
    i = 1
    while i < len(argv):
        arg = argv[i]
        value = ""
        if arg in ("--rhi", "-rhi"):
            if i + 1 < len(argv):
                i += 1
                value = argv[i]
        elif arg.startswith("--rhi="):
            value = arg[6:]
        normalized = rhi.normalize(value)
        if normalized:
            chosen = normalized
        i += 1
    return chosen


@QmlSingleton
@QmlElement
class GraphicsBackend(QObject):
    changed = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._preferred = _read_stored_preferred() or _default_backend()
        env = rhi.normalize(os.environ.get("QSG_RHI_BACKEND", ""))
        self._active = env or self._preferred

    @staticmethod
    def create(_engine, _script_engine):
        return instance()

    @Property(str, notify=changed)
    def active(self) -> str:
        return self._active

    def _get_preferred(self) -> str:
        return self._preferred

    def _set_preferred(self, backend: str) -> None:
        normalized = rhi.normalize(backend)
        if not normalized or normalized not in rhi.platform_backends():
            return
        if normalized == self._preferred:
            return
        self._preferred = normalized
        _write_stored_preferred(normalized)
        self.changed.emit()

    preferred = Property(str, _get_preferred, _set_preferred, notify=changed)

    @Property(list, constant=True)
    def available(self) -> list[str]:
        return rhi.platform_backends()

    @Property(bool, notify=changed)
    def restartRequired(self) -> bool:
        return bool(self._preferred) and self._preferred != self._active

    @Property(str, notify=changed)
    def hint(self) -> str:
        if self._active == "opengl":
            return "OpenGL — recommended for DWM frost without edge artifacts."
        if self._active == "vulkan":
            return "Vulkan — alpha OK on many GPUs; border workarounds are limited."
        if self._active == "d3d11":
            return "Direct3D 11 — frost works; may show a thin white edge ring."
        if self._active == "d3d12":
            return "Direct3D 12 — frost works; may show a thin white edge ring."
        if self._active == "metal":
            return "Metal — macOS default path."
        return ""

    @Slot()
    def restartApplication(self) -> None:
        args = list(QtCore.QCoreApplication.arguments())
        script = args[0] if args else sys.argv[0]
        rest = args[1:] if len(args) > 1 else []
        filtered: list[str] = []
        skip_next = False
        for a in rest:
            if skip_next:
                skip_next = False
                continue
            if a in ("--rhi", "-rhi"):
                skip_next = True
                continue
            if a.startswith("--rhi="):
                continue
            filtered.append(a)
        filtered.insert(0, f"--rhi={self._preferred}")
        QtCore.QProcess.startDetached(sys.executable, [script, *filtered])
        QtCore.QCoreApplication.quit()


def apply_early(argv: list[str] | None = None) -> str:
    """Must run before QGuiApplication / any QQuickWindow (env + RHI only)."""
    global _early_backend
    argv = argv if argv is not None else sys.argv
    cli = _parse_cli(argv)
    env = rhi.normalize(os.environ.get("QSG_RHI_BACKEND", ""))
    if cli:
        backend = cli
    elif env:
        backend = env
    else:
        backend = _default_backend()
    backend = rhi.coerce_available(backend, _default_backend())
    rhi.apply(backend)
    _early_backend = backend
    print(
        f"QWinUI3 Gallery RHI backend: {backend} — "
        "change in Settings or --rhi opengl|vulkan|d3d11|d3d12",
        flush=True,
    )
    return backend


def sync_after_app() -> None:
    self = instance()
    stored = _read_stored_preferred()
    self._active = _early_backend or _default_backend()
    self._preferred = stored or self._active
    if (
        not os.environ.get("QSG_RHI_BACKEND")
        and stored
        and _early_backend == _default_backend()
        and stored != self._active
    ):
        self._preferred = stored
    self.changed.emit()


def instance() -> GraphicsBackend:
    global _instance
    if _instance is None:
        _instance = GraphicsBackend()
    return _instance
