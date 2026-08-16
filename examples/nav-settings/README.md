# NavigationView + Settings example

Minimal shell: `StandardWindow` → `NavigationView` with Home / About and a Settings footer.

Uses **`BackdropSolid`** so the same QML is solid on Windows and Linux (no hollow Mica on Wayland/X11).

## Build / run

```bat
cmake --build build --config Release --target qwinui3_example_nav
build\qwinui3_example_nav.exe
```

```bash
cmake --build build --target qwinui3_example_nav
./build/qwinui3_example_nav   # path may vary by generator
```

`main.cpp` already calls `WindowHelper::configurePlatformEnvironment` (Wayland-first + CSD) and sets a desktop file name for portals/taskbars.

Linux details: [docs/platform-linux-wayland.md](../../docs/platform-linux-wayland.md).
