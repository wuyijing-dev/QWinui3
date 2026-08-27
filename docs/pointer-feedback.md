# Pointer feedback (2.66 baseline · 3.11 Style deepen)

Micro-interaction recipes for press, hover, focus, and cursor affordances on Style + Extras controls. Roadmap IDs **M1–M8** (pointer) and **I1–I4** (icon micro) baseline shipped in **2.66**; **3.11** deepens stock **Style** primitives (`ToolButton`, `RoundButton`, `Slider`, `ProgressBar`, `ItemDelegate`) and gates idle `Behavior` bindings for performance.

See also: [animations.md](animations.md) · [icons.md](icons.md) · [accessibility.md](accessibility.md)

## Theme helpers (2.66+)

| API | Purpose |
|-----|---------|
| `Theme.iconOpticalOffset(fontSize)` | Optical nudge per size band (I1) |
| `Theme.iconDisabledOpacity` | Unified disabled glyph fade (I2) |
| `Theme.iconColor(base, selected, hovered, enabled)` | Selected/accent icon color (I3) |
| `Theme.iconShouldMirror(glyphOrName)` | RTL directional glyphs (I9) |
| `Theme.motionMs("fast" \| "normal" \| "slow" \| "flyout")` | Named motion durations (B1) |
| `Theme.motionEasing("standard" \| "enter" \| "exit" \| "emphasized")` | Named easing (B1) |
| `FocusStroke` | Dual-ring keyboard focus; 2px double in `Theme.highContrast` (M7) |
| `PointerCursor` | `HoverHandler` wrapper — templates lack root `cursorShape` (M8) |

All `Behavior` animations must gate on `!Theme.reducedMotion` (or use `Theme.duration()` which snaps to 1 ms).

## Control checklist (M1–M8)

| ID | Control | Feedback |
|----|---------|----------|
| **M1** | `Button` | `appearance`: filled / subtle / outline / ghost; press `scale` 0.98; `Qt.PointingHandCursor` |
| **M1** | `ToolButton` / `RoundButton` | `appearance` variants; circular press scale; `RoundButton.loading` inline busy (3.11) |
| **M2** | `HyperlinkButton` | Underline on hover; pressed opacity 0.8 |
| **M3** | `TextField` / `TextArea` | `appearance: filled \| outline`; `hasError` shake |
| **M4** | `ComboBox` | Chevron flip on open; selected tick fade-in (Style uses Text glyph; Extras use FontIcon) |
| **M9** | `ListTile` | Row press highlight; compact density; **FontIcon** leading/chevron |
| **M10** | `SettingsCard` | Interactive hover fill + elevation bump |
| **M11** | `IconButton` / `RoundButton` | Circular press; min 40×40; `loading` + **ProgressRing** |
| **M12** | `SplitButton` | Independent primary/chevron press scale; chevron **FontIcon** |
| **M16** | `Slider` | Thumb scale 1→1.12 on hover; optional `tickMarksVisible` + `stepSize` ticks (3.11) |
| **M15** | `Pivot` / `TabButton` | Shared underline slides on `x`/`width`; tab press scale |
| **M26** | `ProgressBar` | Determinate completion opacity flash; indeterminate sweep honors `showPaused` / reducedMotion (3.11) |
| **M17** | `Switch` | Thumb travel ease-out; check glyph fade on (I15) |
| **M13** | `NavigationView` | Pane width tweens compact/0→expanded through intermediates; labels fade with progress |
| **M14** | `TabView` | Shared underline width/opacity slide; close circular hover (I14); selected tab icon accent |
| **M18** | `BreadcrumbBar` | Crumb/ellipsis hover underline; hand cursor; overflow item press scale; separator RTL |
| **M5** | `CheckBox` / `RadioButton` | Check/dot scale-in; unchecked hover border → accent |
| **M6** | `SpinBox` | Independent up/down hover + press scale on repeat buttons |
| **M7** | `FocusStroke` | Opacity + scale enter; HC 2px outer/inner rings |
| **M8** | Cursors | Hand on clickables; I-beam on editable fields — via `PointerCursor` (`HoverHandler`) |

## Icon micro (I1–I15)

Use **`FontIcon`** (Extras) or `Theme.icon*` helpers on inline glyphs:

- **I1** — set `iconContext` or rely on auto offset from `fontSize`
- **I2** — disabled hosts use `Theme.iconDisabledOpacity`
- **I3** — `selected: true` or `Theme.iconColor(...)` with color `Behavior` (keeps `textOnAccent` on accent chrome)
- **I4** — `chevronRotation: expanded ? 180 : 0` on `FontIcon` (SettingsExpander, ComboBox chevron)
- **I5** — `IconButton.loading` → ProgressRing
- **I6** — `InfoBadge` pulse when `value` increases
- **I8** — `AnimatedIcon` dual-glyph cross-fade (~120ms)
- **I9** — `Theme.iconShouldMirror` + `FontIcon.autoMirror` / `effectiveMirror` (RTL chevrons/back)
- **I10** — `CaptionButton` glyph opacity dip on press
- **I11** — `TextField.leadingSymbol` + 32×32 clear hit pad
- **I13** — deferred (selected icon pill removed — row highlight + accent glyph is enough)
- **I14** — `TabView` close button circular hover fill
- **I15** — `Switch` thumb check glyph fade on

## Gallery verification

Exercise NavigationView, Pivot, TabView, and BreadcrumbBar pages under dark/light, reduced motion, and high contrast. Full sign-off remains **M28**.

```bat
python scripts/smoke_gallery.py --smoke
```

Toggle **Theme overrides**: dark/light, accent, density, **reduced motion**, **high contrast**.
