# i18n / RTL baseline (1.13)

Gallery and the starter examples already wrap UI strings in **`qsTr`**. This page is the **baseline** for:

1. Extracting / shipping `.ts` catalogs  
2. Turning on **RTL** via `LayoutMirroring` without breaking LTR  

Not in scope: translating every Gallery string, shipping many language packs, or BiDi for every chart label.

| Surface | Where |
|---------|--------|
| Gallery demo | **Layout → i18n / RTL** |
| Gallery Settings | **Right-to-left layout** toggle |
| Example | [`examples/nav-settings`](../examples/nav-settings/) (same toggle + shell mirroring) |
| Seed `.ts` | [`src/gallery/translations/`](../src/gallery/translations/) |

---

## qsTr + Linguist workflow

1. Mark user-visible strings with `qsTr("…")` in QML / `tr()` in C++.  
2. Extract:

```bat
lupdate src/gallery -ts src/gallery/translations/qwinui3_gallery_en.ts
```

3. Copy for a locale (`qwinui3_gallery_ar.ts`, …), translate in **Qt Linguist**, then `lrelease`.  
4. Install a `QTranslator` in your `main` before loading QML (Gallery does **not** auto-load a `.qm` in 1.13 — apps own language selection).

Details and a seed English catalog: [`src/gallery/translations/README.md`](../src/gallery/translations/README.md).

Examples under `examples/` also use `qsTr`; point `lupdate` at those folders the same way when you localize a starter app.

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

### High-traffic fixes (1.13)

| Area | Change |
|------|--------|
| `HeaderedTextBox` / `HeaderedComboBox` / `HeaderedContentControl` | `Layout.alignment` uses `Qt.AlignLeading` so left-header labels stay on the **start** edge under mirroring |
| Gallery / nav-settings shells | Root `LayoutMirroring` bound to `Qt.application.layoutDirection` |
| Accessibility demo | Removed hard-coded LTR arrow glyph in helper text |

`FormLayout { fieldHeaderPlacement: "left" }` + SettingsCard rows are exercised on the Gallery **i18n / RTL** page — enable RTL and confirm labels/actions flip.

### Caption chrome note

System caption buttons on Windows stay OS-owned. Content under `PlatformTitleBar` / `NavigationView` follows `LayoutMirroring`; do not assume every decorative chevron is locale-aware yet.

---

## Checklist for product apps

1. Wrap strings in `qsTr` / `tr`.  
2. Mirror the shell when `layoutDirection === RightToLeft`.  
3. Prefer `AlignLeading` / start-edge anchors over physical `AlignLeft` for form labels.  
4. Prefer [stable-api.md](stable-api.md) controls when copying recipes.  
5. Keep LTR as the default path in tests.

---

## Out of scope

Full Gallery localization, macOS-first locale packs, chart axis BiDi, renaming SettingsCard `contentLeft` / `contentRight` APIs.
