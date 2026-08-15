# ShellWindow

Independent ApplicationWindow + WindowChrome host.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ShellWindow.qml`](../../src/extras/QWinUI3/Extras/ShellWindow.qml)

[← Component index](../components.md)

**Extends** `ApplicationWindow`.

## Example

```qml
ShellWindow {
    title: qsTr("App")
    symbol: FluentIcons.Home
}

// --- API ---
// signals: onPaneToggleRequested, onBackRequested, onSearchActivated, onSearchTextEdited
// inherits ApplicationWindow (+ Qt Quick Controls base API)
```

## Notes

ApplicationWindow + WindowChrome; does not subclass StandardWindow.
Use BlankWindow / NavigationWindow / MenuStatusWindow / DialogShellWindow /
ToolShellWindow / CompactOverlayShellWindow for common layouts.
Title-bar slots: leftHeader, titleBarContent, rightHeader, menusInTitleBar.
Backdrop / paradigm via WindowHelper (see docs/window-helper.md).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `subtitle` | `alias` | Secondary subtitle text |
| `symbol` | `alias` | FluentIcons symbol (preferred over iconGlyph) |
| `chrome` | `alias` | WindowChrome / PlatformTitleBar host |
| `showPaneToggle` | `bool` | Show navigation pane toggle |
| `searchEnabled` | `alias` | Enable title-bar search |
| `isBackButtonVisible` | `alias` | Show back button |
| `isBackButtonEnabled` | `alias` | Enable back button |
| `leftHeader` | `alias` | WinUI LeftHeader slot |
| `titleBarContent` | `alias` | Extra title-bar middle content (e.g. MenuBar when menusInTitleBar) |
| `rightHeader` | `alias` | WinUI RightHeader slot |
| `searchText` | `alias` | Title-bar search field text |
| `searchModel` | `alias` | Title-bar search suggestions |
| `backdrop` | `int` | WindowHelper.Backdrop* |
| `preferredHeightOption` | `int` | WindowHelper.TitleBarHeightStandard \| TitleBarHeightTall |
| `presenter` | `int` | WindowHelper.Presenter* |
| `paradigm` | `int` | WindowHelper.Paradigm* |
| `isAlwaysOnTop` | `bool` | Keep window above others |
| `extendsContentIntoTitleBar` | `bool` | Custom frame / extend content |
| `showCaptionButtons` | `bool` | Show min/max/close |
| `showMinimize` | `bool` | Show minimize caption button |
| `showMaximize` | `bool` | Show maximize caption button |
| `showClose` | `bool` | Show close caption button |
| `captionButtonBackground` | `color` | AppWindowTitleBar-style caption colors (empty = Theme defaults). |
| `captionButtonHover` | `color` | Caption button hover fill |
| `captionButtonPressed` | `color` | Caption button pressed fill |
| `captionButtonForeground` | `color` | Caption button glyph color |
| `captionCloseHover` | `color` | Close button hover fill |
| `captionClosePressed` | `color` | Close button pressed fill |
| `titleBarBackground` | `color` | Title bar background color |
| `titleBarInactive` | `bool` | Dim title bar when inactive |
| `windowTitle` | `alias` | Compat aliases — prefer title / subtitle / symbol. |
| `windowSubtitle` | `alias` | Window subtitle alias |
| `windowSymbol` | `alias` | Window symbol alias |

### Signals

| Signature | Description |
| --- | --- |
| `paneToggleRequested()` | Emitted when pane toggle is clicked |
| `backRequested()` | Emitted when back is requested |
| `searchActivated(var item)` | Emitted when a search result is activated |
| `searchTextEdited(string text)` | Emitted when search text changes |

### Methods

_No custom methods_ (use inherited methods from the base type).

### Inherited from `ApplicationWindow`

Also available (base type / Qt Quick Controls):

- `title`
- `visible`
- `menuBar` / `header` / `footer`
- `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
