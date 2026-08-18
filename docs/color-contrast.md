# Color, contrast & theme diagnostics (1.43 · 2.38 refresh)

Is this accent OK on light/dark cards? Prefer Theme tokens + a quick **contrast ratio** check—not a WCAG certification product.

| Tool | Role |
|------|------|
| `Theme.contrastRatio(fg, bg)` | WCAG 2.x ratio (≥ 1) |
| `Theme.contrastPassesAA(fg, bg, largeText?)` | AA gate: **4.5:1** body / **3:1** large |
| `Theme.relativeLuminance(c)` | 0…1 luminance |
| `Theme.accentContrastRatio(surface?)` | `accent` vs `bgCard` (or given surface) |
| `Theme.highContrast` | Stronger borders / focus — [accessibility.md](accessibility.md) |
| Branding knobs | [theme-overrides.md](theme-overrides.md) (**2.38** wave 2) |

Gallery: **Theme overrides** (live AA table + accent packs) · **Theme prefs** (persist recipe) · **Accessibility** (high contrast) · Settings → **ThemeAppearanceSettings**.

Related: [compatibility-1xx.md](compatibility-1xx.md) (frozen token names) · [density.md](density.md).

---

## Branding wave 2 workflow (2.38)

Use with [theme-overrides.md](theme-overrides.md) **Branding wave 2**:

1. Apply **`Theme.setAccentPack(...)`** or **`Theme.customAccent`**.  
2. Open **Theme overrides** → Contrast diagnostics — confirm **accent / bgCard** passes AA in **light and dark**.  
3. Adjust density on the same page — typography pairs unchanged ([density.md](density.md)).  
4. Persist via **`ThemeAppearanceSettings { persist: true }`** when branding is approved.

Named packs (`blue` / `purple` / `green` / `orange`) and custom hex share the same contrast helpers.

---

## Quick targets (AA)

| Pair | Target | Typical Theme pair |
|------|--------|---------------------|
| Body text on surface | **≥ 4.5:1** | `textPrimary` / `bgCard`, `textSecondary` / `bgLayer` |
| Large title / bold ≥ ~18px | **≥ 3:1** | `textPrimary` / `bgCard` |
| Accent label on card | **≥ 4.5:1** (or 3:1 if large) | `accent` / `bgCard` |
| Text on accent fill | **≥ 4.5:1** | `textOnAccent` / `accent` |
| Disabled | Often fails AA — don’t rely on color alone | `textDisabled` |

These are **guidance** for LoB branding. Passing `contrastPassesAA` does not certify the whole app.

---

## Recipe — check a brand accent

```qml
import QWinUI3.Theme

Component.onCompleted: {
    Theme.customAccent = "#0F766E"
    var r = Theme.contrastRatio(Theme.accent, Theme.bgCard)
    var ok = Theme.contrastPassesAA(Theme.accent, Theme.bgCard)
    console.log("accent on bgCard:", r.toFixed(2), ok ? "AA" : "fail AA")
}
```

| If it fails | Do |
|-------------|----|
| Accent too light on light card | Darken `customAccent`, or put accent text only on `bgLayer` / dark chrome |
| Accent too dark on dark card | Lighten accent, or use `accentLight1` for labels |
| Secondary text weak | Prefer `textSecondary` tokens — don’t invent gray hex |
| Only accent encodes meaning | Add icon / text — color is not enough |

Always re-check after toggling `Theme.dark`.

---

## Stock token pairs (sanity)

Run mentally (or Gallery diagnostics) after branding:

| Foreground | Background |
|------------|------------|
| `textPrimary` | `bgCard` / `bgLayer` |
| `textSecondary` | `bgCard` / `bgLayer` |
| `textOnAccent` | `accent` |
| `accent` | `bgCard` |

Do **not** assign `Theme.bgCard = …` — [theme-overrides.md](theme-overrides.md). Change `customAccent` / packs / `dark` only.

---

## High contrast

| Knob | Effect |
|------|--------|
| `Theme.highContrast` | Thicker focus (`strokeFocusOuter`), stronger caption borders |
| `Theme.followSystemAccessibility` | Mirror OS high-contrast / reduced motion via `WindowHelper` |
| Gallery Settings | Follow system or override |

High contrast is **orthogonal** to AA ratios: enable it for OS themes; still prefer token pairs for brand colors.

---

## Gallery path (1.43 / 2.38)

1. Open **Theme overrides** → Contrast diagnostics table (live ratios + AA pass/fail).  
2. Change Contoso presets / accent packs / custom accent / light↔dark — watch accent-on-card.  
3. **Theme prefs** → copy `Theme.recipeText()` or enable `ThemePrefs` persist recipe.  
4. Open **Accessibility** → High contrast toggle (when not following system).  
5. Settings → **ThemeAppearanceSettings** for kit-wide knobs (Gallery session; your app sets `persist: true`).

---

## Checklist

- [ ] Brand uses `customAccent` or packs — not hard-coded control fills  
- [ ] `contrastPassesAA(accent, bgCard)` in both light and dark  
- [ ] Body copy uses `textPrimary` / `textSecondary`  
- [ ] `textOnAccent` on accent buttons  
- [ ] High-contrast path tested (Settings or OS)  
- [ ] Don’t claim WCAG certification from this helper alone  

**Out of scope:** Automated site-wide audits, AAA productization, editable token grids.
