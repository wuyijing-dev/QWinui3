# Touch, pen & pointer (1.57)

Honest finger / pen guidance for QWinUI3 LoB shells — **no** custom ink stack. Pair with [density.md](density.md), [accessibility.md](accessibility.md), and [keyboard.md](keyboard.md) (hardware chords stay primary for power users). Touch OSK → in-app IME is **1.70…1.73**: [on-screen-keyboard.md](on-screen-keyboard.md).

Gallery: **Touch & pointer** · **Density** · **Accessibility** · high-traffic callouts on Button / Slider / NavigationView / FileDropZone / SwipeControl.

---

## When to use which density

| Scenario | Prefer | Why |
|----------|--------|-----|
| Mouse + keyboard desktop | `Theme.density: "standard"` or `"compact"` | Compact is fine for dense LoB grids |
| Finger-first / convertible / kiosk | **`standard`** (+ optional `uiScale` ≥ 1) | Compact shrinks `controlHeight` (~0.85×) |
| Custom oversized hit area | `Theme.dp(44)` / `dp(48)` on your chrome | Do not invent a second Theme scale |

Live numbers: Gallery **Density** / **Theme overrides** show `Theme.controlHeight` (base **36** × density × `uiScale`).

**Rule of thumb:** keep primary actions at least **`Theme.controlHeight`** tall and roughly that wide for icon-only buttons. Prefer spacing so adjacent targets are not finger-ambiguous.

```qml
Theme.density = "standard"   // finger-friendly default
// Theme.uiScale = 1.1       // optional bump without compact chrome
Button {
    implicitHeight: Math.max(implicitHeight, Theme.controlHeight)
    // icon-only:
    implicitWidth: Math.max(implicitWidth, Theme.controlHeight)
}
```

---

## Scroll vs drag vs click

| Interaction | Prefer | Avoid |
|-------------|--------|-------|
| Page / list scroll | `ScrollView` / ListView / DataTable flick | Nested `DragHandler` that steals the flick |
| File ingest | [`FileDropZone`](drag-drop.md) + Browse | Drag-drop as the **only** path (touch often lacks OS file DnD) |
| Reveal actions | [`SwipeControl`](components/SwipeControl.md) | Swipe as the only way to delete — also expose a button/menu |
| Pull refresh | [`RefreshContainer`](components/RefreshContainer.md) | Competing vertical drag on the same child |
| Primary activate | `Button` / `TapHandler` click | Hover-only affordances (no finger hover) |

If you add a custom `DragHandler`, set a clear threshold and leave vertical flick to the scrollable parent. Gallery **FileDropZone** and **SwipeControl** pages are the reference patterns.

---

## Pen / stylus notes

Qt Quick exposes device types on pointer events (`PointerDevice.Mouse` / `TouchScreen` / `Stylus`, …). QWinUI3 does **not** ship a handwriting or ink canvas (out of scope for 1.57).

| Topic | Guidance |
|-------|----------|
| Hover | Stylus may generate hover; **mouse** hover does not exist for finger. Never put required UI only in `hovered` chrome. |
| Primary action | Same click/tap path as mouse — `Button`, list activation, etc. |
| Precision | Prefer larger targets still; pens help but LoB rows stay ~`controlHeight`. |
| Accepted devices | Narrow `DragHandler` / `HoverHandler` `acceptedDevices` when mouse-only chrome would fight touch (see NavigationView / TabView internals). |

```qml
HoverHandler {
    // Optional: react to pen hover without requiring it for discovery
    acceptedDevices: PointerDevice.Stylus | PointerDevice.Mouse
    onHoveredChanged: if (hovered) { /* preview only */ }
}
```

---

## High-traffic Gallery checklist

Smoke these with a finger (or Windows touch emulator) after changing density:

- [ ] **Button** / **AccentButton** / icon-only **IconButton** — hit area ≥ `controlHeight`
- [ ] **Slider** / **ToggleSwitch** — thumb reachable; not only the hairline track
- [ ] **NavigationView** items / Settings footer — pane rows match `navItemHeight`
- [ ] **ListDetailsView** / **ItemsView** rows — activate without precision hunting
- [ ] **SettingsCard** toggle rows — whole row toggles (already one Tab stop)
- [ ] **FileDropZone** — Browse still works when drag is unavailable
- [ ] **SwipeControl** — swipe reveal **and** a visible overflow/menu path
- [ ] **ContentDialog** primary/secondary — full-width-friendly buttons on narrow panes
- [ ] Hover tooltips — nice-to-have; names still via `Accessible.name` / `toolTipText` for a11y

---

## Cross-links

| Doc | Role |
|-----|------|
| [density.md](density.md) | Tokens / compact math / responsive shells |
| [adaptive-layout.md](adaptive-layout.md) | Narrow TwoPane / ListDetails |
| [accessibility.md](accessibility.md) | Names, focus, reduced motion |
| [keyboard.md](keyboard.md) | Chords stay available on touch-capable PCs |
| [on-screen-keyboard.md](on-screen-keyboard.md) | Win11 OSK → IME (**1.70…1.73**) — not Qt Virtual Keyboard |
| [drag-drop.md](drag-drop.md) | Drop + Browse + clipboard |
| [icons.md](icons.md) | Icon-only `toolTipText` |

---

## Out of scope (1.57)

Custom ink / handwriting recognition; a second input stack; phone OS shells; forcing touch-mode OS APIs beyond Qt pointer events.
