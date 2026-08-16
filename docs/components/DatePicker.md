# DatePicker

Date selectors (year / month / day).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DatePicker.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DatePicker.qml)

**Category:** Date & time · **Library:** v1.21

[← Component index](../components.md)

**Gallery:** `DatePicker` — [`src/gallery/pages/DatePickerPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/DatePickerPage.qml)

**Extends** `Control`.

## Example

```qml
DatePicker {
    id: date
    selectedDate: new Date()
    onAccepted: apply(date.selectedDate)
}
// --- API ---
// date.year / month / day / selectedDate
```

## Notes

Tumbler date picker; selectedDate or year/month/day parts.
DayVisible / MonthVisible / YearVisible hide tumbler columns (WinUI).
Accept commits; minYear/maxYear bound the year range.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `year` | `int` | Selected year |
| `month` | `int` | Selected month 1..12 |
| `day` | `int` | Selected day of month |
| `minYear` | `int` | Minimum selectable year |
| `maxYear` | `int` | Maximum selectable year |
| `dayVisible` | `bool` | WinUI DayVisible |
| `monthVisible` | `bool` | WinUI MonthVisible |
| `yearVisible` | `bool` | WinUI YearVisible |
| `dayFormat` | `string` | WinUI DayFormat: numeric |
| `monthFormat` | `string` | WinUI MonthFormat: numeric \| abbreviated \| full |
| `yearFormat` | `string` | WinUI YearFormat: numeric |
| `pickerOpen` | `bool` | Picker flyout open |
| `isOpen` | `alias` | Open / visible state |
| `header` | `string` | Header label above the control |
| `placeholderText` | `string` | Placeholder when empty |
| `dateFormat` | `string` | yyyy-MM-dd \| MM/dd/yyyy \| dd/MM/yyyy |
| `selectedDate` | `date` | Currently selected date |
| `displayText` | `string` | Text shown to the user |
| `daysInMonth` | `int` | Days in the selected month |

### Signals

| Signature | Description |
| --- | --- |
| `dateChosen(int year, int month, int day)` | Emitted when a date is chosen |

### Methods

| Signature | Description |
| --- | --- |
| `syncSelectedDateFromParts()` | Rebuild selected date from Y/M/D parts |
| `clampDay()` | Clamp day into the current month |
| `applyFromTumblers()` | Commit tumbler selection into the value |
| `syncTumblers()` | Sync tumbler positions to the value |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
