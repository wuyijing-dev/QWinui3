# Dialogs & flyouts (1.16)

When to use **modal** vs **light-dismiss** surfaces. Prefer types already on [stable-api.md](stable-api.md) for blocking decisions.

| Surface | Modal? | Use when | Gallery |
|---------|--------|----------|---------|
| [`ContentDialog`](components/ContentDialog.md) + [`ContentDialogQueue`](components/ContentDialogQueue.md) | Yes | Confirm / save / destructive choice | ContentDialog |
| [`Flyout`](components/Flyout.md) | No (default) | Short contextual UI next to a control | Flyout (**stable 1.37**) |
| [`TeachingTip`](components/TeachingTip.md) | No | Coach mark / first-run tip with optional action | TeachingTip · InfoBar + TeachingTip recipe |
| Style [`Drawer`](components/Drawer.md) | Yes (dim) | Edge panel for nav / secondary tools | Drawer (**stable 1.37**) |
| [`MenuFlyout`](components/MenuFlyout.md) | Light-dismiss menu | Actions list (see [commands.md](commands.md)) | MenuFlyout |

---

## Choosing

| Need | Prefer |
|------|--------|
| User must decide before continuing | **ContentDialog** (`show()` → queue) |
| Peek / extra fields without blocking the page | **Flyout** |
| “Click here next time” coaching | **TeachingTip** |
| Persistent side tools / filters | **Drawer** |
| Command list / context menu | **MenuFlyout** / CommandBar overflow ([commands.md](commands.md)) |

Do **not** use TeachingTip or Flyout for irreversible confirms — use ContentDialog with a clear close/cancel affordance. Transient status / coach marks: [feedback.md](feedback.md) (1.34).

---

## ContentDialog

```qml
ContentDialog {
    id: dlg
    title: qsTr("Delete item?")
    primaryButtonText: qsTr("Delete")
    closeButtonText: qsTr("Cancel")
    defaultButton: "close"   // safer default for destructive
    onPrimaryClicked: { /* … */ }
}
// Prefer:
dlg.show()   // ContentDialogQueue.enqueue — one dialog at a time
```

| Key / API | Behavior (1.16) |
|-----------|-----------------|
| **Enter** / **Return** | `activateDefault()` for `defaultButton` |
| **Esc** | Close path via `requestClose("close")` (same as close button) — honors `onClosing { args.cancel = true }` |
| Outside click | Does **not** dismiss |
| `ContentDialogQueue.replaceCurrent(d)` | Swap active dialog; queue resumes after |

Accessible name = `title`. Keep `parent: Overlay.overlay` (or queue host) so centering works.

---

## Flyout

```qml
Flyout {
    id: flyout
    target: anchor
    title: qsTr("Details")
    isLightDismissEnabled: true
    Label { text: qsTr("…") }
}
flyout.showAt(anchor)
```

| Setting | Behavior |
|---------|----------|
| `isLightDismissEnabled` | Esc + outside press (default on) |
| `showMode` | `standard` \| `transient` \| `transientWithDismissOnPointerMoveAway` |

---

## TeachingTip

```qml
TeachingTip {
    target: field
    title: qsTr("Required")
    subtitle: qsTr("Enter a display name.")
    actionText: qsTr("Got it")
    preferredPlacement: Qt.AlignTop
    onActionClicked: close()
}
```

Light-dismiss by default. Pair with InfoBar for form errors — see Gallery **InfoBar + TeachingTip recipe**.

---

## Drawer

Styled Qt Quick Controls `Drawer` — parent on **window** `Overlay.overlay` (Gallery `CatalogPage.overlay` alone can clip). Esc / scrim dismiss follow Qt Drawer. Use for navigation chrome, not one-shot confirms.

---

## Out of scope

New dialog engine, replacing QQC `Dialog` entirely, promoting Flyout/TeachingTip/Drawer to stable in this slice (ContentDialog already stable).
