# ContextMenuAtItem

helper to open a MenuFlyout from item + mouse.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ContextMenuAtItem.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ContextMenuAtItem.qml)

**Category:** Input & forms · **Library:** v2.65

[← Component index](../components.md)

**Extends** `QtObject`.

## Notes

Right-click often comes from a MouseArea inside a grid/list delegate.
This helper uses item.mapToGlobal(mouse.x, mouse.y) to get global coordinates.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `menu` | `var` | MenuFlyout to open. |
| `overlay` | `Item` | Optional overlay host; default uses menu.popupAtGlobal() overlay resolution. |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `showAtItem(targetItem, mouse)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
