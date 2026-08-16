# Feedback surfaces (1.34)

When to use **inline banners**, **toasts**, **coach tips**, and **progress** — next to dialogs ([dialogs-flyouts.md](dialogs-flyouts.md)) and OS notify ([system-integration.md](system-integration.md)).

Gallery: **InfoBar** · **InfoBarHost** · **Toast** / **ToastHost** · **TeachingTip** · **InfoBar + TeachingTip recipe** · **ProgressBar** / **ProgressRing** / **ProgressButton**.

---

## When to use

| Need | Prefer | Why |
|------|--------|-----|
| Page-level status that stays until dismissed | **`InfoBar`** / **`InfoBarHost`** | Inline, severity-colored, optional action |
| Transient “Saved” / non-blocking ack | **`ToastHost`** | Auto-dismiss stack; does not steal page layout |
| First-run / “click here” coaching | **`TeachingTip`** | Anchored tip; light-dismiss |
| Blocking confirm / destructive choice | **`ContentDialog`** | [dialogs-flyouts.md](dialogs-flyouts.md) — not Toast/Tip |
| Determinate or busy work | **`ProgressBar`** / **`ProgressRing`** / **`ProgressButton`** | In-place progress, not a toast |
| Also mirror to OS tray / portal | **`NotificationBridge`** + ToastHost | [system-integration.md](system-integration.md) (1.10) |

Do **not** use Toast or TeachingTip for irreversible confirms. Do **not** spam Toast for validation errors that belong on the form ([forms.md](forms.md)) or in an InfoBar.

---

## Severity

Shared severity ints on InfoBar / Toast (and host helpers):

| Value | Name | Typical use |
|------:|------|-------------|
| 0 | `informational` | Neutral notice / update available |
| 1 | `success` | Saved / completed |
| 2 | `warning` | Review before continuing |
| 3 | `error` | Failed / blocked |

Helpers: `host.info` / `success` / `warning` / `error` (InfoBarHost & ToastHost; ToastHost also has `*Toast` aliases). Prefer helpers over hand-setting severity ints.

---

## Queueing

| Surface | Queue behavior |
|---------|----------------|
| **ToastHost** | `maxVisible` (default 3); further `show()` wait in `pending`; drain when a toast closes. `count` / `pendingCount` / `totalCount`. |
| **InfoBarHost** | Declared children; `maxVisible` hides older bars (`0` = unlimited). Not a pending queue — open/close the bars you own. |
| **ContentDialogQueue** | One modal at a time — [dialogs-flyouts.md](dialogs-flyouts.md). |
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
| InfoBar / Toast | `Accessible.role: AlertMessage`; name = title; description includes severity |
| InfoBarHost / ToastHost | Host announces open / notification region |
| TeachingTip | Dialog-like name = title; Close named; Esc / outside per `isLightDismissEnabled` |
| Progress* | ProgressBar role + value / indeterminate description |

Close buttons expose Accessible name **Close** and keyboard activation (1.02).

---

## Gallery map

| Page | Role |
|------|------|
| **InfoBar** / **InfoBarHost** | Severity + stack / maxVisible |
| **Toast** / **ToastHost** | Transient + pending queue |
| **TeachingTip** | Coach mark (not confirm) |
| **InfoBar + TeachingTip recipe** | Form save + first-focus tip (follows this doc) |
| **ProgressBar** / **Ring** / **Button** | In-place progress |
| **NotificationBridge** | Toast + OS mirror |

---

## Out of scope (1.34)

Redesigning Toast chrome; replacing the OS notification center; inventing a second banner stack.
