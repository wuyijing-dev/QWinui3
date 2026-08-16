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
5. `form.clearErrors()` clears the same tree (parity with gather as of 1.08).
6. Set `form.accessibleName` when multiple forms share a page (1.19).

```qml
FormLayout {
    id: form
    accessibleName: qsTr("Account")
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

- No built-in QValidator pipeline — apps own rules.
- `NumberBox.inputInvalid` can keep `hasError` after `clearErrors()` until input is fixed.
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

Example apps: [`examples/settings-cards`](../examples/settings-cards/), [`examples/nav-settings`](../examples/nav-settings/), [`examples/form-settings`](../examples/form-settings/) (1.26 FormLayout + prefs).

---

## Out of scope

Reactive validators, focus-first-error helpers, SettingsCard `errorMessage`, brand theme editor (→ 1.09), token renames.
