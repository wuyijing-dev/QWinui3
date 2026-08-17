# Density, typography & responsive shells (1.30)

Compact vs comfortable metrics, fixed type scale, and one narrow-window shell pattern. Branding knobs stay in [theme-overrides.md](theme-overrides.md); this page is the **metrics + layout** recipe.

Gallery: **Theme overrides** (live metrics) · Settings → Density · **NavigationView** (`paneDisplayMode: auto`) · **ListDetailsView**.

Related: [navigation.md](navigation.md) · [window-shells.md](window-shells.md) · [icons.md](icons.md) · [touch-pointer.md](touch-pointer.md) (**1.57**) · [components/Theme.md](components/Theme.md).

---

## Density knobs

| Knob | Values | Effect |
|------|--------|--------|
| `Theme.density` | `"standard"` \| `"compact"` | Compact uses **0.85×** on scaled metrics |
| `Theme.uiScale` | `real` (≥ 0.5, default `1.0`) | Extra multiplier on the density scale |
| `_densityScale` | (readonly) | `(compact ? 0.85 : 1) * uiScale` |
| `Theme.dp(n)` | helper | `round(n * _densityScale)` |

```qml
Theme.density = "compact"
Theme.uiScale = 1.0   // optional fine tune
```

`CommandBar.compact` defaults to `Theme.density === "compact"`.

---

## What scales vs what does not

| Scales with density / uiScale | Does **not** scale |
|-------------------------------|--------------------|
| `controlHeight` (base 36) | **Type scale** (`fontCaption` … `fontTitleLarge`) |
| `navItemHeight`, padding H/V | Font families / weights |
| `spacing` / `spacingLoose` / `spacingSection` | Corner radii |
| Switch / check / radio / slider thumbs | `navPaneWidth` **280** / `navPaneCompactWidth` **48** |
| `controlMinWidth` | Stroke widths (use `hairline()` for DPR) |

**Typography is fixed on purpose** — compact chrome without shrinking text (a11y). Pair glyph sizes with [icons.md](icons.md); do not invent a second font-scale token in 1.30.

---

## Type scale (reference)

| Token | Typical use |
|-------|-------------|
| `fontCaption` (12) | Hints, secondary labels |
| `fontBody` | Controls, forms |
| `fontSubtitle` / `fontTitle` / `fontTitleLarge` | Page chrome |

Always use `Theme.fontFamily` / `Theme.fontFamilyIcon` — not system defaults.

---

## Responsive shell pattern

Prefer **one** adaptive frame. Full breakpoint cheat sheet: **[adaptive-layout.md](adaptive-layout.md) (1.42)**.

### NavigationView `auto`

```qml
NavigationView {
    paneDisplayMode: "auto"
    autoCompactThreshold: 1008   // default — leftCompact when narrower
    // …
}
```

Gallery `Main.qml` and [`examples/nav-settings`](../examples/nav-settings/) use this. Details: [navigation.md](navigation.md).

### ListDetailsView / TwoPaneView

```qml
ListDetailsView {
    minWideWidth: 720   // API default; Gallery narrow demo may use 900
    // Wide: list + details; narrow: SinglePane + Back / Esc
}
```

Master–detail starter: [`examples/master-detail`](../examples/master-detail/).

| Do | Avoid |
|----|--------|
| `paneDisplayMode: "auto"` for app destinations | Nesting a second full NavigationView per page |
| Test LTR and RTL (`LayoutMirroring`) at ~900–1100 px | Assuming density changes pane rail widths |
| Use [adaptive-layout.md](adaptive-layout.md) for TwoPane vs ListDetails | Fighting Nav auto + TwoPane with conflicting frames |
---

## Gallery

| Page | What to try |
|------|-------------|
| Theme overrides | Toggle density / uiScale; watch live `controlHeight` / `spacing` |
| **Touch & pointer** | Finger checklist + target floor (**1.57**) — [touch-pointer.md](touch-pointer.md) |
| Settings | Persistent Gallery density |
| NavigationView | `auto` / `leftCompact` / `leftMinimal` |
| ListDetailsView | Force narrow with `minWideWidth: 900` in the demo |

Leaving Theme overrides restores Theme knobs from page entry.

---

## Out of scope

- Scaling fonts with density; Fluent 2 redesign; phone/tablet OS shells — desktop adaptive panes: [adaptive-layout.md](adaptive-layout.md) (**1.42**).
