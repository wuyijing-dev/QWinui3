# Adaptive layout — TwoPaneView & shells (1.42)

One LoB pattern for **narrow vs wide** desktop windows: collapse panes, don’t invent a phone shell.

| Surface | Role |
|---------|------|
| [`TwoPaneView`](components/TwoPaneView.md) | Generic dual pane (Wide / Tall / SinglePane) |
| [`ListDetailsView`](components/ListDetailsView.md) | Master–detail on TwoPaneView + Back / Esc |
| [`NavigationView`](components/NavigationView.md) `paneDisplayMode: "auto"` | Rail compact below threshold |
| [`Theme.density`](density.md) | Control metrics — orthogonal to pane breakpoints |

Gallery: **TwoPaneView** · **ListDetailsView** · **NavigationView** · Settings → Density.  
Example: [`examples/master-detail`](../examples/master-detail/).

Related: [density.md](density.md) · [navigation.md](navigation.md) · [data-collections.md](data-collections.md) · [compatibility-1xx.md](compatibility-1xx.md).

---

## Supported pattern (ship this)

```text
Wide window  → list | details side-by-side (TwoPaneView.Wide)
Narrow window → one pane at a time (SinglePane) + Back / Esc to list
Nav rail     → NavigationView auto → leftCompact under 1008 CSS px
Density      → Theme.density compact|standard (heights/padding, not breakpoints)
```

Do **not**: build a separate phone UI, hard-code pixel layouts per DPI without `Theme` / shell, or nest two competing adaptive frames.

---

## Breakpoint cheat sheet

| Control | Property | Default | Narrow behavior |
|---------|----------|---------|-----------------|
| `NavigationView` | `autoCompactThreshold` | **1008** | `auto` → `leftCompact` |
| `TwoPaneView` | `minWideWidth` | **720** | Below → `SinglePane` (or Tall if preferred) |
| `ListDetailsView` | `minWideWidth` | **720** | Same; select opens details; Back / Esc → list |
| `ListDetailsView` | `listPaneWidth` | **280** | Master column width when Wide |

Thresholds are **logical** layout widths (the control’s `width`), not physical mm. Gallery demos sometimes raise `minWideWidth` (e.g. **900**) so SinglePane is visible inside the catalog column.

```qml
NavigationView {
    paneDisplayMode: "auto"
    autoCompactThreshold: 1008
}

TwoPaneView {
    preferredMode: TwoPaneView.Wide
    minWideWidth: 720
    panePriorityWidth: 320   // master column target
    pane1: masterPane
    pane2: detailPane
}

ListDetailsView {
    minWideWidth: 720
    listPaneWidth: 280
    model: tickets
    details: TicketBody { item: listDetails.selectedItem }
}
```

---

## Which host should I use?

| Need | Prefer |
|------|--------|
| Mail / tickets / settings master–detail | **`ListDetailsView`** |
| Custom panes (map + inspector, preview + form) | **`TwoPaneView`** |
| App destinations / settings footer | **`NavigationView`** (`auto`) |
| Both rail + master–detail | Nav host + `ListDetailsView` in the page (Gallery / `examples/master-detail`) |

`ListDetailsView` already owns list keyboard (arrows / Home / End / Enter) and SinglePane Back — don’t reimplement on raw TwoPaneView unless you need custom masters (`ItemsView`, `DataTable`, …).

---

## SinglePane navigation

| API | When |
|-----|------|
| `showPane1()` / `showPane2()` | TwoPaneView — flip which pane fills |
| `toggleSinglePane()` | Swap index 0 ↔ 1 |
| `panePriority` | Which pane wins when collapsing |
| `ListDetailsView.showList()` / `showDetails()` | After selection / Back |
| Esc or Back | ListDetailsView returns to list when details are open in SinglePane |

Wide mode keeps both panes visible — Back is a no-op for “return to list” until the window is narrow.

---

## Wide / Tall configuration

| Property | Values | Notes |
|----------|--------|-------|
| `preferredMode` | `Wide` / `Tall` | Tall stacks top/bottom when width allows Tall path |
| `wideModeConfiguration` | `leftRight` \| `rightLeft` \| `singlePane` | Mirror / force single |
| `tallModeConfiguration` | `topBottom` \| `bottomTop` \| `singlePane` | Same for tall |

Force SinglePane for demos: set `minWideWidth` very high, or `wideModeConfiguration: "singlePane"`.

---

## Pair with density (1.30)

| Concern | Knob |
|---------|------|
| Touch / dense chrome | `Theme.density` / `uiScale` — [density.md](density.md) |
| Pane collapse | `minWideWidth` / `autoCompactThreshold` — **this page** |
| Type size | Fixed Theme font tokens — do not scale fonts with density |

Adaptive layout answers “how many panes?”. Density answers “how large are controls?”.

---

## Checklist

- [ ] One adaptive frame per window region (Nav **or** TwoPane / ListDetails — not both fighting)  
- [ ] `minWideWidth` documented for your product (720 default is fine)  
- [ ] Narrow path has Back / Esc (ListDetailsView) or explicit `showPane1()`  
- [ ] Gallery / QA: shrink window until `modeName` / SinglePane appears  
- [ ] Linux small laptops: keep `NavigationView` on `auto`  

**Out of scope (1.42):** phone/tablet OS shells, foldable hinge APIs, a new layout engine.
