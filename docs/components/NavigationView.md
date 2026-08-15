# NavigationView

WinUI NavigationView with pane modes and page stack.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/NavigationView.qml`](../../src/extras/QWinUI3/Extras/NavigationView.qml)

[← Component index](../components.md)

## Usage

```qml
NavigationView {
    anchors.fill: parent
    paneDisplayMode: "auto"
    model: navModel
    isPaneSearchEnabled: true
    pageModule: "MyApp"
}
```

## Properties

- `model: var` — Navigation items: [{ type, key, title, icon|symbol, children?, badge?, badgeValue? }]
- `currentIndex: int` — Selected index
- `paneOpen: bool` — Expanded pane when true (left / leftMinimal); compact modes force false
- `paneWidth: real` — Expanded pane width
- `paneCompactWidth: real` — Compact pane width
- `headerText: string` — Pane header title text
- `footerText: string` — Footer row label
- `footerSymbol: var` — Footer FluentIcons symbol
- `footerIcon: string` — Footer glyph string fallback
- `footerComponent: string` — Page component name loaded for the footer row (e.g. "SettingsPage")
- `pageModule: string` — QML import URI used to resolve page components
- `footerSelected: bool` — True when footer row is selected
- `paneDisplayMode: string` — WinUI PaneDisplayMode: left | leftCompact | leftMinimal | top | auto
- `autoCompactThreshold: real` — Width below which auto mode uses leftCompact
- `isBackButtonVisible: bool` — Show back button
- `isBackEnabled: bool` — Enable back button
- `isPaneSearchEnabled: bool` — Shows SearchBox at the top of the pane when open
- `paneSearchText: string` — Pane SearchBox text
- `paneSearchModel: var` — Suggestion model for pane SearchBox: [{ title, key?, component? }]
- `paneHeader: alias` — Custom pane header slot
- `paneFooter: alias` — Custom pane footer slot
- `isReorderable: bool` — Drag rows to reorder top-level model entries
- `hostContent: bool` — Shell host: show `content:` instead of StackView page loading (NavigationWindow).
- `content: alias` — Content slot / children host
- `effectiveFooterIcon: string` — Resolved footer icon
- `resolvedPaneMode: string` — Effective pane mode after auto
- `expandedMap: var` — groupKey -> bool; missing means expanded
- `currentKey: string` — Selected nav key (supports "group/0" child paths)
- `pendingMode: string` — Pending page transition: "slide" | "center"
- `pageItem: alias` — Current page item
- `currentComponent: string` — Current page component name

## Signals

- `footerClicked()` — Footer row clicked
- `itemClicked(int index)` — Emitted when an item is clicked
- `pageOpened(string name)` — Page was opened
- `backRequested()` — Emitted when back is requested
- `paneSearchActivated(string text)` — Pane search accepted
- `paneSearchTextEdited(string text)` — Pane search text changed
- `modelReordered(var model)` — Emitted after a successful drag-reorder with the new model array

## Methods

- `moveNavItem(fromIndex, toIndex)`
- `isGroupExpanded(key)`
- `rebuildNavModel()`
- `setGroupExpanded(key, expanded)`
- `selectionAnchorItem()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
