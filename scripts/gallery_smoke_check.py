#!/usr/bin/env python3
"""Smoke-check Gallery QML for CatalogPage FINAL regressions and basic load.

Runs without a display when possible (qmlcachegen-style parse via Qt is heavy);
this script does static checks that catch the failures we hit in production:

  - CatalogPage must be rooted on Item (not Page)
  - CatalogPage must not redeclare FINAL Page props (title/footer aliases to Page)
  - Key gallery pages that use overlay/footer must still reference CatalogPage / overlay / footer
  - No leftover Layout.leftMargin: Theme.spacingSection on CatalogPage demos (HomePage exempt)

Exit code 0 = OK, 1 = problems.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GALLERY = ROOT / "src" / "gallery"
PAGES = GALLERY / "pages"
CATALOG = GALLERY / "CatalogPage.qml"

# Pages that intentionally keep section margins or non-Catalog hosts
MARGIN_ALLOWLIST = {
    "HomePage.qml",  # pagePadding: 0 + custom hero margins
}


def fail(msg: str) -> None:
    print(f"FAIL: {msg}")


def ok(msg: str) -> None:
    print(f"OK:   {msg}")


def check_catalog_page() -> list[str]:
    errors: list[str] = []
    text = CATALOG.read_text(encoding="utf-8")
    # Root type
    if re.search(r"(?m)^Page\s*\{", text):
        errors.append("CatalogPage.qml roots on Page — must be Item (FINAL title/footer)")
    if not re.search(r"(?m)^Item\s*\{", text):
        errors.append("CatalogPage.qml missing Item { root")
    # Must not alias over Page FINAL names while inheriting Page (already covered),
    # but also guard against reintroducing property alias title while on Item is fine.
    # Forbid inheriting Page patterns:
    if "extends Page" in text or "T.Page" in text:
        errors.append("CatalogPage must not extend Page / T.Page")
    if re.search(r"property\s+alias\s+title\s*:", text) and re.search(r"(?m)^Page\s*\{", text):
        errors.append("CatalogPage aliases title on Page (FINAL)")
    if re.search(r"property\s+alias\s+footer\s*:", text) and re.search(r"(?m)^Page\s*\{", text):
        errors.append("CatalogPage aliases footer on Page (FINAL)")
    # Required API
    for needle in ("property alias footer:", "property alias overlay:", "default property alias contentData:"):
        if needle not in text:
            errors.append(f"CatalogPage missing `{needle}`")
    return errors


def check_key_pages() -> list[str]:
    errors: list[str] = []
    expectations = {
        "MenuFlyoutPage.qml": ["CatalogPage"],
        "ItemsViewPage.qml": ["CatalogPage", "overlay:"],
        "TreeViewRecipePage.qml": ["CatalogPage", "overlay:"],
        "StatusBarPage.qml": ["CatalogPage", "footer:"],
        "ToastHostPage.qml": ["CatalogPage", "overlay:"],
        "ToastPage.qml": ["CatalogPage", "overlay:"],
        "DialogPage.qml": ["CatalogPage", "overlay:", "Overlay.overlay"],
        "ContentDialogPage.qml": ["CatalogPage", "overlay:", "Overlay.overlay"],
        "HomePage.qml": ["CatalogPage", 'title: ""', "pagePadding: 0"],
        "SettingsPage.qml": ["SettingsView"],  # not CatalogPage
        "SettingsGroupPage.qml": ["SettingsView"],
    }
    for name, needles in expectations.items():
        path = PAGES / name
        if not path.exists():
            errors.append(f"missing {name}")
            continue
        text = path.read_text(encoding="utf-8")
        for n in needles:
            if n not in text:
                errors.append(f"{name} missing `{n}`")
    # Settings pages must NOT use CatalogPage as the settings host
    for name in ("SettingsPage.qml", "SettingsGroupPage.qml"):
        text = (PAGES / name).read_text(encoding="utf-8")
        if re.search(r"(?m)^CatalogPage\s*\{", text):
            errors.append(f"{name} should stay SettingsView-hosted, not CatalogPage")
    return errors


def check_leftover_margins() -> list[str]:
    errors: list[str] = []
    pat = re.compile(r"Layout\.leftMargin:\s*Theme\.spacingSection")
    for path in sorted(PAGES.glob("*Page.qml")):
        if path.name in MARGIN_ALLOWLIST:
            continue
        text = path.read_text(encoding="utf-8")
        if not re.search(r"(?m)^CatalogPage\s*\{", text):
            continue
        if pat.search(text):
            errors.append(f"{path.name} still has Layout.leftMargin: Theme.spacingSection")
    return errors


def main() -> int:
    print(f"Gallery root: {GALLERY}")
    all_errors: list[str] = []
    for section, fn in (
        ("CatalogPage", check_catalog_page),
        ("key pages", check_key_pages),
        ("leftover margins", check_leftover_margins),
    ):
        errs = fn()
        if errs:
            for e in errs:
                fail(f"[{section}] {e}")
            all_errors.extend(errs)
        else:
            ok(section)
    if all_errors:
        print(f"\n{len(all_errors)} problem(s).")
        return 1
    print("\nAll gallery smoke checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
