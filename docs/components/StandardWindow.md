# StandardWindow

Platform ApplicationWindow + PlatformTitleBar host.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/StandardWindow.qml`](../../src/platform/QWinUI3/Platform/StandardWindow.qml)

[← Component index](../components.md)

## Usage

```qml
StandardWindow {
    title: qsTr("Gallery")
    backdrop: WindowHelper.BackdropSolid
}
```

## Properties

- `paradigm: int` — Window paradigm
- `backdrop: int` — Backdrop kind
- `presenter: int` — Presenter kind
- `preferredHeightOption: int` — Title bar height option
- `autoInstall: bool` — Auto-apply WindowHelper chrome on complete
- `showCaptionButtons: bool` — Show caption buttons
- `showMinimize: bool` — Show minimize
- `showMaximize: bool` — Show maximize
- `showClose: bool` — Show close
- `isAlwaysOnTop: bool` — Always on top
- `extendsContentIntoTitleBar: bool` — Documents frameless / custom chrome (WinUI ExtendsContentIntoTitleBar).
- `chrome: alias` — WindowChrome / PlatformTitleBar host

## Methods

- `applyChrome()` — Apply window chrome / backdrop
- `setPresenterKind(kind)` — Set AppWindow presenter kind
- `onDarkChanged()`
- `onCornerPreferenceChanged()`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
