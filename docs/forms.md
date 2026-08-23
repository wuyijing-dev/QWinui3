# Forms & settings (1.08)

Short recipe for **validation** and **settings pages**. Prefer these patterns over inventing a parallel form engine.

| Surface | Use when | Gallery |
|---------|----------|---------|
| [`FormLayout`](components/FormLayout.md) + fields | Data-entry forms with `errorMessage` | Form validation |
| [`ValidationSummary`](components/ValidationSummary.md) | Page-level error list | Form validation |
| [`SettingsView`](components/SettingsView.md) / [`SettingsGroup`](components/SettingsGroup.md) | Settings page host + sections | SettingsGroup |
| [`SettingsCard`](components/SettingsCard.md) / Expander / Toggle/Combo/Slider cards | Preference rows | SettingsCard, SettingsExpander |

---

## Validation pattern

1. Put fields under `FormLayout` (`HeaderedTextBox`, `HeaderedComboBox`, `NumberBox`, `DatePicker` / `CalendarDatePicker` / `TimePicker`, `PasswordBox`, `RadioButtons`, `TokenizingTextBox`, …).
2. On submit, **set** each `field.errorMessage = "…"` (or `""`).
3. Call `form.validate()` — it **reads** non-empty `errorMessage` / `hasError` from descendants (`children` + `contentChildren`).
4. Bind `ValidationSummary { errors: form.errors }`.
5. `form.clearErrors()` clears the same tree including **`NumberBox.inputInvalid`** (**2.55**).
6. Async server checks: **`form.beginValidate()`** … **`form.endValidate()`**; disable submit while **`form.validating`** (**2.55**).
7. Collapsible groups: wrap fields in **`FormSection { title; expanded }`** (**2.67 D2**).
8. Conditional fields: set **`formFieldId`** on fields/sections and call **`form.setFieldVisible(id, bool)`**, or bind `visible:` directly.
7. After failed validate, call **`form.focusFirstError()`** (**2.55**).
8. Set `form.accessibleName` when multiple forms share a page (1.19).
9. **2.66:** set `form.fieldAppearance: "outline"` (or `"filled"`) and optional `form.readOnly` to push onto TextField / TextArea / ComboBox descendants — [appearance-variants.md](appearance-variants.md).

```qml
FormLayout {
    id: form
    accessibleName: qsTr("Account")
    fieldAppearance: "outline"
    ValidationSummary { errors: form.errors }
    HeaderedTextBox { id: name; header: qsTr("Name") }
    HeaderedComboBox { id: plan; header: qsTr("Plan"); model: […] }
    CalendarDatePicker { id: start; header: qsTr("Start date") }
    Button {
        text: qsTr("Save")
        onClicked: {
            form.clearErrors()
            if (!name.text.trim().length)
                name.errorMessage = qsTr("Required")
            if (plan.currentIndex < 0)
                plan.errorMessage = qsTr("Choose a plan")
            if (!start.selectedDate)
                start.errorMessage = qsTr("Pick a date")
            if (form.validate())
                /* commit */
        }
    }
}
```

**Notes**

- No built-in QValidator pipeline — apps own rules. See [forms-unlike-winui-255.md](forms-unlike-winui-255.md) (**2.55**).
- `NumberBox.inputInvalid` is cleared by `form.clearErrors()` as of **2.55** (was a common footgun).
- Date / calendar / time pickers expose `errorMessage` / `hasError` (1.28); choosing a value clears the error.
- Color pickers: wrap with `HeaderedContentControl` — see [pickers.md](pickers.md).
- Opt out of label push with `formBound: false`.
- Left headers: `fieldHeaderPlacement: "left"` + `labelWidth` (NumberBox / Headered* today).

Picker inventory + Gallery links: **[pickers.md](pickers.md) (1.28)**.

---

## Settings pattern

```qml
SettingsView {
    title: qsTr("Settings")
    SettingsGroup {
        title: qsTr("Account")
        SettingsCard { title: qsTr("Email"); description: "…" }
        SettingsExpander {
            header: qsTr("Privacy")   // alias of title
            toggle: true
            SettingsCard { title: qsTr("Diagnostics"); toggle: true }
        }
    }
}
```

| Topic | Behavior (1.08) |
|-------|-----------------|
| **Expander host** | Default children use an internal `ColumnLayout` — no manual wrapper required |
| **API parity** | `header` alias, `cornerRadius`, `contentSpacing` like cards |
| **Validation** | Settings rows are preferences, not FormLayout fields — keep forms separate |

Example apps: [`examples/settings-cards`](../examples/settings-cards/), [`examples/nav-settings`](../examples/nav-settings/), [`examples/form-settings`](../examples/form-settings/) (1.26 FormLayout + prefs; **1.65** `Settings` persistence).

**Persist toggles / portable Ini / schemaVersion:** [settings-persistence.md](settings-persistence.md) (**1.65**). Keep `geometryPersistenceKey` for window frames — do not mix into prefs categories.

---

## Industry templates (2.25)

Copy-ready Gallery LoB pages — not a separate form engine:

| Template | Page | Pattern |
|----------|------|---------|
| **Registration** | `FormRegistrationTemplatePage` | `FormLayout` + `ValidationSummary` + `PasswordBox` / `NumberBox` + `TokenizingTextBox` + `MultiSelectComboBox` |
| **Admin CRUD** | `FormAdminCrudTemplatePage` | `DataTable` selection → `FormLayout` editor (save / new) |
| **Preferences** | `SettingsPreferencesTemplatePage` | `SettingsView` + `SettingsCard` / `SettingsExpander` + token / multi-select rows |

Hub: Gallery **Forms & settings** opens all three. **`MultiSelectComboBox`** gained `errorMessage` / `hasError` / `formBound` for FormLayout parity (**2.25**). Pair pickers with [pickers.md](pickers.md).

---

## Out of scope

Reactive validators, focus-first-error helpers, SettingsCard `errorMessage`, brand theme editor (→ 1.09), token renames.
