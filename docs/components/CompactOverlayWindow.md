# CompactOverlayWindow

StandardWindow compact overlay presenter.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/CompactOverlayWindow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/CompactOverlayWindow.qml)

**Category:** Platform · **Library:** v2.80

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `StandardWindow`.

## Example

```qml
CompactOverlayWindow {
    id: pip
    title: qsTr("PiP")
    width: 320; height: 180
}
```

## Notes

StandardWindow compact-overlay presenter (always-on-top PiP).

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
