# Feedback surfaces (1.34 / 1.55)

When to use **inline banners**, **toasts**, **coach tips**, and **progress** — next to dialogs ([dialogs-flyouts.md](dialogs-flyouts.md)) and OS notify ([system-integration.md](system-integration.md)).

Gallery: **InfoBar** · **InfoBarHost** · **Toast** / **ToastHost** · **TeachingTip** · **Onboarding coach** · **InfoBar + TeachingTip recipe** · **ProgressBar** / **ProgressRing** / **ProgressButton**.

---

## When to use

| Need | Prefer | Why |
|------|--------|-----|
| Page-level status that stays until dismissed | **`InfoBar`** / **`InfoBarHost`** | Inline, severity-colored, optional action |
| Transient “Saved” / non-blocking ack | **`ToastHost`** | Auto-dismiss stack; does not steal page layout |
| First-run / “click here” coaching | **`TeachingTip`** | Anchored tip; light-dismiss |
| Multi-step first-run tour | **Sequenced `TeachingTip`s** | One tip at a time + persistence — Gallery **Onboarding coach** (**1.55**) |
| Blocking confirm / destructive choice | **`ContentDialog`** | [dialogs-flyouts.md](dialogs-flyouts.md) — not Toast/Tip |
| Determinate or busy work | **`ProgressBar`** / **`ProgressRing`** / **`ProgressButton`** | In-place progress, not a toast |
| Also mirror to OS tray / portal | **`NotificationBridge`** + ToastHost | [system-integration.md](system-integration.md) (1.10) |

Do **not** use Toast or TeachingTip for irreversible confirms. Do **not** spam Toast for validation errors that belong on the form ([forms.md](forms.md)) or in an InfoBar.

---

## Severity

Shared severity ints on InfoBar / Toast / TeachingTip (and host helpers) — **FeedbackSeverity** singleton (2.70):

| Value | Constant | Token |
|-------|----------|-------|
| 0 | informational | `systemAttention` |
| 1 | success | `systemSuccess` |
| 2 | warning | `systemCaution` |
| 3 | error | `systemCritical` |

TeachingTip: set `severity:` to tint chrome + default glyph; leave `-1` for neutral coach tips.

Helpers: `host.info` / `success` / `warning` / `error` (InfoBarHost & ToastHost; ToastHost also has `*Toast` aliases). Prefer helpers over hand-setting severity ints.

### Loading handoff (2.70 B6)

`Button.loading` → inline busy ring · **ProgressRing** for determinate work · **Skeleton** / **Shimmer** for list/form placeholders while data loads.

Helpers: `host.info` / `success` / `warning` / `error` (InfoBarHost & ToastHost; ToastHost also has `*Toast` aliases). Prefer helpers over hand-setting severity ints.

---

## Queueing

| Surface | Queue behavior |
|---------|----------------|
| **ToastHost** | `maxVisible` (default 3); further `show()` wait in `pending`; drain when a toast closes. `count` / `pendingCount` / `totalCount`. |
| **InfoBarHost** | Declared children; `maxVisible` hides older bars (`0` = unlimited). Not a pending queue — open/close the bars you own. |
| **ContentDialogQueue** | One modal at a time — [dialogs-flyouts.md](dialogs-flyouts.md) (**1.48**). |
| **TeachingTip** | One tip instance; do not stack competing tips on the same target. |

```qml
ToastHost {
    id: toasts
    placement: ToastHost.BottomRight
    maxVisible: 3
    durationMs: 3200
}
toasts.success(qsTr("Saved"))
toasts.error(qsTr("Upload failed"), qsTr("Error"), qsTr("Retry"))
```

Put `ToastHost` in `CatalogPage.overlay` / window overlay — it reparents to `Overlay.overlay` for corner placement. Do not also set conflicting anchors.

```qml
InfoBarHost {
    id: bars
    maxVisible: 3
    InfoBar { id: err; severity: err.error; isOpen: false }
}
err.message = qsTr("Name is required.")
err.isOpen = true
```

---

## Focus return (1.34)

| Surface | Focus behavior |
|---------|----------------|
| **TeachingTip** | On open, close button takes focus; on close, **focus returns to `target`** when focusable. |
| **InfoBar** | Close is a StrongFocus button; keep the bar in the page tab order. Prefer fixing the field after error rather than toasting. |
| **Toast** | Focusable while open; auto-dismiss — do not require toast focus for primary tasks. |
| **ContentDialog** | Modal focus trap until dismissed (dialogs recipe). |

Coach-mark recipe: open tip from the control’s first focus; after dismiss, the same control stays usable — Gallery **InfoBar + TeachingTip recipe**.

---

## Onboarding coach sequence (1.55)

First-run tours are **app-owned**: reuse `TeachingTip`, do not invent a second tour framework.

