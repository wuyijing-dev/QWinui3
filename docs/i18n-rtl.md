# i18n / RTL (1.13 / 1.45 / 1.54 / 2.12 / 2.20 full Gallery switch / 2.35 wave 4)

Gallery and starter examples wrap UI strings in **`qsTr`**. This page covers:

1. Extracting / shipping `.ts` → `.qm` catalogs (**~3600** Gallery strings)  
2. **Live** locale switch in Gallery (`GalleryLanguage`) or `--lang` at startup  
3. **RTL** via `LayoutMirroring` without breaking LTR  

| Surface | Where |
|---------|--------|
| Gallery Settings | **Display language** — live switch + persist |
| Gallery demo | **Layout → i18n / RTL** — same `GalleryLanguage` API |
| Gallery Settings | **Right-to-left layout** toggle (separate from translation) |
| Catalogs | [`src/gallery/translations/`](../src/gallery/translations/) — `en`, `zh_CN`, `ja_JP`, `ko_KR`, `de_DE` (**2.35**) |
| Integrity | `python scripts/check_gallery_translations.py` · `python scripts/check_localization_wave4.py` (**2.35**) |

---

## qsTr + Linguist workflow (1.45)

### 1. Mark strings

Use `qsTr("…")` in QML and `tr()` / `QCoreApplication::translate` in C++ for user-visible text.

### 2. Extract (full Gallery)

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

Each locale file holds the same **~3600** source ids. Finish translations in Qt Linguist; unfinished entries fall back to English source at runtime.

### 3. Validate seeds (CI-friendly, no Qt)

```bash
python scripts/check_gallery_translations.py
```

Ensures `qwinui3_gallery_en.ts`, `qwinui3_gallery_zh_CN.ts`, `qwinui3_gallery_ja_JP.ts`, `qwinui3_gallery_ko_KR.ts`, and `qwinui3_gallery_de_DE.ts` parse as Linguist XML.

**2.35 wave 4 — control page rules:**

```bash
python scripts/check_localization_wave4.py
```

Verifies **2.21…2.34** Gallery pages use `title: qsTr(...)` and their titles appear in `qwinui3_gallery_en.ts` (run `lupdate` after adding pages).

### 4. Translate + release

```bat
copy src\gallery\translations\qwinui3_gallery_en.ts src\gallery\translations\qwinui3_gallery_de.ts
linguist src\gallery\translations\qwinui3_gallery_de.ts
lrelease src\gallery\translations\qwinui3_gallery_de.ts -qm src\gallery\translations\qwinui3_gallery_de.qm
```

Shipped seeds: **`zh_CN` (1.45)**, **`ja_JP` (1.54)**, **`ko_KR` (2.12)**, and **`de_DE` (2.35)** cover the same extracted catalog (~3600 strings). **`zh_CN`** is the reference filled locale; other seeds may stay partially unfinished until a Linguist pass.

---

## Localization wave 4 (2.35)

| Item | Detail |
|------|--------|
| **Fourth seed locale** | **`de_DE`** — German catalog copied from `en` extract; selectable in Settings / **i18n / RTL** |
| **Checker** | `scripts/check_localization_wave4.py` — `de_DE` wiring + **2.21…2.34** control pages must use `qsTr` titles present in `qwinui3_gallery_en.ts` |
| **Smoke** | Hooked from `smoke_gallery.py` after `check_gallery_translations.py` |

**Out:** Crowdin portal; full **`ja_JP`** / **`ko_KR`** / **`de_DE`** Linguist completion (community or follow-up minors).

---

### 5. Load at runtime

**Gallery — live switch (Settings / i18n page):**

```qml
GalleryLanguage.applyLocale("zh_CN")  // installs QTranslator + engine.retranslate()
GalleryLanguage.currentLocale       // persisted in QSettings Gallery/uiLocale
```

**Gallery — startup override:**

```bat
qwinui3_gallery.exe --lang zh_CN
```

Release embeds `.qm` under `:/i18n` via `qt_add_translations` in `src/gallery/CMakeLists.txt`. Dev fallback paths: `translations/` beside exe, `src/gallery/translations/`, or `QWINUI3_GALLERY_TRANSLATIONS`.

**Consumer `main`:**

```cpp
QTranslator tr;
if (tr.load(QLocale(QLocale::Japanese, QLocale::Japan),
            QStringLiteral("myapp"),
            QStringLiteral("_"),
            QStringLiteral(":/i18n"))) {
    app.installTranslator(&tr);
}
```

Gallery does **not** auto-pick OS language — apps own selection (CLI / Settings / installer).

Examples under `examples/` also use `qsTr`; point `lupdate` at those folders the same way.

Folder details: [`src/gallery/translations/README.md`](../src/gallery/translations/README.md).

---

## Consumer lrelease recipe (2.x)

Ship translations in **your** app — not only Gallery. Pattern used by [`examples/gallery-shell`](../examples/gallery-shell/) (**2.12**).

### 1. Keep catalogs small

Same rule as Gallery: seed `.ts` files with the strings you actually ship. Run `lupdate` against **your** QML/C++ tree only:

