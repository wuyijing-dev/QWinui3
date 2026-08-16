# Gallery translations (1.13 / 1.45)

Gallery / examples wrap UI strings in `qsTr(...)`. This folder holds **seed** Qt Linguist catalogs — **not** a full Gallery language pack.

| File | Role |
|------|------|
| `qwinui3_gallery_en.ts` | English seed (identity translations) |
| `qwinui3_gallery_zh_CN.ts` | Simplified Chinese seed (**1.45**) — demo subset |
| `*.qm` | Optional `lrelease` output (generate locally; may be gitignored if huge) |
| `README.md` | This workflow |

Do **not** commit a full `lupdate` of every Gallery page unless you intentionally ship that language.

---

## Extract / refresh (manual)

Qt `bin` on `PATH` (or use the kit from CMake `CMAKE_PREFIX_PATH`):

```bat
lupdate src/gallery -ts src/gallery/translations/qwinui3_gallery_en.ts
```

```bash
lupdate src/gallery -ts src/gallery/translations/qwinui3_gallery_en.ts
```

Integrity check (no Qt required):

```bash
python scripts/check_gallery_translations.py
```

---

## Add a locale

```bat
copy src\gallery\translations\qwinui3_gallery_en.ts src\gallery\translations\qwinui3_gallery_de.ts
linguist src\gallery\translations\qwinui3_gallery_de.ts
lrelease src\gallery\translations\qwinui3_gallery_de.ts -qm src\gallery\translations\qwinui3_gallery_de.qm
```

Name pattern: `qwinui3_gallery_<locale>.ts` where `<locale>` is `zh_CN`, `ar`, `de`, …

---

## Load in Gallery (1.45)

```bat
qwinui3_gallery.exe --lang zh_CN
```

`--lang` installs a `QTranslator` looking for `qwinui3_gallery_<lang>.qm` under:

1. `applicationDirPath()/translations`
2. `applicationDirPath()` (beside the exe)
3. Source tree `src/gallery/translations` (dev builds)
4. `QWINUI3_GALLERY_TRANSLATIONS` env override (directory)

Generate `.qm` before running:

```bat
lrelease src\gallery\translations\qwinui3_gallery_zh_CN.ts -qm src\gallery\translations\qwinui3_gallery_zh_CN.qm
```

Smoke / CI does **not** require `.qm` — `scripts/check_gallery_translations.py` validates `.ts` XML only.

---

## Consumer apps

```cpp
QTranslator tr;
if (tr.load(QLocale(QLocale::Chinese, QLocale::China),
            QStringLiteral("qwinui3_gallery"),
            QStringLiteral("_"),
            QStringLiteral("path/to/translations"))) {
    app.installTranslator(&tr);
}
```

Or load by exact file: `tr.load("path/to/qwinui3_gallery_zh_CN.qm")`.

RTL layout is **separate** from translation — Gallery Settings → **Right-to-left layout**. See [`docs/i18n-rtl.md`](../../../docs/i18n-rtl.md).
