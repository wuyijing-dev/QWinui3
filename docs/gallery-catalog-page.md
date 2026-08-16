# Gallery CatalogPage

`CatalogPage` is the Gallery scroll host for control samples
(`src/gallery/CatalogPage.qml`).

## Root type (important)

**`CatalogPage` must be an `Item`, not a Qt Quick Controls `Page`.**

On Qt 6.8, `Page` marks several properties **FINAL**, including:

| Property | Why it matters |
|----------|----------------|
| `title` | Cannot `property alias title` onto a header |
| `footer` | Cannot redeclare a bottom slot |
| `contentData` (via Pane/Container lineage) | Cannot redirect default children |

Declaring those on a `Page` subclass fails at load time with:

```text
Cannot override FINAL property
Type CatalogPage unavailable
```

and every Gallery page that uses `CatalogPage` fails to open.

`CatalogPage` therefore owns its own `title` / `footer` / `overlay` / default
`contentData` on a plain `Item`.

## Usage

```qml
CatalogPage {
    title: qsTr("Button")
    subtitle: qsTr("…")
    ControlExample {
        headerText: qsTr("Basic")
        // demos — no Layout.leftMargin: Theme.spacingSection
    }
}
```

### Host slots

| Slot | Use for |
|------|---------|
| default children | `ControlExample` sections (scrolled) |
| `footer` | Bottom chrome outside the scroll (e.g. `StatusBar`) |
| `overlay` | Floating hosts (`ToastHost`, `Toast`, `Drawer`) and dialog *declarations* |

### Dialogs

Keep modal dialogs parented to `Overlay.overlay` (scrim / centering). Declare them
under `CatalogPage.overlay` so they are not scrolled with content:

```qml
CatalogPage {
    overlay: ContentDialog {
        id: dlg
        parent: Overlay.overlay
        anchors.centerIn: Overlay.overlay
        // …
    }
    ControlExample {
        Button { onClicked: dlg.open() }
    }
}
```

### Custom landing pages

- **HomePage** — `CatalogPage { title: ""; pagePadding: 0 }` so the custom hero
  stays full-bleed (no standard `PageHeader`).
- **SettingsPage / SettingsGroupPage** — intentionally use `SettingsView`
  (`anchors.fill`), not `CatalogPage`.

### Favorites & search (1.20)

- `CatalogPage.componentId` is set by Gallery `Main` when a page opens; `PageHeader`
  shows a favorite star (persisted via `GalleryHistory`).
- Title-bar search matches **component** names (e.g. `datatable`) as well as titles.
- Home **Recently shipped** uses `ControlCatalog.recentlyShipped()` (curated recipes).

Smoke coverage: [ci-smoke.md](ci-smoke.md).

## Rebuild note

After editing `CatalogPage.qml` or Extras QML, rebuild `qwinui3_gallery` (and
`qwinui3_extras` when Extras change). Stale `build/` copies / qrc caches can keep
serving broken FINAL overrides.
