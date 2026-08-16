# Theme overrides & branding (1.09)

Supported path for app branding: set **writable Theme knobs**. Stock Style and Extras already bind to those tokens — **do not fork Style**.

| Knob | Values | Effect |
|------|--------|--------|
| `Theme.dark` | `true` / `false` | Light/dark color ramps |
| `Theme.followSystemColorScheme` | bool | Mirror OS light/dark into `Theme.dark` |
| `Theme.density` | `"standard"` \| `"compact"` | Scales heights / padding / spacing (**not** fonts) — [density.md](density.md) (1.30) |
| `Theme.uiScale` | `real` (default `1.0`) | Extra multiplier on density scale |
| `Theme.accentPack` | `blue` \| `purple` \| `green` \| `orange` | Named accent |
| `Theme.customAccent` | `color` with alpha > 0 | Overrides pack for `accent` / fills |
| `Theme.setAccentPack(name)` | string | Sets pack **and clears** `customAccent` |

Almost every surface color (`bgCard`, `textPrimary`, …) is **readonly** and derived. Assigning `Theme.bgCard = …` is not supported.

---

## Startup recipe

```qml
import QWinUI3.Theme

Component.onCompleted: {
    Theme.customAccent = "#0F766E"   // brand teal
    Theme.density = "compact"        // optional
    // Theme.dark = true             // or followSystemColorScheme
}
```

Pack vs custom:

```qml
Theme.setAccentPack("purple")        // clears customAccent
Theme.customAccent = "#C239B3"       // brand wins over pack
```

Helpers: `Theme.duration(ms)`, `Theme.dp(n)`, `Theme.controlFill(…)`, `Theme.accentFill(…)`.

---

## What cascades

QQC Style under `QWinUI3` and Extras (buttons, switches, progress, settings cards, …) already use `Theme.accent`, `Theme.dark`, density metrics. Changing knobs updates the whole app without editing Style QML.

App-local chrome (logo strip, splash) should also read `Theme.accent` / `Theme.bgCard` rather than hard-coded hex.

---

## Gallery

**Theme overrides** page — apply Contoso-style presets, pick a custom accent, toggle density / uiScale, watch live metrics and stock controls; leaving the page restores prior Theme knobs.

Settings → **Accent pack** / **Custom accent** / **Density** for global Gallery preference.

Metrics, type scale, and narrow shells: **[density.md](density.md) (1.30)**.

Contrast / AA accent checks: **[color-contrast.md](color-contrast.md) (1.43)** — `Theme.contrastRatio` / `contrastPassesAA` on the Theme overrides Gallery page.

---

## Out of scope (1.09)

- Fluent 2 / Style restyle of controls  
- Theme editor / editable token grid  
- Making `bg*` / `text*` writable override maps  
- New accent pack names in Theme.qml (use `customAccent`)  
- Automated WCAG certification (see color-contrast diagnostics instead)
