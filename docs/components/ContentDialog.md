# ContentDialog

Modal dialog with primary / secondary / close actions.

`import QWinUI3.Extras` · [`src/extras/QWinUI3/Extras/ContentDialog.qml`](../../src/extras/QWinUI3/Extras/ContentDialog.qml)

[← Component index](../components.md)

## Usage

```qml
ContentDialog {
    title: qsTr("Confirm")
    primaryButtonText: qsTr("OK")
    closeButtonText: qsTr("Cancel")
}
// prefer dialog.show() → ContentDialogQueue
```

## Properties

- `primaryButtonText: string` — Primary action label (accent); empty hides the button
- `secondaryButtonText: string` — Optional middle action; empty hides
- `closeButtonText: string` — Dismiss / cancel label; empty hides
- `isPrimaryDefault: bool` — Prefer defaultButton; isPrimaryDefault kept for compatibility
- `defaultButton: string` — WinUI DefaultButton: primary | secondary | close | none
- `isPrimaryButtonEnabled: bool` — Enable primary button
- `isSecondaryButtonEnabled: bool` — Enable secondary button
- `isCloseButtonEnabled: bool` — Enable close button
- `isOpen: alias` — Bindable open state (alias of visible)

## Signals

- `primaryClicked()` — Primary button clicked
- `secondaryClicked()` — Secondary button clicked
- `closeClicked()` — Close button clicked

## Methods

- `show()` — Enqueue via ContentDialogQueue (preferred over open())
- `hide()` — Hide
- `openQueued()` — Open Queued
- `activateDefault()` — Activate Default
- `syncBody()` — Instance children land on contentItem; move them into the body slot.

---
*Generated from QML comments by `scripts/generate_component_docs.py` — do not edit by hand.*
