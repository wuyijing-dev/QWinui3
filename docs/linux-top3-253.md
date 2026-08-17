# Linux top-3 parity (2.53)

**FL-002** partial — closes the three highest-count **user-visible** Linux shell gaps from [platform-linux-wayland.md](platform-linux-wayland.md). Not a full DWM parity project (**2.68** residual).

Related: [system-integration.md](system-integration.md) · [window-chrome.md](window-chrome.md) · [planning/friction-log.md](planning/friction-log.md)

---

## Goal

Apps “work on Windows, look broken on Linux” for common nav shells and portal wiring. **2.53** fixes the **top 3** field-matrix rows with targeted code — no new controls.

---

## Top 3 gaps (fixed in 2.53)

| # | Symptom | Root cause | Fix |
|---|---------|------------|-----|
| **1** | Square content bleeds through rounded shell corners | Full-bleed `NavigationView` ignored `shellContentInset` | **`NavigationWindow`** + **`nav-settings`** wrap nav in **`WindowShellContentClip`** |
| **2** | Heavy / double shadow on Sway / wlroots | `shellCompositorProfile` fell through to `other` | New **`sway`** profile — softer opacity/margin (GNOME-like) |
| **3** | File dialog not modal on Wayland | `FilePicker.*` called without `Window.window` | **`qWarning`** when parent missing on Wayland sessions |

**Out:** GNOME tray without SNI extension; compositor-native blur; full portal parent export on every Qt build (**2.57** files slice).

---

## Deliverables

| Item | Location |
|------|----------|
| Auto content clip | `NavigationWindow.qml`, `examples/nav-settings/Main.qml` |
| Sway profile | `WindowHelper::shellCompositorProfile` + shadow tuning |
| FilePicker guard | `FilePicker.cpp` — Wayland parent warning |
| Field matrix bump | [platform-linux-wayland.md](platform-linux-wayland.md) **2.53** section |
| Gallery checklist | **Pitfalls** — **2.53 / FL-002** block |

---

## App checklist (Linux nav shell)

- [ ] Use **`NavigationWindow`** or wrap **`NavigationView`** in **`WindowShellContentClip`**
- [ ] `backdrop: WindowHelper.BackdropSolid` on product shells
- [ ] `QWinUI3::configureEnvironment(argv[0])` before `QGuiApplication`
- [ ] `FilePicker.open*(…, Window.window)` — check console if parent omitted
- [ ] Field soak: KDE Plasma Wayland + spot-check Sway — [platform-linux-wayland.md](platform-linux-wayland.md) regression suite (**2.33**)

---

## Manual verify (not CI)

CI Linux `--smoke` is **offscreen** — run on a real compositor:

```bash
./build/qwinui3_gallery
# Gallery → System integration — shellCompositorProfile, portalParentWindow
./build/qwinui3_example_first_app
./build/qwinui3_example_nav
```

**Next:** **2.54** window chrome footguns · **2.57** files on Linux · **2.68** platform integration harden
