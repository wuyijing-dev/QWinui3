# TimePicker

Hour / minute (and period) selectors.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TimePicker.qml`](../../src/extras/QWinUI3/Extras/TimePicker.qml)

[← Component index](../components.md)

## Usage

```qml
TimePicker { }
```

## Properties

- `hour: int` — Selected hour
- `minute: int` — Selected minute
- `isAm: bool` — True in AM for 12-hour clock
- `use24Hour: bool` — Use 24-hour clock
- `pickerOpen: bool` — Picker flyout open
- `isOpen: alias` — Open / visible state
- `header: string` — Header label above the control
- `minuteIncrement: int` — WinUI MinuteIncrement — e.g. 1, 5, 15
- `clockIdentifier: string` — WinUI ClockIdentifier (read-only mirror of use24Hour)
- `minuteModel: var` — Minute tumbler model
- `displayHour: int` — Hour shown in the current clock format
- `displayText: string` — Text shown to the user

## Signals

- `timeChosen(int hour, int minute)` — Emitted when a time is chosen

## Methods

- `snapMinute(m)` — Snap minutes to the increment
- `applyFromTumblers()` — Commit tumbler selection into the value

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
