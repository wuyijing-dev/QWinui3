# Dialogs & flyouts (1.48)

When to use **modal** vs **light-dismiss** surfaces. Prefer types already on [stable-api.md](stable-api.md) for blocking decisions.

**Keyboard Esc / Enter end-to-end:** [keyboard.md](keyboard.md) (**1.44**).  
**Modal queue deepen (this slice):** ContentDialogQueue ordering, owner overlay, Esc cancel — Gallery **ContentDialog**.

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
| Several confirms in a row (save → export → restart) | **ContentDialogQueue** FIFO (`show()` × N) |
| Peek / extra fields without blocking the page | **Flyout** |
| “Click here next time” coaching | **TeachingTip** |
| Persistent side tools / filters | **Drawer** |
| Command list / context menu | **MenuFlyout** / CommandBar overflow ([commands.md](commands.md)) |

Do **not** use TeachingTip or Flyout for irreversible confirms — use ContentDialog with a clear close/cancel affordance. Transient status / coach marks: [feedback.md](feedback.md) (1.34).

---

## ContentDialogQueue (1.48)

`ContentDialog.show()` calls `ContentDialogQueue.enqueue`. Only **one** dialog is visible; others wait FIFO.

| API | Behavior |
|-----|----------|
| `show(d)` / `enqueue(d)` | Open now if idle; else append (deduped) |
| `pendingCount` / `busy` | Waiting count / whether one is open |
| `cancel(d)` | Drop **pending** only (no-op if `d` is already active) |
| `clearQueue()` | Drop all pending; leave the active dialog open |
| `replaceCurrent(d)` | Close active **without** pumping the queue, open `d`; pending FIFO resumes after `d` closes |

```qml
import QWinUI3.Extras

// Owner window overlay — required for modal centering / dimmer
ContentDialog {
    id: saveDlg
    parent: Overlay.overlay
    anchors.centerIn: Overlay.overlay
    title: qsTr("Save changes?")
    primaryButtonText: qsTr("Save")
    closeButtonText: qsTr("Cancel")
    defaultButton: "close"
}

ContentDialog {
    id: exportDlg
    parent: Overlay.overlay
    anchors.centerIn: Overlay.overlay
    title: qsTr("Export?")
    primaryButtonText: qsTr("Export")
    closeButtonText: qsTr("Later")
}

// Happy path — two queued dialogs:
saveDlg.show()
exportDlg.show()
// User closes save → export opens automatically (FIFO)

// Drop the second while the first is still open:
ContentDialogQueue.cancel(exportDlg)

// Urgent override (pending keep their order):
ContentDialogQueue.replaceCurrent(exportDlg)
```

### Owner / transient rules

1. Parent each `ContentDialog` on the **owner window** `Overlay.overlay` (Gallery: `CatalogPage.overlay` / `parent: Overlay.overlay`).  
2. Do **not** parent dialogs on a page `Item` that gets destroyed while queued — cancel or clear first.  
3. Multi-window apps: keep one queue **per process** (singleton). Prefer dialogs that belong to the focused window’s overlay; avoid opening a dialog whose parent overlay is on a hidden window.  
4. `WindowHelper.setTransientParent` is for **top-level** `Window`s — ContentDialog is an in-window `Popup`, not a separate HWND.

### Esc / Enter patterns

| Key | Behavior |
|-----|----------|
| **Enter** / **Return** | `activateDefault()` for `defaultButton` |
| **Esc** | Close path via `requestClose("close")` — same as close button |
| Outside click | Does **not** dismiss (`NoAutoClose`) |
| Block dismiss | `onClosing: function (args) { args.cancel = true }` |

Esc on the **active** dialog only. Pending dialogs are not focused until pumped. If Closing cancels, the queue stays busy on that dialog (correct).

### Stress checklist (Gallery)

On **ContentDialog**: enqueue three dialogs → watch `pendingCount` / `busy` → dismiss in order; try Cancel second / Clear queue / Replace current. Critical smoke instantiates the page.

---

## ContentDialog

```qml
ContentDialog {
    id: dlg
    parent: Overlay.overlay
    anchors.centerIn: Overlay.overlay
    title: qsTr("Delete item?")
    primaryButtonText: qsTr("Delete")
    closeButtonText: qsTr("Cancel")
    defaultButton: "close"   // safer default for destructive
    onPrimaryClicked: { /* … */ }
}
dlg.show()   // ContentDialogQueue.enqueue — one dialog at a time
```

Accessible name = `title`.

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

New dialog engine, replacing QQC `Dialog` entirely, non-modal sheet redesign, per-window queue instances.
