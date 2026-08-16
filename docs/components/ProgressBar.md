# ProgressBar

Fluent styled ProgressBar (WinUI ShowError / ShowPaused).

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ProgressBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ProgressBar.qml)

**Category:** Styled controls · **Library:** v1.11

[← Component index](../components.md)

**Gallery:** `ProgressBar` — [`src/gallery/pages/ProgressBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ProgressBarPage.qml)

## Example

```qml
ProgressBar {
    id: bar
    value: 0.6
    showError: false
    showPaused: false
}
```

## Notes

Fluent ProgressBar with WinUI ShowError (critical fill) and ShowPaused (caution fill;
pauses indeterminate animation). Base API is Qt Quick Controls ProgressBar.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `showError` | `bool` | WinUI ShowError — paint the bar in the error/critical color |
| `showPaused` | `bool` | WinUI ShowPaused — caution color; stops indeterminate motion |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
