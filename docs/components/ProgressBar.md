# ProgressBar

Fluent / WinUI 3 ProgressBar (Header, value label, ShowError / ShowPaused).

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ProgressBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ProgressBar.qml)

**Category:** Styled controls · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `ProgressBar` — [`src/gallery/pages/ProgressBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ProgressBarPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
ProgressBar {
    header: qsTr("Downloading")
    showValue: true
    value: 0.45
}

ProgressBar {
    indeterminate: true
    showPaused: true   // or showError: true
}
```

## Notes

WinUI ShowError (critical) / ShowPaused (caution; pauses indeterminate motion).
Optional header + percentage above the track (ProgressRing-aligned showValue / valueLabel).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `showError` | `bool` | WinUI ShowError — paint the bar in the error/critical color |
| `showPaused` | `bool` | WinUI ShowPaused — caution color; stops indeterminate motion |
| `header` | `string` | Label above the track (Fluent recipe / WinUI sample pairing) |
| `showValue` | `bool` | Show percentage (or valueLabel) opposite the header |
| `valueLabel` | `string` | Override formatted percentage text |
| `trackThickness` | `real` | Track thickness in px (default Theme.sliderThickness) |
| `formattedValue` | `string` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
