# RepositionThemeTransition

Animate this item when its layout x/y change.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/RepositionThemeTransition.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/RepositionThemeTransition.qml)

**Category:** Media & platform · **Library:** v1.19

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
Flow {
    Repeater {
        model: 6
        RepositionThemeTransition {
            width: 72; height: 72
            Rectangle { anchors.fill: parent; radius: 8; color: Theme.accent }
        }
    }
}

// --- API ---
// properties: animatePosition
```

## Notes

Wrap Flow/Grid children. Honors Theme.reducedMotion.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `content` | `alias` | — |
| `animatePosition` | `bool` | Animate when this item's x/y change (e.g. Flow / Grid reflow) |

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
