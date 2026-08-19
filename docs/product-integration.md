# Product integration notes (LoB apps)

Field feedback from **Light Photos** and similar **NavigationWindow** apps on QWinUI3 **2.64**. Documents integration friction and upstream fixes — not a rejection of the library.

Related: [search.md](search.md) · [recipes.md](recipes.md) · [settings-persistence.md](settings-persistence.md) · [window-shells.md](window-shells.md).

---

## Upstream fixes (2.64+)

| Issue | Fix |
|-------|-----|
| `NavigationWindow` missing `paneSearchTextEdited` | Signal forwarded from `NavigationView` |
| Title-bar placeholder stuck on “Search controls” | `searchPlaceholder` on ShellWindow / TitleBar (default `Search`) |
| Pane search placeholder not configurable | `paneSearchPlaceholder` on NavigationView / NavigationWindow |
| `chrome.titleBarContent` undocumented for shells | Documented in ShellWindow / NavigationWindow headers + [search.md](search.md) |
| `IconButton` accent color unclear | `accentIcon` alias of `highlighted` |
| `ThemeAppearanceSettings.persist` default false | Default **`true`**; Gallery demos keep `persist: false` |
| Global context menu positioning | `MenuFlyout.popupAtGlobal(overlay, x, y)` |
| CommandBar “broken overflow” combos | Product preset in [recipes.md](recipes.md) |

---

## Shell search — product vs Gallery

Gallery optimizes for **control catalog** search. Product apps (photos, files, mail) need:

1. **Domain placeholder** — `searchPlaceholder` / `paneSearchPlaceholder`
2. **Live filter** — `onSearchTextEdited` + `onPaneSearchTextEdited`
3. **Custom title middle** — `searchEnabled: false` + `chrome.titleBarContent: SearchBox { … }`

Syncing pane + title search remains app responsibility until a unified `searchText` API ships.

---

## CommandBar trap matrix

| Combination | Symptom |
|-------------|---------|
| `compact: true` + `defaultLabelPosition: "collapsed"` | Chevron appears to do nothing |
| `isDynamicOverflowEnabled: false` | Overflow `⋯` menu empty |
| `isToggleButtonVisible: false` | No way to expand labels |

Use the **product preset** in [recipes.md](recipes.md).

---

## MenuFlyout — dynamic content

- **Scroll jump:** MenuItem text bound to live selection counts reflows while scrolling → snapshot on open.
- **Context at cursor:** use `popupAtGlobal(Overlay.overlay, globalX, globalY)`.

---

## Theme persistence — one story

| Layer | Owner |
|-------|--------|
| Window geometry | `geometryPersistenceKey` |
| Theme knobs | `ThemePrefs` category **or** `ThemeAppearanceSettings { persist: true; prefsCategory: "…" }` |
| Business prefs | App `Settings` / store |

Align `prefsCategory` between main window and Settings page. Demos (`Gallery`, `gallery-shell`) set `persist: false` on the settings card intentionally.

---

## Distribution cost (unchanged)

Shared kit still requires `package_release_libs.py --shared` or `pip install qwinui3` (**2.72**). See [packaging-python.md](packaging-python.md).

---

## What works well

- Fluent visual consistency via `Theme.*` + `FluentIcons`
- `NavigationView` modes, footer settings, `pageModule` + LRU cache
- `SettingsView` / `SettingsCard` for Win11-like settings
- `WindowHelper`, `FilePicker`, `geometryPersistenceKey`
- CommandBar when product preset is applied

---

*2026-08-19 · QWinUI3 2.64 · Light Photos 0.1 perspective*
