# Input & pickers (1.28)

High-traffic **date / time / number / color** pickers. Prefer these Extras types over inventing parallel flyouts. Pair with [forms.md](forms.md) when the field participates in `FormLayout.validate()`.

Gallery: **NumberBox** · **DatePicker** · **CalendarDatePicker** · **`CalendarView`** · **TimePicker** · **ColorPicker** · **ColorPickerButton** · **Form validation**.

Style only supplies calendar chrome (`MonthGrid` / `DayOfWeekRow`) — not a second date API.

---

## Inventory

| Control | Use when | Header | `errorMessage` / `hasError` | Density |
|---------|----------|--------|-----------------------------|---------|
| [`NumberBox`](components/NumberBox.md) | Numeric spin / edit | yes + `description` + left/`formBound` | yes (+ `inputInvalid`) | `Theme.controlHeight` |
| [`DatePicker`](components/DatePicker.md) | Y/M/D tumblers | yes + `description` | **yes (1.28)** | `Theme.controlHeight` |
| [`CalendarDatePicker`](components/CalendarDatePicker.md) | Field + MonthGrid flyout | yes + `description` | **yes (1.28)** | `Theme.controlHeight` |
| [`CalendarView`](components/CalendarView.md) | Always-visible month grid | — | — | grid intrinsic |
| [`TimePicker`](components/TimePicker.md) | Hour / minute tumblers | yes + `description` | **yes (1.28)** | `Theme.controlHeight` |
| [`ColorPicker`](components/ColorPicker.md) | Full spectrum panel | — | — | Theme strokes / fonts |
| [`ColorPickerButton`](components/ColorPickerButton.md) | Swatch that opens ColorPicker | — | — | `Theme.controlHeight` |

---

## Choosing

| Need | Prefer |
|------|--------|
| Quantity / seats / age | **NumberBox** |
| Compact date entry | **DatePicker** (tumblers) |
| Calendar browsing in a form field | **CalendarDatePicker** |
| Full-month schedule / booking grid | **`CalendarView`** (2.31, experimental) |
| Arrival / schedule time | **TimePicker** |
| Accent / brand color | **ColorPickerButton** (or embed **ColorPicker**) |

---

## FormLayout pairing

```qml
FormLayout {
    id: form
    ValidationSummary { errors: form.errors }

    NumberBox { id: seats; header: qsTr("Seats"); minimum: 1; maximum: 50 }
    CalendarDatePicker {
        id: start
        header: qsTr("Start date")
        description: qsTr("Required for the booking.")
    }
    TimePicker { id: arrival; header: qsTr("Arrival") }

    Button {
        text: qsTr("Save")
        onClicked: {
            form.clearErrors()
            if (seats.value < 1)
                seats.errorMessage = qsTr("At least one seat")
            if (!start.selectedDate)
                start.errorMessage = qsTr("Pick a start date")
            // …
            if (form.validate()) { /* commit */ }
        }
    }
}
```

| Tip | Detail |
|-----|--------|
| Clear on accept | Date / calendar / time clear `errorMessage` when the user accepts a value |
| NumberBox | `inputInvalid` can keep `hasError` after `clearErrors()` until input is fixed — [forms.md](forms.md) |
| Left headers | NumberBox supports `headerPlacement` / `formBound`; date/time headers stay **top** in 1.28 |
| Color fields | Wrap with [`HeaderedContentControl`](components/HeaderedContentControl.md) or a label row; validation stays app-side |

---

## Theme density

All listed field pickers size the value row with **`Theme.controlHeight`**. Prefer Theme tokens for fonts/spacing — do not hard-code control heights in apps.

---

## Gallery

| Page | Notes |
|------|-------|
| Form validation | NumberBox + (1.28) CalendarDatePicker in the sign-up sample |
| NumberBox / Date* / Time* | Headers + cross-link to this recipe |
| ColorPickerButton | Links to ColorPicker; form wrap tip |

---

## Out of scope

- New picker types; replacing Qt Calendar entirely
- Full ColorPicker form chrome / left headers on date-time
