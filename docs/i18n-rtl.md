# i18n / RTL (1.13 / 1.45)

Gallery and starter examples wrap UI strings in **`qsTr`**. This page covers:

1. Extracting / shipping `.ts` → `.qm` catalogs  
2. Loading a locale in Gallery (`--lang`) or your app  
3. **RTL** via `LayoutMirroring` without breaking LTR  

Not in scope: translating every Gallery string, shipping many full language packs, or BiDi for every chart label.

| Surface | Where |
|---------|--------|
| Gallery demo | **Layout → i18n / RTL** |
| Gallery Settings | **Right-to-left layout** toggle |
| Example | [`examples/nav-settings`](../examples/nav-settings/) (same toggle + shell mirroring) |
| Seed `.ts` | [`src/gallery/translations/`](../src/gallery/translations/) — `en` + **`zh_CN` (1.45)** |
| Integrity | `python scripts/check_gallery_translations.py` |

---

## qsTr + Linguist workflow (1.45)

### 1. Mark strings

Use `qsTr("…")` in QML and `tr()` / `QCoreApplication::translate` in C++ for user-visible text.

### 2. Extract (manual — when you start a real locale)

```bat
lupdate src/gallery -ts src/gallery/translations/qwinui3_gallery_en.ts
```

```bash
lupdate src/gallery -ts src/gallery/translations/qwinui3_gallery_en.ts
```

Keep seed catalogs **small**. A full Gallery `lupdate` produces a huge diff — only commit it when intentionally shipping that language.

### 3. Validate seeds (CI-friendly, no Qt)

```bash
python scripts/check_gallery_translations.py
```

Ensures `qwinui3_gallery_en.ts` and `qwinui3_gallery_zh_CN.ts` parse as Linguist XML.

### 4. Translate + release

```bat
copy src\gallery\translations\qwinui3_gallery_en.ts src\gallery\translations\qwinui3_gallery_de.ts
linguist src\gallery\translations\qwinui3_gallery_de.ts
lrelease src\gallery\translations\qwinui3_gallery_de.ts -qm src\gallery\translations\qwinui3_gallery_de.qm
```

Shipped seed: **`zh_CN`** already has sample translations for the i18n / Settings demo strings.

### 5. Load at runtime

**Gallery (1.45):**

```bat
lrelease src\gallery\translations\qwinui3_gallery_zh_CN.ts -qm src\gallery\translations\qwinui3_gallery_zh_CN.qm
qwinui3_gallery.exe --lang zh_CN
```

Search path: `translations/` beside the exe, exe dir, source-tree `src/gallery/translations`, or `QWINUI3_GALLERY_TRANSLATIONS`.

**Consumer `main`:**

```cpp
QTranslator tr;
if (tr.load(QLocale(QLocale::Chinese, QLocale::China),
            QStringLiteral("myapp"),
            QStringLiteral("_"),
            QStringLiteral(":/i18n"))) {
    app.installTranslator(&tr);
}
```

Gallery does **not** auto-pick OS language in 1.45 — apps own selection (CLI / Settings / installer).

Examples under `examples/` also use `qsTr`; point `lupdate` at those folders the same way.

Folder details: [`src/gallery/translations/README.md`](../src/gallery/translations/README.md).

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
