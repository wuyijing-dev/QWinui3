# Icons & FluentIcons (1.29)

Reliable symbol story for apps: **FluentIcons** + **Theme.fontFamilyIcon** — no custom asset pipeline required.

Gallery: **Iconography** (`FontIconPage`) · IconButton · IconicButton · Accessibility.

Related: [conventions.md](conventions.md) · [accessibility.md](accessibility.md) · [platform-linux-wayland.md](platform-linux-wayland.md) · [theme-overrides.md](theme-overrides.md).

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
| [`FontIcon`](components/FontIcon.md) | Extras | Standalone glyph |
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

## Accessibility

| Surface | Guidance |
|---------|----------|
| Icon-only buttons | `toolTipText` (preferred) or `text` / `Accessible.name` — [conventions.md](conventions.md) |
| Decorative `FontIcon` | Leave `accessibleName` empty → ignored / unnamed Graphic (1.29); set name when the icon conveys meaning alone |
| Caption buttons | Defaults map Chrome* glyphs → Minimize / Maximize / Restore / Close (1.29) |
| Gallery Iconography | Prefer named `FluentIcons.*` in copied snippets |

---

## Gallery — Iconography

1. Open **Iconography** and search by name, code, or tags.
2. Select a tile → copy `FontIcon { symbol: FluentIcons.… }` when **named**.
3. Counts show total / filtered / named — prefer named keys in product code.
4. Pair with **IconButton** / **Accessibility** pages for `toolTipText` demos.

---

## Out of scope

- Figma token pipeline; shipping a second icon font for the kit.
