# CalendarDatePicker

Date field with calendar flyout.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CalendarDatePicker.qml`](../../src/extras/QWinUI3/Extras/CalendarDatePicker.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
CalendarDatePicker {
    id: calendarDatePicker
    selectedDate: new Date()
}

// --- API ---
// signals: onDateChosen
// methods: isDateAllowed(d)
// calendarDatePicker.isDateAllowed(d)
```

## Notes

Text field + calendar flyout (MonthGrid); selectedDate with min/max bounds.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `selectedDate` | `date` | Currently selected date |
| `calendarOpen` | `bool` | Calendar flyout open |
| `isOpen` | `alias` | Open / visible state |
| `dateFormat` | `string` | Display date format |
| `showTodayButton` | `bool` | Show Today button in calendar |
| `header` | `string` | Header label above the control |
| `placeholderText` | `string` | Placeholder when empty |
| `minDate` | `date` | Minimum selectable date |
| `maxDate` | `date` | Maximum selectable date |
| `hasMinDate` | `bool` | True when minDate is set |
| `hasMaxDate` | `bool` | True when maxDate is set |

### Signals

| Signature | Description |
| --- | --- |
| `dateChosen(date date)` | Emitted when a date is chosen |

### Methods

| Signature | Description |
| --- | --- |
| `isDateAllowed(d)` | True when the date is within selectable bounds |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
