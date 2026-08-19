# Carousel recipes (2.37)

LoB patterns for **paged content** — hero strips, onboarding slides, image galleries. Prefer [`FlipView`](components/FlipView.md) + built-in [`PipsPager`](components/PipsPager.md), or wire **PipsPager** to your own **`SwipeView`** host.

Gallery: **FlipView** · **PipsPager** · **Animations** (reduced motion).  
Accessibility: [accessibility.md](accessibility.md) · keyboard: [keyboard.md](keyboard.md).

**Out of scope:** full-screen marketing carousel product, auto-play timers, infinite virtualized feeds.

---

## Choosing a host

| Need | Prefer | Why |
|------|--------|-----|
| Fluent chevrons + dots in one control | **`FlipView`** | Embeds `SwipeView`, nav buttons, and `PipsPager` |
| Custom page chrome / only dots | **`PipsPager`** + **`SwipeView`** | Sync `count` / `currentIndex` both ways |
| Vertical pager rail | **`FlipView`** or **`PipsPager`** | Set `orientation: Qt.Vertical` |
| Many pages (>10) | **`PipsPager.maxVisiblePips`** | Window visible dots; arrows still navigate |
| Wrap-around kiosk | **`wrap: true`** on host + pager | `goNext` / `goPrevious` roll from last → first |

Do **not** stack multiple swipe hosts without a single focus owner — one carousel per pane.

---

## Recipe A — FlipView (default)

```qml
import QWinUI3.Extras

FlipView {
    id: hero
    Layout.fillWidth: true
    Layout.preferredHeight: 240
    buttonVisibility: "onHover"   // always | onHover | hidden
    isIndicatorVisible: true
    wrap: false
    orientation: Qt.Horizontal

    onCurrentIndexChangedByUser: function (index) {
        // analytics / prefetch next slide
    }

    // pages as children
    Item { /* slide 1 */ }
    Item { /* slide 2 */ }
}
```

| Property | Guidance |
|----------|----------|
| `buttonVisibility` | **`onHover`** for content-heavy heroes; **`always`** for kiosk |
| `isIndicatorVisible` | Hide when `count <= 1` (FlipView already hides pips when count ≤ 1) |
| `interactive` | Forwarded to inner `SwipeView` — disable for display-only |

Built-in **PipsPager** uses collapsed prev/next chevrons — users swipe or use outer FlipView buttons.

---

## Recipe B — PipsPager + SwipeView

When you own the swipe surface (custom transitions, lazy `Loader` pages):

```qml
ColumnLayout {
    SwipeView {
        id: swipe
        Layout.fillWidth: true
        Layout.preferredHeight: 200
        currentIndex: pager.currentIndex
        Repeater {
            model: slideModel
            delegate: SlideCard { /* … */ }
        }
    }
    PipsPager {
        id: pager
        Layout.alignment: Qt.AlignHCenter
        count: swipe.count
        selectedIndex: swipe.currentIndex
        maxVisiblePips: 7
        previousButtonVisibility: "visibleOnPointerOver"
        nextButtonVisibility: "visibleOnPointerOver"
        onCurrentIndexEdited: function (index) { swipe.currentIndex = index }
    }
    Connections {
        target: swipe
        function onCurrentIndexChanged() {
            if (pager.currentIndex !== swipe.currentIndex)
                pager.currentIndex = swipe.currentIndex
        }
    }
}
```

Keep **one source of truth** — either bind both ways as above or drive only from `onCurrentIndexEdited`.

---

## Reduced motion (2.37)

`FlipView` nav button opacity and **`PipsPager`** pip size/color **Behaviors** honor **`Theme.reducedMotion`** (animations snap off).

```qml
// Gallery demo pattern — toggle to verify
SettingsToggleCard {
    title: qsTr("Reduced motion")
    checked: Theme.reducedMotion
    onToggled: Theme.reducedMotion = checked
}
```

| Surface | When reduced motion |
|---------|---------------------|
| Pip expand/collapse | Instant size/color |
| FlipView chevron fade | Instant opacity |
| SwipeView slide | Qt default — prefer fewer auto-advance loops in product |

Also wire **`WindowHelper.systemReducedMotion`** via **`ThemeSync`** in app shells — [animations.md](animations.md).

Gallery **FlipView** / **PipsPager** pages include live **reduced motion** toggles (**2.37**).

---

## Keyboard & accessibility

| Control | Keys / roles |
|---------|----------------|
| **FlipView** | ←/→ (horizontal) or ↑/↓ (vertical); **Home** / **End** first/last page |
| **PipsPager** | ←/→ / ↑/↓ / wheel; **`Accessible.PageTabList`** + per-pip **`PageTab`** |
| Focus | Both use **`StrongFocus`** — tab into pager to use keyboard without grabbing swipe |

**Checklist:**

- [ ] Each slide has meaningful content (not color-only state)
- [ ] Pips expose **Page N** names (built-in `qsTr("Page %1")`)
- [ ] Do not rely on swipe-only navigation — chevrons / pips / keyboard remain available
- [ ] Pause auto-advance when `Theme.reducedMotion` or user prefers reduced motion

---

## MaxVisiblePips window

For **`numberOfPages: 12`** with **`maxVisiblePips: 5`**, the control slides a window centered on **`currentIndex`** (WinUI-style). Users still reach off-screen pages via **prev/next** arrows or keyboard.

Gallery **PipsPager** → **MaxVisiblePips** demo.

---

## Performance notes

- Prefer **few heavy delegates** — lazy-load slide content with **`Loader { active: index === swipe.currentIndex }`** when pages are costly.
- Avoid rebinding entire `rows` / models on every index change.
- See [performance.md](performance.md) — motion stays optional; carousels are not a list-virtualization substitute.

---

## Validation

`python scripts/smoke_gallery.py` (Gallery **FlipView** / **PipsPager** pages).

---

## Related

| Doc | Role |
|-----|------|
| [components/FlipView.md](components/FlipView.md) | API reference |
| [components/PipsPager.md](components/PipsPager.md) | API reference |
| [animations.md](animations.md) | Reduced motion helpers |
| [accessibility.md](accessibility.md) | Focus + live regions |
| [tree-data.md](tree-data.md) | Not a carousel — use TreeView for hierarchy |
