# PlatformCapability

Runtime feature probe (2.67 F1).

`import QWinUI3.Platform` · [`src/platform/QWinUI3/Platform/PlatformCapability.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/platform/QWinUI3/Platform/PlatformCapability.qml)

**Category:** Platform · **Library:** v3.56 · **singleton**

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `QtObject`.

## Example

```qml
if (PlatformCapability.mica)
    WindowHelper.backdrop = WindowHelper.BackdropMica
else if (PlatformCapability.blur)
    /* frost / solid fallback */

PlatformCapability.has("tray")
PlatformCapability.degradationHint("mica")
```

## Notes

Honest capability map for Mica / Acrylic / frost blur / tray / WebView2 / SNI.
UI should degrade when a flag is false — do not assume Win11 materials on Linux.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `mica` | `bool` | DWM Mica / Acrylic materials available (WindowHelper.supportsBackdrop) |
| `acrylic` | `bool` | — |
| `blur` | `bool` | Qt Quick Effects frost / client shell blur path |
| `tray` | `bool` | System tray host type is available on this build |
| `persistentTray` | `bool` | Persistent tray (Windows notify icon / Linux SNI when linked) |
| `webView` | `bool` | WebView2 host compiled-in and meaningful on Windows |
| `sni` | `bool` | Linux StatusNotifierItem path (tray on Plasma / many desktops) |
| `clientChrome` | `bool` | Client-side Fluent chrome (vs SSD) |
| `portal` | `bool` | Portal file / parent window helpers |

### Signals

_No custom signals_ (use inherited signals from the base type).

### Methods

| Signature | Description |
| --- | --- |
| `has(name)` | Query by name: mica \| acrylic \| blur \| frost \| tray \| webview \| webview2 \| sni \| portal |
| `degradationHint(name)` | Short UI copy when a capability is missing |

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
