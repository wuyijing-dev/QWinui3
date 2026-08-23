# OskPanelButton

compact action chip for OSK auxiliary panels.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OskPanelButton.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OskPanelButton.qml)

**Category:** Buttons & commands · **Library:** v2.80

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Item`.

## Example

```qml
OskPanelButton { label: qsTr("123"); onTapped: showSymbols() }
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `label` | `string` | — |
| `accent` | `bool` | — |
| `enabled` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `tapped()` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
