# ListDetailsView

Master–detail recipe on TwoPaneView.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ListDetailsView.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ListDetailsView.qml)

**Category:** Collections & data · **Library:** v2.62

[← Component index](../components.md)

**Gallery:** `ListDetailsView` — [`src/gallery/pages/ListDetailsViewPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ListDetailsViewPage.qml)

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
// listHeader / details slots; connectedAnimationEnabled (+ key)
```

## Notes

ListView master + details host. Collapses via TwoPaneView on narrow widths.
model items may be strings or objects (titleRole / subtitleRole).
Optional filterText filters plain JS arrays (debounced, 1.88).
Selection tracks item **object** across filter rebuilds (2.18).
Keyboard: arrows / Home / End / Enter on the list; Esc (or Back) returns to the
list in SinglePane mode. Pair with ItemsView for multi-select masters — see
docs/data-collections.md. Live-region announces selection / pane changes (2.07).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | — |
| `titleRole` | `string` | — |
| `subtitleRole` | `string` | — |
| `filterText` | `string` | — |
| `filterRoles` | `var` | — |
| `filterDebounceMs` | `int` | — |
| `maxFilterResults` | `int` | Cap filtered master rows (0 = unlimited) — 2.18. |
| `selectedIndex` | `int` | — |
| `listPaneWidth` | `real` | — |
| `minWideWidth` | `real` | — |
| `details` | `alias` | — |
| `listHeader` | `alias` | — |
| `connectedAnimationEnabled` | `bool` | Morph list row → details pane via ConnectedAnimationService |
| `connectedAnimationKey` | `string` | — |
| `accessibleName` | `string` | Screen-reader name override (1.19) |
| `listAccessibleName` | `string` | — |
| `announceChanges` | `bool` | Qt 6.8+ Accessible.announce for selection / pane changes (2.07). |
| `selectedItem` | `var` | — |
| `singlePaneDetailsOpen` | `bool` | — |
| `filteredCount` | `int` | — |

### Signals

| Signature | Description |
| --- | --- |
| `selectionChanged(int index, var item)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `select(index)` | — |
| `showList()` | — |
| `showDetails()` | — |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
