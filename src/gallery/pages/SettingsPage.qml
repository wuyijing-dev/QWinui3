import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — Settings.
//
// Theme, motion, corners, and graphics backend.

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

    SettingsView {
        anchors.fill: parent
        title: qsTr("Settings")
        subtitle: qsTr("Theme, motion, corners, and graphics backend.")

        SettingsCard {
            title: qsTr("Density")
            description: qsTr("Theme.density scales controlHeight, padding, and spacing.")
            headerIcon: "\uE8A5"
            action: ComboBox {
                model: [qsTr("Standard"), qsTr("Compact")]
                currentIndex: Theme.density === "compact" ? 1 : 0
                onActivated: function (index) {
                    Theme.density = index === 1 ? "compact" : "standard"
                }
            }
        }

        SettingsCard {
            title: qsTr("Accent pack")
            description: qsTr("Theme.accentPack / setAccentPack — blue, purple, green, orange.")
            headerIcon: "\uE790"
            action: ComboBox {
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
                    Theme.setAccentPack(packs[index])
                }
            }
        }

        SettingsCard {
            title: qsTr("Appearance")
            description: qsTr("Toggles the QWinUI3 Theme singleton between light and dark color ramps.")
            headerIcon: "\uE790"
            toggle: true
            toggleText: Theme.dark ? qsTr("Dark") : qsTr("Light")
            checked: Theme.dark
            onToggled: Theme.dark = checked
        }

        SettingsCard {
            title: qsTr("Follow system accessibility")
            description: qsTr("Copy OS reduce-motion / high-contrast into Theme when the window is active.")
            headerIcon: "\uE7F4"
            toggle: true
            toggleText: Theme.followSystemAccessibility ? qsTr("On") : qsTr("Off")
            checked: Theme.followSystemAccessibility
            onToggled: {
                Theme.followSystemAccessibility = checked
                if (checked) {
                    WindowHelper.refreshAccessibility()
                    Theme.reducedMotion = WindowHelper.systemReducedMotion
                    Theme.highContrast = WindowHelper.systemHighContrast
                }
            }
        }

        SettingsCard {
            title: qsTr("Follow system color scheme")
            description: qsTr("Mirror WindowHelper.systemPrefersDark (portal / gsettings / Windows) into Theme.dark.")
            headerIcon: "\uE706"
            toggle: true
            toggleText: Theme.followSystemColorScheme ? qsTr("On") : qsTr("Off")
            checked: Theme.followSystemColorScheme
            onToggled: {
                Theme.followSystemColorScheme = checked
                if (checked) {
                    WindowHelper.refreshColorScheme()
                    Theme.dark = WindowHelper.systemPrefersDark
                }
            }
        }

        SettingsCard {
            title: qsTr("Motion")
            description: Theme.followSystemAccessibility
                         ? qsTr("Driven by system (SPI client-area animation). Turn off “Follow system” to override.")
                         : qsTr("When enabled, Theme.duration() collapses animations for accessibility.")
            headerIcon: "\uE945"
            toggle: true
            toggleText: qsTr("Reduce motion")
            toggleEnabled: !Theme.followSystemAccessibility
            checked: Theme.reducedMotion
            onToggled: {
                if (!Theme.followSystemAccessibility)
                    Theme.reducedMotion = checked
            }
        }

        SettingsCard {
            title: qsTr("High contrast")
            description: Theme.followSystemAccessibility
                         ? qsTr("Driven by system high-contrast. Turn off “Follow system” to override.")
                         : qsTr("Strengthens borders and caption focus cues (Theme.highContrast).")
            headerIcon: "\uE7C7"
            toggle: true
            toggleText: qsTr("High contrast")
            toggleEnabled: !Theme.followSystemAccessibility
            checked: Theme.highContrast
            onToggled: {
                if (!Theme.followSystemAccessibility)
                    Theme.highContrast = checked
            }
        }

        SettingsCard {
            title: qsTr("Page transition")
            description: qsTr("NavigationView pageTransition for pane clicks: slide, fade, drill, cover, …")
            headerIcon: "\uE8AB"
            action: ComboBox {
                id: transitionBox
                implicitWidth: 160
                model: Window.window && Window.window.pageTransitionModes
                        ? Window.window.pageTransitionModes
                        : ["slide", "slideRight", "fade", "center", "drill", "up", "down", "cover", "none"]
                Component.onCompleted: {
                    var cur = Window.window ? Window.window.pageTransition : "slide"
                    var i = model.indexOf(cur)
                    currentIndex = i >= 0 ? i : 0
                }
                onActivated: function (index) {
                    if (Window.window)
                        Window.window.pageTransition = model[index]
                }
            }
        }

        SettingsCard {
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
    }
}
