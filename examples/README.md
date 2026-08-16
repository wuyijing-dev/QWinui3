# QWinUI3 examples

Small apps you can copy as a starting point:

| Target | Folder | What it shows |
|--------|--------|----------------|
| `qwinui3_example_nav` | [`nav-settings/`](nav-settings/) | `StandardWindow` + `NavigationView` + Settings footer |
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

```bash
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DQWINUI3_BUILD_EXAMPLES=ON
cmake --build build --parallel --target qwinui3_example_nav qwinui3_example_settings qwinui3_example_dashboard qwinui3_example_master_detail qwinui3_example_form
```

Binaries land under `build/` (see each example `RUNTIME_OUTPUT_DIRECTORY`). Smoke CI sets `-DQWINUI3_BUILD_EXAMPLES=OFF` for speed; build examples locally or in full Release configures with the option on (default **ON**).

Disable with `-DQWINUI3_BUILD_EXAMPLES=OFF`.

On Linux, leave `QT_QPA_PLATFORM` unset so examples pick Wayland first. Prefer `BackdropSolid` (all examples do). See [`docs/platform-linux-wayland.md`](../docs/platform-linux-wayland.md).

## Copy into your app

1. Copy one example folder.
2. Point CMake `IMPORTS` / `target_link_libraries` at your installed or in-tree `qwinui3_*` targets the same way Gallery does.
3. Keep `QT_QUICK_CONTROLS_STYLE=QWinUI3` (see each `main.cpp` / `Bootstrap`).

Full third-party packaging (Release zip, import paths, Win/Linux runtime): [`docs/packaging-consumer.md`](../docs/packaging-consumer.md).
