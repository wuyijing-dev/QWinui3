# Dialog

Fluent styled Dialog.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Dialog.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/style/QWinUI3/Dialog.qml)

**Category:** Styled controls · **Library:** v2.52

[← Component index](../components.md)

**Gallery:** `Dialog` — [`src/gallery/pages/DialogPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/DialogPage.qml)

## Example

```qml
Dialog {
    id: dlg
    title: qsTr("Notice")
    standardButtons: Dialog.Ok
    onAccepted: close()
}
dlg.open()
```

## Notes

Style-only Fluent chrome for Qt Quick Controls Dialog.
Public API is the Qt Quick Controls Dialog type; this file supplies visuals/metrics only.

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Dialog` API (this file only supplies Fluent visuals / metrics).

### Inherited from `Dialog`

- `title`
- `open()` / `close()`
- `accepted()` / `rejected()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
