# PointerCursor

Hover cursor affordance for styled controls (2.66 M8).

`import QWinUI3.Theme` · [`src/theme/QWinUI3/Theme/PointerCursor.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/theme/QWinUI3/Theme/PointerCursor.qml)

**Category:** Theme · **Library:** v3.56

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `HoverHandler`.

## Example

```qml
PointerCursor { shape: Qt.PointingHandCursor }
```

## Notes

Qt Quick Templates (T.TextField, T.Button, …) do not expose cursorShape;
use this HoverHandler wrapper instead of assigning on the control root.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `shape` | `int` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
