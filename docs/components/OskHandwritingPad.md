# OskHandwritingPad

Zinnia CLI handwriting panel (Windows + Linux).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OskHandwritingPad.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OskHandwritingPad.qml)

**Category:** Other · **Library:** v2.81

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
OskHandwritingPad { engine: kbd; handwriting: hwSvc }
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `engine` | `KeyboardEngine` | — |
| `handwriting` | `OskHandwritingService` | — |

### Signals

| Signature | Description |
| --- | --- |
| `closeRequested()` | — |
| `flashRequested(string message)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `closePanel()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
