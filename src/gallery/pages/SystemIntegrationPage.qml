import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — FilePicker, TrayIcon, display server, Snap Layouts, taskbar progress.

CatalogPage {
    id: page

    title: qsTr("System integration")
    subtitle: qsTr("FilePicker, TrayIcon, display server, taskbar, attention, files, and idle inhibit.")

    property string lastPath: qsTr("(none)")
    property real taskbarValue: 0.35

    TrayIcon {
        id: tray
        trayVisible: trayToggle.checked
        tooltip: qsTr("QWinUI3 Gallery")
        onNotified: function (title, message) {
            toasts.info(message, title)
        }
    }

    overlay: ToastHost {
        id: toasts
        width: 360
        placement: ToastHost.BottomCenter
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
                text: qsTr("WAYLAND_DISPLAY=%1").arg(WindowHelper.waylandDisplay)
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
                text: qsTr("Linux/Wayland: configurePlatformEnvironment() before QGuiApplication; FilePicker prefers xdg-desktop-portal then zenity/kdialog. See docs/platform-linux-wayland.md.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("FilePicker")
        qmlSource: "FilePicker.openFile(title, filters, function (path) { … })"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                text: qsTr("Last path: %1").arg(page.lastPath)
                wrapMode: Text.WrapAnywhere
                Layout.fillWidth: true
            }
            RowLayout {
                Button {
                    text: qsTr("Open file")
                    onClicked: FilePicker.openFile(qsTr("Open"), ["All (*.*)"], function (p) {
                        page.lastPath = p || qsTr("(cancelled)")
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
                      ? qsTr("Windows: Shell_NotifyIcon balloon.")
                      : qsTr("Linux: notify-send (install libnotify-bin).")
            }
            Button {
                text: qsTr("Notify")
                enabled: trayToggle.checked
                onClicked: tray.notifySystem(qsTr("QWinUI3"), qsTr("Notification from Gallery."))
            }
        }
    }

    ControlExample {
        headerText: qsTr("Taskbar progress")
        qmlSource: "WindowHelper.setTaskbarProgress(window, 0.4)"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                color: Theme.textSecondary
                text: WindowHelper.windows
                      ? qsTr("ITaskbarList3 overlay on the Gallery window.")
                      : qsTr("Windows only.")
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
        headerText: qsTr("Attention / files / idle")
        qmlSource: "requestUserAttention · revealFileInFolder · inhibitIdle · copyText"

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
                      ? qsTr("Windows: FlashWindowEx, Explorer /select, SetThreadExecutionState.")
                      : qsTr("Linux: raise/alert, FileManager1 ShowItems, ScreenSaver Inhibit.")
            }
        }
    }

    ControlExample {
        headerText: qsTr("Power / network / screens / recent")
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
