# Theme

Fluent color / type / motion token singleton.

`import QWinUI3.Theme` · [`src/theme/QWinUI3/Theme/Theme.qml`](../../src/theme/QWinUI3/Theme/Theme.qml)

[← Component index](../components.md)

## Usage

```qml
Theme.dark = true
Theme.followSystemAccessibility = true
```

## Properties

- `dark: bool` — Dark color scheme when true
- `reducedMotion: bool` — Collapse Theme.duration() animations when true
- `highContrast: bool` — When true, strengthen borders/focus for high-contrast / accessibility themes.
- `followSystemAccessibility: bool` — When true, Gallery/apps should copy WindowHelper system a11y into the flags above.
- `accent: color` — Fluent / WinUI 3 system accent (matches FluentWinUI3 defaults)
- `accentLight1: color` — Lighter accent step
- `accentDark1: color` — Darker accent step
- `textPrimary: color` — Primary text brush
- `textSecondary: color` — Secondary text brush
- `textDisabled: color` — Disabled text brush
- `textOnAccent: color` — Text on accent fill
- `textOnAccentSecondary: color` — Secondary text on accent fill
- `fillControl: color` — Control fills — WinUI ControlFillColor*
- `fillControlSecondary: color` — Control fill (hover)
- `fillControlTertiary: color` — Control fill (pressed)
- `fillControlDisabled: color` — Control fill (disabled)
- `fillAccent: color` — Accent fill (rest) — same as accent brush
- `fillAccentSecondary: color` — Accent fill (hover)
- `fillAccentTertiary: color` — Accent fill (pressed)
- `fillSubtle: color` — Subtle hover/press wash
- `fillSubtleSecondary: color` — Subtle secondary wash
- `fillSubtleTertiary: color` — Subtle tertiary wash
- `strokeControl: color` — Strokes — ControlStrokeColor*
- `strokeControlStrong: color` — Strong control border
- `strokeControlOnAccent: color` — Stroke on accent-filled controls
- `focusOuter: color` — Focus ring outer color
- `focusInner: color` — Focus ring inner color
- `strokeCard: color` — Card border stroke
- `strokeDivider: color` — Divider stroke
- `bgLayer: color` — Layer / solid backgrounds — LayerFill / SolidBackground
- `bgLayerAlt: color` — Alternate layer (zebra / secondary surface)
- `bgSolid: color` — Opaque solid window fill (no acrylic/mica)
- `bgCard: color` — Card surface background
- `bgCardElevated: color` — Elevated card (dialog / flyout surface)
- `bgSmoke: color` — Modal smoke / light-dismiss scrim
- `bgAcrylic: color` — Acrylic / chrome background
- `bgMica: color` — Mica base fill under system backdrop
- `systemAttention: color` — Attention / info color
- `systemSuccess: color` — Success status color
- `systemCaution: color` — Warning / caution color

## Methods

- `duration(ms)` — Returns ms, or 1 when reducedMotion is on
- `controlFill(hovered, pressed, disabled)` — Rest/hover/pressed/disabled control fill helper
- `accentFill(hovered, pressed, disabled)` — Rest/hover/pressed/disabled accent fill helper

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
