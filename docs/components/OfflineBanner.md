# OfflineBanner

InfoBar bound to WindowHelper.isOnline (2.78).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/OfflineBanner.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/OfflineBanner.qml)

**Category:** Other · **Library:** v3.56

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Item`.

## Example

```qml
OfflineBanner { }
OfflineBanner { pollMs: 5000 }
```

## Notes

Calls WindowHelper.refreshOnlineStatus on a timer.
User dismiss sticks while still offline; banner returns when going offline again
after a reconnect (or forceShow).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `pollMs` | `int` | — |
| `forceShow` | `bool` | — |
| `title` | `string` | — |
| `message` | `string` | — |
| `closableWhenOffline` | `bool` | — |
| `online` | `bool` | — |
| `isOpen` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `retryClicked()` | — |
| `dismissed()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `refresh()` | — |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
