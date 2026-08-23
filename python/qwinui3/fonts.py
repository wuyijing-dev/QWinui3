"""WinUI-aligned UI font stacks (Latin + CJK), mirroring ThemeFonts."""

from __future__ import annotations

import sys

from qwinui3 import _qt


def _has_family(name: str) -> bool:
    _qt.init()
    return _qt.QtGui.QFontDatabase.hasFamily(name)


def _append(out: list[str], name: str) -> None:
    if name and name not in out and _has_family(name):
        out.append(name)


def ui_families() -> list[str]:
    latin: list[str] = []
    cjk: list[str] = []
    if sys.platform == "win32":
        for n in ("Segoe UI Variable", "Segoe UI"):
            _append(latin, n)
        for n in (
            "Microsoft YaHei UI",
            "Microsoft JhengHei UI",
            "Yu Gothic UI",
            "Malgun Gothic",
            "Microsoft YaHei",
            "Microsoft JhengHei",
        ):
            _append(cjk, n)
    elif sys.platform == "darwin":
        for n in ("SF Pro Text", "Helvetica Neue"):
            _append(latin, n)
        for n in (
            "PingFang SC",
            "PingFang TC",
            "Hiragino Sans GB",
            "Hiragino Sans",
            "Apple SD Gothic Neo",
        ):
            _append(cjk, n)
    else:
        for n in ("Inter", "Noto Sans", "DejaVu Sans"):
            _append(latin, n)
        for n in (
            "Noto Sans CJK SC",
            "Noto Sans CJK TC",
            "Noto Sans CJK JP",
            "Noto Sans CJK KR",
            "Source Han Sans SC",
            "WenQuanYi Micro Hei",
            "Droid Sans Fallback",
        ):
            _append(cjk, n)
    stack = latin + cjk
    return stack or ["Sans Serif"]


def apply_application_font(pixel_size: int = 14) -> None:
    """Call after QGuiApplication exists (configure_application)."""
    _qt.init()
    families = ui_families()
    font = _qt.QtGui.QFont()
    font.setFamilies(families)
    if families:
        font.setFamily(families[0])
    font.setPixelSize(pixel_size)
    _qt.QtGui.QGuiApplication.setFont(font)
