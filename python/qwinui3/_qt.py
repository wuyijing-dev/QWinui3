"""Detect PySide6 or PyQt6 and expose a small Qt facade."""

from __future__ import annotations

import os
from types import ModuleType
from typing import Any, Callable

BINDING = ""
QtCore: ModuleType
QtGui: ModuleType
QtQml: ModuleType
QtQuick: ModuleType
QtQuickControls2: ModuleType
Signal: Any
Property: Any
Slot: Any
qmlRegisterType: Callable[..., int]
qmlRegisterSingletonInstance: Callable[..., int]
QmlElement: Any
QmlSingleton: Any


def _load(prefer: str | None) -> str:
    order = ["pyside6", "pyqt6"]
    if prefer == "pyqt6":
        order = ["pyqt6", "pyside6"]
    elif prefer == "pyside6":
        order = ["pyside6", "pyqt6"]

    last_err: BaseException | None = None
    for name in order:
        try:
            if name == "pyside6":
                from PySide6 import QtCore as _core
                from PySide6 import QtGui as _gui
                from PySide6 import QtQml as _qml
                from PySide6 import QtQuick as _quick
                from PySide6.QtQuickControls2 import QQuickStyle
                from PySide6.QtQml import qmlRegisterSingletonInstance as _reg_single
                from PySide6.QtQml import qmlRegisterType as _reg_type
                from PySide6.QtQml import QmlElement as _QmlElement
                from PySide6.QtQml import QmlSingleton as _QmlSingleton

                sig, prop, slot = _core.Signal, _core.Property, _core.Slot
            else:
                from PyQt6 import QtCore as _core
                from PyQt6 import QtGui as _gui
                from PyQt6 import QtQml as _qml
                from PyQt6 import QtQuick as _quick
                from PyQt6.QtQuickControls2 import QQuickStyle
                from PyQt6.QtQml import qmlRegisterSingletonInstance as _reg_single
                from PyQt6.QtQml import qmlRegisterType as _reg_type
                from PyQt6.QtQml import QmlElement as _QmlElement
                from PyQt6.QtQml import QmlSingleton as _QmlSingleton

                sig, prop, slot = _core.pyqtSignal, _core.pyqtProperty, _core.pyqtSlot
        except ImportError as exc:
            last_err = exc
            continue
        globals()["QtCore"] = _core
        globals()["QtGui"] = _gui
        globals()["QtQml"] = _qml
        globals()["QtQuick"] = _quick
        qc2 = ModuleType("QtQuickControls2")
        qc2.QQuickStyle = QQuickStyle
        globals()["QtQuickControls2"] = qc2
        globals()["Signal"] = sig
        globals()["Property"] = prop
        globals()["Slot"] = slot
        globals()["qmlRegisterType"] = _reg_type
        globals()["qmlRegisterSingletonInstance"] = _reg_single
        globals()["QmlElement"] = _QmlElement
        globals()["QmlSingleton"] = _QmlSingleton
        return name
    raise ImportError(
        "QWinUI3 Python support needs PySide6 or PyQt6 "
        "(current wheels, Qt 6.5+). "
        "Install one of: pip install PySide6  |  pip install PyQt6"
    ) from last_err


def init(prefer: str | None = None) -> str:
    global BINDING
    if BINDING:
        return BINDING
    raw = (prefer or os.environ.get("QWINUI3_QT_BINDING") or "").strip().lower()
    if raw in ("pyside", "shiboken"):
        raw = "pyside6"
    if raw in ("pyqt", "sip"):
        raw = "pyqt6"
    BINDING = _load(raw or None)
    return BINDING
