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
- `tabCount: int` — Tab Count
- `modelData: var`
- `index: int`
- `tabIndex: int` — Tab Index
- `dragActive: bool` — Drag Active

## Signals

- `tabCloseRequested(int index)` — User asked to close a tab
- `currentIndexChangedByUser(int index)` — Selection changed by user
- `selectionChanged(int index)` — Selection changed
- `tabMoved(int from, int to)` — Tab reordered
- `addTabButtonClicked()` — Add Tab Button Clicked

## Methods

- `addTab(item)` — Add Tab
- `closeTab(index)` — Close Tab
- `moveTab(from, to)` — Move Tab
- `tabIndexAtContentX(x)` — Tab Index At Content X
- `tabItemAt(index)`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
