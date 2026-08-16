# Shell extras (1.17)

Stable **WindowHelper** helpers for taskbar progress, user attention, reveal-in-folder, and idle inhibit. Prefer these over ad-hoc Win32 / D-Bus calls.

Gallery: **System integration** (taskbar / attention / idle sections).

Related: [system-integration.md](system-integration.md) (FilePicker / Tray / NotificationBridge).

---

## Stable helpers

| API | Role |
|-----|------|
| `setTaskbarProgress(window, value)` | 0…1 determinate progress |
| `setTaskbarProgressState(window, state)` | `TaskbarNoProgress` / `Indeterminate` / `Normal` / `Error` / `Paused` |
| `clearTaskbarProgress(window)` | Clear overlay progress |
| `setTaskbarOverlayText(window, text)` | Badge glyph (short text); empty clears |
| `clearTaskbarOverlay(window)` | Clear badge |
| `requestUserAttention(window, continuous = false)` | Flash / urgency |
| `revealFileInFolder(path)` | Select path in file manager (`bool`) |
| `inhibitIdle(reason)` / `releaseIdleInhibit()` | Keep display awake |
| `idleInhibited` | Whether inhibit is active |

```qml
import QWinUI3.Platform

WindowHelper.setTaskbarProgress(Window.window, 0.4)
WindowHelper.setTaskbarProgressState(Window.window, WindowHelper.TaskbarNormal)
WindowHelper.requestUserAttention(Window.window, false)
if (!WindowHelper.revealFileInFolder(path))
    console.warn("reveal failed")
if (WindowHelper.inhibitIdle(qsTr("Exporting…")))
    // … long work …
WindowHelper.releaseIdleInhibit()
```

Always pass a real `Window` / `Item` so `window` resolves to a native handle on Windows.

---

## Platform matrix

| API | Windows | Linux | Notes / failure |
|-----|---------|-------|-----------------|
| Taskbar progress / state / clear | **Yes** — `ITaskbarList3` | No-op | Needs visible HWND; fails quietly if COM/taskbar unavailable |
| Taskbar overlay badge | **Yes** — `SetOverlayIcon` | No-op | Short text (≈2 chars drawn); empty clears |
| `requestUserAttention` | **Yes** — `FlashWindowEx` | Best-effort — `raise` + `alert` | Wayland may ignore flash; still raises when allowed |
| `revealFileInFolder` | **Yes** — `explorer /select` | Best-effort — FileManager1 `ShowItems`, else open parent dir | Returns `false` on empty path / launch failure |
| `inhibitIdle` | **Yes** — `SetThreadExecutionState` | Best-effort — ScreenSaver Inhibit → portal Inhibit | Returns `false` if both fail; call `releaseIdleInhibit` when done |
| `idleInhibited` | Tracks success | Tracks success | Stays `false` if inhibit failed |

**Out of this promote (still experimental):** Snap Layouts toggle, battery / online / screens helpers, Jump Lists / recent-docs deepen, taskbar thumbnail toolbars.

---

## Failure checklist

1. **Taskbar APIs on Linux** — no visual; branch UI with `WindowHelper.windows`.
2. **Progress with no effect on Windows** — window not shown yet, or Explorer/taskbar policy blocked COM.
3. **Reveal returns false** — path empty, cancelled pick, or no FileManager1 / Explorer.
4. **Idle inhibit false on Linux** — no Session bus / portal; do not assume sleep is blocked.
5. **Forget `releaseIdleInhibit`** — display stays awake until process exit (Windows) or cookie release (Linux).

---

## Related

- [system-integration.md](system-integration.md) — FilePicker / Tray / NotificationBridge  
- [platform-linux-wayland.md](platform-linux-wayland.md) — portal matrix  
- [stable-api.md](stable-api.md) — promoted surface
