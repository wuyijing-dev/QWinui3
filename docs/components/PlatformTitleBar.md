# PlatformTitleBar

Caption buttons + drag region + TitleBar host.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/PlatformTitleBar.qml`](../../src/platform/QWinUI3/Platform/PlatformTitleBar.qml)

[← Component index](../components.md)

## Usage

```qml
PlatformTitleBar {
    targetWindow: window
    TitleBar { embedded: true; title: qsTr("App") }
}
```

## Properties

- `targetWindow: var` — Window this chrome is attached to
- `showCaptionButtons: bool` — Show caption buttons
- `showMinimize: bool` — Show minimize
- `showMaximize: bool` — Show maximize
- `showClose: bool` — Show close
- `preferredHeightOption: int` — Title bar height option
- `useNativeChrome: bool` — Use native NC hit-testing
- `resolvedCaptionHeight: real` — Resolved caption button height
- `titleContent: alias` — Title content slot
- `captionHeight: real` — Caption button row height
- `chromeBackground: color` — AppWindowTitleBar theming (WinUI caption button / chrome colors).
- `chromeInactive: bool` — Inactive chrome styling
- `buttonBackground: color` — Caption button rest fill
- `buttonHover: color` — Caption button hover fill
- `buttonPressed: color` — Caption button pressed fill
- `buttonForeground: color` — Caption button foreground
- `closeHover: color` — Close hover fill
- `closePressed: color` — Close pressed fill

## Methods

- `reportHitTest()` — Report title-bar hit-test layout to WindowHelper
- `screenRect(item)` — from GetWindowRect.

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
