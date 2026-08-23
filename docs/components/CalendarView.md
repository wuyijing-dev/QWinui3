# CalendarView

month grid for scheduling / booking surfaces (2.31).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CalendarView.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CalendarView.qml)

**Category:** Date & time · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `CalendarView` — [`src/gallery/pages/CalendarViewPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CalendarViewPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
CalendarView {
    selectionMode: "single"   // single | multiple | range
    selectedDate: new Date()
}

// --- API ---
// properties: month, year, selectionMode, selectedDate, selectedDates,
//             rangeStart, rangeEnd, firstDayOfWeek, minDate, maxDate,
//             showTodayButton, accessibleName, announceChanges
// signals: dateClicked(date), selectionChanged()
// methods: isDateAllowed(d), clearSelection(), goToToday()
```

## Notes

Distinct from CalendarDatePicker (field + flyout) and DatePicker (tumblers).
Composes MonthGrid + DayOfWeekRow. Experimental — see docs/calendar-view.md.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `month` | `int` | — |
| `year` | `int` | — |
| `selectionMode` | `string` | — |
| `selectedDate` | `date` | — |
| `selectedDates` | `var` | — |
| `rangeStart` | `date` | — |
| `rangeEnd` | `date` | — |
| `firstDayOfWeek` | `int` | — |
| `minDate` | `date` | — |
| `maxDate` | `date` | — |
| `blackoutDates` | `var` | Dates that cannot be selected — Date[] or ISO strings (2.69 D5) |
| `blackoutFilter` | `var` | Optional predicate (date) → bool; return false to black out |
| `hasMinDate` | `bool` | — |
| `hasMaxDate` | `bool` | — |
| `showTodayButton` | `bool` | — |
| `showNavigation` | `bool` | — |
| `accessibleName` | `string` | — |
| `announceChanges` | `bool` | — |
| `calendarLocale` | `var` | — |

### Signals

| Signature | Description |
| --- | --- |
| `dateClicked(date date)` | — |
| `selectionChanged()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `sameDay(a, b)` | — |
| `isDateAllowed(d)` | — |
| `clearSelection()` | — |
| `goToToday()` | — |
| `goToMonth(m, y)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
