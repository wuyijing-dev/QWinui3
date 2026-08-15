import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

Page {
    id: root
    padding: 0

    readonly property var cornerLabels: [
        qsTr("Round"),
        qsTr("Round small"),
        qsTr("Square"),
        qsTr("Default")
    ]
    readonly property var cornerValues: [
        WindowHelper.CornerRound,
        WindowHelper.CornerRoundSmall,
        WindowHelper.CornerDoNotRound,
        WindowHelper.CornerDefault
    ]

    readonly property var rhiLabels: {
        var labels = []
        var list = GraphicsBackend.available
        for (var i = 0; i < list.length; ++i)
            labels.push(rhiDisplayName(list[i]))
        return labels
    }

    function rhiDisplayName(id) {
        switch (id) {
        case "opengl": return qsTr("OpenGL")
        case "vulkan": return qsTr("Vulkan")
        case "d3d11": return qsTr("Direct3D 11")
        case "d3d12": return qsTr("Direct3D 12")
        case "metal": return qsTr("Metal")
        default: return id
        }
    }

    function findIndex(values, value) {
        for (var i = 0; i < values.length; ++i) {
            if (values[i] === value)
                return i
        }
        return 0
    }

    function syncCornerBox() {
        var i = findIndex(cornerValues, WindowHelper.cornerPreference)
        if (cornerBox.currentIndex !== i)
            cornerBox.currentIndex = i
    }

    function syncRhiBox() {
        var i = findIndex(GraphicsBackend.available, GraphicsBackend.preferred)
        if (rhiBox.currentIndex !== i)
            rhiBox.currentIndex = i
    }

    function applyCornerAt(index) {
        if (index < 0 || index >= cornerValues.length)
            return
        WindowHelper.setCornerStyle(Window.window, cornerValues[index])
    }

    Component.onCompleted: {
        syncCornerBox()
        syncRhiBox()
    }

    Connections {
        target: WindowHelper
        function onCornerPreferenceChanged() { root.syncCornerBox() }
    }

    Connections {
        target: GraphicsBackend
        function onChanged() { root.syncRhiBox() }
    }

    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        background: null

        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection

            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("Settings")
                subtitle: qsTr("Theme, motion, corners, and graphics backend.")
            }

            SettingsCard {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                title: qsTr("Appearance")
                description: qsTr("Toggles the QWinUI3 Theme singleton between light and dark color ramps.")
                headerIcon: "\uE790"
                action: Switch {
                    text: Theme.dark ? qsTr("Dark") : qsTr("Light")
                    checked: Theme.dark
                    onToggled: Theme.dark = checked
                }
            }

            SettingsCard {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                title: qsTr("Motion")
                description: qsTr("When enabled, Theme.duration() collapses animations for accessibility.")
                headerIcon: "\uE945"
                action: Switch {
                    text: qsTr("Reduce motion")
                    checked: Theme.reducedMotion
                    onToggled: Theme.reducedMotion = checked
                }
            }

            SettingsCard {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                enabled: WindowHelper.nativeChrome
                title: qsTr("Window corners")
                description: qsTr("DWM corner preference — round (Win11), round small, or square.")
                headerIcon: "\uE8B9"
                action: ComboBox {
                    id: cornerBox
                    implicitWidth: 160
                    model: root.cornerLabels
                    onActivated: function (index) { root.applyCornerAt(index) }
                }
            }

            SettingsCard {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                title: qsTr("Graphics backend")
                description: qsTr("Qt Quick RHI API. Must restart to apply. Active: %1. %2")
                             .arg(root.rhiDisplayName(GraphicsBackend.active))
                             .arg(GraphicsBackend.hint)
                headerIcon: "\uE7F4"
                action: RowLayout {
                    spacing: Theme.spacing
                    ComboBox {
                        id: rhiBox
                        implicitWidth: 160
                        model: root.rhiLabels
                        onActivated: function (index) {
                            if (index < 0 || index >= GraphicsBackend.available.length)
                                return
                            GraphicsBackend.preferred = GraphicsBackend.available[index]
                        }
                    }
                    Button {
                        text: qsTr("Restart")
                        visible: GraphicsBackend.restartRequired
                        onClicked: GraphicsBackend.restartApplication()
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
