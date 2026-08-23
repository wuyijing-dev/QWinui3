# WindowShellDecoration

Linux / Wayland client shell: DWM-like shadow + rounded frame.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/WindowShellDecoration.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/WindowShellDecoration.qml)

**Category:** Platform · **Library:** v2.65

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
WindowShellDecoration { targetWindow: window }

Used as ApplicationWindow.background when WindowHelper.clientShellDecoration is true.
Windows uses native DWM; this is the cross-compositor fallback.
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `targetWindow` | `var` | — |
| `active` | `bool` | — |
| `expanded` | `bool` | — |
| `cornerRadius` | `real` | — |
| `showShadow` | `bool` | — |
| `frameFill` | `color` | — |
| `frameBorder` | `color` | — |
| `shadowOpacity` | `real` | — |
| `shadowBlur` | `real` | — |
| `shadowVerticalOffset` | `real` | — |

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
