# NavigationView + Settings example

Gallery-aligned shell: `StandardWindow` → `PlatformTitleBar` / `TitleBar` → `NavigationView` with Home / About and a Settings footer.

Uses **`BackdropSolid`** (see [`docs/window-chrome.md`](../../docs/window-chrome.md)).

## Build / run

```bat
cmake --build build --config Release --target qwinui3_example_nav
build\qwinui3_example_nav.exe
```

```bash
cmake --build build --target qwinui3_example_nav
./build/qwinui3_example_nav   # path may vary by generator
```

`main.cpp` uses `QWinUI3::configureEnvironment` / `configureApplication` (`Bootstrap.h`) for one-call kit setup.

Linux: [docs/platform-linux-wayland.md](../../docs/platform-linux-wayland.md).
