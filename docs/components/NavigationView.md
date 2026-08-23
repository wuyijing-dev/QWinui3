# NavigationView

WinUI NavigationView with pane modes and page stack.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/NavigationView.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/NavigationView.qml)

**Category:** Navigation · **Library:** v2.80

[← Component index](../components.md)

**Gallery:** `NavigationView` — [`src/gallery/pages/NavigationViewPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/NavigationViewPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Item`.

## Example

```qml
NavigationView {
    id: nav
    anchors.fill: parent
    paneDisplayMode: "auto"
    paneAppearance: "standard"   // standard | minimal | branded
    model: navModel
    isPaneSearchEnabled: true
    pageModule: "MyApp"
    pinnedPageCache: ["HomePage", "SettingsPage"]
    onItemClicked: (index) => { /* … */ }
    onPageOpened: (name) => { /* … */ }
    onBackRequested: { /* … */ }
}

// --- API ---
// navigate: nav.selectKey("home"), nav.selectFooter(), nav.openPage("HomePage")
//           nav.reloadPage()  // force rebuild current page with transition
// Same-key / same-page clicks skip StackView replace + pageTransition.
//           nav.openSlide("HomePage"), nav.openFromCenter("HomePage")
//           nav.openFade("HomePage"), nav.openDrill("HomePage")
//           nav.navigateToTitle("Home"), nav.reloadPage()
//           nav.navigateToPage("DetailPage", "drill")  // in-page drill + history (2.56)
//           nav.clearPageCache()  // drop cached page Components (keep current)
// groups:   nav.toggleGroup(key), nav.setGroupExpanded(key, true)
// pane:     nav.togglePane()  // TitleBar hamburger; no-op when too narrow
//           compactPaneStyle "iconOnly" | "labeled"
// reorder:  nav.moveNavItem(from, to)   // requires isReorderable
// signals:  onItemClicked, onPageOpened, onFooterClicked, onBackRequested,
//           onPaneSearchActivated, onPaneSearchTextEdited, onModelReordered
```

## Notes

model entries: type "item"|"group"|"header"; groups use children[].
pageModule + component names load StackView pages (unless hostContent).
Pages compile on first open — not at shell startup; pageCacheLimit LRU (1.39).
paneAppearance: standard | minimal | branded (logo band + footer chrome — 2.68).
pinnedPageCache + pageCacheMemoryAware weighted LRU (2.68 C3).
initialPageTransition defaults to "none" for a snappy first paint.
paneDisplayMode auto: left → leftCompact → leftMinimal (drawer) by width.
leftMinimal / compact drawer overlay content with a light-dismiss scrim (Calculator-like).
Left-rail title bar is hamburger + paneTitle (paired); Back is top mode / TitleBar.
pageTransition / openPage modes: slide | slideRight | fade | center | drill |
up | down | cover | none (suppress). Pane clicks use pageTransition.
WinUI aliases: paneTitle, openPaneLength, compactPaneLength, isSettingsVisible, isPaneToggleButtonVisible.
compactPaneStyle: "iconOnly" (WinUI) | "labeled" (Store — icon above caption).
togglePane() — TitleBar hamburger; leftCompact expands inline or opens a drawer
when the window is too narrow; leftMinimal opens the overlay drawer.
Prefer selectKey / openPage over mutating currentIndex alone.
Live-region announces nav selection / pane expand (2.07) when announceChanges is true.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `announceChanges` | `bool` | Qt 6.8+ Accessible.announce for selection / pane changes (2.07). |
| `model` | `var` | Navigation items: [{ type, key, title, icon\|symbol, children?, badge?, badgeValue? }] |
| `currentIndex` | `int` | Selected index |
| `paneOpen` | `bool` | Expanded pane when true (left / leftMinimal); compact modes force false |
| `isPaneOpen` | `alias` | WinUI IsPaneOpen alias |
| `isPanePinned` | `bool` | When true, auto mode / scrim will not collapse the pane (2.56) |
| `isPaneVisible` | `bool` | WinUI IsPaneVisible — hide the navigation pane entirely when false |
| `alwaysShowHeader` | `bool` | WinUI AlwaysShowHeader — show the pane title bar in leftCompact (hamburger + title) |
| `paneWidth` | `real` | Expanded pane width (WinUI OpenPaneLength) |
| `openPaneLength` | `alias` | — |
| `paneCompactWidth` | `real` | Compact pane width (WinUI CompactPaneLength) |
| `compactPaneLength` | `alias` | — |
| `compactPaneStyle` | `string` | Compact rail: "iconOnly" (WinUI) or "labeled" (Store icon-above-caption) |
| `paneAppearance` | `string` | Pane chrome: "standard" \| "minimal" \| "branded" (2.68 A5) |
| `paneLogo` | `alias` | Logo slot for branded pane (Image / Item children) |
| `brandedTitle` | `string` | Optional brand title shown next to the logo band |
| `minContentWidth` | `real` | Minimum page width reserved when the left pane is expanded |
| `headerText` | `string` | Pane header title text (WinUI PaneTitle) |
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
| `autoCompactThreshold` | `real` | Width below which auto mode uses leftCompact (icon rail) |
| `autoMinimalThreshold` | `real` | Width below which auto mode uses leftMinimal (overlay drawer — Calculator-like) |
| `isBackButtonVisible` | `bool` | Show back in top pane mode only (left rail uses TitleBar / ShellWindow back) |
| `isBackEnabled` | `bool` | Enable back button |
| `isPaneSearchEnabled` | `bool` | Shows SearchBox at the top of the pane when open |
| `paneSearchText` | `string` | Pane SearchBox text |
| `paneSearchModel` | `var` | Suggestion model for pane SearchBox: [{ title, key?, component? }] |
| `paneSearchPlaceholder` | `string` | Placeholder for pane SearchBox (product apps: qsTr("Search photos")) |
| `paneHeader` | `alias` | Custom pane header slot |
| `paneFooter` | `alias` | Custom pane footer slot |
| `isReorderable` | `bool` | Drag rows to reorder top-level model entries |
| `hostContent` | `bool` | Shell host: show `content:` instead of StackView page loading (NavigationWindow). |
| `content` | `alias` | Content slot / children host |
| `pageHistory` | `var` | Soft navigation history for TitleBar / pane back (replace stack still applies) |
| `canGoBack` | `bool` | — |
| `effectiveBackVisible` | `bool` | TitleBar / ShellWindow: bind isBackButtonVisible to this (not a static true) |
| `effectiveBackEnabled` | `bool` | — |
| `hasLeftRail` | `bool` | True when a left navigation rail is active (TitleBar chrome) |
| `effectiveFooterIcon` | `string` | Resolved footer icon |
| `resolvedPaneMode` | `string` | Effective pane mode after auto |
| `expandedMap` | `var` | groupKey -> bool; missing means expanded |
| `currentKey` | `string` | Selected nav key (supports "group/0" child paths) |
| `pageTransition` | `string` | Default page transition for pane clicks (see openPage modes) |
| `initialPageTransition` | `string` | First openPage from Component.onCompleted (Gallery cold start — 1.39) |
| `pendingMode` | `string` | Last / pending page transition mode |
| `pageCacheLimit` | `int` | Max cached page Components from pageModule (0 = unlimited). LRU eviction (1.39). |
| `pinnedPageCache` | `var` | Page names never evicted by LRU (2.68 C3) |
| `pageCacheMemoryAware` | `bool` | Weight pinned pages as 2; prefer evicting unpinned oldest first (2.68 C3) |
| `pageCacheMemoryBudgetMb` | `int` | Weight budget (0 = derive from pageCacheLimit). Rough MB≈weight units. |
| `pageCacheHits` | `int` | Cached Component hits (diagnostics — 2.18). |
| `pageCacheCount` | `int` | Number of entries in the page Component cache |
| `sameKeySkipCount` | `int` | selectKey skipped — same nav key already active (diagnostics — 2.28). |
| `samePageSkipCount` | `int` | openPage skipped — same page component already showing (diagnostics — 2.28). |
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
| `togglePane()` | Toggle the left pane / overlay drawer |
| `groupTitle(key)` | Title text for a nav group key |
| `fillFlyoutModel(key)` | Populate the compact-mode group flyout model |
| `openCompactFlyout(groupKey, anchorItem)` | Open the compact pane group flyout |
| `requestCompactFlyout(groupKey, anchorItem)` | Schedule opening the compact flyout (hover delay) |
| `requestCloseCompactFlyout()` | Schedule closing the compact flyout |
| `componentForKey(key)` | Resolve page component name for a nav key |
| `keyForComponent(componentName)` | First nav key whose component matches (for search / featured → rail pip). |
| `titleForKey(key)` | Display title for a nav key (item or group/child path) |
| `breadcrumbPathForKey(key)` | Breadcrumb path for a nav key — [{ title, symbol?, navKey }] (2.23) |
| `breadcrumbModelForKey(key)` | Plain BreadcrumbBar model derived from breadcrumbPathForKey (2.23) |
| `navKeyForBreadcrumbIndex(key, index)` | navKey at breadcrumb index for the given selection key |
| `selectBreadcrumbIndex(index, mode)` | Select nav destination for a breadcrumb index (2.23) — no history push (2.56) |
| `flatIndexForKey(key)` | Flat list index for a nav key |
| `ensureSelectionVisible()` | Scroll so the current selection is on-screen |
| `selectIndex(index)` | Select a top-level model index (legacy) |
| `selectKey(key, mode, pageName)` | (Gallery search / hub pages that are not themselves rail entries). |
| `selectFooter(mode)` | Select the footer row and open footerComponent |
| `pushHistorySnapshot()` | Snapshot current selection for TitleBar back |
| `navigateBack(mode)` | Restore previous nav selection (slideRight by default) |
| `clearHistory()` | — |
| `clearPageCache(keepCurrent)` | Drop cached page Components. keepCurrent (default true) retains the open page type. |
| `ensureComponent(name)` | Load / cache a page Component from pageModule (lazy — not at shell startup) |
| `applyPageTransition(mode)` | Configure enter/exit transform targets for a named transition mode |
| `openPage(name, mode, forceReload)` | forceReload: true rebuilds even when the same page is already open (reloadPage). |
| `openSlide(name)` | Left-nav style: content slides in from the left |
| `openSlideRight(name)` | Forward slide from the right |
| `openFade(name)` | Opacity-only crossfade |
| `openDrill(name)` | Stronger scale drill-in (WinUI DrillIn–style) |
| `navigateToPage(name, mode)` | In-page drill/detail — records soft history so TitleBar Back works (2.56) |
| `openDrillWithHistory(name)` | — |
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
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
