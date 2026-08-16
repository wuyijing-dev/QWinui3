# TabView

Closeable / reorderable / tear-out tabs.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TabView.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TabView.qml)

**Category:** Navigation · **Library:** v1.07

[← Component index](../components.md)

**Gallery:** `TabView` — [`src/gallery/pages/TabViewPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TabViewPage.qml)

**Extends** `Control`.

## Example

```qml
TabView {
    id: tabView
    model: tabs
    canTearOutTabs: true
    onTabTearOutRequested: (index, item, gx, gy) => { … }
}

// --- API ---
// signals: onTabCloseRequested, onCurrentIndexChangedByUser, onSelectionChanged,
//          onTabMoved, onAddTabButtonClicked, onTabTearOutRequested
// methods: addTab(item), closeTab(index), moveTab(from, to), takeTab(index),
//          tearOutTab(index, globalX, globalY), tabIndexAtContentX(x), tabItemAt(index)
// tabView.addTab(item)
// tabView.closeTab(index)
// tabView.moveTab(from, to)
// tabView.tearOutTab(index, gx, gy)
```

## Notes

model items: { title, content, icon? } or a string title.
closable tabs emit closeRequested / tabCloseRequested — remove from model yourself.
closeButtonOverlayMode: always | onPointerOver | auto (WinUI CloseButtonOverlayMode).
tabStripHeader / tabStripFooter for strip chrome; tabsReorderable enables drag reorder.
canTearOutTabs: drag a tab vertically past tearOutThreshold to open a new window
(or handle tabTearOutRequested yourself). createTearOutWindow builds a BlankWindow
hosting another TabView with the torn tab.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | model items: { title, content, icon? } or string title with empty content |
| `currentIndex` | `int` | Selected index |
| `selectedIndex` | `alias` | Selected index alias |
| `closable` | `bool` | Shows a close affordance when true |
| `isClosable` | `alias` | Alias of closable |
| `closeButtonOverlayMode` | `string` | WinUI CloseButtonOverlayMode: "always" \| "onPointerOver" \| "auto" |
| `tabsReorderable` | `bool` | Allow dragging tabs to reorder |
| `canReorderTabs` | `alias` | Alias of tabsReorderable |
| `canDragTabs` | `bool` | WinUI CanDragTabs — enable drag gesture (reorder still gated by tabsReorderable) |
| `canTearOutTabs` | `bool` | Drag a tab out of the strip to tear it into a new window |
| `allowTearOutLastTab` | `bool` | Allow tearing out when only one tab remains |
| `tearOutThreshold` | `real` | Vertical drag distance (px) before a tear-out is armed |
| `createTearOutWindow` | `bool` | When true, TabView opens a BlankWindow for torn tabs (still emits the signal) |
| `tabWidthMode` | `string` | Tab width mode |
| `isAddTabButtonVisible` | `bool` | Show add-tab button |
| `tabStripHeader` | `alias` | WinUI TabStripHeader |
| `tabStripFooter` | `alias` | WinUI TabStripFooter |
| `selectedItem` | `var` | Currently selected model item (WinUI SelectedItem) |
| `tabCount` | `int` | Number of tabs |

### Signals

| Signature | Description |
| --- | --- |
| `tabCloseRequested(int index)` | User asked to close a tab |
| `currentIndexChangedByUser(int index)` | Selection changed by user |
| `selectionChanged(int index)` | Selection changed |
| `tabMoved(int from, int to)` | Tab reordered |
| `addTabButtonClicked()` | Emitted when the add-tab button is clicked |
| `tabTearOutRequested(int index, var item, real globalX, real globalY)` | Tab torn out — item already removed from model when tearOutTab runs |

### Methods

| Signature | Description |
| --- | --- |
| `addTab(item)` | Append a tab |
| `closeTab(index)` | Close tab at index |
| `takeTab(index)` | Remove tab and return its model item (no close signal) |
| `tearOutTab(index, globalX, globalY)` | Tear tab into a new window (optional) and emit tabTearOutRequested |
| `moveTab(from, to)` | Move a tab from/to index |
| `tabIndexAtContentX(x)` | Tab index under a contentX |
| `tabItemAt(index)` | Tab item at the given index |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
