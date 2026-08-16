import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — FilePicker, TrayIcon, display server, Snap Layouts, shell extras.
//
// Linux Wayland edge cases: docs/platform-linux-wayland.md (1.38).
// Shell extras: docs/shell-extras.md (1.17). System integration: docs/system-integration.md

CatalogPage {
    id: page

    title: qsTr("System integration")
    subtitle: qsTr("FilePicker / Tray / portals. Linux Wayland matrix: docs/platform-linux-wayland.md (1.38).")

    property string lastPath: qsTr("(none)")
    property real taskbarValue: 0.35

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
        headerText: qsTr("Linux / Wayland (1.38)")
        qmlSource: "// docs/platform-linux-wayland.md\n// SSD off · Solid backdrop · portal FilePicker · SNI tray"
        visible: WindowHelper.linux
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Field matrix: double title bar → keep QT_WAYLAND_DISABLE_WINDOWDECORATION=1; Mica hollow → BackdropSolid; pure Wayland FilePicker has empty portal parent_window (still pass Window.window); GNOME tray needs SNI/AppIndicator. CI Linux --smoke is offscreen — not a compositor soak.")
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
        }
    }

    ControlExample {
        headerText: qsTr("Platform / display server")
        qmlSource: "WindowHelper.displayServer · wayland · x11 · snapLayoutsEnabled"

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
                text: qsTr("Snap Layouts (Win11 HTMAXBUTTON)")
                checked: WindowHelper.snapLayoutsEnabled
                enabled: WindowHelper.windows
                onToggled: WindowHelper.snapLayoutsEnabled = checked
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
                text: qsTr("Bootstrap configureEnvironment before QGuiApplication. FilePicker: portal → zenity/kdialog. Full matrix: docs/platform-linux-wayland.md (1.38).")
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
                text: qsTr("Cancel → empty path. Always pass Window.window for dialog ownership (X11 parent_window; pure Wayland parent is empty — docs/platform-linux-wayland.md 1.38).")
            }
            RowLayout {
                Button {
                    text: qsTr("Open file")
                    onClicked: FilePicker.openFile(qsTr("Open"), ["All (*.*)"], function (p) {
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
        headerText: qsTr("Taskbar progress (1.17 stable)")
        qmlSource: "WindowHelper.setTaskbarProgress(window, 0.4)\n// docs/shell-extras.md"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: WindowHelper.windows
                      ? qsTr("ITaskbarList3 overlay on the Gallery window. Stable API — docs/shell-extras.md.")
                      : qsTr("Windows only (no-op on Linux). See docs/shell-extras.md.")
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
        headerText: qsTr("Attention / files / idle (1.17 stable)")
        qmlSource: "requestUserAttention · revealFileInFolder · inhibitIdle\n// docs/shell-extras.md"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            RowLayout {
                Button {
                    text: qsTr("Flash / attention")
                    onClicked: WindowHelper.requestUserAttention(page.Window.window, false)
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
                      : qsTr("Linux: raise/alert, FileManager1 ShowItems, ScreenSaver/portal Inhibit — docs/shell-extras.md.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Power / network / screens / recent (experimental)")
        qmlSource: "batteryLevel · isOnline · screensInfo() · addToRecentDocuments"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
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
                        parts.push((s.primary ? "* " : "  ") + s.name
                                   + " @" + Number(s.dpr).toFixed(2)
                                   + " " + s.geometry.width + "x" + s.geometry.height)
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
