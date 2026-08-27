# WebView2Host

Registers WebView2Host on QWinUI3.Platform.WebView2 (3.35 S12). Import that URI before instantiating WebView2Host — not part of Platform cold path.

`import QWinUI3.Platform.WebView2` · [`src/platform/QWinUI3/Platform/WebView2Host_qml.h`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/WebView2Host_qml.h)

**Category:** Platform · **Library:** v3.56 · **C++ type**

[← Component index](../components.md)

**Gallery:** `WebView2` — [`src/gallery/pages/WebView2Page.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/WebView2Page.qml)

**Extends** `QQuickItem`.

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
| `userDataFolder` | `QString` | — |

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
| `userDataFolderChanged()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `checkRuntimeInstalled() const)` | — |
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
