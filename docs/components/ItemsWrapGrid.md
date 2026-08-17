# ItemsWrapGrid

model-driven variable-size wrap layout (2.24).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ItemsWrapGrid.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ItemsWrapGrid.qml)

**Category:** Collections & data · **Library:** v2.56

[← Component index](../components.md)

**Gallery:** `ItemsWrapGrid` — [`src/gallery/pages/ItemsWrapGridPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ItemsWrapGridPage.qml)

**Extends** `Control`.

## Example

```qml
ItemsWrapGrid {
    model: tags
    minItemSize: Theme.controlHeight
    delegate: Chip {
        required property int index
        required property var modelData
        text: modelData.title
    }
}

// --- API ---
// properties: model, delegate, filterText, itemSpacing, horizontalSpacing,
//             verticalSpacing, orientation, layoutDirection, itemWidth,
//             itemHeight, minItemSize
// signals: itemClicked, itemActivated
// readonly: count
```

## Notes

WinUI-style wrap grid over WrapPanel + Repeater — variable item sizes, not
million-item virtualized. Prefer ItemsRepeater for long single-column lists.
Touch: keep delegates ≥ minItemSize (default Theme.controlHeight).
Optional filterText filters plain JS arrays (debounced). See docs/items-wrap-grid.md.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `accessibleName` | `string` | — |
| `announceChanges` | `bool` | — |
| `model` | `var` | — |
| `delegate` | `Component` | — |
| `filterText` | `string` | — |
| `filterRoles` | `var` | — |
| `filterDebounceMs` | `int` | — |
| `itemSpacing` | `real` | — |
| `horizontalSpacing` | `real` | — |
| `verticalSpacing` | `real` | — |
| `orientation` | `int` | — |
| `layoutDirection` | `int` | — |
| `itemWidth` | `real` | — |
| `itemHeight` | `real` | — |
| `minItemSize` | `real` | Documented touch floor — delegates should honor via implicit sizes. |
| `count` | `int` | — |

### Signals

| Signature | Description |
| --- | --- |
| `itemClicked(int index)` | — |
| `itemActivated(int index, var itemData)` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
