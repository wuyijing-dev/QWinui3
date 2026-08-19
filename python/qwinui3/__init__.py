"""QWinUI3 Python consumer — PySide6 or PyQt6 + a shared kit (`qml/` + DLLs/.so).

Typical app:

    from qwinui3 import (
        configure_environment, configure_application, setup_engine,
        QtGui, QtQml, QtCore,
    )

    configure_environment()
    app = QtGui.QGuiApplication(sys.argv)
    configure_application("org.example.myapp")
    engine = QtQml.QQmlApplicationEngine()
    setup_engine(engine)
    engine.load(Main.qml)
    app.exec()
"""

from __future__ import annotations

from .bootstrap import (
    binding_name,
    configure_application,
    configure_environment,
    find_kit,
    qt_version,
    setup_engine,
)

__all__ = [
    "QtCore",
    "QtGui",
    "QtQml",
    "QtQuick",
    "QtQuickControls2",
    "BINDING",
    "binding_name",
    "configure_application",
    "configure_environment",
    "find_kit",
    "qt_version",
    "setup_engine",
]


def __getattr__(name: str):
    if name in ("QtCore", "QtGui", "QtQml", "QtQuick", "QtQuickControls2", "BINDING"):
        from . import _qt

        _qt.init()
        if name == "BINDING":
            return _qt.BINDING
        return getattr(_qt, name)
    raise AttributeError(name)