| Rule | Detail |
|------|--------|
| One tip at a time | Close (or set `isOpen: false`) before opening the next target |
| Advance | `onActionClicked` → mark advancing → on `onClosed` open the next step (`Qt.callLater`) |
| Focus | Focus the **next** target before opening its tip; dismiss still returns focus to the current target |
| Don’t show again | Persist a bool in `QtCore.Settings` (or your store); skip auto-offer when set |
| Esc / Close | End the tour; honor the checkbox if the user already checked it |
| Not for | Save confirms, validation errors, transient “Saved” acks |

```qml
import QtCore

Settings {
    id: coachStore
    category: "OnboardingCoach"
    property bool dismissed: false
}

TeachingTip {
    id: tip
    // rebind target / title / subtitle / actionText per step
    CheckBox { id: dontShowAgain; text: qsTr("Don’t show again") }
    onActionClicked: { /* set advancing / pendingFinish */ }
    onClosed: {
        if (advancing)
            Qt.callLater(function () { showStep(stepIndex + 1) })
        else
            finishTour(dontShowAgain.checked)
    }
}
```

Gallery: **Dialogs → Onboarding coach** (3-step demo + Reset). Cross-links: [keyboard.md](keyboard.md) (Esc / focus return), [dialogs-flyouts.md](dialogs-flyouts.md) (vs ContentDialog). **Multi-window apps:** defer tour until main shell is visible; separate Settings category from geometry — [multi-window-onboarding.md](multi-window-onboarding.md) (**2.43**).

---

## Progress

| Control | Use when |
|---------|----------|
| Style **ProgressBar** | Known fraction; `showError` / `showPaused` / indeterminate |
| **ProgressRing** | Compact busy / determinate ring |
| **ProgressButton** | Button that shows progress in-place during an action |

Progress belongs **next to the work**, not as a Toast. Pair long jobs with an InfoBar or status text if the user can leave the page.

---

## Accessibility checklist

| Surface | Expectation |
|---------|-------------|
| InfoBar / Toast | `Accessible.role: AlertMessage`; name = title; description includes severity; InfoBar Qt 6.8+ `Accessible.announce` on open (**1.85**) |
| InfoBarHost / ToastHost | Host announces open / notification region |
| TeachingTip | Dialog-like name = title; Close named; Esc / outside per `isLightDismissEnabled` |
| Onboarding sequence | Name each step target; checkbox “Don’t show again”; Tab reaches Next/Done |
| Progress* | ProgressBar role + value / indeterminate description |

Close buttons expose Accessible name **Close** and keyboard activation (1.02).

---

## Gallery map

| Page | Role |
|------|------|
| **InfoBar** / **InfoBarHost** | Severity + stack / maxVisible |
| **Toast** / **ToastHost** | Transient + pending queue |
| **Notification center** | Grouped dismissible history (**2.27**) |
| **TeachingTip** | Coach mark (not confirm) |
| **Onboarding coach** | Sequenced tips + don’t-show-again (**1.55**) |
| **InfoBar + TeachingTip recipe** | Form save + first-focus tip (follows this doc) |
| **ProgressBar** / **Ring** / **Button** | In-place progress |
| **InfoBadge** | Unread count on bell / nav (**2.27**) |
| **NotificationBridge** | Toast + OS mirror |

---

## Notification center (2.27)

**Experimental** — `NotificationCenter` addresses **FL-007** (in-app history + grouping). Toast-only flows lose dismissible history; LoB apps need a drawer.

| Surface | Role |
|---------|------|
| **ToastHost** | Transient ack — still use for “Saved” |
| **NotificationCenter** | Grouped list, mark read, clear read / all |
| **InfoBadge** | `unreadCount` on bell / nav icon |
| **ProgressRing** + **InfoBar** | Long save/upload next to the work (**2.27** demo) |
| **TeachingTip** | One-time coach on the bell |

```qml
NotificationCenter {
    id: center
    model: appNotifications
    onNotificationClicked: (index, item) => center.markRead(index)
}

IconButton {
    id: bell
    symbol: FluentIcons.Ringer
    onClicked: center.open()
    InfoBadge {
        anchors.right: parent.right
        anchors.top: parent.top
        visible: center.unreadCount > 0
        value: center.unreadCount
    }
}

center.addNotification({
    title: qsTr("Build finished"),
    message: qsTr("Release succeeded."),
    category: qsTr("CI"),
    severity: center.success
})
```

| API | Role |
|-----|------|
| `groupRole` | Model field for sections (default `"category"`) |
| `unreadCount` | Unread rows for **InfoBadge** |
| `markRead` / `markAllRead` / `clear` / `clearRead` | History hygiene |
| `addNotification` / `push` | Append to history (newest first) |

Gallery: **Notification center** page · **Feedback surfaces** hub.

**2.63 productize:** [notification-center-263.md](notification-center-263.md) — `NotificationBridge.notificationCenter`, `maxHistory`, dedupe **`id`**.

**Out:** OS notification center replacement; push SaaS.

---

## Out of scope

Redesigning Toast chrome; replacing the OS notification center; inventing a second banner stack; a product “tour” / Spotlight overlay control family (1.55).
