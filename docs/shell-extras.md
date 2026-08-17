# Shell extras (1.47)

Stable **WindowHelper** helpers for taskbar progress, user attention, reveal-in-folder, and idle inhibit — plus a polished **Win11 Snap Layouts** toggle recipe (still experimental). Prefer these over ad-hoc Win32 / D-Bus calls.

Gallery: **System integration** (Snap · taskbar · attention / reveal / idle). Critical smoke page.

Related: [system-integration.md](system-integration.md) · [window-helper.md](window-helper.md) · [platform-linux-wayland.md](platform-linux-wayland.md) · [window-chrome.md](window-chrome.md).

---

## Snap Layouts (Win11 · experimental)

`WindowHelper.snapLayoutsEnabled` (default **true**) controls whether Fluent caption maximize hit-testing reports `HTMAXBUTTON` so Windows 11 can show the Snap Layouts flyout.

| | |
|--|--|
| **Requires** | Windows 11 + Gallery / app using Fluent **native chrome** (`nativeChrome` / maximize caption rect) |
| **How to try** | Hover the **maximize** caption button (do not click yet) — Snap Layouts flyout should appear when enabled |
| **Toggle off** | `WindowHelper.snapLayoutsEnabled = false` → maximize rect reports `HTCLIENT` (no flyout) |
| **Linux / Wayland** | **n/a** — property exists; switch is disabled in Gallery; no compositor Snap Layouts |

```qml
import QWinUI3.Platform

// Default on for Win11 CSD windows. Persist if your settings page owns the toggle.
WindowHelper.snapLayoutsEnabled = settings.snapLayouts
```

**Not** a Wayland feature — do not plan compositor snap grids here (out of scope for 1.47). Troubleshooting: [window-chrome.md](window-chrome.md) (maximize not `HTMAXIMIZE` / hit-test).

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

Always pass a real `Window` / `Item` so `window` resolves to a native handle on Windows.

---

## Recipe — taskbar progress (Windows)

Typical LoB export / install loop:

```qml
import QWinUI3.Platform

function beginExport(window) {
    WindowHelper.setTaskbarProgressState(window, WindowHelper.TaskbarNormal)
    WindowHelper.setTaskbarProgress(window, 0)
}

function onExportProgress(window, fraction) {
    WindowHelper.setTaskbarProgress(window, Math.min(1, Math.max(0, fraction)))
}

function onExportPaused(window) {
    WindowHelper.setTaskbarProgressState(window, WindowHelper.TaskbarPaused)
}

function onExportFailed(window) {
    WindowHelper.setTaskbarProgressState(window, WindowHelper.TaskbarError)
}

function endExport(window) {
    WindowHelper.clearTaskbarProgress(window)
    WindowHelper.clearTaskbarOverlay(window)
}

// Optional badge while queued work remains:
WindowHelper.setTaskbarOverlayText(window, "3")
```

**Gallery:** System integration → **Taskbar progress** — slider + Normal / Paused / Error / Indeterminate / Clear + badge.

---

## Recipe — attention & reveal

```qml
// Soft flash once (taskbar / caption attention)
WindowHelper.requestUserAttention(Window.window, false)
// Continuous until the user focuses the window (Windows FlashWindowEx)
WindowHelper.requestUserAttention(Window.window, true)

if (!WindowHelper.revealFileInFolder(savedPath))
    console.warn("reveal failed — empty path or no Explorer/FileManager")
```

**Patterns**

1. After **Save** / export: `revealFileInFolder` so the user lands on the file.  
2. Background job finished while minimized: `requestUserAttention(window, false)`.  
3. Pair with in-app toast (`ToastHost` / `NotificationBridge`) — shell flash is not a substitute for accessible messaging.

**Gallery:** System integration → **Attention / files / idle** — Flash, Continuous flash, Reveal (needs a FilePicker path first).

---

## Idle inhibit

```qml
if (WindowHelper.inhibitIdle(qsTr("Exporting…"))) {
    // … long work …
    WindowHelper.releaseIdleInhibit()
}
```

Always release — forgetting leaves the display awake until process exit (Windows) or cookie release (Linux).

---

## Platform matrix (honest n/a)

| API | Windows | Linux | Notes |
|-----|---------|-------|-------|
| `snapLayoutsEnabled` | **Yes** — Win11 Snap Layouts via `HTMAXBUTTON` | **n/a** (no-op UX) | Needs Fluent maximize caption; Gallery switch disabled off-Windows |
| Taskbar progress / state / clear | **Yes** — `ITaskbarList3` | **n/a** (no-op) | Visible HWND; quiet fail if COM/taskbar blocked |
| Taskbar overlay badge | **Yes** — `SetOverlayIcon` | **n/a** (no-op) | Short text (≈2 chars); empty clears |
| `requestUserAttention` | **Yes** — `FlashWindowEx` | Best-effort — `raise` + `alert` | Wayland may ignore flash |
| `revealFileInFolder` | **Yes** — `explorer /select` | Best-effort — FileManager1 `ShowItems` → OpenURI folder → parent dir (**1.68**) | `false` on empty / launch failure |
| `inhibitIdle` | **Yes** — `SetThreadExecutionState` | Best-effort — ScreenSaver → portal Inhibit | `false` if both fail |
| `idleInhibited` | Tracks success | Tracks success | Stays `false` if inhibit failed |

**Still experimental (Gallery only):** battery / online / screens helpers, Jump Lists / recent-docs deepen, taskbar thumbnail toolbars. Snap Layouts toggle is documented here but **not** promoted to the stable API table (same defer as **1.17** / [stable-api.md](stable-api.md)).

---

## Failure checklist

1. **Snap flyout missing on Win11** — `snapLayoutsEnabled` false, or maximize caption not hit-tested as `HTMAXBUTTON` ([window-chrome.md](window-chrome.md)).  
2. **Taskbar APIs on Linux** — no visual; gate UI with `WindowHelper.windows`.  
3. **Progress with no effect on Windows** — window not shown yet, or Explorer/taskbar policy blocked COM.  
4. **Reveal returns false** — path empty, cancelled pick, or no FileManager1 / Explorer.  
5. **Idle inhibit false on Linux** — no Session bus / portal; do not assume sleep is blocked.  
6. **Forget `releaseIdleInhibit`** — display stays awake until process exit / cookie release.

---

## Related

- [system-integration.md](system-integration.md) — FilePicker / Tray / NotificationBridge  
- [print-share.md](print-share.md) — grab → save → reveal (**1.63**)  
- [platform-linux-wayland.md](platform-linux-wayland.md) — portal / SSD matrix (**1.38** / **1.68**)  
- [drag-drop.md](drag-drop.md) — reveal after save (**1.41**)  
- [stable-api.md](stable-api.md) — promoted taskbar / attention / reveal / idle surface
