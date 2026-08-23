"""WinUI LanguageFont-style UI stacks (locale-aware), mirroring ThemeFonts."""

from __future__ import annotations

import sys

from qwinui3 import _qt

_ui_locale = ""
_revision = 0


def _has_family(name: str) -> bool:
    _qt.init()
    return _qt.QtGui.QFontDatabase.hasFamily(name)


def _append(out: list[str], name: str, *, require: bool = True) -> None:
    if not name or name in out:
        return
    if require and not _has_family(name):
        return
    out.append(name)


def _normalize(locale: str) -> str:
    t = (locale or "").strip().lower().replace("-", "_")
    if t in ("", "en", "en_us", "c"):
        return ""
    return t


def ui_families(locale: str | None = None) -> list[str]:
    loc = _normalize(locale if locale is not None else _ui_locale)
    primary: list[str] = []
    latin: list[str] = []
    cjk: list[str] = []

    if sys.platform == "win32":
        for n in ("Segoe UI Variable", "Segoe UI Variable Text", "Segoe UI"):
            _append(latin, n)
        hans = loc.startswith(("zh_cn", "zh_sg", "zh_hans")) or loc == "zh"
        hant = loc.startswith(("zh_tw", "zh_hk", "zh_mo", "zh_hant"))
        if hans:
            _append(primary, "Microsoft YaHei UI", require=False)
            _append(primary, "Microsoft YaHei", require=False)
        elif hant:
            _append(primary, "Microsoft JhengHei UI", require=False)
            _append(primary, "Microsoft JhengHei", require=False)
        elif loc.startswith("ja"):
            _append(primary, "Yu Gothic UI", require=False)
        elif loc.startswith("ko"):
            _append(primary, "Malgun Gothic", require=False)
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
        if loc.startswith("zh"):
            _append(primary, "PingFang SC", require=False)
        elif loc.startswith("ja"):
            _append(primary, "Hiragino Sans", require=False)
        elif loc.startswith("ko"):
            _append(primary, "Apple SD Gothic Neo", require=False)
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
        if loc.startswith("zh"):
            _append(primary, "Noto Sans CJK SC", require=False)
        elif loc.startswith("ja"):
            _append(primary, "Noto Sans CJK JP", require=False)
        elif loc.startswith("ko"):
            _append(primary, "Noto Sans CJK KR", require=False)
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

    stack: list[str] = []
    for n in primary + latin + cjk:
        if n not in stack:
            stack.append(n)
    return stack or ["Sans Serif"]


def apply_application_font(pixel_size: int = 14, locale: str | None = None) -> None:
    _qt.init()
    families = ui_families(locale)
    font = _qt.QtGui.QFont()
    font.setFamilies(families)
    font.setPixelSize(pixel_size)
    _qt.QtGui.QGuiApplication.setFont(font)


def apply_for_ui_locale(locale: str) -> None:
    global _ui_locale, _revision
    _ui_locale = _normalize(locale)
    _revision += 1
    apply_application_font(locale=_ui_locale)
