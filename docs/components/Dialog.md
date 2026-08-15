# Dialog

Fluent styled Dialog.

`import QtQuick.Controls.QWinUI3` · [`src/style/QWinUI3/Dialog.qml`](../../src/style/QWinUI3/Dialog.qml)

[← Component index](../components.md)

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

## API

Style-only control: no extra QWinUI3 properties. Use the Qt Quick Controls `Dialog` API (this file only supplies Fluent visuals / metrics).

### Inherited from `Dialog`

- `title`
- `open()` / `close()`
- `accepted()` / `rejected()`
- `standardButtons`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
