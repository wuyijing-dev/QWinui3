# Gallery shell template (1.50)

Thin **extractable** app chrome from Gallery patterns: `NavigationWindow` + `pageModule` + Settings footer + `Bootstrap` + `geometryPersistenceKey`.

Prefs (theme / density / reduced motion) use QtCore `Settings` under `GalleryShellPrefs` — see [`docs/settings-persistence.md`](../../docs/settings-persistence.md) (**1.65**). Keep geometry on `GalleryShellMain`; do not mix.

Smaller than Gallery itself — one Home page and Settings. Prefer this over copying `src/gallery/`.

| Related | Role |
|---------|------|
| [`nav-settings/`](../nav-settings/) | Hand-wired `StandardWindow` + `NavigationView` (1.27) |
| [docs/navigation.md](../../docs/navigation.md) | Pane / footer / Back recipes |
| [docs/window-shells.md](../../docs/window-shells.md) | Shell matrix |
| [docs/qt-creator.md](../../docs/qt-creator.md) | Open **repo root**, not this folder |

## Build / run

```bat
cmake --build build --config Release --target qwinui3_example_gallery_shell
build\qwinui3_example_gallery_shell.exe
```

```bash
cmake --build build --target qwinui3_example_gallery_shell
./build/qwinui3_example_gallery_shell
```

Preset: `cmake --build --preset example-gallery-shell`.

## Keep vs delete

When copying into your product:

| Keep | Delete / replace |
|------|------------------|
| `main.cpp` (`Bootstrap` / `configureEnvironment`) | Example `qsTr` copy and ContentCard tips on Home |
| `CMakeLists.txt` pattern (`IMPORTS`, link `qwinui3_*`) | URI `QWinUI3.Examples.GalleryShell` → your module name |
| `Main.qml` shell (`NavigationWindow`, persistence key, footer) | Rename persistence key (`GalleryShellMain` → your app id) |
| `SettingsPage.qml` as a starting SettingsView | Cards you do not need |
| One content page (`HomePage.qml`) | Add more `navModel` rows + page QML files |

**Do not** copy Gallery’s `ControlCatalog.qml`, smoke harness, or full page tree.

## What this demonstrates

- `hostContent: false` + `pageModule` — same StackView loading as Gallery
- Settings via `footerComponent`
- `paneDisplayMode: "auto"`
- TitleBar Back ↔ `navigateBack()` (wired inside `NavigationWindow`)
- `geometryPersistenceKey: "GalleryShellMain"`
- Settings prefs via `Settings` category `GalleryShellPrefs` (**1.65**)
- Solid backdrop (Win + Linux safe)

Linux: [docs/platform-linux-wayland.md](../../docs/platform-linux-wayland.md).
