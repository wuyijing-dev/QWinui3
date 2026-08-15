# DatePicker

Date selectors (year / month / day).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DatePicker.qml`](../../src/extras/QWinUI3/Extras/DatePicker.qml)

[← Component index](../components.md)

## Usage

```qml
DatePicker { }
```

## Properties

- `year: int` — Selected year
- `month: int` — Selected month 1..12
- `day: int` — Selected day of month
- `minYear: int` — Minimum selectable year
- `maxYear: int` — Maximum selectable year
- `pickerOpen: bool` — Picker flyout open
- `isOpen: alias` — Open / visible state
- `header: string` — Header label above the control
- `placeholderText: string` — Placeholder when empty
- `dateFormat: string` — yyyy-MM-dd | MM/dd/yyyy | dd/MM/yyyy
- `selectedDate: date` — Currently selected date
- `displayText: string` — Text shown to the user
- `daysInMonth: int` — Days in the selected month

## Signals

- `dateChosen(int year, int month, int day)` — Emitted when a date is chosen

## Methods

- `syncSelectedDateFromParts()` — Sync Selected Date From Parts
- `clampDay()` — Clamp Day
- `applyFromTumblers()` — Apply From Tumblers
- `syncTumblers()` — Sync Tumblers

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
