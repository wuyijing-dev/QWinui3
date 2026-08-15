# Window shells (application layout paradigms)

Independent top-level hosts in `QWinUI3.Extras` share **`ShellWindow`**
(chrome + `WindowHelper`) — they do **not** subclass `StandardWindow`.

## ShellWindow vs StandardWindow

| | `ShellWindow` (Extras) | `StandardWindow` (Platform) |
|--|--|--|
| Audience | App layouts / workbench shells | Gallery host + low-level AppWindow |
| Chrome | `WindowChrome` + WinUI `TitleBar` slots | `PlatformTitleBar` (caption host) |
| Layout helpers | Blank / Nav / MenuStatus / Dialog / Tool / Overlay | DialogWindow / ToolWindow / CompactOverlayWindow |
| Typical use | Ship product UI with `title` / `navModel` / `Menu` | Custom AppWindow presenter / backdrop experiments |

Prefer **ShellWindow** family for applications. Keep **StandardWindow** when you need Platform presenters without Extras.

Platform chrome singleton: [`WindowHelper`](window-helper.md).

## Shared chrome API

```qml
title: qsTr("App")
subtitle: qsTr("Optional")
symbol: FluentIcons.Home
preferredHeightOption: WindowHelper.TitleBarHeightTall
isBackButtonVisible: true
rightHeader: Button { text: qsTr("Account") }
captionButtonHover: Theme.fillSubtle
titleBarBackground: Theme.bgAcrylic
```

## Shell types

| Type | Notes |
|------|--------|
| `BlankWindow` | Empty client |
| `NavigationWindow` | `NavigationView` hostContent + pane modes |
| `MenuStatusWindow` | `menusInTitleBar`, multi-segment `StatusBar` |
| `DialogShellWindow` | Dialog paradigm (`WindowHelper.ParadigmDialog`) |
| `ToolShellWindow` | Tool / palette paradigm |
| `CompactOverlayShellWindow` | Compact overlay presenter |

### Dialog / Tool / Overlay snippets

```qml
DialogShellWindow {
    title: qsTr("Confirm")
    width: 440; height: 280
    // content: …
}

ToolShellWindow {
    title: qsTr("Inspector")
    width: 320; height: 480
}

CompactOverlayShellWindow {
    title: qsTr("Now playing")
    width: 360; height: 200
}
```

Gallery demos: `WindowParadigmPage`.

## NavigationWindow / NavigationView

`paneDisplayMode`: `left` | `leftCompact` | `leftMinimal` | `top` | `auto`  
(`auto` switches left ↔ leftCompact at `autoCompactThreshold`, default 1008.)

- **`leftMinimal`**: pane is a light-dismiss **overlay** (does not push content).
- Pane search: `isPaneSearchEnabled` + `paneSearchModel`
- `paneHeader` / `paneFooter` slots
- Item `badge` / `badgeValue` → `InfoBadge`
- Drag reorder: `isReorderable` + `onModelReordered`
- Keyboard Home/End/type-ahead; compact flyout ↑↓ Enter Esc
- Top overflow `…` lists only **clipped** items

Gallery `Main.qml` enables `auto`, pane search, badges, and reorder as the living sample.

## StatusBar

```qml
StatusBar {
    text: qsTr("Ready")
    progress: 0.4
    centerContent: Label { text: qsTr("Ln 12") }
    content: Label { text: qsTr("UTF-8") }
}
```

## ContentDialog queue

`ContentDialog.show()` enqueues via `ContentDialogQueue` (one visible dialog at a time).

```qml
ContentDialogQueue.show(dialogA)
ContentDialogQueue.cancel(dialogA)       // drop pending
ContentDialogQueue.clearQueue()          // drop all pending
ContentDialogQueue.replaceCurrent(dialogB) // close active, open B; queue resumes after
```

## Theme tokens (WinUI-aligned)

| Token | Typical WinUI | QWinUI3 |
|-------|---------------|---------|
| Control corner | 4px | `Theme.cornerControl` |
| Overlay / flyout corner | 8px | `Theme.cornerOverlay` / `cornerCard` |
| Focus outer / inner | 2px + 1px | `strokeFocusOuter` / `strokeFocusInner` + `focusOuter` / `focusInner` |
| Nav pane expanded | ~320 / 280 | `navPaneWidth` (280) |
| Nav compact | 48 | `navPaneCompactWidth` |
| Control padding | 12×7 | `paddingControlH` / `paddingControlV` |
| Spacing scale | 8 / 12 / 24 | `spacing` / `spacingLoose` / `spacingSection` |

Accessibility: `Theme.followSystemAccessibility` (default true) copies
`WindowHelper.systemReducedMotion` / `systemHighContrast` (Windows SPI) into
`Theme.reducedMotion` / `Theme.highContrast`. Settings can override when follow is off.

## Non-Windows notes

`WindowHelper` native chrome / DWM backdrop / hit-test are Windows-first.
On Linux/macOS, `applyNative` / hit-test layout are stubs — shells still run with Qt chrome.
See `window-appwindow.md` and `window-transparency-dwm.md`.
