# MonthGrid

Fluent calendar month grid for DatePicker / CalendarDatePicker.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/MonthGrid.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/MonthGrid.qml)

**Category:** Styled controls · **Library:** v1.08

[← Component index](../components.md)

**Extends** `AbstractMonthGrid`.

## Example

```qml
MonthGrid {
    id: grid
    month: (new Date()).getMonth()
    year: (new Date()).getFullYear()
    onClicked: (date) => pick(date)
}
// --- API ---
// grid.month / year / locale / title / clicked(date)
```

## Notes

Style-only Fluent chrome for Qt Quick Controls MonthGrid.
Public API is the Qt Quick Controls MonthGrid type; this file supplies visuals/metrics only.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `selectedDate` | `date` | Selected date |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `sameDay(a, b)` | True when two dates are the same calendar day |

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
