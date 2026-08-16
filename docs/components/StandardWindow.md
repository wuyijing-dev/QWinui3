# StandardWindow

Platform ApplicationWindow + PlatformTitleBar host.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/StandardWindow.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/StandardWindow.qml)

**Category:** Platform · **Library:** v1.21

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
effectiveBackdrop / WindowHelper.resolveBackdrop keep Linux shells opaque when Mica is requested.
Runtime: backdrop/paradigm changes, first-show reapply, DPI → Theme + hit-test (see docs/window-chrome.md).
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
| `effectiveBackdrop` | `int` | Platform-safe backdrop (Linux coerces Mica/Acrylic → Solid so the window is not hollow). |

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
- `menuBar` / `header` / `footer`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
