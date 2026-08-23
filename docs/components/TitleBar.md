# TitleBar

WinUI TitleBar content chrome (not caption buttons).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/TitleBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/TitleBar.qml)

**Category:** Shells & windows · **Library:** v2.81

[← Component index](../components.md)

**Gallery:** `TitleBar` — [`src/gallery/pages/TitleBarPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/TitleBarPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Item`.

## Example

```qml
TitleBar {
    id: titleBar
    title: qsTr("App")
    subtitle: qsTr("Optional")
    symbol: FluentIcons.Home
}

// --- API ---
// signals: onSearchActivated, onSearchTextEdited, onBackRequested, onPaneToggleRequested
// methods: clientExcludeRectsFor(window)
// titleBar.clientExcludeRectsFor(window)
```

## Notes

WinUI-style title bar for ShellWindow / WindowChrome / **StandardTitleChrome**.
Header slots: leftHeader, content (titleBarContent on shells), rightHeader.
StandardTitleChrome.rightHeader → PlatformTitleBar (before captions); ShellWindow.rightHeader → TitleBar.
Cookbook: docs/title-bar-cookbook.md. Slot layout changes auto-refresh Windows NC hit-test via notifyChromeHitTest().

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Primary title text |
| `subtitle` | `string` | Secondary subtitle text |
| `iconSource` | `url` | Image icon when symbol / iconGlyph are empty |
| `symbol` | `var` | FluentIcons value (preferred over iconGlyph) |
| `iconGlyph` | `string` | Raw Fluent glyph string fallback |
| `searchText` | `alias` | Title-bar search field text |
| `searchModel` | `var` | Suggestion rows for the built-in search field |
| `searchPlaceholder` | `string` | Placeholder for built-in search (product apps; Gallery sets qsTr("Search controls")) |
| `searchEnabled` | `bool` | When true and content slot is empty, show built-in search field. |
| `isBackButtonVisible` | `bool` | Show back button |
| `isBackButtonEnabled` | `bool` | Enable back button |
| `isPaneToggleButtonVisible` | `bool` | Show navigation pane toggle |
| `embedded` | `bool` | Hosted inside PlatformTitleBar / WindowChrome (hides local acrylic plate) |
| `useSystemMove` | `bool` | Use Window.startSystemMove for caption drag |
| `trailingReserve` | `real` | Extra right inset when caption buttons are drawn outside this item |
| `dragWindow` | `var` | Window used for system move |
| `preferredHeight` | `real` | WinUI TitleBarHeightOption — Standard 32 / Tall 48 (from PlatformTitleBar). |
| `effectiveIconGlyph` | `string` | Resolved glyph string |
| `hasContentChildren` | `bool` | Content slot has children |
| `showBuiltInSearch` | `bool` | Show built-in search field |
| `leftHeader` | `alias` | WinUI LeftHeader slot |
| `content` | `alias` | WinUI Content slot (replaces built-in search when set) |
| `rightHeader` | `alias` | uses PlatformTitleBar.rightHeader (before caption buttons) instead. |
| `trailing` | `alias` | Trailing slot |

### Signals

| Signature | Description |
| --- | --- |
| `searchActivated(var item)` | Emitted when a search result is activated |
| `searchTextEdited(string text)` | Emitted when search text changes |
| `backRequested()` | Emitted when back is requested |
| `paneToggleRequested()` | Emitted when pane toggle is clicked |

### Methods

| Signature | Description |
| --- | --- |
| `clientExcludeRectsFor(window)` | whole fill-width slot (caption drag vs menu clicks). |
| `notifyChromeHitTest()` | Ask ancestor PlatformTitleBar / WindowChrome to refresh NC hit-test after slot layout changes. |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
