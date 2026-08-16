# QWinUI3 examples

Small apps you can copy as a starting point. **CMake only** (no `.pro`). Open the **repo root** in Qt Creator — do not open an example folder alone. Full Creator path: [`docs/qt-creator.md`](../docs/qt-creator.md) (1.35).

| Target | Folder | What it shows |
|--------|--------|----------------|
| `qwinui3_example_nav` | [`nav-settings/`](nav-settings/) | `StandardWindow` + `NavigationView` + Settings footer — [docs/navigation.md](../docs/navigation.md) (1.27) |
| `qwinui3_example_settings` | [`settings-cards/`](settings-cards/) | Settings page built from `SettingsCard` / `SettingsExpander` |
| `qwinui3_example_dashboard` | [`dashboard/`](dashboard/) | `KpiTile` + charts/gauges monitoring layout |
| `qwinui3_example_master_detail` | [`master-detail/`](master-detail/) | `ListDetailsView` LoB ticket shell (1.26) |
| `qwinui3_example_form` | [`form-settings/`](form-settings/) | `FormLayout` validation + SettingsCard prefs (1.26) |

## Build

From the repo root (same toolchain as Gallery), **Release**:

```bat
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DQWINUI3_BUILD_EXAMPLES=ON
cmake --build build --parallel --target qwinui3_example_nav qwinui3_example_settings qwinui3_example_dashboard qwinui3_example_master_detail qwinui3_example_form
```

Or use presets:

```bat
cmake --preset release
cmake --build --preset example-nav
cmake --build --preset examples
```

```bash
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DQWINUI3_BUILD_EXAMPLES=ON
cmake --build build --parallel --target qwinui3_example_nav qwinui3_example_settings qwinui3_example_dashboard qwinui3_example_master_detail qwinui3_example_form
```

### Qt Creator

1. **File → Open** → repo root `CMakeLists.txt`.
2. Kit: Qt 6.5+ (6.8+ recommended), Release preset.
3. Build / Run target: e.g. `qwinui3_example_nav` (see [qt-creator.md](../docs/qt-creator.md)).

Binaries land under `build/` (see each example `RUNTIME_OUTPUT_DIRECTORY`). Smoke CI sets `-DQWINUI3_BUILD_EXAMPLES=OFF` for speed; build examples locally or in full Release configures with the option on (default **ON**).

Disable with `-DQWINUI3_BUILD_EXAMPLES=OFF`.

On Linux, leave `QT_QPA_PLATFORM` unset so examples pick Wayland first. Prefer `BackdropSolid` (all examples do). See [`docs/platform-linux-wayland.md`](../docs/platform-linux-wayland.md).

## Copy into your app

1. Copy one example folder.
2. Point CMake `IMPORTS` / `target_link_libraries` at your installed or in-tree `qwinui3_*` targets the same way Gallery does.
3. Keep `QT_QUICK_CONTROLS_STYLE=QWinUI3` (see each `main.cpp` / `Bootstrap`).

Full third-party packaging (Release zip, import paths, Win/Linux runtime): [`docs/packaging-consumer.md`](../docs/packaging-consumer.md).
