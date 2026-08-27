# ListDetailsView

Master–detail recipe on TwoPaneView.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ListDetailsView.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ListDetailsView.qml)

**Category:** Collections & data · **Library:** v3.10

[← Component index](../components.md)

**Gallery:** `ListDetailsView` — [`src/gallery/pages/ListDetailsViewPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ListDetailsViewPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Control`.

## Example

```qml
ListDetailsView {
    model: […]
    titleRole: "title"
    details: Label { text: listDetails.selectedItem.title }
}

// --- API ---
// selectedIndex / selectedItem, select(index), showList(), showDetails()
// listHeader / detailToolbar / details slots; multiSelectEnabled + selectedItems (2.64)
// detailToolbarMode: always | whenSelected | never (2.82 D15)
// connectedAnimationEnabled (+ key) — list→detail and reverse on showList() (2.68 B3)
```

## Notes

ListView master + details host (`reuseItems` + mild `cacheBuffer`). Collapses via TwoPaneView on narrow widths.
model items may be strings or objects (titleRole / subtitleRole).
Optional filterText filters plain JS arrays (debounced; defaults align ItemsView in **3.51**).
Selection tracks item **object** across filter rebuilds (2.18).
multiSelectEnabled adds checkboxes + detailToolbar for bulk actions (2.64).
Keyboard: arrows / Home / End / Enter on the list; Esc (or Back) returns to the
list in SinglePane mode. Live-region announces selection / pane changes (2.07).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | — |
| `titleRole` | `string` | — |
| `subtitleRole` | `string` | — |
| `filterText` | `string` | — |
| `filterRoles` | `var` | — |
| `filterDebounceMs` | `int` | Debounce ms before master filter rebuild (default **120**, 3.51). |
| `minFilterLength` | `int` | Skip filter until query length >= this (3.51 — parity with ItemsView). |
| `maxFilterResults` | `int` | Cap filtered master rows (default **256**, 3.51; `0` = unlimited). |
| `cacheBufferPx` | `int` | Master ListView overscan; `< 0` uses `max(240, height * 1.5)` (3.51 C22). |
| `selectedIndex` | `int` | — |
| `listPaneWidth` | `real` | — |
| `minWideWidth` | `real` | — |
| `details` | `alias` | — |
| `listHeader` | `alias` | — |
| `detailToolbar` | `alias` | — |
| `detailToolbarMode` | `string` | Detail toolbar visibility: always \| whenSelected \| never (2.82 D15). |
| `multiSelectEnabled` | `bool` | Master multi-select + bulk toolbar slot (2.64). |
| `connectedAnimationEnabled` | `bool` | Morph list row → details pane via ConnectedAnimationService |
| `connectedAnimationKey` | `string` | — |
| `accessibleName` | `string` | Screen-reader name override (1.19) |
| `listAccessibleName` | `string` | — |
| `announceChanges` | `bool` | Qt 6.8+ Accessible.announce for selection / pane changes (2.07). |
| `itemEnter` | `string` | Master list enter motion: none \| fade \| slide — 2.67 B2 |
| `itemExit` | `string` | Master list exit motion: none \| fade \| slide |
| `selectedItem` | `var` | — |
| `singlePaneDetailsOpen` | `bool` | — |
| `filteredCount` | `int` | — |
| `selectedItems` | `var` | — |
| `selectionCount` | `int` | — |
| `detailToolbarVisible` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `selectionChanged(int index, var item)` | — |
| `multiSelectionChanged(var items)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `isMultiSelected(item)` | — |
| `toggleMultiSelect(index)` | — |
| `selectAllMulti()` | — |
| `clearMultiSelection()` | — |
| `select(index)` | — |
| `showList()` | — |
| `showDetails()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
