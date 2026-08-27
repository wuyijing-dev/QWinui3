import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Main + tool + owned dialog + WindowMessageBus + PanelFloatHost (3.08).
// Recipe: docs/window-shells.md · docs/app-platform-3xx.md

ShellWindow {
    id: mainWindow
    width: 960
    height: 680
    visible: true
    title: qsTr("Multi-window example")
    subtitle: qsTr("examples/multi-window · 3.08 W7–W8")
    symbol: FluentIcons.OpenInNewWindow
    backdrop: WindowHelper.BackdropSolid
    geometryPersistenceKey: "MultiWindowExampleMain"

    property string statusText: qsTr("Open a tool window, float the filter pane, or broadcast appearance.")
    property var _busUnsub: null
    readonly property string portalReadout: {
        var id = WindowHelper.portalParentWindow(mainWindow)
        return id.length
            ? qsTr("portal parent_window=%1").arg(id)
            : qsTr("portal parent_window=(empty on this session — still call openDialog(owner))")
    }

    function broadcastAppearance() {
        WindowMessageBus.post("appearance", {
            dark: Theme.dark,
            accentPack: Theme.accentPack,
            layoutDirection: WindowHelper.layoutDirection
        })
        mainWindow.statusText = qsTr("Posted appearance on WindowMessageBus (theme / accent / layoutDirection).")
    }

    function applyAppearance(payload) {
        if (!payload)
            return
        if (payload.dark !== undefined)
            Theme.dark = !!payload.dark
        if (payload.accentPack !== undefined && String(payload.accentPack).length)
            Theme.accentPack = String(payload.accentPack)
        if (payload.layoutDirection !== undefined)
            WindowHelper.setLayoutDirection(payload.layoutDirection)
    }

    Component.onCompleted: {
        mainWindow._busUnsub = WindowMessageBus.subscribe("appearance", function (p) {
            mainWindow.applyAppearance(p)
            mainWindow.statusText = qsTr("Received appearance bus message.")
        })
    }
    Component.onDestruction: {
        if (typeof mainWindow._busUnsub === "function")
            mainWindow._busUnsub()
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
                text: qsTr("W7: WindowMessageBus channel \"appearance\" syncs Theme / accent / layoutDirection across shells. W8: PanelFloatHost detaches a pane into ToolShellWindow.")
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
                        mainWindow.statusText = qsTr("Tool visible — MultiWindowExampleTool geometry key.")
                    }
                }
                Button {
                    text: qsTr("Open owned dialog")
                    onClicked: {
                        aboutDialog.openDialog(mainWindow)
                        mainWindow.statusText = qsTr("Dialog opened — %1").arg(mainWindow.portalReadout)
                    }
                }
                Button {
                    text: qsTr("Broadcast appearance")
                    onClicked: mainWindow.broadcastAppearance()
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

            SettingsToggleCard {
                Layout.fillWidth: true
                title: qsTr("Dark mode")
                description: qsTr("Toggles Theme then posts WindowMessageBus \"appearance\".")
                checked: Theme.dark
                onToggled: {
                    Theme.dark = checked
                    mainWindow.broadcastAppearance()
                }
            }

            PanelFloatHost {
                id: filterFloat
                Layout.fillWidth: true
                Layout.preferredHeight: 200
                title: qsTr("Filters")
                subtitle: qsTr("Floated filter pane")
                geometryPersistenceKey: "MultiWindowExampleFilterFloat"
                content: ColumnLayout {
                    spacing: Theme.spacing
                    CheckBox { text: qsTr("Live metrics"); checked: true }
                    CheckBox { text: qsTr("Sev1 only") }
                    Label {
                        Layout.fillWidth: true
                        wrapMode: Text.Wrap
                        color: Theme.textSecondary
                        font.pixelSize: Theme.fontCaption
                        text: qsTr("Float moves this body into a ToolShellWindow; Dock restores it here.")
                    }
                }
                onFloated: mainWindow.statusText = qsTr("Filter pane floated.")
                onDocked: mainWindow.statusText = qsTr("Filter pane docked.")
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
                text: qsTr("Win + Linux: BackdropSolid. Distinct persistence keys per top-level role. Bus is same-process only.")
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

        property var _busUnsub: null

        Component.onCompleted: {
            toolWindow._busUnsub = WindowMessageBus.subscribe("appearance", function (p) {
                mainWindow.applyAppearance(p)
            })
        }
        Component.onDestruction: {
            if (typeof toolWindow._busUnsub === "function")
                toolWindow._busUnsub()
        }

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
                    text: qsTr("Subscribes to WindowMessageBus \"appearance\". Accent pack changes from here also broadcast.")
                    color: Theme.textSecondary
                    font.pixelSize: Theme.fontBody
                }

                SettingsToggleCard {
                    Layout.fillWidth: true
                    title: qsTr("Dark mode")
                    checked: Theme.dark
                    onToggled: {
                        Theme.dark = checked
                        mainWindow.broadcastAppearance()
                    }
                }

                SettingsComboCard {
                    Layout.fillWidth: true
                    title: qsTr("Accent")
                    model: [qsTr("Blue"), qsTr("Purple"), qsTr("Green"), qsTr("Orange")]
                    currentIndex: {
                        switch (Theme.accentPack) {
                        case "purple": return 1
                        case "green": return 2
                        case "orange": return 3
                        default: return 0
                        }
                    }
                    onActivated: function (index) {
                        var packs = ["blue", "purple", "green", "orange"]
                        Theme.accentPack = packs[index]
                        mainWindow.broadcastAppearance()
                    }
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
                    text: qsTr("openDialog(owner) calls ensureWindowCreated + setTransientParent + centerOnOwner.")
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
