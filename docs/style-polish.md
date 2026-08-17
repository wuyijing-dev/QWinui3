# Style polish & WinUI 3 chrome (2.17)

Wave-2 audit on the existing **`QWinUI3` Style** module (Qt Quick Controls templates under `src/style/`). **No** Fluent 2 fork — branding stays on writable **Theme** knobs ([theme-overrides.md](theme-overrides.md)).

Gallery: **Style spot-check** · **Theme overrides** · stock control pages (Button, TextField, …).

Related: [theme-overrides.md](theme-overrides.md) · [density.md](density.md) · [color-contrast.md](color-contrast.md) · [performance.md](performance.md) (Style hot path, 1.89).

---

## Principle

| Do | Don't |
|----|-------|
| Style reads **Theme** tokens / helpers | Fork Style for brand colors |
| Use `borderedControlFill` / `bgControlRest` for rest states | Duplicate `#FFFFFF` / `#0FFFFFFF` hex in every control |
| Spot-check light / dark / accent on Gallery | Ship a second Style import |

---

## Control-fill token map (2.17)

| Token / helper | WinUI role | Used by |
|----------------|------------|---------|
| `Theme.fillControlDisabled` | ControlFillColorDisabled | Button, ComboBox, TextField, CheckBox, … |
| `Theme.fillControlSecondary` | ControlFillColorSecondary (hover) | Inputs, bordered controls |
| `Theme.fillControlTertiary` | ControlFillColorTertiary (pressed) | Button, ComboBox, indicators |
| `Theme.bgControlRest` | Opaque rest (`bgCard` light / `fillControl` dark) | TextField, TextArea, SpinBox, CheckBox unchecked |
| `Theme.borderedControlFill(h, p, d)` | Rest + hover + press + disabled | **Button**, **ComboBox** |
| `Theme.fillSliderThumb` | Slider / RangeSlider thumb rest | **Slider**, **RangeSlider** |
| `Theme.controlFill(h, p, d)` | Subtle translucent fills | Legacy paths, menus |
| `Theme.accentFill(h, p, d)` | Accent fills | Highlighted buttons, toggles |

Stroke: `Theme.strokeControl` / `strokeControlStrong`. Focus: `FocusStroke` + `Theme.focusOuter`.

---

## Style module audit (2.17)

**Token migration (shipped)**

| Control | Change |
|---------|--------|
| **Button** | `borderedControlFill`; flat uses `fillSubtle*` |
| **ComboBox** | `borderedControlFill` |
| **TextField** / **TextArea** / **SpinBox** | `bgControlRest` + `fillControlSecondary` / disabled |
| **CheckBox** / **RadioButton** | Unchecked rest → `bgControlRest` |
| **Slider** / **RangeSlider** | Thumb → `fillSliderThumb` |
| **RoundButton** / **DelayButton** | Rest → `bgControlRest` |

**Still intentional hex** — accent tint via `Qt.tint(Theme.accent, …)`, disabled accent wash (`#28FFFFFF` / `#37000000`), check/radio glyph on accent (`Theme.textOnAccent`).


---

## Gallery spot-check recipe

1. Open **Style spot-check** — stock Style controls in one column.
2. Open **Theme overrides** — toggle light/dark, accent pack, density.
3. Confirm rest/hover/pressed/disabled fills stay consistent across Button ↔ ComboBox ↔ TextField.
4. Tab through controls — `FocusStroke` visible on keyboard focus.
5. Enable **High contrast** (Settings / Accessibility) — borders strengthen via Theme tokens.

Checklist on Gallery page mirrors this flow.

---

## App author guidance

```qml
import QWinUI3.Theme

// Branding — never edit Style/
Theme.customAccent = "#0F766E"
Theme.density = "compact"
```

Custom controls in app code should call `Theme.borderedControlFill` / `bgControlRest` rather than copying WinUI hex from Button.qml.

---

## Out of scope (2.17)

Fluent 2 visual redesign; editable readonly color tokens; automated pixel diff vs WinUI reference binaries.
