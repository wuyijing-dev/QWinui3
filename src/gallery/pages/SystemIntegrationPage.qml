import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — FilePicker, TrayIcon, display server, Snap Layouts, shell extras.
//
// Linux Wayland edge cases: docs/platform-linux-wayland.md (1.38 / 1.68).
// Shell extras / Snap: docs/shell-extras.md (1.47). System integration: docs/system-integration.md

CatalogPage {
    id: page

    title: qsTr("System integration")
    subtitle: qsTr("FilePicker · tray · Snap · reveal. Linux portal: docs/platform-linux-wayland.md (1.68).")

    property string lastPath: qsTr("(none)")
    property real taskbarValue: 0.35
    property string snapHint: ""

    TrayIcon {
        id: tray
        trayVisible: trayToggle.checked
        tooltip: qsTr("QWinUI3 Gallery")
        iconName: "dialog-information"
        onNotified: function (title, message) {
            toasts.info(message, title)
        }
        onTrayActivated: function (reason) {
            toasts.info(qsTr("reason 0x%1").arg(Number(reason).toString(16)), qsTr("Tray click"))
        }
    }

    overlay: ToastHost {
        id: toasts
        width: 360
        placement: ToastHost.BottomCenter
    }

    ControlExample {
        headerText: qsTr("Linux / Wayland (1.68)")
        qmlSource: "// docs/platform-linux-wayland.md\n// SSD off · Solid · portal FilePicker · SNI tray"
        visible: WindowHelper.linux
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Field matrix: double title bar → QT_WAYLAND_DISABLE_WINDOWDECORATION=1; Mica hollow → BackdropSolid; portal timeout no longer opens zenity as a second dialog (1.68). Pure Wayland parent_window may still be empty — still pass Window.window. GNOME tray needs SNI/AppIndicator. CI Linux --smoke is offscreen — not a compositor soak.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("customFrame=%1 · serverSideDecorations=%2 · supportsBackdrop=%3 · portal=%4 · SNI active=%5")
                    .arg(WindowHelper.customFrame)
                    .arg(WindowHelper.serverSideDecorations)
                    .arg(WindowHelper.supportsBackdrop)
                    .arg(WindowHelper.portalAvailable)
                    .arg(tray.persistentTrayActive)
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WrapAnywhere
                color: Theme.textSecondary
                text: {
                    var p = WindowHelper.portalParentWindow(page.Window.window)
                    return qsTr("portal parent_window=%1")
                        .arg(p && p.length ? p : qsTr("(empty — X11 uses x11:0x…; Wayland export is best-effort)"))
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Platform / display server")
        qmlSource: "WindowHelper.displayServer · wayland · x11"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("OS: %1 · DE: %2 · displayServer: %3 · Wayland: %4 · portal: %5 · DPR: %6 · Theme DPR: %7 · prefersDark: %8")
                    .arg(WindowHelper.platformName)
                    .arg(WindowHelper.desktopEnvironment)
                    .arg(WindowHelper.displayServer)
                    .arg(WindowHelper.wayland)
                    .arg(WindowHelper.portalAvailable)
                    .arg(WindowHelper.devicePixelRatio.toFixed(2))
                    .arg(Theme.devicePixelRatio.toFixed(2))
                    .arg(WindowHelper.systemPrefersDark)
            }
            Label {
                visible: WindowHelper.wayland && WindowHelper.waylandDisplay.length
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("WAYLAND_DISPLAY=%1 · SSD=%2 · customFrame=%3")
                    .arg(WindowHelper.waylandDisplay)
                    .arg(WindowHelper.serverSideDecorations)
                    .arg(WindowHelper.customFrame)
            }
            Switch {
                text: qsTr("Follow system color scheme")
                checked: Theme.followSystemColorScheme
                onToggled: {
                    Theme.followSystemColorScheme = checked
                    if (checked) {
                        WindowHelper.refreshColorScheme()
                        Theme.dark = WindowHelper.systemPrefersDark
                    }
                }
            }
            Label {
                visible: WindowHelper.linux
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Bootstrap configureEnvironment before QGuiApplication. FilePicker: portal → zenity/kdialog (1.68: no double dialog after portal timeout). Full matrix: docs/platform-linux-wayland.md.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Snap Layouts (1.47)")
        qmlSource: "WindowHelper.snapLayoutsEnabled = true\n// Hover Win11 maximize caption — docs/shell-extras.md"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: WindowHelper.windows
                      ? qsTr("Win11 only (experimental). When enabled, maximize caption hit-tests as HTMAXBUTTON so Snap Layouts can appear. Hover the maximize button in the title bar — do not click yet. Toggle off to report HTCLIENT instead. Recipe: docs/shell-extras.md.")
                      : qsTr("n/a on Linux / Wayland — no Snap Layouts flyout. Property is a no-op here; see docs/shell-extras.md platform matrix.")
            }
            Switch {
                id: snapSwitch
                text: qsTr("Enable Snap Layouts (HTMAXBUTTON)")
                checked: WindowHelper.snapLayoutsEnabled
                enabled: WindowHelper.windows
                onToggled: {
                    WindowHelper.snapLayoutsEnabled = checked
                    page.snapHint = checked
                            ? qsTr("On — hover the maximize caption to try Snap Layouts.")
                            : qsTr("Off — maximize caption will not open Snap Layouts.")
                    if (WindowHelper.windows)
                        toasts.info(page.snapHint, qsTr("Snap Layouts"))
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textPrimary
                text: qsTr("snapLayoutsEnabled=%1 · nativeChrome=%2 · customFrame=%3")
                    .arg(WindowHelper.snapLayoutsEnabled)
                    .arg(WindowHelper.nativeChrome)
                    .arg(WindowHelper.customFrame)
            }
            Label {
                visible: page.snapHint.length > 0
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: page.snapHint
            }
        }
    }

    ControlExample {
        headerText: qsTr("FilePicker")
        qmlSource: "FilePicker.openFile(title, filters, function (path) { … }, Window.window)"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                text: qsTr("Last path: %1").arg(page.lastPath)
                wrapMode: Text.WrapAnywhere
                Layout.fillWidth: true
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Cancel → empty path. Always pass Window.window (X11 parent_window; Wayland export best-effort — docs/platform-linux-wayland.md 1.68).")
            }
            RowLayout {
                Button {
                    text: qsTr("Open file")
                    onClicked: FilePicker.openFile(qsTr("Open"), ["Text (*.txt *.md)", "All (*.*)"], function (p) {
                        page.lastPath = p || qsTr("(cancelled)")
                    }, page.Window.window)
                }
                Button {
                    text: qsTr("Open files")
                    onClicked: FilePicker.openFiles(qsTr("Open"), ["All (*.*)"], function (paths) {
                        page.lastPath = (paths && paths.length)
                                       ? paths.join("; ") : qsTr("(cancelled)")
                    }, page.Window.window)
                }
                Button {
                    text: qsTr("Open folder")
                    onClicked: FilePicker.openFolder(qsTr("Folder"), function (p) {
                        page.lastPath = p || qsTr("(cancelled)")
                    }, page.Window.window)
                }
                Button {
                    text: qsTr("Save file")
                    onClicked: FilePicker.saveFile(qsTr("Save"), ["Text (*.txt)"], function (p) {
                        page.lastPath = p || qsTr("(cancelled)")
                    }, "txt", page.Window.window)
                }
                Button {
                    text: qsTr("Open docs URL")
                    onClicked: WindowHelper.openExternalUrl("https://github.com/")
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("TrayIcon")
        qmlSource: "TrayIcon { trayVisible: true }\ntray.notifySystem(title, body)"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Switch {
                id: trayToggle
                text: qsTr("Enable tray icon / notify")
                checked: false
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: WindowHelper.windows
                      ? qsTr("Windows: Shell_NotifyIcon balloon + persistent tray.")
                      : qsTr("Linux: StatusNotifierItem when a tray watcher is present (KDE Plasma reference; GNOME needs SNI/AppIndicator). notifySystem → portal / notify-send. supportsPersistentTray=%1, persistentTrayActive=%2 — docs/platform-linux-wayland.md (1.38).")
                            .arg(tray.supportsPersistentTray).arg(tray.persistentTrayActive)
            }
            Button {
                text: qsTr("Notify info")
                enabled: trayToggle.checked
                onClicked: tray.notifySystem(qsTr("QWinUI3"), qsTr("Info balloon."), 0)
            }
            Button {
                text: qsTr("Notify warning")
                enabled: trayToggle.checked
                onClicked: tray.notifySystem(qsTr("QWinUI3"), qsTr("Warning balloon."), 1)
            }
            Button {
                text: qsTr("Notify error")
                enabled: trayToggle.checked
                onClicked: tray.notifySystem(qsTr("QWinUI3"), qsTr("Error balloon."), 2)
            }
        }
    }

    ControlExample {
        headerText: qsTr("Taskbar progress (1.47 recipe)")
        qmlSource: "setTaskbarProgress · TaskbarPaused / Error\n// docs/shell-extras.md"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: WindowHelper.windows
                      ? qsTr("Stable ITaskbarList3 API. Typical loop: Normal + progress → Paused/Error → clear. Optional overlay badge for queued work. Full recipe: docs/shell-extras.md (1.47).")
                      : qsTr("Windows only — n/a on Linux (no-op). Gate UI with WindowHelper.windows. See docs/shell-extras.md.")
            }
            Slider {
                id: progressSlider
                from: 0
                to: 1
                value: page.taskbarValue
                Layout.fillWidth: true
                enabled: WindowHelper.windows
                onMoved: {
                    page.taskbarValue = value
                    WindowHelper.setTaskbarProgress(page.Window.window, value)
                }
            }
            RowLayout {
                Button {
                    text: qsTr("Normal")
                    enabled: WindowHelper.windows
                    onClicked: {
                        WindowHelper.setTaskbarProgressState(page.Window.window, WindowHelper.TaskbarNormal)
                        WindowHelper.setTaskbarProgress(page.Window.window, page.taskbarValue)
                    }
                }
                Button {
                    text: qsTr("Paused")
                    enabled: WindowHelper.windows
                    onClicked: WindowHelper.setTaskbarProgressState(page.Window.window, WindowHelper.TaskbarPaused)
                }
                Button {
                    text: qsTr("Error")
                    enabled: WindowHelper.windows
                    onClicked: WindowHelper.setTaskbarProgressState(page.Window.window, WindowHelper.TaskbarError)
                }
                Button {
                    text: qsTr("Indeterminate")
                    enabled: WindowHelper.windows
                    onClicked: WindowHelper.setTaskbarProgressState(page.Window.window, WindowHelper.TaskbarIndeterminate)
                }
                Button {
                    text: qsTr("Clear")
                    enabled: WindowHelper.windows
                    onClicked: WindowHelper.clearTaskbarProgress(page.Window.window)
                }
            }
            RowLayout {
                Button {
                    text: qsTr("Badge 3")
                    enabled: WindowHelper.windows
                    onClicked: WindowHelper.setTaskbarOverlayText(page.Window.window, "3")
                }
                Button {
                    text: qsTr("Clear badge")
                    enabled: WindowHelper.windows
                    onClicked: WindowHelper.clearTaskbarOverlay(page.Window.window)
                }
            }
        }
    }

    ControlExample {
        headerText: qsTr("Attention / reveal / idle (1.47)")
        qmlSource: "requestUserAttention · revealFileInFolder · inhibitIdle\n// docs/shell-extras.md"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("After Save: revealFileInFolder. Background job done while minimized: requestUserAttention. Pair with a toast for accessibility. Pick a file above first to enable Reveal.")
            }
            RowLayout {
                Button {
                    text: qsTr("Flash once")
                    onClicked: WindowHelper.requestUserAttention(page.Window.window, false)
                }
                Button {
                    text: qsTr("Flash continuous")
                    onClicked: WindowHelper.requestUserAttention(page.Window.window, true)
                }
                Button {
                    text: qsTr("System beep")
                    onClicked: WindowHelper.systemBeep()
                }
                Button {
                    text: qsTr("Copy path")
                    onClicked: {
                        WindowHelper.copyText(page.lastPath)
                        toasts.info(qsTr("Copied to clipboard"), qsTr("Clipboard"))
                    }
                }
                Button {
                    text: qsTr("Reveal in folder")
                    enabled: page.lastPath.length > 0 && page.lastPath !== qsTr("(none)") && page.lastPath !== qsTr("(cancelled)")
                    onClicked: {
                        if (!WindowHelper.revealFileInFolder(page.lastPath))
                            toasts.info(qsTr("Could not reveal path"), qsTr("Files"))
                        else
                            toasts.info(qsTr("Opened in file manager"), qsTr("Files"))
                    }
                }
            }
            Switch {
                text: qsTr("Inhibit idle / screensaver")
                checked: WindowHelper.idleInhibited
                onToggled: {
                    if (checked)
                        WindowHelper.inhibitIdle(qsTr("QWinUI3 Gallery demo"))
                    else
                        WindowHelper.releaseIdleInhibit()
                }
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: WindowHelper.windows
                      ? qsTr("Windows: FlashWindowEx, Explorer /select, SetThreadExecutionState — docs/shell-extras.md.")
                      : qsTr("Linux: raise/alert (may ignore flash on Wayland), FileManager1 ShowItems → OpenURI folder → QDesktopServices (1.68), ScreenSaver/portal Inhibit — docs/shell-extras.md.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Power / network / screens / recent (experimental)")
        qmlSource: "batteryLevel · isOnline · screensInfo() · addToRecentDocuments\n// DPI polish: HighDpiPage · docs/high-dpi.md (1.58)"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: qsTr("Full DPR / availableGeometry readout + GalleryMain clear: Gallery High-DPI & monitors (docs/high-dpi.md).")
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Battery: %1% · onBattery: %2 · online: %3 · screens: %4")
                    .arg(WindowHelper.batteryLevel < 0 ? qsTr("n/a") : String(WindowHelper.batteryLevel))
                    .arg(WindowHelper.onBattery)
                    .arg(WindowHelper.isOnline)
                    .arg(WindowHelper.screenCount)
            }
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WrapAnywhere
                color: Theme.textSecondary
                text: {
                    var list = WindowHelper.screensInfo()
                    var parts = []
                    for (var i = 0; i < list.length; ++i) {
                        var s = list[i]
                        var a = s.availableGeometry
                        parts.push((s.primary ? "* " : "  ") + s.name
                                   + " @" + Number(s.dpr).toFixed(2)
                                   + " " + s.geometry.width + "x" + s.geometry.height
                                   + " avail " + a.width + "x" + a.height)
                    }
                    return parts.join("\n")
                }
            }
            RowLayout {
                Button {
                    text: qsTr("Refresh power/online")
                    onClicked: {
                        WindowHelper.refreshPowerStatus()
                        WindowHelper.refreshOnlineStatus()
                    }
                }
                Button {
                    text: qsTr("Add path to Recent")
                    enabled: page.lastPath.length > 0 && page.lastPath !== qsTr("(none)") && page.lastPath !== qsTr("(cancelled)")
                    onClicked: {
                        WindowHelper.addToRecentDocuments(page.lastPath)
                        toasts.info(qsTr("Added to recent documents"), qsTr("Shell"))
                    }
                }
                Button {
                    text: qsTr("Clear Recent")
                    enabled: WindowHelper.windows
                    onClicked: {
                        WindowHelper.clearRecentDocuments()
                        toasts.info(qsTr("Cleared recent documents"), qsTr("Shell"))
                    }
                }
            }
        }
    }
}
