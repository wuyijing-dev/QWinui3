# NavigationWindow

ShellWindow hosting NavigationView + content.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/NavigationWindow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/NavigationWindow.qml)

**Category:** Shells & windows · **Library:** v2.80

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `ShellWindow`.

## Example

```qml
// Simple hostContent slot:
NavigationWindow {
    navModel: [{ key: "home", title: "Home", symbol: FluentIcons.Home }]
    content: Label { text: "Hello" }
}

// Gallery-style pageModule shell (1.50):
NavigationWindow {
    geometryPersistenceKey: "MyAppMain"
    hostContent: false
    pageModule: "MyApp"
    footerText: qsTr("Settings")
    footerComponent: "SettingsPage"
    navModel: [{ key: "home", title: qsTr("Home"),
                 symbol: FluentIcons.Home, component: "HomePage" }]
}

// --- API ---
// signals: onNavActivated, onFooterClicked, onPaneSearchActivated, onPaneSearchTextEdited
// search: searchPlaceholder (title bar), paneSearchPlaceholder, onSearchTextEdited (title)
// chrome.titleBarContent: replace built-in search with domain SearchBox (see docs/search.md)
// methods: clearNav(), addNavItem(item), addNavGroup(group), selectNavKey(key), navigateBack()
// inherits ShellWindow (+ Qt Quick Controls base API)
```

## Notes

ShellWindow hosting NavigationView. Default hostContent + content slot;
set hostContent: false + pageModule for StackView pages (Gallery / examples/gallery-shell).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `paneOpen` | `alias` | Navigation pane expanded |
| `paneWidth` | `alias` | Expanded pane width |
| `paneHeaderText` | `alias` | NavigationWindow pane header text |
| `isPanePinned` | `alias` | When true, pane stays open across auto/scrim dismiss (2.56) |
| `autoMinimalThreshold` | `alias` | Width below which auto mode uses leftMinimal overlay drawer |
| `paneDisplayMode` | `alias` | left \| leftCompact \| leftMinimal \| top \| auto |
| `currentKey` | `alias` | Selected navigation key |
| `content` | `alias` | Content slot / children host (when hostContent) |
| `navModel` | `alias` | NavigationView model |
| `isBackEnabled` | `alias` | Enable back button |
| `isPaneBackButtonVisible` | `alias` | Show back in the pane |
| `isPaneSearchEnabled` | `alias` | Show pane SearchBox |
| `paneSearchText` | `alias` | Pane SearchBox text |
| `paneSearchModel` | `alias` | Pane search suggestion model |
| `paneSearchPlaceholder` | `alias` | Pane SearchBox placeholder (real-time filter via onPaneSearchTextEdited) |
| `paneHeader` | `alias` | Custom pane header slot |
| `paneFooter` | `alias` | Custom pane footer slot |
| `footerText` | `alias` | Footer row label |
| `footerSymbol` | `alias` | Footer FluentIcons symbol |
| `footerIcon` | `alias` | Footer glyph string fallback |
| `footerComponent` | `alias` | Footer page component |
| `pageModule` | `alias` | QML module URI for page components (1.50) |
| `hostContent` | `alias` | true = content slot; false = StackView via pageModule (Gallery pattern) |
| `pageTransition` | `alias` | Page enter transition name |
| `initialPageTransition` | `alias` | First openPage transition (default none — 1.39 cold start) |
| `pageCacheLimit` | `alias` | LRU page Component cache cap (0 = unlimited) |
| `pageCacheHits` | `alias` | Cached page Component hits (diagnostics — 2.18) |
| `pageCacheCount` | `alias` | Entries in page Component cache |
| `sameKeySkipCount` | `alias` | selectKey skips when destination already selected (2.28) |
| `samePageSkipCount` | `alias` | openPage skips when same component already open (2.28) |
| `canGoBack` | `alias` | TitleBar / pane can go back |
| `effectiveBackVisible` | `alias` | Bind TitleBar isBackButtonVisible to these — not a static true (2.56) |
| `effectiveBackEnabled` | `alias` | — |
| `syncSubtitleFromNavigation` | `bool` | Mirror last breadcrumb segment into ShellWindow.subtitle (2.23) |

### Signals

| Signature | Description |
| --- | --- |
| `navActivated(var item)` | Emitted when a nav item is activated |
| `footerClicked()` | Footer row clicked |
| `paneSearchActivated(string text)` | Pane search accepted |
| `paneSearchTextEdited(string text)` | Pane search text changed (live filter — mirrors ShellWindow.searchTextEdited) |

### Methods

| Signature | Description |
| --- | --- |
| `clearNav()` | Clear navigation model |
| `addNavItem(item)` | Append a navigation item |
| `addNavGroup(group)` | Append a navigation group |
| `selectNavKey(key)` | Forward selection to the hosted NavigationView |
| `navigateBack(mode)` | Restore previous page (TitleBar Back) |
| `navigateToPage(name, mode)` | In-page drill with soft history (2.56) |
| `clearPageCache(keepCurrent)` | Drop cached page Components (keeps current page by default) |
| `breadcrumbPathForKey(key)` | Breadcrumb helpers — forward to hosted NavigationView (2.23) |
| `breadcrumbModelForKey(key)` | — |
| `selectBreadcrumbIndex(index, mode)` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
