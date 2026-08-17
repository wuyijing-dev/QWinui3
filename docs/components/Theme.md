# Theme

Fluent color / type / motion token singleton.

`import QWinUI3.Theme` · [`src/theme/QWinUI3/Theme/Theme.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/theme/QWinUI3/Theme/Theme.qml)

**Category:** Theme · **Library:** v2.54

[← Component index](../components.md)

**Extends** `QtObject`.

## Example

```qml
import QWinUI3.Theme

Theme.dark = true
Theme.reducedMotion = false
Theme.followSystemAccessibility = true
Theme.density = "compact"
Theme.uiScale = 1.0
Theme.devicePixelRatio = Screen.devicePixelRatio
Theme.accentPack = "purple"
Theme.customAccent = "#C239B3"

Rectangle {
    color: Theme.bgCard
    radius: Theme.cornerControl
    border.width: Theme.strokeHairline
    Behavior on color {
        ColorAnimation { duration: Theme.duration(Theme.motionNormal) }
    }
}
// --- API ---
Theme.duration(ms)
Theme.dp(value) / Theme.hairline(dpr)
Theme.controlFill(hovered, pressed, disabled)
Theme.accentFill(hovered, pressed, disabled)
Theme.setAccentPack(name)
Theme.snapshot() / Theme.apply(obj) / Theme.recipeText()  // 1.69
Theme.relativeLuminance(c) / Theme.contrastRatio(fg, bg) / Theme.contrastPassesAA(…)  // 1.43
```

## Notes

Singleton tokens: colors, type, spacing, motion, corners, density, accent packs.
Theme.dark / reducedMotion / highContrast; followSystem* mirrored by ThemeSync (shells, not Gallery-only).
snapshot/apply/recipeText copy knobs into any app; OS follow is ThemeSync.applyFromSystem().
density "standard"|"compact" scales controlHeight / padding / spacing.
devicePixelRatio + uiScale: hairline strokes and optional extra UI scale (ShellWindow syncs DPR).
accentPack "blue"|"purple"|"green"|"orange"; customAccent (alpha>0) overrides pack.
Branding: set knobs only — do not assign readonly bg*/text* or fork Style (docs/theme-overrides.md).
Contrast diagnostics: docs/color-contrast.md (1.43) — AA guidance, not a certification product.
Use Theme.duration(ms) and controlFill/accentFill helpers for states.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `dark` | `bool` | Dark color scheme when true |
| `reducedMotion` | `bool` | Collapse Theme.duration() animations when true |
| `highContrast` | `bool` | When true, strengthen borders/focus for high-contrast / accessibility themes. |
| `followSystemAccessibility` | `bool` | When true, ThemeSync copies WindowHelper system a11y into reducedMotion / highContrast. |
| `followSystemColorScheme` | `bool` | When true, ThemeSync mirrors WindowHelper.systemPrefersDark into Theme.dark. |
| `density` | `string` | Control density: "standard" \| "compact" |
| `uiScale` | `real` | Extra UI scale on top of system DPR (1.0 = follow OS only). Qt layout is already in DIPs. |
| `devicePixelRatio` | `real` | Last synced window/screen devicePixelRatio (ShellWindow / StandardWindow update this). |
| `accentPack` | `string` | Named accent pack: "blue" \| "purple" \| "green" \| "orange" |
| `customAccent` | `color` | When alpha > 0, overrides accentPack colors |
| `accent` | `color` | Fluent / WinUI 3 system accent (pack or customAccent) |
| `accentLight1` | `color` | Lighter accent step |
| `accentDark1` | `color` | Darker accent step |
| `textPrimary` | `color` | Primary text brush |
| `textSecondary` | `color` | Secondary text brush |
| `textDisabled` | `color` | Disabled text brush |
| `textOnAccent` | `color` | Text on accent fill |
| `textOnAccentSecondary` | `color` | Secondary text on accent fill |
| `fillControl` | `color` | Control fills — WinUI ControlFillColor* |
| `fillControlSecondary` | `color` | Control fill (hover) |
| `fillControlTertiary` | `color` | Control fill (pressed) |
| `fillControlDisabled` | `color` | Control fill (disabled) |
| `bgControlRest` | `color` | Opaque rest fill for bordered inputs (2.17 — Style token audit) |
| `fillSliderThumb` | `color` | Slider / range thumb rest fill (2.17) |
| `fillAccent` | `color` | Accent fill (rest) — same as accent brush |
| `fillAccentSecondary` | `color` | Accent fill (hover) |
| `fillAccentTertiary` | `color` | Accent fill (pressed) |
| `fillSubtle` | `color` | Subtle hover/press wash |
| `fillSubtleSecondary` | `color` | Subtle secondary wash |
| `fillSubtleTertiary` | `color` | Subtle tertiary wash |
| `strokeControl` | `color` | Strokes — ControlStrokeColor* |
| `strokeControlStrong` | `color` | Strong control border |
| `strokeControlOnAccent` | `color` | Stroke on accent-filled controls |
| `focusOuter` | `color` | Focus ring outer color |
| `focusInner` | `color` | Focus ring inner color |
| `strokeCard` | `color` | Card border stroke |
| `strokeDivider` | `color` | Divider stroke |
| `bgLayer` | `color` | Layer / solid backgrounds — LayerFill / SolidBackground |
| `bgLayerAlt` | `color` | Alternate layer (zebra / secondary surface) |
| `bgSolid` | `color` | Opaque solid window fill (no acrylic/mica) |
| `bgCard` | `color` | Card surface background |
| `bgCardElevated` | `color` | Elevated card (dialog / flyout surface) |
| `bgSmoke` | `color` | Modal smoke / light-dismiss scrim |
| `bgAcrylic` | `color` | Acrylic / chrome background |
| `bgMica` | `color` | Mica base fill under system backdrop |
| `systemAttention` | `color` | Attention / info color |
| `systemSuccess` | `color` | Success status color |
| `systemCaution` | `color` | Warning / caution color |
| `systemCritical` | `color` | Error / critical color |
| `systemAttentionBg` | `color` | Attention banner background |
| `systemSuccessBg` | `color` | Success banner background |
| `systemCautionBg` | `color` | Caution banner background |
| `systemCriticalBg` | `color` | Critical banner background |
| `fontFamily` | `string` | Typography — Segoe UI Variable / WinUI type ramp |
| `fontFamilyText` | `string` | Segoe UI Variable Text face |
| `fontFamilyDisplay` | `string` | Segoe UI Variable Display face (large titles) |
| `fontFamilyIcon` | `string` | Fluent Icons — system Segoe on Windows when present, else embedded WinSymbols3 ("Symbols") |
| `iconFontFamily` | `string` | Alias used by a few tiles |
| `fontCaption` | `int` | Caption font size (12) |
| `fontBody` | `int` | Body font size (14) |
| `fontBodyLarge` | `int` | Body Large font size (18) |
| `fontSubtitle` | `int` | Subtitle font size (20) |
| `fontTitle` | `int` | Title font size (28) |
| `fontTitleLarge` | `int` | Title Large font size (40) |
| `fontWeightRegular` | `int` | Regular / normal font weight |
| `fontWeightSemiBold` | `int` | Semi-bold weight |
| `motionFast` | `int` | Fast motion duration (ms) |
| `motionNormal` | `int` | Normal motion duration (ms) |
| `motionSlow` | `int` | Slow motion duration (ms) |
| `motionFlyout` | `int` | Flyout / popup enter duration (ms) |
| `easingEnter` | `int` | Enter easing curve |
| `easingExit` | `int` | Exit easing curve |
| `easingStandard` | `int` | Standard easing curve |
| `easingEmphasized` | `int` | Emphasized easing (slight overshoot) |
| `cornerControl` | `real` | — |
| `cornerOverlay` | `real` | Overlay / flyout corner radius |
| `strokeThin` | `real` | Default 1px design stroke (scales with Qt DIP) |
| `strokeHairline` | `real` | True 1-device-pixel hairline (set Theme.devicePixelRatio from the window screen) |
| `strokeFocusOuter` | `real` | Focus ring outer width |
| `strokeFocusInner` | `real` | Focus ring inner width |
| `controlHeight` | `real` | Default control height |
| `controlMinWidth` | `real` | Minimum control width |
| `searchBoxHeight` | `real` | SearchBox height |
| `navItemHeight` | `real` | Navigation item row height |
| `navPaneWidth` | `real` | Expanded NavigationView pane width |
| `navPaneCompactWidth` | `real` | Compact NavigationView pane width |
| `paddingControlH` | `real` | Horizontal control padding |
| `paddingControlV` | `real` | Vertical control padding |
| `spacing` | `real` | Child spacing |
| `spacingLoose` | `real` | Loose spacing |
| `spacingSection` | `real` | Section spacing |
| `cornerCard` | `real` | Card corner radius |
| `switchWidth` | `real` | Switch track width |
| `switchHeight` | `real` | Switch track height |
| `switchThumb` | `real` | Switch thumb diameter |
| `checkSize` | `real` | CheckBox box size |
| `radioSize` | `real` | RadioButton outer size |
| `sliderThickness` | `real` | Slider track thickness |
| `sliderThumb` | `real` | Slider thumb diameter |
| `recipeSnippet` | `string` | Binding-friendly; CopyButton.textToCopy can track this. |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `duration(ms)` | Returns ms, or 1 when reducedMotion is on |
| `dp(value)` | Density-aware design pixels (Qt layout units are already DPI-independent). |
| `hairline(dpr)` | 1 physical pixel in logical units for the given DPR (defaults to Theme.devicePixelRatio). |
| `setAccentPack(name)` | Apply a named accent pack and clear customAccent |
| `snapshot()` | Writable knobs only (1.69) — paste into another process via recipeText(), or apply() in-process. |
| `apply(obj)` | — |
| `recipeText()` | QML snippet for Component.onCompleted — Gallery Copy is a convenience, not a privilege. |
| `controlFill(hovered, pressed, disabled)` | Rest/hover/pressed/disabled control fill helper |
| `borderedControlFill(hovered, pressed, disabled)` | Bordered Button / ComboBox / TextField rest states (2.17) |
| `accentFill(hovered, pressed, disabled)` | Rest/hover/pressed/disabled accent fill helper |
| `relativeLuminance(colorValue)` | Relative luminance 0…1 (WCAG 2.x) for a Qt color / "#RRGGBB" |
| `contrastRatio(fg, bg)` | Contrast ratio ≥ 1 (WCAG). Order of fg/bg does not matter. |
| `contrastPassesAA(fg, bg, largeText)` | WCAG AA: 4.5:1 normal text, 3:1 large text (≥18pt / 14pt bold ≈ Theme.fontBodyLarge+) |
| `accentContrastRatio(surface)` | Convenience: accent on a surface (default bgCard) |

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
