# MonthGrid

Fluent styled MonthGrid.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/MonthGrid.qml`](../../src/style/QWinUI3/MonthGrid.qml)

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
```

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
