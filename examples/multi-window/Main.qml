import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Main + tool + owned dialog (1.56). Shared Theme (same process). Distinct geometry keys.
// Recipe: docs/window-shells.md · docs/window-helper.md · docs/window-chrome.md

ShellWindow {
    id: mainWindow
    width: 920
    height: 640
    visible: true
    title: qsTr("Multi-window example")
    subtitle: qsTr("examples/multi-window · 1.56")
    symbol: FluentIcons.OpenInNewWindow
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "MultiWindowExampleMain"

    property string statusText: qsTr("Open a tool window or an owned dialog. Theme is shared automatically.")
    readonly property string portalReadout: {
        var id = WindowHelper.portalParentWindow(mainWindow)
        return id.length
            ? qsTr("portal parent_window=%1").arg(id)
            : qsTr("portal parent_window=(empty on this session — still call openDialog(owner))")
    }

    Pane {
        anchors.fill: parent
        padding: Theme.spacingSection
        background: null

        ColumnLayout {
            anchors.fill: parent
            spacing: Theme.spacingLoose

            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Main shell uses geometryPersistenceKey \"MultiWindowExampleMain\". Tool window uses a separate key. Dialog uses setTransientParent + centerOnOwner via openDialog() (2.14).")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }

            RowLayout {
                spacing: Theme.spacing
                AccentButton {
                    text: qsTr("Open tool window")
                    onClicked: {
                        toolWindow.visible = true
                        toolWindow.raise()
                        toolWindow.requestActivate()
                        mainWindow.statusText = qsTr("Tool visible — move/resize it; geometry saves under MultiWindowExampleTool.")
                    }
                }
                Button {
                    text: qsTr("Open owned dialog")
                    onClicked: {
                        aboutDialog.openDialog(mainWindow)
                        mainWindow.statusText = qsTr("Dialog opened — transient parent + centerOnOwner (2.14). %1").arg(mainWindow.portalReadout)
                    }
                }
                Button {
                    text: qsTr("Clear saved layouts")
                    onClicked: {
                        mainWindow.clearSavedGeometry()
                        toolWindow.clearSavedGeometry()
                        aboutDialog.clearSavedGeometry()
                        mainWindow.statusText = qsTr("Cleared MultiWindowExampleMain / Tool / Dialog geometry keys.")
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: mainWindow.statusText
                color: Theme.textPrimary
            }

            Label {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("Win + Linux: prefer BackdropSolid. Distinct persistence keys per top-level role. Do not share one key across main and tool. ContentDialog stays in-window — use DialogShellWindow only for a real second HWND.")
                font.pixelSize: Theme.fontCaption
                color: Theme.textTertiary
            }

            Item { Layout.fillHeight: true }
        }
    }

    ToolShellWindow {
        id: toolWindow
        title: qsTr("Inspector")
        subtitle: qsTr("Secondary shell")
        symbol: FluentIcons.DeveloperTools
        width: 360
        height: 480
        visible: false
        backdrop: WindowHelper.BackdropSolid
        geometryPersistenceKey: "MultiWindowExampleTool"

        Pane {
            anchors.fill: parent
            padding: Theme.spacingSection
            background: null

            ColumnLayout {
                anchors.fill: parent
                spacing: Theme.spacing

                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("Same Theme.dark / accent as the main window — one QGuiApplication, no second Theme singleton.")
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontBody
                }

                SettingsToggleCard {
                    Layout.fillWidth: true
                    title: qsTr("Dark mode")
                    description: qsTr("Toggles Theme for every window in this process.")
                    checked: Theme.dark
                    onToggled: Theme.dark = checked
                }

                Item { Layout.fillHeight: true }

                Button {
                    Layout.alignment: Qt.AlignRight
                    text: qsTr("Close")
                    onClicked: toolWindow.close()
                }
            }
        }
    }

    DialogShellWindow {
        id: aboutDialog
        title: qsTr("About")
        subtitle: qsTr("Owned dialog shell")
        symbol: FluentIcons.Info
        ownerWindow: mainWindow
        width: 420
        height: 260
        visible: false
        backdrop: WindowHelper.BackdropSolid
        geometryPersistenceKey: "MultiWindowExampleDialog"

        Pane {
            anchors.fill: parent
            padding: Theme.spacingSection
            background: null

            ColumnLayout {
                anchors.fill: parent
                spacing: Theme.spacing

                Text {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: qsTr("openDialog(owner) calls ensureWindowCreated + setTransientParent + centerOnOwner. Prefer this over a second ContentDialog host.")
                    color: Theme.textSecondary
                }

                Item { Layout.fillHeight: true }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    AccentButton {
                        text: qsTr("OK")
                        onClicked: aboutDialog.closeDialog()
                    }
                }
            }
        }
    }
}
