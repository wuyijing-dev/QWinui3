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
//           nav.openFade("HomePage"), nav.openDrill("HomePage")
//           nav.navigateToTitle("Home"), nav.reloadPage()
// groups:   nav.toggleGroup(key), nav.setGroupExpanded(key, true)
// reorder:  nav.moveNavItem(from, to)   // requires isReorderable
// signals:  onItemClicked, onPageOpened, onFooterClicked, onBackRequested,
//           onPaneSearchActivated, onPaneSearchTextEdited, onModelReordered
```

## Notes

model entries: type "item"|"group"|"header"; groups use children[].
pageModule + component names load StackView pages (unless hostContent).
paneDisplayMode auto switches left / leftCompact by width.
leftMinimal overlays content with a light-dismiss scrim.
Left-rail title bar is hamburger + paneTitle only (no Back); Back belongs on TitleBar / top mode.
When the rail title bar is shown, hamburger and title are always paired.
pageTransition / openPage modes: slide | slideRight | fade | center | drill |
up | down | cover | none (suppress). Pane clicks use pageTransition.
WinUI aliases: paneTitle, openPaneLength, compactPaneLength, isSettingsVisible, isPaneToggleButtonVisible.
Prefer selectKey / openPage over mutating currentIndex alone.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `model` | `var` | Navigation items: [{ type, key, title, icon\|symbol, children?, badge?, badgeValue? }] |
| `currentIndex` | `int` | Selected index |
| `paneOpen` | `bool` | Expanded pane when true (left / leftMinimal); compact modes force false |
| `isPaneOpen` | `alias` | WinUI IsPaneOpen alias |
| `isPaneVisible` | `bool` | WinUI IsPaneVisible — hide the navigation pane entirely when false |
| `alwaysShowHeader` | `bool` | WinUI AlwaysShowHeader — show the left-rail title bar (hamburger + paneTitle) in leftCompact |
| `paneWidth` | `real` | Expanded pane width (WinUI OpenPaneLength) |
| `openPaneLength` | `alias` | — |
| `paneCompactWidth` | `real` | Compact pane width (WinUI CompactPaneLength) |
| `compactPaneLength` | `alias` | — |
| `headerText` | `string` | Pane header title text (WinUI PaneTitle); always paired with the hamburger when the rail title bar is shown |
| `paneTitle` | `alias` | — |
| `footerText` | `string` | Footer row label |
| `footerSymbol` | `var` | Footer FluentIcons symbol |
| `footerIcon` | `string` | Footer glyph string fallback |
| `footerComponent` | `string` | Page component name loaded for the footer row (e.g. "SettingsPage") |
| `pageModule` | `string` | QML import URI used to resolve page components |
| `footerSelected` | `bool` | True when footer row is selected |
| `isSettingsVisible` | `bool` | WinUI IsSettingsVisible — show the settings/footer item |
| `isPaneToggleButtonVisible` | `bool` | WinUI IsPaneToggleButtonVisible — left-rail title bar (hamburger + paneTitle as a pair) |
| `paneDisplayMode` | `string` | WinUI PaneDisplayMode: left \| leftCompact \| leftMinimal \| top \| auto |
| `autoCompactThreshold` | `real` | Width below which auto mode uses leftCompact |
| `isBackButtonVisible` | `bool` | Show back in top pane mode (left rail uses TitleBar / ShellWindow back) |
| `isBackEnabled` | `bool` | Enable back button |
| `isPaneSearchEnabled` | `bool` | Shows SearchBox at the top of the pane when open |
| `paneSearchText` | `string` | Pane SearchBox text |
| `paneSearchModel` | `var` | Suggestion model for pane SearchBox: [{ title, key?, component? }] |
| `paneHeader` | `alias` | Custom pane header slot |
| `paneFooter` | `alias` | Custom pane footer slot |
| `isReorderable` | `bool` | Drag rows to reorder top-level model entries |
| `hostContent` | `bool` | Shell host: show `content:` instead of StackView page loading (NavigationWindow). |
| `content` | `alias` | Content slot / children host |
| `pageHistory` | `var` | Soft navigation history for TitleBar / pane back (replace stack still applies) |
| `canGoBack` | `bool` | — |
| `effectiveBackVisible` | `bool` | Top-pane / shell chrome back visibility |
| `effectiveBackEnabled` | `bool` | — |
| `effectiveFooterIcon` | `string` | Resolved footer icon |
| `resolvedPaneMode` | `string` | Effective pane mode after auto |
| `expandedMap` | `var` | groupKey -> bool; missing means expanded |
| `currentKey` | `string` | Selected nav key (supports "group/0" child paths) |
| `pageTransition` | `string` | Default page transition for pane clicks (see openPage modes) |
| `pendingMode` | `string` | Last / pending page transition mode |
| `pageTransitionModes` | `var` | Supported mode ids for Settings / Gallery pickers |
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
| `pushHistorySnapshot()` | Snapshot current selection for TitleBar back |
| `navigateBack(mode)` | Restore previous nav selection (slideRight by default) |
| `clearHistory()` | — |
| `ensureComponent(name)` | Load / cache a page Component from pageModule |
| `applyPageTransition(mode)` | Configure enter/exit transform targets for a named transition mode |
| `openPage(name, mode)` | Replace the page stack with the named component |
| `openSlide(name)` | Left-nav style: content slides in from the left |
| `openSlideRight(name)` | Forward slide from the right |
| `openFade(name)` | Opacity-only crossfade |
| `openDrill(name)` | Stronger scale drill-in (WinUI DrillIn–style) |
| `openUp(name)` | Vertical rise from below |
| `openDown(name)` | Vertical settle from above |
| `openCover(name)` | Covering slide from the right |
| `openNone(name)` | Instant swap (no motion) |
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
