# TimePicker

Hour / minute (and period) selectors.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TimePicker.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TimePicker.qml)

**Category:** Date & time · **Library:** v1.80

[← Component index](../components.md)

**Gallery:** `TimePicker` — [`src/gallery/pages/TimePickerPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TimePickerPage.qml)

**Extends** `Control`.

## Example

```qml
TimePicker {
    id: time
    selectedTime: new Date()
    clockIdentifier: "12HourClock"
    onTimeChosen: apply(time.selectedTime)
}
// --- API ---
// time.hour / minute / selectedTime / clockIdentifier
```

## Notes

Tumbler time picker; selectedTime + clockIdentifier 12HourClock|24HourClock.
minuteIncrement snaps minutes (WinUI MinuteIncrement).
Form: header / description / errorMessage / hasError (1.28) — FormLayout.validate().

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `hour` | `int` | Selected hour (0..23) |
| `minute` | `int` | Selected minute |
| `isAm` | `bool` | True in AM for 12-hour clock |
| `use24Hour` | `bool` | Use 24-hour clock |
| `clockIdentifier` | `string` | WinUI ClockIdentifier: "12HourClock" \| "24HourClock" |
| `selectedTime` | `date` | WinUI SelectedTime — date whose time-of-day mirrors hour/minute |
| `time` | `alias` | WinUI Time alias of selectedTime |
| `pickerOpen` | `bool` | Picker flyout open |
| `isOpen` | `alias` | Open / visible state |
| `header` | `string` | Header label above the control |
| `description` | `string` | Supporting description text |
| `errorMessage` | `string` | Validation error text (FormLayout) |
| `hasError` | `bool` | True when validation failed |
| `minuteIncrement` | `int` | WinUI MinuteIncrement — e.g. 1, 5, 15 |
| `minuteModel` | `var` | Minute tumbler model |
| `displayHour` | `int` | Hour shown in the current clock format |
| `displayText` | `string` | Text shown to the user |

### Signals

| Signature | Description |
| --- | --- |
| `timeChosen(int hour, int minute)` | Emitted when a time is chosen |
| `accepted(date time)` | Emitted when selectedTime changes via accept |

### Methods

| Signature | Description |
| --- | --- |
| `syncSelectedTimeFromParts()` | Push hour/minute into selectedTime |
| `snapMinute(m)` | Snap minutes to the increment |
| `applyFromTumblers()` | Commit tumbler selection into the value |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
