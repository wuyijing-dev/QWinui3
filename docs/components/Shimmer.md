# Shimmer

Skeleton shimmer placeholder.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/Shimmer.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/Shimmer.qml)

**Category:** Status & feedback · **Library:** v1.04

[← Component index](../components.md)

**Gallery:** `Shimmer` — [`src/gallery/pages/ShimmerPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ShimmerPage.qml)

**Extends** `Control`.

## Example

```qml
Shimmer {
    id: shim
    width: 200; height: 16
    active: true
}
// --- API ---
// shim.active
```

## Notes

Loading placeholder shimmer; active enables the animation.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `cornerRadius` | `real` | Corner radius |
| `active` | `bool` | Active state |
| `isActive` | `alias` | Active / animating state |
| `shape` | `int` | Shape variant |
| `durationMs` | `int` | Auto-dismiss duration; 0 keeps open |
| `baseColor` | `color` | Base / track color |
| `sheenColor` | `color` | Sheen / highlight color |
| `direction` | `int` | Qt.Horizontal \| Qt.Vertical |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
