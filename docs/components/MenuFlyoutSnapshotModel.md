# MenuFlyoutSnapshotModel

Freeze dynamic menu label values at open time.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MenuFlyoutSnapshotModel.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MenuFlyoutSnapshotModel.qml)

**Category:** Dialogs & flyouts · **Library:** v2.65

[← Component index](../components.md)

**Extends** `QtObject`.

## Notes

QML property bindings on MenuFlyoutItem.text are hard to “freeze” generically.
Instead, this snapshot model exposes a frozen array that apps can feed
into menu items (e.g. via Repeater) when the menu opens.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `source` | `var` | [{ id: 1, title: "Copy", payload: {...} }, ...] |
| `textFn` | `var` | Optional mapping function: (row) => string |
| `payloadFn` | `var` | Optional mapping function: (row) => var (for payload) |
| `frozen` | `var` | Last frozen snapshot rows (deep-ish copy). |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `freeze()` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
