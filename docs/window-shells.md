# Window shells (application layout paradigms) (1.32)

Independent top-level hosts in `QWinUI3.Extras` share **`ShellWindow`**
(chrome + `WindowHelper`) — they do **not** subclass `StandardWindow`.

Chrome reliability (DPI, backdrop, dialog owners): [`window-chrome.md`](window-chrome.md).  
Geometry recipe: [`window-helper.md`](window-helper.md#window-geometry-persistence).  
Linux matrix detail: [`platform-linux-wayland.md`](platform-linux-wayland.md).  
Frost / RHI: [`graphics-backend.md`](graphics-backend.md).

Gallery: **Window shells** (`WindowParadigmPage`) · Main host uses `BackdropSolid` + `geometryPersistenceKey: "GalleryMain"`.

---

## ShellWindow vs StandardWindow

| | `ShellWindow` (Extras) | `StandardWindow` (Platform) |
|--|--|--|
| Audience | App layouts / workbench shells | Gallery host + low-level AppWindow |
| Chrome | `WindowChrome` + WinUI `TitleBar` slots | `PlatformTitleBar` (caption host) |
| Layout helpers | Blank / Nav / MenuStatus / Dialog / Tool / Overlay | DialogWindow / ToolWindow / CompactOverlayWindow |
| Typical use | Ship product UI with `title` / `navModel` / `Menu` | Custom AppWindow presenter / backdrop experiments |

Prefer **ShellWindow** family for applications. Keep **StandardWindow** when you need Platform presenters without Extras.

---

## Win + Linux soak matrix (1.32)

Re-checked against Gallery Window paradigm page + Platform `resolveBackdrop` / geometry clamp.

| Surface | Windows | Linux (Wayland/X11) | Ship note |
|---------|---------|---------------------|-----------|
| `StandardWindow` + `BackdropSolid` | **Works** | **Works** | Gallery default; safest product chrome |
| `ShellWindow` / `NavigationWindow` + Solid | **Works** | **Works** | Prefer for apps (`NavigationWindow` defaults Solid) |
| `BlankWindow` / MenuStatus / Dialog / Tool / Overlay shells | **Works** | **Works** | Roles via paradigm / presenter APIs |
| `BackdropMica` / `MicaAlt` / `Acrylic` | **Works** (DWM) | **Coerced → Solid** | Paint with `effectiveBackdrop`; pin OpenGL for frost — [graphics-backend.md](graphics-backend.md) |
| `BackdropTransparent` / `None` | DIY fill | DIY fill | No system material |
| `geometryPersistenceKey` | **Works** | **Works** | Restore clamps to available screens (see below) |
| NC hit-test / Snap Layouts | **Works** | Unsupported | QML caption handles input on Linux |
| Bootstrap `configureEnvironment` | Required early | Required early | Calls `configurePlatformEnvironment` + style / IME |

Do **not** ship Mica as a Linux feature — copying a Windows sample is fine; the platform coerces.

---

## Geometry persistence (supported recipe)

Set a non-empty key on either host:

```qml
StandardWindow {
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "MainWindow"
}
ShellWindow {
    geometryPersistenceKey: "MainWindow"
}
```

Behavior (1.32):

1. Debounced save on resize/move; always save on close.
2. Stores **normal** frame + maximized vs windowed + optional screen **name** under `QSettings` → `WindowGeometry/<key>`.
3. Restore runs `clampGeometryToScreens`: prefer saved screen → any intersecting screen → primary center; reject frames smaller than **160×120**; fit inside `availableGeometry` (taskbar-safe).
4. Empty key = off. `clearSavedGeometry()` / `WindowHelper.clearWindowGeometry(key)` forgets the entry.

Full API notes: [window-helper.md](window-helper.md#window-geometry-persistence).

---

## Shared chrome API

```qml
title: qsTr("App")
subtitle: qsTr("Optional")
symbol: FluentIcons.Home
preferredHeightOption: WindowHelper.TitleBarHeightTall
isBackButtonVisible: true
rightHeader: Button { text: qsTr("Account") }
captionButtonHover: Theme.fillSubtle
titleBarBackground: Theme.bgAcrylic
```

## Shell types

| Type | Notes |
|------|--------|
| `BlankWindow` | Empty client |
| `NavigationWindow` | `NavigationView` hostContent + pane modes |
| `MenuStatusWindow` | `menusInTitleBar`, multi-segment `StatusBar` |
| `DialogShellWindow` | Dialog paradigm (`WindowHelper.ParadigmDialog`) |
| `ToolShellWindow` | Tool / palette paradigm |
| `CompactOverlayShellWindow` | Compact overlay presenter |

### Dialog / Tool / Overlay snippets

```qml
DialogShellWindow {
    id: dlg
    title: qsTr("Confirm")
    ownerWindow: mainWindow
    width: 440; height: 280
}
dlg.openDialog()

ToolShellWindow {
    title: qsTr("Inspector")
    width: 320; height: 480
}

CompactOverlayShellWindow {
    title: qsTr("Now playing")
    width: 360; height: 200
}
```

Gallery demos: `WindowParadigmPage`.

## NavigationWindow / NavigationView

`paneDisplayMode`: `left` | `leftCompact` | `leftMinimal` | `top` | `auto`  
(`auto` switches left ↔ leftCompact at `autoCompactThreshold`, default 1008.)

- **`leftMinimal`**: pane is a light-dismiss **overlay** (does not push content).
- Pane search: `isPaneSearchEnabled` + `paneSearchModel`
- `paneHeader` / `paneFooter` slots
- Item `badge` / `badgeValue` → `InfoBadge`
- Drag reorder: `isReorderable` + `onModelReordered`
- Keyboard Home/End/type-ahead; compact flyout ↑↓ Enter Esc
- Top overflow `…` lists only **clipped** items

Gallery `Main.qml` enables `auto`, pane search, badges, and reorder as the living sample. More: [navigation.md](navigation.md).

## StatusBar

```qml
StatusBar {
    text: qsTr("Ready")
    progress: 0.4
    centerContent: Label { text: qsTr("Ln 12") }
    content: Label { text: qsTr("UTF-8") }
}
```

## ContentDialog queue

`ContentDialog.show()` enqueues via `ContentDialogQueue` (one visible dialog at a time). Full FIFO / owner / Esc recipe: [dialogs-flyouts.md](dialogs-flyouts.md) (**1.48**).

```qml
ContentDialogQueue.show(dialogA)
ContentDialogQueue.cancel(dialogA)       // drop pending
ContentDialogQueue.clearQueue()          // drop all pending
ContentDialogQueue.replaceCurrent(dialogB) // close active without pumping; open B; queue resumes after
```

## Theme tokens (WinUI-aligned)

| Token | Typical WinUI | QWinUI3 |
|-------|---------------|---------|
| Control corner | 4px | `Theme.cornerControl` |
| Overlay / flyout corner | 8px | `Theme.cornerOverlay` / `cornerCard` |
| Focus outer / inner | 2px + 1px | `strokeFocusOuter` / `strokeFocusInner` + `focusOuter` / `focusInner` |
| Nav pane expanded | ~320 / 280 | `navPaneWidth` (280) |
| Nav compact | 48 | `navPaneCompactWidth` |
| Control padding | 12×7 | `paddingControlH` / `paddingControlV` |
| Spacing scale | 8 / 12 / 24 | `spacing` / `spacingLoose` / `spacingSection` |

Accessibility: `Theme.followSystemAccessibility` (default true) copies
`WindowHelper.systemReducedMotion` / `systemHighContrast` (Windows SPI) into
`Theme.reducedMotion` / `Theme.highContrast`. Settings can override when follow is off.

## Startup (Bootstrap)

Prefer one-call bootstrap before `QGuiApplication`:

```cpp
#include "Bootstrap.h"
QWinUI3::configureEnvironment(argv[0]); // style + Wayland/DPI + QPA sanitize
```

That wraps `WindowHelper::configurePlatformEnvironment`. Manual `configurePlatformEnvironment` alone still works for Linux CSD/DPI but skips style / Windows QPA sanitize / IME unset — see [packaging-consumer.md](packaging-consumer.md).
