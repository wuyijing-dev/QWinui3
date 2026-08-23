# ToolShellWindow

ShellWindow with tool paradigm.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ToolShellWindow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ToolShellWindow.qml)

**Category:** Shells & windows · **Library:** v2.80

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `ShellWindow`.

## Example

```qml
ToolShellWindow {
    id: tool
    title: qsTr("Inspector")
    width: 360; height: 480
}
// --- API ---
// WindowHelper.ParadigmTool flags
```

## Notes

ShellWindow with WindowHelper.ParadigmTool flags (palette / inspector).

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
