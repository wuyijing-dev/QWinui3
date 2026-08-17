# ListDetailsView

Master–detail recipe on TwoPaneView.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ListDetailsView.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ListDetailsView.qml)

**Category:** Collections & data · **Library:** v1.78

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
Keyboard: arrows / Home / End / Enter on the list; Esc (or Back) returns to the
list in SinglePane mode. Pair with ItemsView for multi-select masters — see
docs/data-collections.md.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | — |
| `titleRole` | `string` | — |
| `subtitleRole` | `string` | — |
| `selectedIndex` | `int` | — |
| `listPaneWidth` | `real` | — |
| `minWideWidth` | `real` | — |
| `details` | `alias` | — |
| `listHeader` | `alias` | — |
| `connectedAnimationEnabled` | `bool` | Morph list row → details pane via ConnectedAnimationService |
| `connectedAnimationKey` | `string` | — |
| `accessibleName` | `string` | Screen-reader name override (1.19) |
| `listAccessibleName` | `string` | — |
| `selectedItem` | `var` | — |
| `singlePaneDetailsOpen` | `bool` | — |

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