```bat
lupdate examples/gallery-shell -ts examples/gallery-shell/translations/qwinui3_gallery_shell_en.ts
```

### 2. CMake — `qt_add_translations` (Qt 6.5+)

```cmake
find_package(Qt6 REQUIRED COMPONENTS LinguistTools)

qt_add_executable(myapp main.cpp)

qt_add_translations(myapp
    TS_FILES
        translations/myapp_en.ts
        translations/myapp_ko_KR.ts
    RESOURCE_PREFIX "/i18n"
)
```

`lrelease` runs at **build** time. `.qm` files embed under `:/i18n/` when `RESOURCE_PREFIX` is set.

**Reference:** [`examples/gallery-shell/CMakeLists.txt`](../examples/gallery-shell/CMakeLists.txt).

### 3. Load before QML

```cpp
#include <QTranslator>

static bool installAppTranslator(QGuiApplication &app, QTranslator *tr, const QString &lang)
{
    if (lang.isEmpty())
        return false;
    const QString qm = QStringLiteral(":/i18n/myapp_%1.qm").arg(lang);
    if (tr->load(qm)) {
        app.installTranslator(tr);
        return true;
    }
    // Packaged deploy: translations/ beside the exe (windeploy / zip layout)
    return tr->load(QCoreApplication::applicationDirPath()
                    + QStringLiteral("/translations/myapp_") + lang + QStringLiteral(".qm"));
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QTranslator translator;
    installAppTranslator(app, &translator, argValue(argc, argv, "--lang"));
    // … QQmlApplicationEngine …
}
```

Gallery shell demo: `qwinui3_example_gallery_shell.exe --lang ko_KR` after Release build.

### 4. Ship `.qm` in packages

| Path | When |
|------|------|
| `:/i18n/*.qm` | Default with `qt_add_translations` + `RESOURCE_PREFIX` |
| `<app>/translations/*.qm` | Optional loose files for hot-swappable language packs |
| Shared zip / vcpkg prefix | Not included — apps own `.ts` / `.qm`; kit strings stay English unless you translate control templates |

After `windeployqt` / `linuxdeploy`, copy extra `.qm` into `translations/` if not embedded. See [packaging-consumer.md](packaging-consumer.md).

### 5. CI without Qt Linguist

Commit `.ts` seeds; validate XML in CI:

```bash
python scripts/check_gallery_translations.py   # Gallery seeds
```

Add a similar check for your app catalogs if you keep multiple locales in-tree.

### 6. RTL unchanged

Translation and RTL stay **independent** — see [RTL / LayoutMirroring](#rtl--layoutmirroring) below. Korean / Chinese / Japanese seeds do **not** enable RTL.

---

## RTL / LayoutMirroring

```qml
StandardWindow {
    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true
    // …
}

// Session toggle (Gallery Settings / i18n page / nav-settings Settings):
Qt.application.layoutDirection = checked ? Qt.RightToLeft : Qt.LeftToRight
```

**Default remains LTR.** RTL is session-only unless your app persists the choice.

Translation and RTL are **independent**: `--lang zh_CN` does not force RTL; Arabic apps usually enable both.

### High-traffic fixes (1.13)

| Area | Change |
|------|--------|
| `HeaderedTextBox` / `HeaderedComboBox` / `HeaderedContentControl` | `Layout.alignment` uses `Qt.AlignLeading` so left-header labels stay on the **start** edge under mirroring |
| Gallery / nav-settings shells | Root `LayoutMirroring` bound to `Qt.application.layoutDirection` |
| Accessibility demo | Removed hard-coded LTR arrow glyph in helper text |

`FormLayout { fieldHeaderPlacement: "left" }` + SettingsCard rows are exercised on the Gallery **i18n / RTL** page — enable RTL and confirm labels/actions flip.

### Caption chrome note

System caption buttons on Windows stay OS-owned. Content under `PlatformTitleBar` / `NavigationView` follows `LayoutMirroring`; do not assume every decorative chevron is locale-aware yet.

### RTL regression pass (1.45)

After adding strings or shell chrome, smoke these with **Settings → Right-to-left layout**:

- [ ] Gallery Home featured cards / nav rail  
- [ ] i18n page FormLayout left headers + SettingsCard rows  
- [ ] ContentDialog / CommandPalette (overlay centering still OK)  
- [ ] ListDetailsView / TwoPaneView (master on start edge)  
- [ ] `examples/nav-settings` Settings RTL toggle  

---

## Checklist for product apps

1. Wrap strings in `qsTr` / `tr`.  
2. Ship `.ts` / `.qm` via Linguist; validate XML in CI if you keep seeds.  
3. Install `QTranslator` before loading QML.  
4. Mirror the shell when `layoutDirection === RightToLeft`.  
5. Prefer `AlignLeading` / start-edge anchors over physical `AlignLeft` for form labels.  
6. Prefer [stable-api.md](stable-api.md) controls when copying recipes.  
7. Keep LTR as the default path in automated tests.

---

## Out of scope

Full Gallery localization into many languages, macOS-first locale packs, chart axis BiDi, renaming SettingsCard `contentLeft` / `contentRight` APIs, auto-detecting OS language inside Gallery.
