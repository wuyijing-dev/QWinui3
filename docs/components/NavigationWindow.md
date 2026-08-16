# NavigationWindow

ShellWindow hosting NavigationView + content.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/NavigationWindow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/NavigationWindow.qml)

**Category:** Shells & windows · **Library:** v1.06

[← Component index](../components.md)

**Extends** `ShellWindow`.

## Example

```qml
NavigationWindow {
    id: navigationWindow
    title: qsTr("App")
    paneDisplayMode: "left"
    navModel: [{ key: "home", title: "Home", symbol: FluentIcons.Home }]
    content: Label { text: "Hello" }
}

// --- API ---
// signals: onNavActivated, onFooterClicked, onPaneSearchActivated
// methods: clearNav(), addNavItem(item), addNavGroup(group), selectNavKey(key)
// navigationWindow.clearNav()
// navigationWindow.addNavItem(item)
// navigationWindow.addNavGroup(group)
// navigationWindow.selectNavKey(key)
// inherits ShellWindow (+ Qt Quick Controls base API)
```

## Notes

ShellWindow hosting NavigationView with hostContent.
Wire navModel / paneDisplayMode; content goes in the NavigationView content slot.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `paneOpen` | `alias` | Navigation pane expanded |
| `paneWidth` | `alias` | Expanded pane width |
| `paneHeaderText` | `alias` | NavigationWindow pane header text |
| `paneDisplayMode` | `alias` | left \| leftCompact \| leftMinimal \| top \| auto |
| `currentKey` | `alias` | Selected navigation key |
| `content` | `alias` | Content slot / children host |
| `navModel` | `alias` | NavigationView model |
| `isBackEnabled` | `alias` | Enable back button |
| `isPaneBackButtonVisible` | `alias` | Show back in the pane |
| `isPaneSearchEnabled` | `alias` | Show pane SearchBox |
| `paneSearchText` | `alias` | Pane SearchBox text |
| `paneSearchModel` | `alias` | Pane search suggestion model |
| `paneHeader` | `alias` | Custom pane header slot |
| `paneFooter` | `alias` | Custom pane footer slot |
| `footerText` | `alias` | Footer row label |
| `footerSymbol` | `alias` | Footer FluentIcons symbol |
| `footerIcon` | `alias` | Footer glyph string fallback |
| `footerComponent` | `alias` | Footer page component |

### Signals

| Signature | Description |
| --- | --- |
| `navActivated(var item)` | Emitted when a nav item is activated |
| `footerClicked()` | Footer row clicked |
| `paneSearchActivated(string text)` | Pane search accepted |

### Methods

| Signature | Description |
| --- | --- |
| `clearNav()` | Clear navigation model |
| `addNavItem(item)` | Append a navigation item |
| `addNavGroup(group)` | Append a navigation group |
| `selectNavKey(key)` | Forward selection to the hosted NavigationView |

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
