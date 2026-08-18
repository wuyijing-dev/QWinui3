# Title-bar & shell chrome cookbook (2.05)

Integrator recipes for **WinUI header slots**, caption placement, and Windows **NC hit-test** when building on `StandardWindow` or the `ShellWindow` family.

**Gallery:** [TitleBar](../src/gallery/pages/TitleBarPage.qml) · [Window shells](../src/gallery/pages/WindowParadigmPage.qml) (Main host uses `StandardTitleChrome` + `FrameStatsBadge` in `rightHeader`).

**Related:** [window-chrome.md](window-chrome.md) (failure modes) · [window-shells.md](window-shells.md) (shell matrix) · [performance.md](performance.md#runtime-diagnostics-204) (FPS / RHI badge) · [components/TitleBar.md](components/TitleBar.md).

---

## Pick a host

| Host | Import | Title chrome | Typical app |
|------|--------|--------------|-------------|
| **`StandardWindow`** | `QWinUI3.Platform` | `StandardTitleChrome` (recommended) or raw `PlatformTitleBar` + `TitleBar` | Gallery-style hosts, backdrop experiments, low-level AppWindow |
| **`ShellWindow` family** | `QWinUI3.Extras` | `WindowChrome` inside `BlankWindow` / `NavigationWindow` / … | Product shells (`NavigationWindow` default) |

Both expose the same **WinUI slot names** at the API boundary: `leftHeader`, `titleBarContent`, `rightHeader`.  
The important difference is **where `rightHeader` lands** (see below).

---

## Slot anatomy

```
PlatformTitleBar row (left → right)
┌─────────────────────────────────────────────────────────────────────────┐
│  contentHost (TitleBar)          │ PlatformTitleBar │ caption min max x │
│  ┌ leftHeader │ title │ content │ .rightHeader     │                   │
│  └─────────────┴───────┴─────────┴──────────────────┴───────────────────┘
└─────────────────────────────────────────────────────────────────────────┘
         ▲                              ▲
   TitleBar.leftHeader /          PlatformTitleBar.rightHeader
   titleBarContent /              (StandardTitleChrome.rightHeader)
   TitleBar.rightHeader            — before caption buttons
   (ShellWindow.rightHeader)
```

| Slot | WinUI name | What to put here |
|------|------------|------------------|
| `leftHeader` | LeftHeader | Mode picker, compact toolbar, persona chip |
| `titleBarContent` | Content | Menu row, centered toolbar, custom search (disables built-in search when non-empty) |
| `rightHeader` | RightHeader | Trailing actions — **see placement rules below** |
| Built-in search | Content (empty) | Gallery catalog search when `searchEnabled` and Content slot empty |

On **Linux**, caption buttons are QML-only (no NC hit-test). Slot layout still matters for drag vs click regions.

---

## `rightHeader` — the main footgun

There are **two** RightHeader channels. Using the wrong one makes controls vanish or steals caption clicks on Windows.

| API | Maps to | Before caption buttons? | Use when |
|-----|---------|-------------------------|----------|
| **`StandardTitleChrome.rightHeader`** | `PlatformTitleBar.rightHeader` | **Yes** | `StandardWindow` hosts — FPS badge, Share, account menu |
| **`ShellWindow.rightHeader`** | `TitleBar.rightHeader` (inside drag band) | No — sits in title content | Shell apps — Share / More beside title (Gallery TitleBar page) |
| **`TitleBar.rightHeader`** (standalone / demo) | Same as ShellWindow | No | Demos, `WindowChrome`-less layouts |

**Rule of thumb**

- **`StandardWindow` + `StandardTitleChrome`:** put `FrameStatsBadge`, dense trailing controls, or anything that must stay **left of min/max/close** on `rightHeader` at the chrome root (Platform slot). Unnamed children of `StandardTitleChrome` also land there (`extraContent` default property) — they are **not** buried under the inner TitleBar.
- **Named TitleBar slots** on a standalone `TitleBar`: use `leftHeader:`, `content:`, and `rightHeader:` — unnamed children always go to `rightHeader` (the default property), so a toolbar `Row` without `content:` never appears in the middle band.
- **`ShellWindow` / `NavigationWindow`:** use `rightHeader` for normal trailing actions (Share, Settings). For diagnostics badge before captions on shells, prefer **`FrameStatsOverlay`** or Settings overlay mode — ShellWindow does not re-export PlatformTitleBar `rightHeader` today.

Historical pain: Gallery “Show FPS in title bar” was invisible until badge moved to PlatformTitleBar `rightHeader` ([friction-log.md](planning/friction-log.md) FL-001).

---

## Recipe: StandardWindow + StandardTitleChrome

Preferred low-boilerplate path (Gallery Main):

```qml
import QWinUI3.Platform
import QWinUI3.Extras

StandardWindow {
    id: win
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "MyAppMain"

    header: StandardTitleChrome {
        id: chrome
        targetWindow: win
        title: qsTr("My App")
        symbol: FluentIcons.Home
        isPaneToggleButtonVisible: true
        searchEnabled: true

        leftHeader: ComboBox { model: [qsTr("Draft"), qsTr("Published")] }

        titleBarContent: Row {
            spacing: 4
            Button { text: qsTr("Undo"); flat: true }
            Button { text: qsTr("Redo"); flat: true }
        }

        // PlatformTitleBar slot — before caption buttons
        rightHeader: Row {
            spacing: 4
            FrameStatsBadge { }   // optional; attach FrameStatsMonitor once
            Button { text: qsTr("Share"); flat: true }
        }
    }

    Component.onCompleted: {
        FrameStatsMonitor.attachWindow(win)
        Qt.callLater(function () { chrome.reportHitTest() })
    }
}
```

Raw `PlatformTitleBar` + embedded `TitleBar` is equivalent; `StandardTitleChrome` wires signals, height, and hit-test refresh for you.

---

## Recipe: ShellWindow / NavigationWindow

Application shells alias slots to `WindowChrome` → `TitleBar`:

```qml
import QWinUI3.Extras

NavigationWindow {
    geometryPersistenceKey: "MyAppMain"
    title: qsTr("Contoso")
    symbol: FluentIcons.Home
    isBackButtonVisible: true

    leftHeader: ComboBox { implicitWidth: 140; model: [qsTr("Team A"), qsTr("Team B")] }

    titleBarContent: MenuBar {
        // or Row of flat Buttons — see MenuStatusWindow for menusInTitleBar
    }

    rightHeader: Row {
        spacing: 4
        Button { text: qsTr("Share"); flat: true }
        Button { text: qsTr("Settings"); flat: true }
    }
}
```

`TitleBar` auto-calls `notifyChromeHitTest()` when slot children resize — `WindowChrome` forwards to `PlatformTitleBar.reportHitTest()`.

---

## Hit-test troubleshooting (Windows)

Native caption buttons rely on **screen-logical** rects (`mapToGlobal`). QML must re-report after layout moves.

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Min/max/close miss clicks after maximize or DPI change | Stale NC rects | Ensure `reportHitTest()` runs after resize / `screensChanged` — shells do this by default |
| Title-bar buttons drag the window instead of clicking | Item not in `clientExcludeRects` | Slot items inside `TitleBar` are tracked via `clientExcludeRectsFor()`; PlatformTitleBar `rightHeader` children are pushed in `reportHitTest()` |
| Snap Layouts flyout never appears | Maximize not `HTMAXBUTTON` | `WindowHelper.snapLayoutsEnabled` (default true) + valid hit-test — [shell-extras.md](shell-extras.md) |
| Custom chrome added but captions broke | Manual chrome without `reportHitTest` | Call `chrome.reportHitTest()` on `Component.onCompleted` (deferred) and after dynamic children |
| FPS badge toggled on but empty strip | Badge in `TitleBar.rightHeader` on `StandardTitleChrome` | Move to **`StandardTitleChrome.rightHeader`** (Platform slot) |
| Overlay controls steal caption hits | Badge parent not refreshing hit-test | `FrameStatsBadge` walks parents for `reportHitTest` / `notifyChromeHitTest` on monitor changes |

**Checklist**

1. Use `StandardTitleChrome` or `WindowChrome` — do not fork caption layout unless you call `WindowHelper.updateHitTestLayout`.
2. After programmatic show/hide of `rightHeader` children, expect automatic refresh; if you bypass slots, call `reportHitTest()` manually.
3. On mixed-DPI moves, listen for `WindowHelper.screensChanged` (wired in platform chrome).
4. Gallery soak: **High-DPI & monitors** — “125% ↔ 150%: caption clicks still work”.

Full chrome matrix: [window-chrome.md](window-chrome.md).

---

## Runtime diagnostics in the title bar (2.04+)

```qml
FrameStatsMonitor.attachWindow(window)   // once per top-level
// Settings → Show FPS + Title bar placement, or CLI --show-diagnostics

StandardTitleChrome {
    rightHeader: FrameStatsBadge { }      // StandardWindow — Platform slot
}
```

Readout format: `FPS · ms · OpenGL` (RHI suffix when **Show RHI** enabled). See [performance.md](performance.md).

---

## MenuBar in the title bar

`MenuStatusWindow` sets `menusInTitleBar: true` and places `MenuBar` in `titleBarContent`.  
Do not duplicate a system menu bar in `footer` when using this pattern — [window-shells.md](window-shells.md).

---

## Examples & Gallery map

| Sample | Pattern |
|--------|---------|
| Gallery `Main.qml` | `StandardTitleChrome` + Platform `rightHeader` + `FrameStatsBadge` |
| Gallery **TitleBar** page | Standalone `TitleBar` slots (LeftHeader / Content / RightHeader) |
| Gallery **Window shells** page | `ShellWindow` family + backdrop / geometry recipes |
| `examples/nav-settings` | `PlatformTitleBar` + `TitleBar` + `NavigationView` |
| `examples/gallery-shell` | Extractable `NavigationWindow` app shell |

---

## Out of scope (2.05)

- Replacing `PlatformTitleBar` or compositor-native title-bar protocols
- Exposing PlatformTitleBar `rightHeader` on `ShellWindow` (use overlay diagnostics or StandardWindow host if you need the Platform slot)
