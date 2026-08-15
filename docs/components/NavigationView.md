# NavigationView

WinUI NavigationView with pane modes and page stack.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/NavigationView.qml`](../../src/extras/QWinUI3/Extras/NavigationView.qml)

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
NavigationView {
    id: nav
    anchors.fill: parent
    paneDisplayMode: "auto"
    model: navModel
    isPaneSearchEnabled: true
    pageModule: "MyApp"
    onItemClicked: (index) => { /* … */ }
    onPageOpened: (name) => { /* … */ }
    onBackRequested: { /* … */ }
}

// --- API ---
// navigate: nav.selectKey("home"), nav.selectFooter(), nav.openPage("HomePage")
//           nav.openSlide("HomePage"), nav.openFromCenter("HomePage")
//           nav.navigateToTitle("Home"), nav.reloadPage()
// groups:   nav.toggleGroup(key), nav.setGroupExpanded(key, true)
// reorder:  nav.moveNavItem(from, to)   // requires isReorderable
// signals:  onItemClicked, onPageOpened, onFooterClicked, onBackRequested,
//           onPaneSearchActivated, onPaneSearchTextEdited, onModelReordered
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | Navigation items: [{ type, key, title, icon\|symbol, children?, badge?, badgeValue? }] |
| `currentIndex` | `int` | Selected index |
| `paneOpen` | `bool` | Expanded pane when true (left / leftMinimal); compact modes force false |
| `paneWidth` | `real` | Expanded pane width |
| `paneCompactWidth` | `real` | Compact pane width |
| `headerText` | `string` | Pane header title text |
| `footerText` | `string` | Footer row label |
| `footerSymbol` | `var` | Footer FluentIcons symbol |
| `footerIcon` | `string` | Footer glyph string fallback |
| `footerComponent` | `string` | Page component name loaded for the footer row (e.g. "SettingsPage") |
| `pageModule` | `string` | QML import URI used to resolve page components |
| `footerSelected` | `bool` | True when footer row is selected |
| `paneDisplayMode` | `string` | WinUI PaneDisplayMode: left \| leftCompact \| leftMinimal \| top \| auto |
| `autoCompactThreshold` | `real` | Width below which auto mode uses leftCompact |
| `isBackButtonVisible` | `bool` | Show back button |
| `isBackEnabled` | `bool` | Enable back button |
| `isPaneSearchEnabled` | `bool` | Shows SearchBox at the top of the pane when open |
| `paneSearchText` | `string` | Pane SearchBox text |
| `paneSearchModel` | `var` | Suggestion model for pane SearchBox: [{ title, key?, component? }] |
| `paneHeader` | `alias` | Custom pane header slot |
| `paneFooter` | `alias` | Custom pane footer slot |
| `isReorderable` | `bool` | Drag rows to reorder top-level model entries |
| `hostContent` | `bool` | Shell host: show `content:` instead of StackView page loading (NavigationWindow). |
| `content` | `alias` | Content slot / children host |
| `effectiveFooterIcon` | `string` | Resolved footer icon |
| `resolvedPaneMode` | `string` | Effective pane mode after auto |
| `expandedMap` | `var` | groupKey -> bool; missing means expanded |
| `currentKey` | `string` | Selected nav key (supports "group/0" child paths) |
| `pendingMode` | `string` | Pending page transition: "slide" \| "center" |
| `pageItem` | `alias` | Current page item |
| `currentComponent` | `string` | Current page component name |
| `flyoutGroupKey` | `string` | Group key for exclusive flyouts |
| `pendingFlyoutKey` | `string` | Key for a pending flyout |
| `pendingFlyoutAnchor` | `var` | Anchor item for a pending flyout |
| `flyoutHovered` | `bool` | True while the flyout is hovered |

### Signals

| Signature | Description |
| --- | --- |
| `footerClicked()` | Footer row clicked |
| `itemClicked(int index)` | Emitted when an item is clicked |
| `pageOpened(string name)` | Page was opened |
| `backRequested()` | Emitted when back is requested |
| `paneSearchActivated(string text)` | Pane search accepted |
| `paneSearchTextEdited(string text)` | Pane search text changed |
| `modelReordered(var model)` | Emitted after a successful drag-reorder with the new model array |

### Methods

| Signature | Description |
| --- | --- |
| `moveNavItem(fromIndex, toIndex)` | Reorder a top-level nav model entry (requires isReorderable) |
| `isGroupExpanded(key)` | True when the nav group is expanded |
| `rebuildNavModel()` | Rebuild the flattened ListModel from model |
| `setGroupExpanded(key, expanded)` | Expand or collapse a nav group by key |
| `selectionAnchorItem()` | Visual anchor item for the selection pip |
| `toggleGroup(key)` | Toggle a nav group expanded state |
| `groupTitle(key)` | Title text for a nav group key |
| `fillFlyoutModel(key)` | Populate the compact-mode group flyout model |
| `openCompactFlyout(groupKey, anchorItem)` | Open the compact pane group flyout |
| `requestCompactFlyout(groupKey, anchorItem)` | Schedule opening the compact flyout (hover delay) |
| `requestCloseCompactFlyout()` | Schedule closing the compact flyout |
| `componentForKey(key)` | Resolve page component name for a nav key |
| `flatIndexForKey(key)` | Flat list index for a nav key |
| `ensureSelectionVisible()` | Scroll so the current selection is on-screen |
| `selectIndex(index)` | Select a top-level model index (legacy) |
| `selectKey(key, mode)` | Select by nav key and open the page |
| `selectFooter(mode)` | Select the footer row and open footerComponent |
| `ensureComponent(name)` | Load / cache a page Component from pageModule |
| `openPage(name, mode)` | Replace the page stack with the named component |
| `openSlide(name)` | Left-nav style: content slides in from the left |
| `openFromCenter(name)` | Keep center-open API (scale + fade from middle) |
| `navigateToTitle(title, mode)` | Select the first nav item matching a title |
| `reloadPage()` | Reload the current page component |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors` / `x` / `y`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
