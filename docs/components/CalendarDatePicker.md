# CalendarDatePicker

Date field with calendar flyout.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CalendarDatePicker.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CalendarDatePicker.qml)

**Category:** Date & time · **Library:** v1.15

[← Component index](../components.md)

**Gallery:** `CalendarDatePicker` — [`src/gallery/pages/CalendarDatePickerPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CalendarDatePickerPage.qml)

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
FirstDayOfWeek remaps calendar locale (WinUI CalendarView.FirstDayOfWeek).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `selectedDate` | `date` | Currently selected date |
| `date` | `alias` | WinUI Date alias of selectedDate |
| `calendarOpen` | `bool` | Calendar flyout open |
| `isOpen` | `alias` | Open / visible state |
| `isCalendarOpen` | `alias` | WinUI IsCalendarOpen |
| `dateFormat` | `string` | Display date format |
| `showTodayButton` | `bool` | Show Today button in calendar |
| `isTodayHighlighted` | `bool` | Highlight today ring (MonthGrid isToday) |
| `header` | `string` | Header label above the control |
| `placeholderText` | `string` | Placeholder when empty |
| `minDate` | `date` | Minimum selectable date |
| `maxDate` | `date` | Maximum selectable date |
| `hasMinDate` | `bool` | True when minDate is set |
| `hasMaxDate` | `bool` | True when maxDate is set |
| `firstDayOfWeek` | `int` | WinUI FirstDayOfWeek — Qt.Sunday..Qt.Saturday, or -1 for system default |
| `calendarLocale` | `var` | Locale whose firstDayOfWeek matches the requested start day |

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
