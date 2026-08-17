# CalendarView (2.31)

Always-visible **month grid** for scheduling, booking, and PTO surfaces — distinct from **CalendarDatePicker** (field + flyout) and **DatePicker** (tumblers).

Gallery: **CalendarView** · **Calendar** (raw `MonthGrid`) · **CalendarDatePicker** · [pickers.md](pickers.md).

Control: `import QWinUI3.Extras` · [`CalendarView.qml`](../src/extras/QWinUI3/Extras/CalendarView.qml) (**experimental**).

---

## Choosing

| Need | Prefer |
|------|--------|
| Compact date entry in a form | **CalendarDatePicker** or **DatePicker** |
| Full-month schedule / room booking | **`CalendarView`** |
| Custom chrome only | Style **`MonthGrid`** + **`DayOfWeekRow`** (Gallery **Calendar**) |

**Out of scope (2.31):** Outlook sync, recurring events engine, multi-month virtualized year view.

---

## Basic usage

```qml
CalendarView {
    id: cal
    width: 320
    accessibleName: qsTr("Team PTO")
    selectionMode: "single"   // single | multiple | range
    selectedDate: new Date()
    onSelectionChanged: refreshSummary()
}
```

---

## Selection modes

| Mode | Properties | Interaction |
|------|------------|-------------|
| **single** | `selectedDate` | Click sets one day (default) |
| **multiple** | `selectedDates` | Click toggles days on/off |
| **range** | `rangeStart`, `rangeEnd` | First click start, second click end (auto-order) |

```qml
CalendarView {
    selectionMode: "range"
    onSelectionChanged: {
        console.log(rangeStart, rangeEnd)
    }
}
```

`clearSelection()` resets all modes. `goToToday()` jumps the visible month (and selects today in **single** mode).

---

## Bounds & locale

Same patterns as **CalendarDatePicker**:

- `hasMinDate` / `minDate`, `hasMaxDate` / `maxDate` — `isDateAllowed(d)` blocks disallowed clicks
- `firstDayOfWeek` — `-1` for system, or `Qt.Monday` / `Qt.Sunday` / …
- `showNavigation` / `showTodayButton` — header chevrons and Today row

---

## Accessibility (2.31)

| API | Note |
|-----|------|
| `accessibleName` | Override when multiple calendars share a page |
| `announceChanges` | Live region on selection / month change (Qt 6.8+ `Accessible.announce`) |
| Month grid | `Accessible.Table`; prev/next month buttons named |

See [accessibility.md](accessibility.md) · Gallery **CalendarView** page.

---

## MonthGrid extension

**`CalendarView`** composes Style **`MonthGrid`**, which gained **`selectionMode`**, **`selectedDates`**, and **`rangeStart` / `rangeEnd`** styling (**2.31**) — backward compatible (**CalendarDatePicker** unchanged).

