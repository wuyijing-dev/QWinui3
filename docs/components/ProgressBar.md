# ProgressBar

Fluent / WinUI 3 ProgressBar with optional header, value label, ShowError / ShowPaused.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/ProgressBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/ProgressBar.qml)

**Category:** Styled controls · **Library:** v3.15

[← Component index](../components.md)

**Gallery:** `ProgressBar` — [`src/gallery/pages/ProgressBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ProgressBarPage.qml)

## Example

```qml
ProgressBar {
    header: qsTr("Downloading update")
    showValue: true
    value: 0.45
}

ProgressBar {
    indeterminate: true
    header: qsTr("Working…")
    showValue: true
    // showPaused: true  — caution, freezes motion
    // showError: true   — critical
}
```

## QWinUI3 properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `header` | `string` | `""` | Label above the track |
| `showValue` | `bool` | `false` | Show percentage (or `valueLabel`) opposite the header |
| `valueLabel` | `string` | `""` | Override formatted value text |
| `showError` | `bool` | `false` | Critical fill; freezes indeterminate motion |
| `showPaused` | `bool` | `false` | Caution fill; freezes indeterminate motion |
| `trackThickness` | `real` | `Theme.sliderThickness` | Track height in px |

`formattedValue` is a readonly string used by the value label and accessibility.

## Inherited from Qt `ProgressBar`

- `from` / `to` / `value` / `position`
- `indeterminate`
- `padding` / size hints

## Notes

Determinate fill flashes briefly at 100%. Honors `Theme.reducedMotion` (no indeterminate sweep, no complete flash). Prefer **ProgressRing** for compact busy; keep progress beside the work — not a toast ([feedback](../feedback.md)).

---
*Updated for 3.15 header / value label / trackThickness.*
