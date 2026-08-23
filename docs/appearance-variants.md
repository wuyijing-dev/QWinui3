# Appearance variants (2.66)

Cookbook for **A1** button appearances and **A2** input appearances. Theme-token driven; no parallel style forks.

Related: [forms.md](forms.md) · [pointer-feedback.md](pointer-feedback.md) · [data-collections.md](data-collections.md)

---

## A1 — Button family

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

## A2 — Inputs + FormLayout

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

## DataTable pro grid (C1 / D1)

| API | Role |
|-----|------|
| `sortSpecs: [{ column, order }, …]` | Multi-column sort (Shift+click header) |
| `hiddenColumns: [index, …]` / `setColumnVisible(i, bool)` | Column visibility |
| `columnWidths: [w, …]` | Persist widths (Settings); updates on resize release |
| `fixedRowHeight` / `rowHeight` | C1 virtualizing fast path (`ListView` + `reuseItems`) |
| `maxFilterResults` | Cap JS filter walk for 10k+ arrays |

Gallery **DataTable** demos the chooser, multi-sort, and a 10k load path.

**Out of 2.66:** million-row GPU grid; per-locale masked-input engine.
