# MenuStatusWindow

TitleBar + MenuBar + content + StatusBar shell.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MenuStatusWindow.qml`](../../src/extras/QWinUI3/Extras/MenuStatusWindow.qml)

[← Component index](../components.md)

## Usage

```qml
MenuStatusWindow {
    menusInTitleBar: true
    Menu { title: qsTr("File") }
    content: Label { text: "Body" }
    statusText: qsTr("Ready")
}
```

## Properties

- `menus: alias` — Declare Menu { } children here
- `statusText: alias` — StatusBar left text
- `statusBar: alias` — StatusBar instance
- `shellMenuBar: alias` — Shell MenuBar instance
- `content: alias` — Main client area
- `statusProgress: alias` — StatusBar progress 0..1
- `statusProgressIndeterminate: alias` — StatusBar indeterminate progress
- `statusCenter: alias` — StatusBar center slot
- `statusRight: alias` — StatusBar right slot
- `menusInTitleBar: bool` — Embed MenuBar in the title chrome instead of a strip below it

## Methods

- `addMenu(menu)` — Append a menu to the title-bar menus
- `clearMenus()` — Dismiss open menus
- `onImplicitWidthChanged()` — React to implicitWidth changes
- `onCountChanged()` — React to count changes

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
