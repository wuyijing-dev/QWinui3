# CommandPaletteHost

Ctrl+K / Meta+K wiring for StandardWindow and custom hosts (3.01 W3).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CommandPaletteHost.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CommandPaletteHost.qml)

**Category:** Buttons & commands · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `CommandPalette` — [`src/gallery/pages/CommandPalettePage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/CommandPalettePage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Item`.

## Example

```qml
StandardWindow {
    CommandPaletteHost {
        commands: [ { title: qsTr("Settings"), action: openSettings } ]
    }
}

ShellWindow / NavigationWindow include built-in palette — use this for StandardWindow only.
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `enabled` | `bool` | — |
| `commands` | `var` | — |
| `registry` | `var` | — |

### Signals

| Signature | Description |
| --- | --- |
| `commandTriggered(var command)` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
