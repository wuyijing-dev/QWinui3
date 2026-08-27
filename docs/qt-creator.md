# Open in Qt Creator (1.35)

QWinUI3 is a **CMake-only** project (no `.pro` / qmake). A new engineer should open the **repository root**, pick a Qt 6 kit, build **Gallery** or an **example**, and run — without inventing a second project layout.

**Consuming QWinUI3 from another app** (Release zip, `add_subdirectory`): [packaging-consumer.md](packaging-consumer.md).  
**Stable types to copy:** [stable-api.md](stable-api.md).  
**CLI same tree:** [README Build](../README.md#build-from-source).

---

## Path A — Gallery (recommended first)

1. **File → Open File or Project…** → select **`CMakeLists.txt` at the repo root** (not `examples/…`).
2. Choose a kit with **Qt 6.5+** (**6.8 LTS** recommended).
3. Configure with preset **Default (Release)** or **Release (Ninja)**. Leave Debug alone unless you need a debugger.
4. In the **Projects** mode (or target selector), build **`qwinui3_gallery`**.
5. Set the run target to `qwinui3_gallery` → **Run**.

| Output (Ninja Release) | Path |
|------------------------|------|
| Gallery | `build/qwinui3_gallery.exe` (Windows) / `build/qwinui3_gallery` (Linux) |

Qt Creator injects `CMAKE_PREFIX_PATH` from the kit. Shared [`CMakePresets.json`](../CMakePresets.json) does **not** hardcode a Qt install path.

---

## Path B — Example apps (same project)

Examples are **targets in the same root CMake project** (`QWINUI3_BUILD_EXAMPLES` defaults **ON**). Do **not** open `examples/nav-settings/CMakeLists.txt` alone.

1. Open the **repo root** as in Path A and configure Release.
2. Build one of:

| Creator / CMake target | Folder | Recipe |
|------------------------|--------|--------|
| `qwinui3_example_gallery_shell` | `examples/gallery-shell/` | **Start from Gallery shell** — [window-shells.md](window-shells.md) / [navigation.md](navigation.md) (**1.50**) |
| `qwinui3_example_nav` | `examples/nav-settings/` | [navigation.md](navigation.md) |
| `qwinui3_example_settings` | `examples/settings-cards/` | Settings cards |
| `qwinui3_example_dashboard` | `examples/dashboard/` | Charts / KPI |
| `qwinui3_example_master_detail` | `examples/master-detail/` | [data-collections.md](data-collections.md) |
| `qwinui3_example_form` | `examples/form-settings/` | [forms.md](forms.md) |
| `qwinui3_example_admin_settings` | `examples/admin-settings/` | [app-platform-3xx.md](app-platform-3xx.md) (**3.07**) |
| `qwinui3_example_master_detail_crm` | `examples/master-detail-crm/` | CRM kit (**3.07**) |
| `qwinui3_example_ops_console` | `examples/ops-console/` | Ops kit (**3.07**) |
| `qwinui3_example_floating_osk` | `examples/floating-osk/` | [on-screen-keyboard.md](on-screen-keyboard.md) (**1.84**) |

3. Select that target as the **Run** configuration → Run.

Build presets (CLI or Creator preset list): `examples` (all) or `example-gallery-shell` / `example-nav` / `example-settings` / `example-dashboard` / `example-master-detail` / `example-form`.

```bat
cmake --build --preset example-gallery-shell
```

List and notes: [examples/README.md](../examples/README.md).

---

## Kit checklist

### Windows

- Qt **6.5+** `msvc2022_64` (6.8.x recommended)
- Compiler: **MSVC 2022** amd64 (Creator kit “Desktop Qt 6.x MSVC2022 64bit”)
- CMake ≥ 3.21 (Qt Maintenance Tool or system)
- Generator: **Ninja** — put `…/Qt/Tools/Ninja` on the kit `PATH`, or set `CMAKE_MAKE_PROGRAM` in user presets
- Optional WebView2: `scripts/fetch_webview2.ps1`

### Linux

- Qt **6.5+** from distro or online installer (`gcc_64` / system packages with Quick + QuickControls2)
- Kit compiler matching that Qt build
- Prefer leaving `QT_QPA_PLATFORM` unset (Wayland-first) — [platform-linux-wayland.md](platform-linux-wayland.md)
- Examples use `BackdropSolid` already

### Local path override (CLI / stubborn kits)

```bat
copy CMakeUserPresets.json.example CMakeUserPresets.json
```

Edit `CMAKE_PREFIX_PATH` / Ninja, then:

```bat
cmake --preset local-qt68-msvc
cmake --build --preset local-qt68-msvc
```

`CMakeUserPresets.json` is gitignored.

---

## Presets (shared)

| Configure preset | Build dir | Notes |
|------------------|-----------|--------|
| `default` / `release` / `qt68-msvc` | `build/` | **Release** (project default) |
| `debug` | `build-debug/` | Only if you need Debug |
| `relwithdebinfo` | `build-relwithdebinfo/` | Optional |

| Build preset | Targets |
|--------------|---------|
| `default` / `release` / `qt68-msvc` | `qwinui3_gallery` |
| `examples` | All five example apps |
| `example-nav` (etc.) | One example |

Plain `cmake -S . -B build` (no build type) also configures **Release**. Multi-config generators use `CMAKE_DEFAULT_BUILD_TYPE=Release`.

Qt range: [qt-version-compat.md](qt-version-compat.md).

---

## Common issues

| Symptom | Fix |
|---------|-----|
| `Could not find Qt6` | Select a Qt 6.5+ kit (6.8+ recommended), or set `CMAKE_PREFIX_PATH` in `CMakeUserPresets.json` |
| `Ninja not found` | Install Ninja via Qt Maintenance Tool; add `…/Qt/Tools/Ninja` to kit PATH |
| Configure fights an old `build/` cache | Delete `build/CMakeCache.txt` or use a fresh preset build dir |
| Opened `examples/…` only | Always open the **repo root** `CMakeLists.txt` |
| Looking for a `.pro` | There is none — CMake only (1.35) |
| Examples missing from target list | Ensure `QWINUI3_BUILD_EXAMPLES=ON` (default); reconfigure |
| Run fails to find QML plugins | Run the built exe from `build/` (same tree Creator uses); kit Qt must match configure |

---

## After it runs

- Prefer **stable** API names when copying into a product — [stable-api.md](stable-api.md).
- Third-party zip / `add_subdirectory` — [packaging-consumer.md](packaging-consumer.md).
- Shell chrome — [window-chrome.md](window-chrome.md) / [window-shells.md](window-shells.md).
