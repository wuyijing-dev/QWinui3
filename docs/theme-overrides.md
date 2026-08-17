# Theme overrides & branding (1.09 · 2.17 Style cross-link · 2.38 wave 2)

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

**Style chrome (2.17):** Stock controls under `QWinUI3` Style read these tokens via helpers (`borderedControlFill`, `bgControlRest`, …). Spot-check light/dark/accent on Gallery **Style spot-check** — [style-polish.md](style-polish.md).

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

## Copy knobs into another app (1.69)

These knobs are **not** a Gallery privilege. `StandardWindow` / `ShellWindow` run `ThemeSync` so follow-system flags work in any product window.

| Piece | Role |
|-------|------|
| `Theme.snapshot()` / `Theme.apply(obj)` | In-process copy |
| `Theme.recipeText()` / `Theme.recipeSnippet` | Paste into `Component.onCompleted` |
| `ThemeAppearanceSettings` | Drop-in Settings group (same cards as Gallery Settings) |
| `ThemePrefs` | Persist knobs via QtCore `Settings` — [settings-persistence.md](settings-persistence.md) |
| `ThemeSync` | Copy OS a11y / color scheme when `followSystem*` is on |

```qml
SettingsView {
    ThemeAppearanceSettings {
        persist: true
        prefsCategory: "MyAppTheme"
    }
}
```

Gallery **Settings** uses that group plus Gallery-only chrome (RTL, page cache, RHI). **Theme prefs** copies the current recipe. Example: [`examples/gallery-shell`](../examples/gallery-shell/).

---

## Gallery

**Theme overrides** page — apply Contoso-style presets, pick a custom accent, toggle density / uiScale, watch live metrics and stock controls; leaving the page restores prior Theme knobs.

**Style spot-check** (2.17) — one-page audit of Button / TextField / ComboBox / CheckBox / Slider chrome against [style-polish.md](style-polish.md).

Settings → **ThemeAppearanceSettings** (kit) plus Gallery-only RHI / page cache. **Theme prefs** copies `Theme.recipeText()`.

Metrics, type scale, and narrow shells: **[density.md](density.md) (1.30)**.

Contrast / AA accent checks: **[color-contrast.md](color-contrast.md) (1.43 / 2.38 refresh)** — `Theme.contrastRatio` / `contrastPassesAA` on the Theme overrides Gallery page.

---

## Branding wave 2 (2.38)

Extend **1.09** / **1.69** for 2.x product apps — still **writable knobs only**; no Style fork.

| Recipe | When | Sketch |
|--------|------|--------|
| **Named pack** | Microsoft-style default | `Theme.setAccentPack("purple")` — clears `customAccent` |
| **Brand hex** | LoB color | `Theme.customAccent = "#0F766E"` — wins over pack |
| **Preset bundle** | Demo / onboarding | Set accent + `density` + `dark` together (Gallery Contoso buttons) |
| **Persist** | Settings survive restart | `ThemeAppearanceSettings { persist: true; prefsCategory: "MyAppTheme" }` |
| **Contrast gate** | Before ship | `Theme.contrastPassesAA(Theme.accent, Theme.bgCard)` light **and** dark |

### Accent packs (built-in)

| `accentPack` | Typical use |
|--------------|-------------|
| `blue` | Default Fluent |
| `purple` | Secondary product line |
| `green` | Success / eco branding |
| `orange` | Warm / utility accent |

Custom brand colors use **`Theme.customAccent`** — do not add new pack names in `Theme.qml`.

### ThemePrefs recipe (2.x apps)

```qml
import QWinUI3.Extras

StandardWindow {
    id: win
    geometryPersistenceKey: "MyAppMain"   // WindowGeometry — separate category

    property ThemePrefs themePrefs: ThemePrefs {
        category: "MyAppTheme"
        autoLoad: true
        autoSave: true
    }

    SettingsView {
        ThemeAppearanceSettings {
            persist: true
            prefsCategory: "MyAppTheme"
        }
    }
}
```

| Rule | Detail |
|------|--------|
| **Categories** | One `prefsCategory` per app — never share with `geometryPersistenceKey` |
| **Load order** | `ThemePrefs.load()` → `ThemeSync` on shell applies `followSystem*` over stored dark/motion |
| **Copy recipe** | `Theme.recipeText()` for one-shot bootstrap; `ThemePrefs` for user Settings |
| **Gallery** | Settings uses `persist: false` (session demo); **Theme prefs** page shows persist recipe |

Example: [`examples/gallery-shell`](../examples/gallery-shell/) (`GalleryShellTheme` category).

### Contrast + density integration

1. Pick accent (pack or `customAccent`) on **Theme overrides** — watch live AA table.  
2. Toggle **light/dark** — re-check `accent / bgCard` ([color-contrast.md](color-contrast.md)).  
3. Set **`Theme.density`** / **`uiScale`** — metrics change; **fonts stay fixed** ([density.md](density.md)).  
4. Persist when satisfied: `ThemeAppearanceSettings { persist: true }`.


---

## Out of scope (1.09 / 2.38)

- Fluent 2 / Style restyle of controls  
- Theme editor / editable token grid  
- Making `bg*` / `text*` writable override maps  
- New accent pack names in Theme.qml (use `customAccent`)  
- Automated WCAG certification (see color-contrast diagnostics instead)
- Fluent 2 token fork / Figma pipeline (**2.38** out)
