# DialogWindow

StandardWindow dialog paradigm.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/DialogWindow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/DialogWindow.qml)

**Category:** Platform · **Library:** v1.07

[← Component index](../components.md)

**Extends** `StandardWindow`.

## Example

```qml
DialogWindow {
    id: dlg
    title: qsTr("Prompt")
    ownerWindow: mainWindow   // optional transient parent
    width: 420; height: 280
}
dlg.openDialog()
```

## Notes

StandardWindow with ParadigmDialog flags.
Prefer openDialog() so owner stacking + centerOnScreen match Gallery patterns.
On Linux/Wayland, setTransientParent keeps modality stacking correct.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `ownerWindow` | `var` | Optional owner Window / Item for transient parenting (Win HWND owner / Wayland stacking) |
| `centerWhenOpened` | `bool` | Center on the owner screen when shown via openDialog() |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `openDialog(owner)` | Show as a dialog: wire owner, center, then make visible |
| `closeDialog()` | Hide without destroying |

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
