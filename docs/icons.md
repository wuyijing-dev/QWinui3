# Icons & FluentIcons (1.29 · micro-motion 1.49)

Reliable symbol story for apps: **FluentIcons** + **Theme.fontFamilyIcon** — no custom asset pipeline required.

Gallery: **Iconography** (`FontIconPage`) · IconButton · AppBarButton · IconicButton · Accessibility.

Related: [conventions.md](conventions.md) · [accessibility.md](accessibility.md) · [animations.md](animations.md) · [platform-linux-wayland.md](platform-linux-wayland.md) · [theme-overrides.md](theme-overrides.md).

---

## Prefer named symbols

```qml
import QWinUI3.Theme
import QWinUI3.Extras

FontIcon {
    symbol: FluentIcons.Home
    fontSize: 16
    iconColor: Theme.textPrimary
    accessibleName: qsTr("Home")   // or toolTipText on buttons
}

// On chrome controls:
IconButton {
    symbol: FluentIcons.Settings
    toolTipText: qsTr("Settings")
}
```

| Do | Avoid |
|----|--------|
| `FluentIcons.Save` / `symbol: FluentIcons.X` | Hard-coded `\uE74E` when a named key exists |
| `Theme.fontFamilyIcon` | Assuming Segoe is always installed |
| `toolTipText` / `accessibleName` on icon-only UI | Glyph alone as `Accessible.name` |
| Theme color tokens | One-off hex for icons |

---

## API

| Piece | Module | Role |
|-------|--------|------|
| [`FluentIcons`](components/Theme.md) | Theme singleton | `FluentIcons.Home` → glyph string (~100 named; full map in font) |
| `FluentIconsCatalog` | Theme singleton | Browser data: `entries`, `names`, `namedCount` |
| [`FontIcon`](components/FontIcon.md) | Extras | Standalone glyph (+ micro-motion 1.49) |
| [`IconSource`](components/IconSource.md) | Theme | `resolve(symbol\|name\|glyph)` |
| `Theme.fontFamilyIcon` | Theme | Active icon font family |

Helpers: `FluentIcons.of(name)`, `has(name)`, `codeHex(name)`.

---

## Font loading

| Host | Behavior |
|------|----------|
| Windows | Prefer system **Segoe Fluent Icons**; else embed `WinSymbols3.ttf` |
| Linux / others | Embedded WinSymbols (`Symbols` / `Theme.fontFamilyIcon`) |

Apps should not ship a second icon font for kit chrome. See [platform-linux-wayland.md](platform-linux-wayland.md).

---

## Size ramp (high-traffic)

| Context | Typical px |
|---------|------------|
| Caption buttons (min / max / close) | **10** |
| TitleBar Back / hamburger / search clear | **10–14** |
| TitleBar app symbol | **16** |
| NavigationView item icons | **16** (flyout **14**, chevron **10**) |
| InfoBar severity / IconButton default | **16** |
| AppBarButton (standard) | **18** |
| `FontIcon` default `fontSize` | **16** |

Use `Theme.controlHeight` / density for **controls**; keep glyph px in this band so chrome stays aligned.

---

## Color

| Intent | Token |
|--------|--------|
| Default glyph | `Theme.textPrimary` |
| Secondary / chrome idle | `Theme.textSecondary` |
| Accent / brand mark | `Theme.accent` |
| Disabled | `Theme.textDisabled` |
| Severity (InfoBar) | success / caution / critical system colors |

Do not invent fills for icons — follow the hosting control’s foreground recipe.

---

## Micro-motion (1.49)

WinUI-style **hover lift** and **press squash** on glyphs. Shared knobs on `FontIcon` and `IconicButton` (hence `IconButton` / `AppBarButton` / `AppBarToggleButton`):

| Property | Default | Role |
|----------|---------|------|
| `microMotionEnabled` | `true` | Master switch |
| `hoverScale` | `1.06` | Hover lift |
| `pressScale` | `0.92` | Press squash |
| `effectiveIconScale` | (readonly) | Resolved scale |

```qml
FontIcon {
    symbol: FluentIcons.Home
    toolTipText: qsTr("Home")
    // microMotionEnabled: false   // opt out
    // hoverScale: 1.08
    // pressScale: 0.9
}

IconButton {
    symbol: FluentIcons.Settings
    toolTipText: qsTr("Settings")
}
```

| Rule | Detail |
|------|--------|
| Reduced motion | When `Theme.reducedMotion` (or system SPI mirrored in Gallery), scale stays **1** |
| Duration | `Theme.duration(Theme.motionFast)` + `Theme.easingStandard` |
| Scope | Glyph only — not a full **AnimatedIcon** / Lottie path (see roadmap 1.53) |

Also see [animations.md](animations.md) (pointer).

---

## Accessibility

| Surface | Guidance |
|---------|----------|
| Icon-only buttons | `toolTipText` (preferred) or `text` / `Accessible.name` — [conventions.md](conventions.md) |
| Decorative `FontIcon` | Leave `accessibleName` empty → ignored / unnamed Graphic (1.29); set name when the icon conveys meaning alone |
| Caption buttons | Defaults map Chrome* glyphs → Minimize / Maximize / Restore / Close (1.29) |
| Gallery Iconography | Prefer named `FluentIcons.*` in copied snippets |

---

## Gallery — Iconography

1. Open **Iconography** — try the **Micro-motion (1.49)** strip (hover/press + `Theme.reducedMotion` toggle).
2. Search the catalog by name, code, or tags; copy `FontIcon { symbol: FluentIcons.… }` when **named**.
3. Pair with **IconButton** / **AppBarButton** pages for control chrome demos.

---

## Out of scope

- Figma token pipeline; shipping a second icon font for the kit.
- Full WinUI AnimatedIcon / Lottie state machines (planned thin path: roadmap **1.53**).
