# FocusStroke

Dual-ring keyboard focus chrome (WinUI / Fluent).

`import QWinUI3.Theme` · [`src/theme/QWinUI3/Theme/FocusStroke.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/theme/QWinUI3/Theme/FocusStroke.qml)

**Category:** Theme · **Library:** v2.80

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `Item`.

## Example

```qml
FocusStroke { anchors.fill: parent; show: control.visualFocus }
```

## Notes

Shared by Style + Extras. Uses Theme.strokeFocus* / focusOuter/Inner and reducedMotion.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `show` | `bool` | Show the control |
| `frameRadius` | `real` | Frame corner radius |
| `outerSize` | `real` | Outer ring width (thicker in high contrast — 2px double per accessibility.md) |
| `innerSize` | `real` | Inner ring width |

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
