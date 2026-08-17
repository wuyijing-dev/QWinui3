# ItemsRepeater

Thin WinUI-style virtualizing repeater over ListView.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ItemsRepeater.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ItemsRepeater.qml)

**Category:** Collections & data · **Library:** v2.57

[← Component index](../components.md)

**Gallery:** `ItemsRepeater` — [`src/gallery/pages/ItemsRepeaterPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ItemsRepeaterPage.qml)

**Extends** `Control`.

## Example

```qml
ItemsRepeater {
    model: bigModel
    orientation: Qt.Vertical
    delegate: ListTile { title: model.title }
}

// --- API ---
// properties: model, delegate, orientation, itemSpacing, cacheBuffer
// aliases: contentX/Y, count, currentIndex
```

## Notes

Prefer this for large models; ItemsView adds selection / EmptyState recipe on top.
ListView uses reuseItems (1.25) — keep delegates binding-driven for pooling.
Optional filterText filters plain JS arrays (debounced, 1.88).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | List / array / QAbstractItemModel |
| `filterText` | `string` | Filter plain JS arrays (debounced). C++ / ListModel: filter app-side. |
| `filterRoles` | `var` | — |
| `filterDebounceMs` | `int` | — |
| `delegate` | `alias` | Item delegate component |
| `orientation` | `alias` | Qt.Vertical or Qt.Horizontal |
| `itemSpacing` | `alias` | Spacing between items (Control.spacing is FINAL — do not alias it) |
| `cacheBuffer` | `alias` | Extra cache outside the viewport |
| `currentIndex` | `alias` | Current index |
| `count` | `alias` | Item count |
| `contentX` | `alias` | — |
| `contentY` | `alias` | — |
| `contentWidth` | `alias` | — |
| `contentHeight` | `alias` | — |

### Signals

| Signature | Description |
| --- | --- |
| `itemClicked(int index)` | Emitted when an item is clicked (if delegate forwards) |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
