# ItemsView

ListView recipe: sections, selection, context MenuFlyout, EmptyState.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ItemsView.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ItemsView.qml)

**Category:** Collections & data · **Library:** v3.10

[← Component index](../components.md)

**Gallery:** `ItemsView` — [`src/gallery/pages/ItemsViewPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ItemsViewPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
ItemsView {
    model: myModel
    sectionRole: "group"
    selectionMode: ItemsView.SelectionMultiple
    titleRole: "title"
    subtitleRole: "subtitle"
    emptyTitle: qsTr("No items")
    MenuFlyout {
        id: ctx
        MenuFlyoutItem { text: qsTr("Open") }
    }
    contextMenu: ctx
}
// --- API ---
// methods: clearSelection(), selectAll(), isSelected(index), toggleSelection(index)
// itemsView.clearSelection()
// itemsView.selectAll()
```

## Notes

Fluent list recipe over QQC ListView (`reuseItems` + mild `cacheBuffer`; not a separate virtualization engine).
selectionMode: selectionNone | selectionSingle | selectionMultiple.
Keyboard: arrows / Home / End / Page / Enter; Space toggles multi-select; Ctrl+A; Esc clears.
Right-click / long-press opens contextMenu.
Empty list shows EmptyState via emptyTitle / emptyMessage / emptyActionText.
Large models: prefer QAbstractListModel. Optional filterText filters plain JS
arrays (debounced, 1.88) — C++ models: filter app-side.
`cacheBufferPx` (< 0 = auto mild overscan) and filter caps tuned in **3.51**.
See docs/data-collections.md for pairing with ListDetailsView.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `selectionNone` | `int` | — |
| `selectionSingle` | `int` | — |
| `selectionMultiple` | `int` | — |
| `model` | `var` | List model (array or ListModel / QAbstractListModel) |
| `selectionMode` | `int` | selectionNone \| selectionSingle \| selectionMultiple |
| `selectedIndexes` | `var` | Selected row indexes (array of int) |
| `titleRole` | `string` | Model role / property name for title |
| `subtitleRole` | `string` | Model role / property name for subtitle |
| `symbolRole` | `string` | Model role / property name for leading Fluent symbol |
| `sectionRole` | `string` | Model role / property name for section header (empty = no sections) |
| `checkboxLeading` | `bool` | Put multi-select checkboxes in the leading slot (WinUI-like) |
| `contextMenu` | `var` | Optional MenuFlyout (or Menu) instance for context actions |
| `emptyTitle` | `string` | EmptyState title when model is empty |
| `emptyMessage` | `string` | EmptyState message |
| `emptyActionText` | `string` | EmptyState action label |
| `filterText` | `string` | Filter plain JS array models (debounced). Leave empty for C++ / ListModel — filter app-side. |
| `filterRoles` | `var` | Roles searched when filterText is set (defaults to title + subtitle + section + symbol). |
| `filterDebounceMs` | `int` | Debounce ms before rebuilding the filtered array (1.88 / 3.51). |
| `minFilterLength` | `int` | Skip filter until query length >= this (2.59 — huge JS arrays). |
| `maxFilterResults` | `int` | Cap filtered rows for plain JS arrays (default **256**, 2.59 / 3.51). |
| `cacheBufferPx` | `int` | ListView overscan; `< 0` uses `max(240, height * 1.5)` (3.51 C22). |
| `itemEnter` | `string` | Row enter motion: none \| fade \| slide — 2.67 B2 (honors Theme.reducedMotion) |
| `itemExit` | `string` | Row exit motion: none \| fade \| slide |
| `accessibleName` | `string` | Screen-reader name override (1.19) |
| `count` | `int` | Resolved item count |
| `isEmpty` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `itemActivated(int index, var itemData)` | Emitted when an item is activated (click / Enter) |
| `selectionChanged()` | Emitted when selection changes |
| `emptyActionClicked()` | Empty action clicked |

### Methods

| Signature | Description |
| --- | --- |
| `isSelected(index)` | — |
| `clearSelection()` | — |
| `selectAll()` | — |
| `toggleSelection(index)` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
