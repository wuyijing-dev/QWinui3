# MenuStatusWindow

TitleBar + MenuBar + content + StatusBar shell.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/MenuStatusWindow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/MenuStatusWindow.qml)

**Category:** Shells & windows · **Library:** v1.77

[← Component index](../components.md)

**Extends** `ShellWindow`.

## Example

```qml
MenuStatusWindow {
    id: menuStatusWindow
    menusInTitleBar: true
    Menu { title: qsTr("File") }
    content: Label { text: "Body" }
    statusText: qsTr("Ready")
}

// --- API ---
// methods: addMenu(menu), clearMenus()
// menuStatusWindow.addMenu(menu)
// menuStatusWindow.clearMenus()
// inherits ShellWindow (+ Qt Quick Controls base API)
```

## Notes

ShellWindow with menusInTitleBar + multi-segment StatusBar.
Put Menu items in menus; status via StatusBar segments / statusText.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `menus` | `alias` | Declare Menu { } children here |
| `statusText` | `alias` | StatusBar left text |
| `statusBar` | `alias` | StatusBar instance |
| `shellMenuBar` | `alias` | Shell MenuBar instance |
| `content` | `alias` | Main client area |
| `statusProgress` | `alias` | StatusBar progress 0..1 |
| `statusProgressIndeterminate` | `alias` | StatusBar indeterminate progress |
| `statusCenter` | `alias` | StatusBar center slot |
| `statusRight` | `alias` | StatusBar right slot |
| `menusInTitleBar` | `bool` | Embed MenuBar in the title chrome instead of a strip below it |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `addMenu(menu)` | Append a menu to the title-bar menus |
| `clearMenus()` | Dismiss open menus |

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
