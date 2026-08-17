# Touch, pen & pointer (1.57 · 2.42 SwipeControl)

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
- [ ] **SwipeControl** — swipe reveal **and** a visible overflow/menu path (**2.42** thresholds + teaching — below)
- [ ] **ContentDialog** primary/secondary — full-width-friendly buttons on narrow panes
- [ ] Hover tooltips — nice-to-have; names still via `Accessible.name` / `toolTipText` for a11y

---

## SwipeControl deepen (2.42)

Horizontal swipe rows inside vertical lists are a common friction point. **`SwipeControl`** exposes tuning knobs — not OS edge gestures.

### Thresholds

| Property | Default | Role |
|----------|---------|------|
| `revealThreshold` | 36 | Release distance to snap open (reveal mode) or invoke first action (execute mode) |
| `dragThreshold` | 12 | Pointer travel before horizontal drag engages |
| `nestedScrollFriendly` | false | When **true**, uses `max(dragThreshold, 20)` so vertical flick can win in `ListView` / `ScrollView` |
| `actionWidth` | 72 | Width per `SwipeAction` — affects `maxLeftReveal` / `maxRightReveal` |

```qml
SwipeControl {
    nestedScrollFriendly: true
    revealThreshold: 40
    dragThreshold: 16
    // …
}
```

**Rule:** inside a scrolling list, set **`nestedScrollFriendly: true`** and keep a **non-swipe** delete/archive path (`MenuFlyout`, overflow `IconButton`, or row button).

### Teaching (first-run)

Use **`TeachingTip`** anchored to the first swipe row — not as the only discoverability path:

```qml
TeachingTip {
    target: firstRow
    title: qsTr("Swipe for actions")
    subtitle: qsTr("Or tap ⋯ — swipe is optional")
}
```

Gallery **SwipeControl** demonstrates tip + overflow menu. Persistence: `Settings` / onboarding coach — [feedback.md](feedback.md) (**1.55**).

### Nested scroll checklist

| # | Check |
|---|--------|
| 1 | Parent is `ListView` / `ScrollView` / `DataTable` flick — child row uses `nestedScrollFriendly: true` |
| 2 | Vertical scroll still works without accidental horizontal capture |
| 3 | `revealThreshold` ≤ half row width — tune on real touch hardware |
| 4 | Execute mode (`swipeMode: "execute"`) — higher threshold recommended for destructive actions |
| 5 | Keyboard path remains: **←** / **→** reveal · **Esc** close |


**Out:** OS edge-back / system gesture hooks.

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
