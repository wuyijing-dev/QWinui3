# Switch

Fluent styled Switch (WinUI ToggleSwitch OnContent / OffContent).

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Switch.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Switch.qml)

**Category:** Styled controls · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `Switch` — [`src/gallery/pages/SwitchPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/SwitchPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
Switch {
    id: sw
    text: qsTr("Wi‑Fi")
    onContent: qsTr("On")
    offContent: qsTr("Off")
    onToggled: Theme.dark = sw.checked
}
```

## Notes

Fluent Switch with WinUI OnContent/OffContent labels beside the track (plus Qt text as Header).
Base API is Qt Quick Controls Switch.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `onContent` | `string` | WinUI OnContent — label shown when checked (beside indicator) |
| `offContent` | `string` | WinUI OffContent — label shown when unchecked |
| `header` | `alias` | WinUI Header alias of text |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
