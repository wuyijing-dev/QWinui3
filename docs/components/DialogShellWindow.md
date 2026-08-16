# DialogShellWindow

ShellWindow with dialog paradigm flags.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/DialogShellWindow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/DialogShellWindow.qml)

**Category:** Shells & windows · **Library:** v1.16

[← Component index](../components.md)

**Extends** `ShellWindow`.

## Example

```qml
DialogShellWindow {
    title: qsTr("Confirm")
    ownerWindow: mainWindow
    width: 440; height: 280
}
dlg.openDialog()
```

## Notes

ShellWindow with WindowHelper.ParadigmDialog flags.
Prefer openDialog() for owner stacking + center (same recipe as DialogWindow / Gallery).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `ownerWindow` | `var` | Optional owner Window / Item for transient parenting |
| `centerWhenOpened` | `bool` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `openDialog(owner)` | — |
| `closeDialog()` | — |

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
