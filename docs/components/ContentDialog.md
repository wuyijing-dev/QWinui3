# ContentDialog

Modal dialog with primary / secondary / close actions.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ContentDialog.qml`](../../src/extras/QWinUI3/Extras/ContentDialog.qml)

[← Component index](../components.md)

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

**Gallery host:** declare dialogs under `CatalogPage.overlay` and keep
`parent: Overlay.overlay` + `anchors.centerIn: Overlay.overlay` for the modal
scrim. See [`gallery-catalog-page.md`](../gallery-catalog-page.md).

## API

### Properties

| Name | Type | Description |
| --- | --- | --- |
| `primaryButtonText` | `string` | Primary action label (accent); empty hides the button |
| `secondaryButtonText` | `string` | Optional middle action; empty hides |
| `closeButtonText` | `string` | Dismiss / cancel label; empty hides |
| `isPrimaryDefault` | `bool` | Prefer defaultButton; isPrimaryDefault kept for compatibility |
| `defaultButton` | `string` | WinUI DefaultButton: primary \| secondary \| close \| none |
| `isPrimaryButtonEnabled` | `bool` | Enable primary button |
| `isSecondaryButtonEnabled` | `bool` | Enable secondary button |
| `isCloseButtonEnabled` | `bool` | Enable close button |
| `fullSizeDesired` | `bool` | WinUI FullSizeDesired — nearly fill the overlay when true |
| `dialogResult` | `string` | (dialogResult — cannot redeclare Dialog.result which is FINAL) |
| `primaryButton` | `alias` | Custom primary button content (overrides primaryButtonText when set) |
| `secondaryButton` | `alias` | Custom secondary button content |
| `closeButton` | `alias` | Custom close button content |
| `isOpen` | `alias` | Bindable open state (alias of visible) |

### Signals

| Signature | Description |
| --- | --- |
| `primaryClicked()` | Primary button clicked |
| `secondaryClicked()` | Secondary button clicked |
| `closeClicked()` | Close button clicked |
| `resultReady(string result)` | Closed with a ContentDialogResult |
| `closing(var args)` | WinUI Closing — set args.cancel = true to keep the dialog open |

### Methods

| Signature | Description |
| --- | --- |
| `show()` | Enqueue via ContentDialogQueue (preferred over open()) |
| `hide()` | Hide the control (respects Closing cancel) |
| `requestClose(kind)` | — |
| `openQueued()` | Open the next queued dialog |
| `activateDefault()` | Activate the default button / action |
| `syncBody()` | Instance children land on contentItem; move them into the body slot. |

### Inherited from `Dialog`

Also available (base type / Qt Quick Controls):

- `title`
- `open()` / `close()`
- `accepted()` / `rejected()`
- `standardButtons`

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
