# TabView

Closeable / reorderable tabs.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TabView.qml`](../../src/extras/QWinUI3/Extras/TabView.qml)

[← Component index](../components.md)

## Usage

```qml
TabView {
    model: tabs
    onCloseRequested: (index) => remove(index)
}
```

## Properties

- `model: var` — model items: { title, content, icon? } or string title with empty content
- `currentIndex: int` — Selected index
- `selectedIndex: alias` — Selected index alias
- `closable: bool` — Shows a close affordance when true
- `isClosable: alias` — Alias of closable
- `tabsReorderable: bool` — Allow dragging tabs to reorder
- `canReorderTabs: alias` — Alias of tabsReorderable
- `tabWidthMode: string` — Tab width mode
- `isAddTabButtonVisible: bool` — Show add-tab button
- `tabCount: int` — Number of tabs

## Signals

- `tabCloseRequested(int index)` — User asked to close a tab
- `currentIndexChangedByUser(int index)` — Selection changed by user
- `selectionChanged(int index)` — Selection changed
- `tabMoved(int from, int to)` — Tab reordered
- `addTabButtonClicked()` — Emitted when the add-tab button is clicked

## Methods

- `addTab(item)` — Append a tab
- `closeTab(index)` — Close tab at index
- `moveTab(from, to)` — Move a tab from/to index
- `tabIndexAtContentX(x)` — Tab index under a contentX
- `tabItemAt(index)` — Tab item at the given index

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
