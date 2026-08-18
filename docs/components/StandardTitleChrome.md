# StandardTitleChrome

PlatformTitleBar + TitleBar with WinUI header slots.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/StandardTitleChrome.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/StandardTitleChrome.qml)

**Category:** Other · **Library:** v2.64

[← Component index](../components.md)

**Extends** `PlatformTitleBar`.

## Example

```qml
StandardWindow {
    id: win
    header: StandardTitleChrome {
        targetWindow: win
        title: qsTr("App")
        rightHeader: Button { text: qsTr("Share"); flat: true }
    }
}

Same slot model as ShellWindow (leftHeader / titleBarContent / rightHeader).
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `extraContent` | `alias` | TitleBar is assigned to titleContent so it is not covered by extra controls. |
| `title` | `string` | Primary title text |
| `subtitle` | `string` | Secondary subtitle text |
| `symbol` | `var` | FluentIcons symbol |
| `leftHeader` | `alias` | WinUI LeftHeader slot |
| `titleBarContent` | `alias` | Title-bar middle content (menus, toolbar, …) |
| `searchEnabled` | `alias` | Built-in title-bar search |
| `searchText` | `alias` | — |
| `searchModel` | `alias` | — |
| `isBackButtonVisible` | `alias` | — |
| `isBackButtonEnabled` | `alias` | — |
| `isPaneToggleButtonVisible` | `alias` | — |

### Signals

| Signature | Description |
| --- | --- |
| `backRequested()` | — |
| `paneToggleRequested()` | — |
| `searchActivated(var item)` | — |
| `searchTextEdited(string text)` | — |

### Methods

_No custom methods_ (use inherited methods from the base type).

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
