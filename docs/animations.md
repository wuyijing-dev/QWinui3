# Animations & transitions (1.22)

Copy-ready motion for **list → detail**, **page enter**, and **content swap**. All helpers honor `Theme.reducedMotion` (and `Theme.duration()` collapses to ~1 ms when reduced motion is on).

**Status:** **experimental** — APIs are usable; keep them behind reduced-motion checks in production. Explicitly **deferred in 1.37** — [stable-api.md](stable-api.md).

Gallery: **Animations** (hub) · ConnectedAnimation · EntranceThemeTransition · Theme transitions.

---

## Choosing

| Need | Prefer |
|------|--------|
| Shared-element morph (thumb → hero) | [`ConnectedAnimation`](components/ConnectedAnimation.md) + [`ConnectedAnimationService`](components/ConnectedAnimationService.md) |
| Master–detail pane handoff | [`ListDetailsView`](components/ListDetailsView.md) `connectedAnimationEnabled` |
| First show of a section / card | [`EntranceThemeTransition`](components/EntranceThemeTransition.md) |
| Swap content identity (tab/panel) | [`ContentThemeTransition`](components/ContentThemeTransition.md) |
| Flow/Grid children reflow | [`RepositionThemeTransition`](components/RepositionThemeTransition.md) |
| Icon hover/press micro-motion | [`FontIcon`](components/FontIcon.md) / IconButton — [icons.md](icons.md) (**1.49**) |
| Theme.dark / accent color change | `Behavior` + `Theme.duration` (below) — **not** a dedicated type |

Do **not** wrap the entire `ShellWindow` / title bar in entrance motion — animate **client content** only to avoid chrome jank.

---

## Reduced motion

```qml
// Prefer system SPI (Gallery / apps):
WindowHelper.refreshAccessibility()
Theme.reducedMotion = WindowHelper.systemReducedMotion

// Or let the user toggle Theme.reducedMotion in Settings.
```

| Helper | When `Theme.reducedMotion` |
|--------|----------------------------|
| ConnectedAnimation / Service | Skips morph; still invokes `finished` / `onFinished` |
| Entrance / Content transitions | Snaps to final opacity/transform |
| RepositionThemeTransition | `Behavior` disabled |
| `Theme.duration(ms)` | Returns `1` |

Always drive custom `NumberAnimation` / `ColorAnimation` durations through `Theme.duration(...)`.

---

## ConnectedAnimation — list → detail

Register **from** then **to** under the same key, then `play`. Same-window only (ghost parents to `Overlay.overlay`).

```qml
import QWinUI3.Extras

// After layout is ready (e.g. onClicked):
ConnectedAnimationService.register("mail.hero", listThumb)
ConnectedAnimationService.register("mail.hero", detailHero)
ConnectedAnimationService.play("mail.hero", function () {
    stack.push(detailPage)
})

// Or one-shot without the registry:
ConnectedAnimation {
    id: morph
    from: listThumb
    to: detailHero
    onFinished: stack.push(detailPage)
}
morph.play()
```

| Tip | Detail |
|-----|--------|
| Key lifetime | Unregister or `clear()` when leaving the page |
| Timing | Register **after** the destination item has a real size |
| ListDetailsView | Set `connectedAnimationEnabled: true` for built-in handoff |
| Ghost look | `ghostColor` / source tint via `ConnectedAnimation` |

---

## EntranceThemeTransition — shell page enter

```qml
EntranceThemeTransition {
    anchors.fill: parent
    autoPlay: true          // also replays when becoming visible
    // offsetY / fromScale — optional tuning
    YourPageBody { anchors.fill: parent }
}
```

Call `play()` / `reset()` for demos. Prefer wrapping **one** content host, not every nested card.

---

## ContentThemeTransition — panel swap

Bump `contentKey` (or call `play()`) after replacing children:

```qml
ContentThemeTransition {
    anchors.fill: parent
    contentKey: currentPanelId
    // children = current panel UI
}
```

---

## RepositionThemeTransition — layout reflow

Wrap Flow/Grid delegates so x/y changes animate:

```qml
Flow {
    spacing: Theme.spacing
    Repeater {
        model: count
        RepositionThemeTransition {
            width: 72; height: 40
            Rectangle { anchors.fill: parent; /* … */ }
        }
    }
}
```

---

## Theme.dark / accent (no dedicated transition type)

```qml
Rectangle {
    color: Theme.bgLayer
    Behavior on color {
        ColorAnimation {
            duration: Theme.duration(Theme.motionNormal)
            easing.type: Theme.easingStandard
        }
    }
}
```

Use the same pattern for `Theme.accent` fills. Avoid animating dozens of deep tree nodes on every theme flip — prefer a few large surfaces (window layer, cards).

---

## Motion tokens

| Token | Typical use |
|-------|-------------|
| `Theme.motionFast` / `motionNormal` / `motionSlow` | Pass to `Theme.duration(...)` |
| `Theme.easingEnter` / `easingStandard` / `easingEmphasized` | Match Fluent enter vs morph |

---

## Related

| Doc / type | Role |
|------------|------|
| [ConnectedAnimation](components/ConnectedAnimation.md) | Ghost morph |
| [ConnectedAnimationService](components/ConnectedAnimationService.md) | Key registry |
| [EntranceThemeTransition](components/EntranceThemeTransition.md) | Page enter |
| [ContentThemeTransition](components/ContentThemeTransition.md) | Content swap |
| [RepositionThemeTransition](components/RepositionThemeTransition.md) | Reflow |
| [ListDetailsView](components/ListDetailsView.md) | Built-in connected animation |
| [accessibility.md](accessibility.md) | `reducedMotion` / SPI |
| [icons.md](icons.md) | Glyph hover/press micro-motion (**1.49**) |
| [data-collections.md](data-collections.md) | List → detail notes |
