# QWinUI3 examples

Small apps you can copy as a starting point. **CMake only** (no `.pro`). Open the **repo root** in Qt Creator — do not open an example folder alone. Full Creator path: [`docs/qt-creator.md`](../docs/qt-creator.md) (1.35).

| Target | Folder | What it shows |
|--------|--------|----------------|
| `qwinui3_example_first_app` | [`first-app/`](first-app/) | **Start here (2.52)** — smallest `NavigationWindow` + `DashboardShell` — [docs/first-app-252.md](../docs/first-app-252.md) |
| `qwinui3_example_gallery_shell` | [`gallery-shell/`](gallery-shell/) | Product frame — Settings + `ThemeAppearanceSettings` (1.50) |
| `qwinui3_example_multi_window` | [`multi-window/`](multi-window/) | Main + tool + owned dialog shells (1.56) — [docs/window-shells.md](../docs/window-shells.md) |
| `qwinui3_example_nav` | [`nav-settings/`](nav-settings/) | `StandardWindow` + hand-wired `NavigationView` + Settings — [docs/navigation.md](../docs/navigation.md) (1.27) |
| `qwinui3_example_settings` | [`settings-cards/`](settings-cards/) | Settings page built from `SettingsCard` / `SettingsExpander` |
| `qwinui3_example_dashboard` | [`dashboard/`](dashboard/) | Stable six: `KpiTile` + `ChartCard` + Line/Bar/Donut + `RingGauge` (**1.66**) |
| `qwinui3_example_master_detail` | [`master-detail/`](master-detail/) | `ListDetailsView` LoB ticket shell (1.26) |
| `qwinui3_example_form` | [`form-settings/`](form-settings/) | `FormLayout` validation + SettingsCard prefs (1.26) |
| `qwinui3_example_admin_settings` | [`admin-settings/`](admin-settings/) | **3.07 V1** — admin SettingsView + FormLayout |
| `qwinui3_example_master_detail_crm` | [`master-detail-crm/`](master-detail-crm/) | **3.07 V2** — CRM ListDetailsView + DataTable + CommandBar |
| `qwinui3_example_ops_console` | [`ops-console/`](ops-console/) | **3.07 V3** — SplitWorkspace + LiveMetricStrip + grid |
| `qwinui3_example_floating_osk qwinui3_example_osk_dock` | [`floating-osk/`](floating-osk/) | Floating `OnScreenKeyboardWindow` (**1.84**) — [docs/on-screen-keyboard.md](../docs/on-screen-keyboard.md) |
| `qwinui3_example_osk_dock` | [`osk-dock/`](osk-dock/) | Embedded footer dock + shared engine (**2.58**) — [docs/osk-in-apps-258.md](../docs/osk-in-apps-258.md) |

Standalone (not in monorepo CMake tree): [`find-package-consumer/`](find-package-consumer/) — `find_package(QWinUI3 CONFIG)` sketch (**1.61**). Build with `python scripts/verify_find_package.py` or see that folder’s README.

**Python Gallery** (not in CMake tree): [`python-gallery/`](python-gallery/) — same catalog as `src/gallery` via PySide6 / PyQt6 + shared kit — [docs/packaging-python.md](../docs/packaging-python.md) (**2.64**).

## Build

From the repo root (same toolchain as Gallery), **Release**:

```bat
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DQWINUI3_BUILD_EXAMPLES=ON
cmake --build build --parallel --target qwinui3_example_first_app qwinui3_example_gallery_shell qwinui3_example_multi_window qwinui3_example_nav qwinui3_example_settings qwinui3_example_dashboard qwinui3_example_master_detail qwinui3_example_form qwinui3_example_admin_settings qwinui3_example_master_detail_crm qwinui3_example_ops_console qwinui3_example_floating_osk qwinui3_example_osk_dock
```

Or use presets:

```bat
cmake --preset release
cmake --build --preset example-gallery-shell
cmake --build --preset example-multi-window
cmake --build --preset example-ops-console
cmake --build --preset examples
```

```bash
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DQWINUI3_BUILD_EXAMPLES=ON
cmake --build build --parallel --target qwinui3_example_first_app qwinui3_example_gallery_shell qwinui3_example_multi_window qwinui3_example_nav qwinui3_example_settings qwinui3_example_dashboard qwinui3_example_master_detail qwinui3_example_form qwinui3_example_admin_settings qwinui3_example_master_detail_crm qwinui3_example_ops_console qwinui3_example_floating_osk qwinui3_example_osk_dock
```

### Qt Creator

1. **File → Open** → repo root `CMakeLists.txt`.
2. Kit: Qt 6.5+ (6.8+ recommended), Release preset.
3. Build / Run target: e.g. `qwinui3_example_gallery_shell` (see [qt-creator.md](../docs/qt-creator.md)).

Binaries land under `build/` (see each example `RUNTIME_OUTPUT_DIRECTORY`). Smoke CI sets `-DQWINUI3_BUILD_EXAMPLES=OFF` for speed; build examples locally or in full Release configures with the option on (default **ON**).

Disable with `-DQWINUI3_BUILD_EXAMPLES=OFF`.

On Linux, leave `QT_QPA_PLATFORM` unset so examples pick Wayland first. Prefer `BackdropSolid` (all examples do). See [`docs/platform-linux-wayland.md`](../docs/platform-linux-wayland.md).

## Copy into your app

1. Prefer **`first-app/`** for the first hour, then **`gallery-shell/`** when you need Settings (keep vs delete tables in each README).
2. Or copy another example folder for a specialized recipe.
3. Point CMake `IMPORTS` / `target_link_libraries` at your installed or in-tree `qwinui3_*` targets the same way Gallery does.
4. Keep `QT_QUICK_CONTROLS_STYLE=QWinUI3` (see each `main.cpp` / `Bootstrap`).

Full third-party packaging (Release zip, `find_package` sketch, import paths, Win/Linux runtime): [`docs/packaging-consumer.md`](../docs/packaging-consumer.md).
