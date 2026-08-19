# Gallery translations

Gallery wraps UI strings in `qsTr(...)`. **`lupdate src/gallery`** extracts **~3600** messages per locale.

| File | Role |
|------|------|
| `qwinui3_gallery_en.ts` | English (source) |
| `qwinui3_gallery_zh_CN.ts` | 简体中文 |
| `qwinui3_gallery_ja_JP.ts` | 日本語 |
| `qwinui3_gallery_ko_KR.ts` | 한국어 |
| `qwinui3_gallery_de_DE.ts` | Deutsch (**2.35** seed) |

Release builds embed `.qm` via **`qt_add_translations`** (`:/i18n`).

Switch language **live**: Gallery **Settings → Display language** or **i18n / RTL** (`GalleryLanguage` + `QQmlEngine::retranslate`). Persisted in `QSettings` (`Gallery/uiLocale`). Startup override: `--lang zh_CN`.

---

## Extract / refresh

```bat
lupdate src/gallery -ts src/gallery/translations/qwinui3_gallery_en.ts ^
    src/gallery/translations/qwinui3_gallery_zh_CN.ts ^
    src/gallery/translations/qwinui3_gallery_ja_JP.ts ^
    src/gallery/translations/qwinui3_gallery_ko_KR.ts ^
    src/gallery/translations/qwinui3_gallery_de_DE.ts -no-obsolete
```

```bash
lupdate src/gallery \
  -ts src/gallery/translations/qwinui3_gallery_en.ts \
     src/gallery/translations/qwinui3_gallery_zh_CN.ts \
     src/gallery/translations/qwinui3_gallery_ja_JP.ts \
     src/gallery/translations/qwinui3_gallery_ko_KR.ts \
     src/gallery/translations/qwinui3_gallery_de_DE.ts \
  -no-obsolete
```

After `lupdate`, translate in Qt Linguist, then **Release build** (CMake runs `lrelease` via `qt_add_translations`).

---

## Add a locale

Copy `qwinui3_gallery_en.ts` → `qwinui3_gallery_de_DE.ts` (or other locale code), translate, add the `.ts` to `qt_add_translations` in `src/gallery/CMakeLists.txt`, extend `GalleryLanguage::availableLocales()`. **2.35** ships **`de_DE`** as the fourth seed.

---

## Consumer apps

[`docs/i18n-rtl.md`](../../../docs/i18n-rtl.md) · [`examples/gallery-shell/translations/`](../../../examples/gallery-shell/translations/)

RTL layout is separate — Gallery Settings → **Right-to-left layout**.
