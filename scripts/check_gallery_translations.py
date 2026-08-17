#!/usr/bin/env python3
"""Validate Gallery translation catalogs and live locale switch wiring.

  python scripts/check_gallery_translations.py

Checks .ts XML (~3600 messages), README, and GalleryLanguage / qt_add_translations wiring.
No Qt / lrelease required.
"""

from __future__ import annotations

import sys
import xml.etree.ElementTree as ET
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TRANS = ROOT / "src" / "gallery" / "translations"

# Seed catalogs + full Gallery extract (lupdate src/gallery — ~3600 messages per locale).
REQUIRED = [
    "qwinui3_gallery_en.ts",
    "qwinui3_gallery_zh_CN.ts",
    "qwinui3_gallery_ja_JP.ts",
    "qwinui3_gallery_ko_KR.ts",
    "qwinui3_gallery_de_DE.ts",
]
MIN_MESSAGES = 3000


def must_contain(path: Path, needles: tuple[str, ...]) -> list[str]:
    if not path.is_file():
        return [f"missing {path.relative_to(ROOT)}"]
    text = path.read_text(encoding="utf-8")
    return [f"{path.relative_to(ROOT)}: missing {n!r}" for n in needles if n not in text]


def check_wiring() -> list[str]:
    errors: list[str] = []
    errors.extend(
        must_contain(
            ROOT / "src" / "gallery" / "GalleryLanguage.cpp",
            ("engine->retranslate()", "QSettings", "uiLocale", ":/i18n"),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "src" / "gallery" / "GalleryLanguage.h",
            ("QML_SINGLETON", "applyLocale", "availableLocales"),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "src" / "gallery" / "Main.qml",
            ("refreshNavForLocale", "onCurrentLocaleChanged", "GalleryLanguage"),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "src" / "gallery" / "ControlCatalog.qml",
            ("GalleryLanguage.currentLocale",),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "src" / "gallery" / "pages" / "SettingsPage.qml",
            ("Display language", "GalleryLanguage.applyLocale"),
        )
    )
    errors.extend(
        must_contain(
            ROOT / "src" / "gallery" / "CMakeLists.txt",
            ("qt_add_translations", "qwinui3_gallery_zh_CN.ts", 'RESOURCE_PREFIX "/i18n"'),
        )
    )
    return errors


def main() -> int:
    if not TRANS.is_dir():
        print(f"error: missing {TRANS}", file=sys.stderr)
        return 2

    ok = 0
    for name in REQUIRED:
        path = TRANS / name
        if not path.is_file():
            print(f"error: missing seed catalog {path}", file=sys.stderr)
            return 2
        try:
            tree = ET.parse(path)
        except ET.ParseError as exc:
            print(f"error: {path}: {exc}", file=sys.stderr)
            return 2
        root = tree.getroot()
        if root.tag != "TS":
            print(f"error: {path}: root is <{root.tag}>, expected <TS>", file=sys.stderr)
            return 2
        lang = root.attrib.get("language", "")
        contexts = list(root.findall("context"))
        messages = sum(len(c.findall("message")) for c in contexts)
        if messages < MIN_MESSAGES:
            print(f"error: {path}: expected >={MIN_MESSAGES} messages, got {messages}", file=sys.stderr)
            return 2
        print(f"ok: {name} language={lang or '(none)'} contexts={len(contexts)} messages={messages}")
        ok += 1

    readme = TRANS / "README.md"
    if not readme.is_file():
        print(f"error: missing {readme}", file=sys.stderr)
        return 2

    wiring_errors = check_wiring()
    if wiring_errors:
        print("error: gallery i18n wiring checks failed:", file=sys.stderr)
        for e in wiring_errors:
            print(f"  {e}", file=sys.stderr)
        return 1

    print(f"translations: {ok} catalogs OK, live switch wiring OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
