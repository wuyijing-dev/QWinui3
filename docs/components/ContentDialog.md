# ContentDialog

Modal dialog with primary / secondary / close actions.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ContentDialog.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ContentDialog.qml)

**Category:** Input & forms · **Library:** v3.56

[← Component index](../components.md)

**Gallery:** `ContentDialog` — [`src/gallery/pages/ContentDialogPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ContentDialogPage.qml)

**Python:** same QML type after `qwinui3.setup_engine()` — [Python API](../python-api.md).

**Extends** `Dialog`.

## Example

```qml
ContentDialog {
    id: dlg
    title: qsTr("Confirm")
    primaryButtonText: qsTr("OK")
    secondaryButtonText: qsTr("More")
    closeButtonText: qsTr("Cancel")
    onPrimaryClicked: { /* … */ }
    onSecondaryClicked: { /* … */ }
    onCloseClicked: { /* … */ }
}

// --- API ---
// dlg.show()          // enqueue via ContentDialogQueue (preferred)
// dlg.hide()          // close
// dlg.activateDefault()
// signals: onPrimaryClicked, onSecondaryClicked, onCloseClicked
// inherits Dialog: open(), close(), title, accepted(), rejected()
```

## Notes

Prefer show() -> ContentDialogQueue so dialogs open one-at-a-time.
Empty primary/secondary/closeButtonText hides that button.
defaultButton: primary | secondary | close | none (or isPrimaryDefault).
activateDefaultOnEnter: false skips Enter → default when a single-line field is focused.
queuePriority: higher pending dialogs open before lower (ContentDialogQueue).
fullSizeDesired expands toward the overlay (WinUI FullSizeDesired).
dialogResult: none | primary | secondary | close (WinUI ContentDialogResult).
primaryButton / secondaryButton / closeButton slots override text buttons.
Body: put content as children (moved into the dialog body slot).
Keyboard (1.16): Enter/Return → activateDefault(); Esc → close path via requestClose
(honors onClosing { args.cancel = true }). Outside click does not dismiss.
On close, focus returns to the opener (1.85).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `primaryButtonText` | `string` | — |
| `secondaryButtonText` | `string` | — |
| `closeButtonText` | `string` | — |
| `isPrimaryDefault` | `bool` | — |
| `defaultButton` | `string` | — |
| `activateDefaultOnEnter` | `bool` | When false, Enter/Return does not activate the default button (2.82 D19) |
| `queuePriority` | `int` | Higher values dequeue before lower when using ContentDialogQueue (2.82 D19) |
| `isPrimaryButtonEnabled` | `bool` | — |
| `isSecondaryButtonEnabled` | `bool` | — |
| `isCloseButtonEnabled` | `bool` | — |
| `fullSizeDesired` | `bool` | — |
| `dialogResult` | `string` | — |
| `primaryButton` | `alias` | — |
| `secondaryButton` | `alias` | — |
| `closeButton` | `alias` | — |
| `isOpen` | `alias` | — |

### Signals

| Signature | Description |
| --- | --- |
| `primaryClicked()` | — |
| `secondaryClicked()` | — |
| `closeClicked()` | — |
| `resultReady(string result)` | — |
| `closing(var args)` | — |

### Methods

| Signature | Description |
| --- | --- |
| `show()` | — |
| `showFront()` | — |
| `hide()` | — |
| `requestClose(kind)` | — |
| `openQueued()` | — |
| `activateDefault()` | — |
| `syncBody()` | — |

### Inherited from `Dialog`

Also available (base type / Qt Quick Controls):

- `title`
- `open()` / `close()`
- `accepted()` / `rejected()`

---
*Generated from module sources by `scripts/generate_component_docs.py` — do not edit by hand.*
