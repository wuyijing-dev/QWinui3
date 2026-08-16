# ToastHost

Hosts stacked Toasts.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ToastHost.qml`](../../src/extras/QWinUI3/Extras/ToastHost.qml)

[← Component index](../components.md)

**Extends** `Control`.

## Example

```qml
// Gallery: put ToastHost in CatalogPage.overlay (not scrolled)
CatalogPage {
    overlay: ToastHost {
        id: toasts
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        width: 360
    }
    // …
}
toasts.info(qsTr("Hello"))
toasts.success(qsTr("Done"))
```

## Notes

Stack host for Toast; info/success/warning/error enqueue helpers.
In Gallery, declare under `CatalogPage.overlay` so toasts float above the scroll
host. See [`gallery-catalog-page.md`](../gallery-catalog-page.md).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `maxVisible` | `int` | Max visible items before overflow |
| `durationMs` | `int` | Auto-dismiss duration; 0 keeps open |
| `newestOnTop` | `bool` | Stack newest items on top |
| `informational` | `int` | Informational severity constant |
| `success` | `int` | Success severity constant |
| `warning` | `int` | Warning severity constant |
| `error` | `int` | Error severity constant |
| `count` | `int` | Item count |

### Signals

| Signature | Description |
| --- | --- |
| `toastClosed(string message)` | Emitted when a toast is closed |
| `toastActionClicked(string message)` | Emitted when a toast action is clicked |

### Methods

| Signature | Description |
| --- | --- |
| `show(message, severity, title, actionText)` | Show the control |
| `info(message, title, actionText)` | Show an informational toast / tip |
| `successToast(message, title, actionText)` | Show a success toast |
| `warningToast(message, title, actionText)` | Show a warning toast |
| `errorToast(message, title, actionText)` | Show an error toast |
| `clear()` | Clear text or selection |

### Inherited from `Control`

Also available (base type / Qt Quick Controls):

- `padding`
- `font`
- `background` / `contentItem`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
