"""Python port of src/gallery/GalleryLanguage.cpp — QML singleton GalleryLanguage."""

from __future__ import annotations

import os
from pathlib import Path

from qwinui3 import _qt

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

ROOT = Path(__file__).resolve().parents[2]
_STARTUP_OVERRIDE = ""
_instance: GalleryLanguage | None = None
_LOCALES = ["", "zh_CN", "ja_JP", "ko_KR", "de_DE"]


def normalize_locale(locale: str) -> str:
    trimmed = locale.strip()
    if not trimmed or trimmed in ("en", "en_US"):
        return ""
    return trimmed


def _search_directories() -> list[str]:
    dirs: list[str] = []
    env = os.environ.get("QWINUI3_GALLERY_TRANSLATIONS", "")
    if env:
        dirs.append(env)
    app_dir = QtCore.QCoreApplication.applicationDirPath() if QtCore.QCoreApplication.instance() else ""
    dirs.extend(
        [
            str(ROOT / "src" / "gallery" / "translations"),
            str(ROOT / "examples" / "python-gallery" / "translations"),
        ]
    )
    if app_dir:
        dirs.extend(
            [
                app_dir + "/translations",
                app_dir,
                app_dir + "/../src/gallery/translations",
            ]
        )
    return dirs


@QmlSingleton
@QmlElement
class GalleryLanguage(QObject):
    currentLocaleChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._engine = None
        self._translator = QtCore.QTranslator(self)
        self._installed = False
        self._current_locale = ""

    @staticmethod
    def create(engine, _script_engine):
        self = instance()
        self.set_engine(engine)
        return self

    def set_engine(self, engine) -> None:
        self._engine = engine
        if _STARTUP_OVERRIDE:
            self.applyLocale(_STARTUP_OVERRIDE)
        elif not self._current_locale and not self._installed:
            self.applyLocale(_read_persisted_locale())

    def _get_current_locale(self) -> str:
        return self._current_locale

    def _set_current_locale(self, locale: str) -> None:
        self.applyLocale(locale)

    currentLocale = Property(str, _get_current_locale, _set_current_locale, notify=currentLocaleChanged)

    @Property(list, constant=True)
    def availableLocales(self) -> list[str]:
        return list(_LOCALES)

    @Property(list, notify=currentLocaleChanged)
    def localeLabels(self) -> list[str]:
        return [self.labelForLocale(loc) for loc in _LOCALES]

    @Property(bool, notify=currentLocaleChanged)
    def translatorActive(self) -> bool:
        return self._installed and bool(self._current_locale)

    @Slot(str, result=str)
    def labelForLocale(self, locale: str) -> str:
        norm = normalize_locale(locale)
        if not norm:
            return self.tr("English (default)")
        if norm == "zh_CN":
            return self.tr("简体中文 (zh_CN)")
        if norm == "ja_JP":
            return self.tr("日本語 (ja_JP)")
        if norm == "ko_KR":
            return self.tr("한국어 (ko_KR)")
        if norm == "de_DE":
            return self.tr("Deutsch (de_DE)")
        return norm

    @Slot(str, result=int)
    def indexOfLocale(self, locale: str) -> int:
        norm = normalize_locale(locale)
        for i, loc in enumerate(_LOCALES):
            if normalize_locale(loc) == norm:
                return i
        return 0

    @Slot(str)
    def applyLocale(self, locale: str) -> None:
        norm = normalize_locale(locale)
        if norm == self._current_locale and (not self._installed if not norm else self._installed):
            return
        self._unload_translator()
        loaded = bool(norm) and self._load_translator(norm)
        if loaded:
            QtCore.QCoreApplication.installTranslator(self._translator)
        self._installed = loaded
        self._current_locale = norm if loaded else ""
        if self._engine is not None:
            self._engine.retranslate()
        if not _STARTUP_OVERRIDE:
            _persist_locale(self._current_locale)
        self.currentLocaleChanged.emit()

    def _load_translator(self, locale: str) -> bool:
        stem = f"qwinui3_gallery_{locale}"
        for directory in _search_directories():
            if not directory:
                continue
            path = Path(directory)
            if not path.is_dir():
                continue
            qm = path / f"{stem}.qm"
            if qm.is_file() and self._translator.load(str(qm)):
                print(f"QWinUI3 Gallery translator: {qm}", flush=True)
                return True
            if self._translator.load(QtCore.QLocale(locale), "qwinui3_gallery", "_", str(path)):
                print(
                    f"QWinUI3 Gallery translator (locale): {locale} in {path}",
                    flush=True,
                )
                return True
        print(
            f"QWinUI3 Gallery: locale {locale} — no .qm found (rebuild after lupdate/lrelease)",
            flush=True,
        )
        return False

    def _unload_translator(self) -> None:
        if self._installed:
            QtCore.QCoreApplication.removeTranslator(self._translator)
            self._installed = False


def _read_persisted_locale() -> str:
    settings = QtCore.QSettings()
    settings.beginGroup("Gallery")
    return normalize_locale(str(settings.value("uiLocale", "") or ""))


def _persist_locale(locale: str) -> None:
    settings = QtCore.QSettings()
    settings.beginGroup("Gallery")
    norm = normalize_locale(locale)
    if not norm:
        settings.remove("uiLocale")
    else:
        settings.setValue("uiLocale", norm)


def set_startup_locale_override(locale: str) -> None:
    global _STARTUP_OVERRIDE
    _STARTUP_OVERRIDE = normalize_locale(locale)


def instance() -> GalleryLanguage:
    global _instance
    if _instance is None:
        _instance = GalleryLanguage()
    return _instance
