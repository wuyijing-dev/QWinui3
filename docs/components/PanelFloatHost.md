# PanelFloatHost

Detach a pane into ToolShellWindow and dock it back (3.08 W8).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/PanelFloatHost.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/PanelFloatHost.qml)

**Category:** Layout · **Library:** v3.10

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Item`.

## Example

```qml
PanelFloatHost {
    title: qsTr("Filters")
    geometryPersistenceKey: "MyAppFilterFloat"
    content: Rectangle { /* pane body */ }
}

// --- API ---
// methods: floatPane(), dockPane()
// properties: floating, title, subtitle, geometryPersistenceKey, content, showChrome
```

## Notes

Mutual-exclusive Loaders share one Component — not a full dock framework.
Closing the tool window docks the pane.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `alias` | — |
| `subtitle` | `alias` | — |
| `geometryPersistenceKey` | `string` | — |
| `content` | `Component` | — |
| `floating` | `bool` | — |
| `showChrome` | `bool` | — |
| `chromeHeight` | `real` | — |

### Signals

| Signature | Description |
| --- | --- |
| `floated()` | — |
| `docked()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `floatPane()` | — |
| `dockPane()` | — |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
