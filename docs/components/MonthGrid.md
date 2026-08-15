# MonthGrid

Fluent styled MonthGrid.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/MonthGrid.qml`](../../src/style/QWinUI3/MonthGrid.qml)

[← Component index](../components.md)

**Extends** `AbstractMonthGrid`.

## Example

```qml
MonthGrid {
    id: monthGrid
   
}

// --- API ---
// methods: sameDay(a, b)
// monthGrid.sameDay(a, b)
// inherits AbstractMonthGrid (+ Qt Quick Controls base API)
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
