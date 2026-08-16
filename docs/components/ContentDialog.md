# ContentDialog

Modal dialog with primary / secondary / close actions.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ContentDialog.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/extras/QWinUI3/Extras/ContentDialog.qml)

**Category:** Input & forms · **Library:** v1.06

[← Component index](../components.md)

**Gallery:** `ContentDialog` — [`src/gallery/pages/ContentDialogPage.qml`](https://github.com/wuyijing-dev/QWinui3/blob/master/src/gallery/pages/ContentDialogPage.qml)

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
fullSizeDesired expands toward the overlay (WinUI FullSizeDesired).
dialogResult: none | primary | secondary | close (WinUI ContentDialogResult).
primaryButton / secondaryButton / closeButton slots override text buttons.
Body: put content as children (moved into the dialog body slot).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `primaryButtonText` | `string` | — |
| `secondaryButtonText` | `string` | — |
| `closeButtonText` | `string` | — |
| `isPrimaryDefault` | `bool` | — |
| `defaultButton` | `string` | — |
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
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
