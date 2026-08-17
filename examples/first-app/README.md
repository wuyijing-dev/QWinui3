# First app in an hour (2.52)

Smallest copy-ready app: **Bootstrap** + **`NavigationWindow`** + one page using **`DashboardShell`**.

| vs | When |
|----|------|
| **This folder** | First hour — one nav item, no Settings, no `.ts` translations |
| [`gallery-shell/`](../gallery-shell/) | Product frame — Settings footer + `ThemeAppearanceSettings` (**1.50**) |
| [`dashboard/`](../dashboard/) | Stable six charts — full ops layout (**2.22**) |
| [`find-package-consumer/`](../find-package-consumer/) | Path C zip / vcpkg install — not monorepo `add_subdirectory` |

Full checklist: [`docs/first-app-252.md`](../../docs/first-app-252.md).

## Build / run

```bat
cmake --build build --config Release --target qwinui3_example_first_app
build\qwinui3_example_first_app.exe
```

```bash
cmake --build build --target qwinui3_example_first_app
./build/qwinui3_example_first_app
```

Preset: `cmake --build --preset example-first-app`.

## Copy into your product

| Keep | Replace |
|------|---------|
| `main.cpp` (`configureEnvironment` / `configureApplication`) | Example strings and `org.qwinui3.example.firstapp` app id |
| `CMakeLists.txt` `IMPORTS` + link lines | Your target / module URI name |
| `Main.qml` shell + `geometryPersistenceKey` | Rename persistence key; add `navModel` rows |
| `HomePage.qml` as a layout sample | Your real UI — keep or drop `DashboardShell` |

**Do not** copy Gallery `ControlCatalog.qml` or smoke harness.

Before shipping: `python scripts/lint_qml_imports.py` — [stable-clarity-251.md](../../docs/stable-clarity-251.md).
