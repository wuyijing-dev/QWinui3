# Button

Fluent Button with WinUI stroke / fill / focus chrome.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Button.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Button.qml)

**Category:** Styled controls · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `Button` — [`src/gallery/pages/ButtonPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ButtonPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

## Example

```qml
Button {
    id: btn
    text: qsTr("OK")
    onClicked: accept()
}
// --- API ---
// style-only Fluent chrome; API is Qt Quick Controls Button
// loading: true — inline busy ring, disables click (2.59)
// btn.text / enabled / highlighted / clicked()
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Button.
Public API is the Qt Quick Controls Button type; this file supplies visuals/metrics only.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `loading` | `bool` | Async action in flight — disables click and shows inline ring (2.59). |
| `appearance` | `string` | Visual variant: filled \| subtle \| outline \| ghost \| "" (legacy) — 2.66 A1/M1 |
| `preserveWidthWhileLoading` | `bool` | Keep width stable while loading (avoids toolbar reflow). |
| `accented` | `bool` | Use accent chrome |
| `lightScheme` | `bool` | True in light theme |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
