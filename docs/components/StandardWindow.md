# StandardWindow

Platform ApplicationWindow + PlatformTitleBar host.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/StandardWindow.qml`](../../src/platform/QWinUI3/Platform/StandardWindow.qml)

[← Component index](../components.md)

**Extends** `ApplicationWindow`.

## Example

```qml
StandardWindow {
    id: standardWindow
    title: qsTr("Gallery")
    backdrop: WindowHelper.BackdropSolid
}

// --- API ---
// methods: applyChrome(), setPresenterKind(kind)
// standardWindow.applyChrome()
// standardWindow.setPresenterKind(kind)
// inherits ApplicationWindow (+ Qt Quick Controls base API)
```

## Notes

Low-level AppWindow host (PlatformTitleBar + WindowHelper).
Prefer ShellWindow family for product UI; use this for presenter/backdrop experiments.
See docs/window-appwindow.md and docs/window-helper.md.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `paradigm` | `int` | Window paradigm |
| `backdrop` | `int` | Backdrop kind |
| `presenter` | `int` | Presenter kind |
| `preferredHeightOption` | `int` | Title bar height option |
| `autoInstall` | `bool` | Auto-apply WindowHelper chrome on complete |
| `showCaptionButtons` | `bool` | Show caption buttons |
| `showMinimize` | `bool` | Show minimize |
| `showMaximize` | `bool` | Show maximize |
| `showClose` | `bool` | Show close |
| `isAlwaysOnTop` | `bool` | Always on top |
| `extendsContentIntoTitleBar` | `bool` | Documents frameless / custom chrome (WinUI ExtendsContentIntoTitleBar). |
| `chrome` | `alias` | WindowChrome / PlatformTitleBar host |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `applyChrome()` | Apply window chrome / backdrop |
| `setPresenterKind(kind)` | Set AppWindow presenter kind |

### Inherited from `ApplicationWindow`

Also available (base type / Qt Quick Controls):

- `title`
- `visible`
- `menuBar` / `header` / `footer`
- `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
