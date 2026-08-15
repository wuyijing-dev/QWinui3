# TimePicker

Hour / minute (and period) selectors.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TimePicker.qml`](../../src/extras/QWinUI3/Extras/TimePicker.qml)

[← Component index](../components.md)

## Usage

```qml
TimePicker { }
```

## Properties

- `hour: int` — Hour
- `minute: int` — Minute
- `isAm: bool` — Is Am
- `use24Hour: bool` — Use24 Hour
- `pickerOpen: bool` — Picker flyout open
- `isOpen: alias` — Open / visible state
- `header: string` — Header label above the control
- `minuteIncrement: int` — WinUI MinuteIncrement — e.g. 1, 5, 15
- `clockIdentifier: string` — WinUI ClockIdentifier (read-only mirror of use24Hour)
- `minuteModel: var` — Minute Model
- `displayHour: int` — Display Hour
- `displayText: string` — Text shown to the user

## Signals

- `timeChosen(int hour, int minute)` — Time Chosen

## Methods

- `snapMinute(m)` — Snap Minute
- `applyFromTumblers()` — Apply From Tumblers

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
