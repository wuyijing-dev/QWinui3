# ShellWindow

Independent ApplicationWindow + WindowChrome host.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ShellWindow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ShellWindow.qml)

**Category:** Shells & windows · **Library:** v1.53

[← Component index](../components.md)

**Extends** `ApplicationWindow`.

## Example

```qml
ShellWindow {
    title: qsTr("App")
    symbol: FluentIcons.Home
    paradigm: WindowHelper.ParadigmStandard
    presenter: WindowHelper.PresenterOverlapped
}

// --- API ---
// roles:    paradigm (Standard/Dialog/Tool), presenter, isAlwaysOnTop, backdrop
// actions:  applyWindowRole(), setPresenterKind(k), setWindowParadigm(p),
//           setAlwaysOnTopEnabled(on), centerOnScreen()
// signals: onPaneToggleRequested, onBackRequested, onSearchActivated, onSearchTextEdited
// inherits ApplicationWindow (+ Qt Quick Controls base API)
```

## Notes

ApplicationWindow + WindowChrome; does not subclass StandardWindow.
Use BlankWindow / NavigationWindow / MenuStatusWindow / DialogShellWindow /
ToolShellWindow / CompactOverlayShellWindow for common layouts.
Title-bar slots: leftHeader, titleBarContent, rightHeader, menusInTitleBar.
Window roles (作用): paradigm + presenter + always-on-top via WindowHelper.
Backdrop / paradigm via WindowHelper (see docs/window-helper.md).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `subtitle` | `alias` | Secondary subtitle text |
| `symbol` | `alias` | FluentIcons symbol (preferred over iconGlyph) |
| `chrome` | `alias` | WindowChrome / PlatformTitleBar host |
| `shellSupport` | `alias` | Shared WindowHelper install glue |
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
| `effectiveBackdrop` | `int` | Platform-safe backdrop (Linux coerces Mica/Acrylic → Solid). |
| `preferredHeightOption` | `int` | WindowHelper.TitleBarHeightStandard \| TitleBarHeightTall |
| `presenter` | `int` | WindowHelper.Presenter* |
| `paradigm` | `int` | WindowHelper.Paradigm* |
| `isAlwaysOnTop` | `bool` | Keep window above others |
| `extendsContentIntoTitleBar` | `bool` | Custom frame / extend content |
| `geometryPersistenceKey` | `alias` | Non-empty → persist frame geometry (see ShellWindowSupport / WindowHelper). |
| `geometryPersistenceEnabled` | `bool` | — |
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
| `commandPaletteEnabled` | `bool` | Ctrl+K command palette (modern desktop launcher) |
| `commandPaletteCommands` | `var` | — |
| `commandPalette` | `alias` | — |
| `windowTitle` | `alias` | Compat aliases — prefer title / subtitle / symbol. |
| `windowSubtitle` | `alias` | Window subtitle alias |
| `windowSymbol` | `alias` | Window symbol alias |
| `windowRoleSummary` | `string` | Human-readable role summary for Gallery / diagnostics |

### Signals

| Signature | Description |
| --- | --- |
| `paneToggleRequested()` | Emitted when pane toggle is clicked |
| `backRequested()` | Emitted when back is requested |
| `searchActivated(var item)` | Emitted when a search result is activated |
| `searchTextEdited(string text)` | Emitted when search text changes |
| `commandTriggered(var command)` | Emitted when a CommandPalette command is run |

### Methods

| Signature | Description |
| --- | --- |
| `applyWindowRole()` | Re-apply paradigm + presenter + always-on-top + backdrop |
| `setPresenterKind(kind)` | Switch AppWindowPresenterKind at runtime |
| `setWindowParadigm(kind)` | Switch Standard / Dialog / Tool paradigm at runtime |
| `setAlwaysOnTopEnabled(on)` | Toggle stay-on-top |
| `centerOnScreen()` | Center on the current screen |
| `saveGeometry()` | — |
| `restoreGeometry()` | — |
| `clearSavedGeometry()` | — |

### Inherited from `ApplicationWindow`

Also available (base type / Qt Quick Controls):

- `title`
- `menuBar` / `header` / `footer`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
