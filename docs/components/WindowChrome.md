# WindowChrome

PlatformTitleBar + TitleBar bundle for shells.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/WindowChrome.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/WindowChrome.qml)

**Category:** Shells & windows · **Library:** v3.56

[← Component index](../components.md)

> Internal / support type — not part of the public Gallery surface.

**Extends** `PlatformTitleBar`.

## Example

```qml
WindowChrome { targetWindow: root; title: qsTr("App") }

// --- API ---
// signals: onPaneToggleRequested, onBackRequested, onSearchActivated, onSearchTextEdited
// inherits PlatformTitleBar (+ Qt Quick Controls base API)
```

## Notes

Internal title-bar chrome for ShellWindow (caption + header slots).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | Primary title text |
| `subtitle` | `string` | Secondary subtitle text |
| `symbol` | `var` | FluentIcons symbol (preferred over iconGlyph) |
| `showPaneToggle` | `bool` | Show navigation pane toggle |
| `searchEnabled` | `bool` | Enable title-bar search |
| `isBackButtonVisible` | `alias` | Show back button |
| `isBackButtonEnabled` | `alias` | Enable back button |
| `leftHeader` | `alias` | WinUI LeftHeader slot |
| `titleBarContent` | `alias` | Title-bar middle content slot |
| `rightHeader` | `alias` | WinUI RightHeader inside TitleBar (Share, Settings beside title) |
| `captionRightHeader` | `alias` | WinUI RightHeader before caption buttons — alias of PlatformTitleBar.rightHeader |
| `searchText` | `alias` | Title-bar search field text |
| `searchModel` | `alias` | Title-bar search suggestions |
| `searchPlaceholder` | `alias` | Built-in title-bar search placeholder |
| `captionButtonBackground` | `color` | Caption button rest fill |
| `captionButtonHover` | `color` | Caption button hover fill |
| `captionButtonPressed` | `color` | Caption button pressed fill |
| `captionButtonForeground` | `color` | Caption button glyph color |
| `captionCloseHover` | `color` | Close button hover fill |
| `captionClosePressed` | `color` | Close button pressed fill |
| `titleBarBackground` | `color` | Title bar background color |
| `titleBarInactive` | `bool` | Dim title bar when inactive |

### Signals

| Signature | Description |
| --- | --- |
| `paneToggleRequested()` | Emitted when pane toggle is clicked |
| `backRequested()` | Emitted when back is requested |
| `searchActivated(var item)` | Emitted when a search result is activated |
| `searchTextEdited(string text)` | Emitted when search text changes |

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
