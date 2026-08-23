# RightClickAnchorHelper

compute global anchor point for right-click menus.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RightClickAnchorHelper.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/RightClickAnchorHelper.qml)

**Category:** Other · **Library:** v2.66

[← Component index](../components.md)

**Extends** `QtObject`.

## Notes

This is a tiny helper aimed at grid/list delegates where apps repeatedly
need mapToGlobal() plumbing.

## API

### Properties

_No additional properties beyond the base type._

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `globalPointForMouse(targetItem, mouse)` | Returns global point for a mouse event within targetItem coordinates. |
| `popupFlyoutAt(menu, targetItem, mouse, overlay)` | Open a MenuFlyout at cursor global coordinates. |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
