# PlatformTitleBar

Caption buttons + drag region + TitleBar host.

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/PlatformTitleBar.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/PlatformTitleBar.qml)

**Category:** Platform · **Library:** v2.67

[← Component index](../components.md)

**Extends** `Item`.

## Example

```qml
PlatformTitleBar {
    id: platformTitleBar
    targetWindow: window
    TitleBar { embedded: true; title: qsTr("App") }
}

// --- API ---
// methods: reportHitTest()
// platformTitleBar.reportHitTest()
```

## Notes

Caption host for StandardWindow; reports hit-test layout to WindowHelper.
Caption buttons use screen-logical rects (mapToGlobal).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `targetWindow` | `var` | Window this chrome is attached to |
| `showCaptionButtons` | `bool` | Show caption buttons |
| `showMinimize` | `bool` | Show minimize |
| `showMaximize` | `bool` | Show maximize |
| `showClose` | `bool` | Show close |
| `preferredHeightOption` | `int` | Title bar height option |
| `useNativeChrome` | `bool` | Use native NC hit-testing |
| `resolvedCaptionHeight` | `real` | Resolved caption button height |
| `titleContent` | `alias` | Title content slot |
| `rightHeader` | `alias` | WinUI RightHeader — before caption buttons (FrameStatsBadge, actions, …) |
| `captionHeight` | `real` | Caption button row height |
| `chromeBackground` | `color` | AppWindowTitleBar theming (WinUI caption button / chrome colors). |
| `chromeInactive` | `bool` | Inactive chrome styling |
| `buttonBackground` | `color` | Caption button rest fill |
| `buttonHover` | `color` | Caption button hover fill |
| `buttonPressed` | `color` | Caption button pressed fill |
| `buttonForeground` | `color` | Caption button foreground |
| `closeHover` | `color` | Close hover fill |
| `closePressed` | `color` | Close pressed fill |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `reportHitTest()` | Report title-bar hit-test layout to WindowHelper |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
