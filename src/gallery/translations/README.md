# Gallery translations (1.13)

Gallery / examples wrap UI strings in `qsTr(...)`. This folder holds **optional** Qt Linguist catalogs — **not** a full language pack.

## Workflow

From the repo root (Qt `bin` on `PATH`):

```bat
REM Extract / refresh English source catalog from Gallery QML + main.cpp
lupdate src/gallery -ts src/gallery/translations/qwinui3_gallery_en.ts

REM Copy for a locale, translate in Linguist, then:
copy src\gallery\translations\qwinui3_gallery_en.ts src\gallery\translations\qwinui3_gallery_ar.ts
linguist src\gallery\translations\qwinui3_gallery_ar.ts
lrelease src\gallery\translations\qwinui3_gallery_ar.ts
```

Load at runtime (app-owned — Gallery does not auto-install a translator in 1.13):

```cpp
QTranslator tr;
if (tr.load(QLocale(QLocale::Arabic),
            QStringLiteral("qwinui3_gallery"),
            QStringLiteral("_"),
            QStringLiteral("path/to/translations"))) {
    app.installTranslator(&tr);
}
Qt::setUiLanguage(/* … */);  // optional
```

RTL layout is separate from translation: set `Qt.application.layoutDirection` and `LayoutMirroring` on the shell (Gallery Settings → **Right-to-left layout**). See [`docs/i18n-rtl.md`](../../../docs/i18n-rtl.md).

## Files

| File | Role |
|------|------|
| `qwinui3_gallery_en.ts` | Seed catalog (hand-maintained sample strings) |
| `README.md` | This workflow |

Regenerate the full Gallery catalog with `lupdate` when you start a real localization effort. Do not commit huge auto-generated diffs unless intentionally shipping a language.
