# CommandBarKeyHints

show keyboardAcceleratorText hints from AppBarButton children.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/CommandBarKeyHints.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/CommandBarKeyHints.qml)

**Category:** Buttons & commands · **Library:** v2.80

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Item`.

## Notes

CommandBar buttons already render their own hints visually when
`keyboardAcceleratorText` is set. This component is mainly for debugging
“which buttons have chords” during product integration.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `commandBar` | `var` | — |
| `enabled` | `bool` | — |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
