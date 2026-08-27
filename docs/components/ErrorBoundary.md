# ErrorBoundary

Recovery UI for failed page / session loads (2.75).

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ErrorBoundary.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ErrorBoundary.qml)

**Category:** Other · **Library:** v3.56

[← Component index](../components.md)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Item`.

## Example

```qml
ErrorBoundary {
    id: boundary
    title: qsTr("Something went wrong")
    message: qsTr("Reload this view or restore the last session.")
    sessionRestore: session // optional SessionRestore
    onRetryRequested: loader.active = false; loader.active = true
}
```

## Notes

Shows an InfoBar-style recovery surface. Does not catch native crashes;
pair with QQmlEngine warnings / Loader status in app code.

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `title` | `string` | — |
| `message` | `string` | — |
| `isOpen` | `bool` | — |
| `sessionRestore` | `var` | — |
| `showSessionRestore` | `bool` | — |

### Signals

| Signature | Description |
| --- | --- |
| `retryRequested()` | — |
| `sessionRestoreRequested()` | — |

### Methods

| Signature | Description |
| --- | --- |
| `open()` | — |
| `close()` | — |
| `retry()` | — |
| `restoreSession()` | — |

### Inherited from `Item`

Also available (base type / Qt Quick Controls):

- `width` / `height`
- `visible`
- `anchors`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
