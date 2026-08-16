# BlankWindow

Empty ShellWindow client — declare UI as children.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/BlankWindow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/BlankWindow.qml)

**Category:** Shells & windows · **Library:** v1.09

[← Component index](../components.md)

**Extends** `ShellWindow`.

## Example

```qml
BlankWindow {
    id: win
    title: qsTr("App")
    width: 800; height: 600
    Label { anchors.centerIn: parent; text: qsTr("Hello") }
}
// --- API ---
// inherits ShellWindow chrome API (title, backdrop, …)
```

## Notes

Empty ShellWindow client; declare UI as children.
See ShellWindow / docs/window-shells.md for chrome slots.

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
