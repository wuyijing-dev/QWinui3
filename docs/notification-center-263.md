# Notification center productize (2.63)

Wires **transient toasts** + **grouped history** + optional **OS mirror** into one LoB stack — closes **FL-007** residual after **2.27** experimental `NotificationCenter`.

Related: [feedback.md](feedback.md) · [system-integration.md](system-integration.md) · [performance.md](performance.md) · [planning/friction-log.md](planning/friction-log.md) (**FL-007**) · Gallery **Notification center** page.

Controls: `NotificationCenter` · `NotificationBridge` · `ToastHost` — all **`import QWinUI3.Extras`** (**experimental** center; stable bridge/toast patterns).

---

## Goal

Product apps need **three layers**:

| Layer | Control | Role |
|-------|---------|------|
| Transient ack | **ToastHost** | “Saved” — auto-dismiss |
| Grouped history | **NotificationCenter** | Bell drawer — mark read / clear |
| OS mirror (optional) | **NotificationBridge** | Tray / portal notify |

**2.63** connects **`NotificationBridge.notificationCenter`** so one `bridge.success()` fills toast **and** history. Adds **`maxHistory`** cap and **`id`** dedupe.

**Out:** OS notification center replacement; push SaaS backend.

---

## Product stack recipe

```qml
ToastHost { id: toasts; placement: ToastHost.TopRight }

NotificationCenter {
    id: center
    model: appNotifications
    maxHistory: 100
}

NotificationBridge {
    id: bridge
    toastHost: toasts
    notificationCenter: center
    recordInCenter: true
    defaultCategory: qsTr("App")
    mirrorToSystem: true
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

// One call → toast + history (+ OS when mirrorToSystem)
bridge.success(qsTr("Document saved."), qsTr("Saved"), "", "save-doc")
```

Gallery: **Notification center** page — **2.63** block demos **`NotificationBridge`** wiring.

---

## 2.63 API additions

| Control | Property / API | Note |
|---------|----------------|------|
| **NotificationCenter** | `maxHistory` (default **100**) | Trims oldest rows on `addNotification` |
| **NotificationCenter** | `dedupeIdRole` (default **`"id"`**) | Same `id` updates row instead of duplicate |
| **NotificationBridge** | `notificationCenter` | Target drawer |
| **NotificationBridge** | `recordInCenter` (default **true**) | Append history on `show()` |
| **NotificationBridge** | `defaultCategory` | Group label when recording |
| **ToastHost** | `show(..., dedupeId)` | Skip enqueue when id already visible/pending |

---

## App checklist

- [ ] One **`NotificationBridge`** entry point — not raw `toasts` + manual `center.push` in every handler
- [ ] Set **`maxHistory`** for long-running apps (default **100**)
- [ ] Pass stable **`id`** on repeated events (save progress, sync status)
- [ ] **`InfoBadge`** on bell uses **`center.unreadCount`**
- [ ] Long work: **ProgressRing** / **InfoBar** — not toast spam ([feedback.md](feedback.md))
- [ ] Mark **`NotificationCenter`** experimental until promote gate

**Next:** **2.64** collection perf + a11y sign-off (**FL-008** residual)
