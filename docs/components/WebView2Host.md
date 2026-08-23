# WebView2Host

HWND-backed Edge WebView2 under a QQuickItem (Windows only).

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/WebView2Host.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/WebView2Host.h)

**Category:** Platform · **Library:** v2.65 · **C++ type**

[← Component index](../components.md)

**Gallery:** `WebView2` — [`src/gallery/pages/WebView2Page.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/WebView2Page.qml)

**Extends** `QQuickItem`.

## Example

```qml
WebView2Host {
    source: "https://example.com"
    anchors.fill: parent
}

Lifecycle: creates a child HWND + controller when attached to a window; destroys
on scene detach. Geometry follows mapToScene each frame (ScrollView / Flickable)
and clips to clip:true ancestors.

Missing Runtime: runtimeInstalled is false; statusMessage explains; Gallery shows EmptyState.
Focus: when the item gains activeFocus, focus moves into the browser (and back on blur).
Stable (1.18): Windows + Evergreen Runtime; see docs/webview2.md soak checklist.
```

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `source` | `QUrl` | — |
| `documentTitle` | `QString` | — |
| `canGoBack` | `bool` | — |
| `canGoForward` | `bool` | — |
| `loading` | `bool` | — |
| `available` | `bool` | — |
| `runtimeInstalled` | `bool` | — |
| `ready` | `bool` | — |
| `runtimeMissing` | `bool` | — |
| `statusMessage` | `QString` | — |
| `runtimeDownloadUrl` | `QString` | — |

### Signals

| Signature | Description |
| --- | --- |
| `sourceChanged()` | — |
| `documentTitleChanged()` | — |
| `navigationChanged()` | — |
| `loadingChanged()` | — |
| `statusMessageChanged()` | — |
| `navigationCompleted(bool success)` | — |
| `runtimeInstalledChanged()` | — |
| `readyChanged()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `reload()` | — |
| `stop()` | — |
| `goBack()` | — |
| `goForward()` | — |
| `navigate(const QUrl &url)` | — |
| `refreshRuntimeProbe()` | — |
| `focusBrowser()` | — |
| `blurBrowser()` | — |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
