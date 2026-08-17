# WindowShellContentClip

inset / clip helper for Linux client-shell bottom corners.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/WindowShellContentClip.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/WindowShellContentClip.qml)

**Category:** Platform · **Library:** v2.59

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
WindowShellContentClip {
    targetWindow: window
    Page { anchors.fill: parent }
}

When clientShellDecoration is active and the window is not maximized, applies side/bottom
insets equal to shellCornerRadius() so content does not bleed through rounded frame corners.
Prefer this wrapper for full-bleed pages (NavigationView, ListView backgrounds).
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `targetWindow` | `var` | — |
| `content` | `alias` | — |
| `clipActive` | `bool` | — |
| `contentInset` | `real` | — |

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
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
