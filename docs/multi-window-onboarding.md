# Multi-window + onboarding (2.43)

Combine **1.55** coach marks with **1.56 / 2.14** multi-window z-order so first-run tours do not fight secondary shells.

**Related:** [window-shells.md](window-shells.md) · [feedback.md](feedback.md) · [settings-persistence.md](settings-persistence.md) · Gallery **Multi-window** · **Onboarding coach**.

---

## Problem

Apps with inspectors, owned dialogs, or tool windows often:

- Anchor `TeachingTip` to the wrong top-level surface
- Spawn a dialog during a coach step and lose z-order on Wayland
- Store tour flags in the same `QSettings` category as `geometryPersistenceKey`

---

## Real-app checklist

| # | Check | Pattern |
|---|--------|---------|
| 1 | Coach on **primary** shell only | `NavigationWindow` / main `ShellWindow` — not `ToolShellWindow` |
| 2 | Defer auto-offer | Run tour after main `visible` + first frame (e.g. `Component.onCompleted` + `Qt.callLater`) |
| 3 | No secondary shells mid-tour | Finish or pause coach before `openDialog(owner)` / tool spawn |
| 4 | Z-order before tips | Owner must be visible; use `openDialog(owner)` (**2.14**) not raw `visible = true` |
| 5 | Settings category | `Settings { category: "MyApp/Onboarding" }` — **not** `WindowGeometry/…` |
| 6 | Geometry keys | Unique `geometryPersistenceKey` per role (Main / Tool / Dialog) |
| 7 | Don’t show again | `property bool mainTourDismissed: false` — separate from window restore |
| 8 | Esc / focus | Same as **1.55** — one tip at a time; dismiss returns focus to target |

---

## Settings persistence

```qml
import QtCore

Settings {
    id: onboarding
    category: "MyApp/Onboarding"   // not WindowGeometry/*
    property bool mainTourDismissed: false
    property int tourVersion: 1     // bump when copy changes
}

function maybeOfferTour(mainWindow) {
    if (onboarding.mainTourDismissed || onboarding.tourVersion < kCurrentTourVersion)
        return
    if (!mainWindow || !mainWindow.visible)
        return
    Qt.callLater(startMainTour)
}
```

Window frame restore stays in `WindowGeometry/<geometryPersistenceKey>` — [settings-persistence.md](settings-persistence.md) (**1.65**).

---

## Multi-window z-order (recap)

| Surface | Open path |
|---------|-----------|
| Owned dialog | `DialogShellWindow.openDialog(owner)` |
| Tool / inspector | Own key + `visible` / `raise()` after `ensureWindowCreated` |
| In-window confirm | `ContentDialog` on `Overlay.overlay` — not a second HWND |

Wayland regression: `WindowHelper.portalParentWindow(owner)` readout — Gallery **Multi-window** (**2.14**).

---

## Gallery map

| Page | Role |
|------|------|
| **Onboarding coach** | 3-step `TeachingTip` + `Settings` don’t-show-again (**1.55**); **2.43** multi-window defer rules |
| **Multi-window** | Tool + owned dialog spawn; **2.43** coach/z-order checklist |


**Out:** Analytics-backed onboarding SaaS; cloud tour CMS.
