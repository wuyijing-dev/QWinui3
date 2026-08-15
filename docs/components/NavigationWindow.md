# NavigationWindow

ShellWindow hosting NavigationView + content.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/NavigationWindow.qml`](../../src/extras/QWinUI3/Extras/NavigationWindow.qml)

[← Component index](../components.md)

## Usage

```qml
NavigationWindow {
    title: qsTr("App")
    paneDisplayMode: "left"
    navModel: [{ key: "home", title: "Home", symbol: FluentIcons.Home }]
    content: Label { text: "Hello" }
}
```

## Properties

- `paneOpen: alias` — Navigation pane expanded
- `paneWidth: alias` — Expanded pane width
- `paneHeaderText: alias` — NavigationWindow pane header text
- `paneDisplayMode: alias` — left | leftCompact | leftMinimal | top | auto
- `currentKey: alias` — Selected navigation key
- `content: alias` — Content slot / children host
- `navModel: alias` — NavigationView model
- `isBackEnabled: alias` — Enable back button
- `isPaneBackButtonVisible: alias` — Show back in the pane
- `isPaneSearchEnabled: alias` — Show pane SearchBox
- `paneSearchText: alias` — Pane SearchBox text
- `paneSearchModel: alias` — Pane search suggestion model
- `paneHeader: alias` — Custom pane header slot
- `paneFooter: alias` — Custom pane footer slot
- `footerText: alias` — Footer row label
- `footerSymbol: alias` — Footer FluentIcons symbol
- `footerIcon: alias` — Footer glyph string fallback
- `footerComponent: alias` — Footer page component

## Signals

- `navActivated(var item)` — Emitted when a nav item is activated
- `footerClicked()` — Footer row clicked
- `paneSearchActivated(string text)` — Pane search accepted

## Methods

- `onBackRequested()` — Forward NavigationView back request
- `onFooterClicked()` — Forward footer click
- `onPaneSearchActivated(text)` — Forward pane search activation
- `clearNav()` — Clear navigation model
- `addNavItem(item)` — Append a navigation item
- `addNavGroup(group)` — Append a navigation group
- `selectNavKey(key)`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
