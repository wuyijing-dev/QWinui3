# Appearance variants (2.66–2.67)

Cookbook for button / input / list / card surface variants. Theme-token driven; no parallel style forks.

Related: [forms.md](forms.md) · [pointer-feedback.md](pointer-feedback.md) · [data-collections.md](data-collections.md)

---

## A1 — Button family (2.66)

| Control | Property | Values | Default |
|---------|----------|--------|---------|
| **Button** | `appearance` | `filled` · `subtle` · `outline` · `ghost` | `filled` (or `subtle` when `flat`) |
| **AccentButton** | `appearance` | same | `filled` (solid accent) |
| **HyperlinkButton** | `appearance` | `ghost` · `subtle` · `outline` · `filled` | `ghost` (classic link) |

```qml
Button { text: qsTr("Save"); appearance: "filled" }
Button { text: qsTr("Cancel"); appearance: "subtle" }
AccentButton { text: qsTr("Primary"); appearance: "outline" }
HyperlinkButton { text: qsTr("Docs"); appearance: "ghost"; navigateUri: "…" }
```

Legacy: `Button.flat` maps to **subtle** when `appearance` is empty; `highlighted` keeps accent chrome on Style **Button**.

---

## A2 — Inputs + FormLayout (2.66)

| Control | Property | Values | Notes |
|---------|----------|--------|-------|
| **TextField** / **TextArea** | `appearance` | `filled` · `outline` | `hasError` critical stroke + shake |
| **ComboBox** | `appearance` | `filled` · `outline` | same `hasError` contract |
| **FormLayout** | `fieldAppearance` | pushed to descendants | also `readOnly` → field `readOnly` |

```qml
FormLayout {
    fieldAppearance: "outline"
    readOnly: false
    HeaderedTextBox { header: qsTr("Name") }
    TextField { appearance: "outline"; hasError: nameBad }
    ComboBox { appearance: "outline"; model: plans }
}
```

Validation still uses `errorMessage` / `hasError` + `form.validate()` — [forms.md](forms.md).

---

## A3 — ListTile density + leading presets (2.67)

| Property | Values | Notes |
|----------|--------|-------|
| `density` | `compact` · `normal` · `spacious` · `""` | Empty follows `Theme.density` |
| `tileDensity` | alias of `density` | Compat |
| `leadingPreset` | `icon` · `avatar` · `checkbox` · `none` | Custom `leading:` wins |
| `avatarName` / `avatarSource` | string / url | When `leadingPreset: "avatar"` |

```qml
ListTile {
    title: qsTr("Jordan")
    density: "compact"
    leadingPreset: "avatar"
    avatarName: qsTr("Jordan Lee")
}
ListTile {
    title: qsTr("Select me")
    leadingPreset: "checkbox"
    checkable: true
}
```

---

## A4 — Card / banner surfaces (2.67)

| Control | Property | Values | Notes |
|---------|----------|--------|-------|
| **SettingsCard** | `appearance` | `filled` · `elevated` · `outline` · `accent` | Default `filled` |
| **ChartCard** | `appearance` | same | Empty falls back to `elevated` bool |
| **InfoBar** | `appearance` | same | Layers on severity colors |

```qml
SettingsCard { title: qsTr("Quiet hours"); appearance: "elevated"; toggle: true }
ChartCard { title: qsTr("Revenue"); appearance: "outline"; LineChart { … } }
InfoBar { severity: warning; appearance: "outline"; title: qsTr("Check billing") }
```

---

## Motion tokens (2.67 B1)

Prefer nested tokens:

```qml
Behavior on opacity {
    NumberAnimation {
        duration: Theme.motion.ms("fast")
        easing.type: Theme.motion.easing("enter")
    }
}
```

Aliases: `Theme.motion.durationFast/Normal/Slow`, `Theme.motionMs` / `Theme.motionEasing`.

Lists: **ItemsView** / **DataTable** / **ListDetailsView** expose `itemEnter` / `itemExit` (`none` · `fade` · `slide`); honor `Theme.reducedMotion`.

---

## DataTable pro grid (C1 / D1 — 2.66)

| API | Role |
|-----|------|
| `sortSpecs: [{ column, order }, …]` | Multi-column sort (Shift+click header) |
| `hiddenColumns: [index, …]` / `setColumnVisible(i, bool)` | Column visibility |
| `columnWidths: [w, …]` | Persist widths (Settings); updates on resize release |
| `fixedRowHeight` / `rowHeight` | C1 virtualizing fast path (`ListView` + `reuseItems`) |
| `maxFilterResults` | Cap JS filter walk for 10k+ arrays |

Gallery **DataTable** demos the chooser, multi-sort, and a 10k load path.

**Out of 2.66/2.67:** million-row GPU grid; per-locale masked-input engine.
