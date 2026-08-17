import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — Settings.
//
// Theme knobs come from ThemeAppearanceSettings (kit, not Gallery-only).
// Gallery-only: RTL session toggle, page cache, corners, RHI.

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
        subtitle: qsTr("Theme knobs are kit-wide (copy recipe into your app). Corners, RHI, and page cache stay Gallery chrome.")

        ThemeAppearanceSettings {
            persist: false
            prefsCategory: "GalleryTheme"
        }

        SettingsGroup {
            title: qsTr("Gallery")
            description: qsTr("This process only — not Theme tokens.")
            symbol: FluentIcons.DeveloperTools

            SettingsCard {
                title: qsTr("Right-to-left layout")
                description: qsTr("Sets Qt.application.layoutDirection and mirrors the Gallery shell. Session only — docs/i18n-rtl.md.")
                symbol: FluentIcons.Globe
                toggle: true
                toggleText: qsTr("RTL")
                checked: Qt.application.layoutDirection === Qt.RightToLeft
                onToggled: {
                    Qt.application.layoutDirection = checked ? Qt.RightToLeft : Qt.LeftToRight
                }
            }

            SettingsCard {
                title: qsTr("Real-time FPS")
                description: qsTr("FrameStatsMonitor — title-bar badge or floating overlay. Toggle persists in QSettings. CLI: --show-fps, --fps-overlay.")
                symbol: FluentIcons.SpeedHigh
                toggle: true
                toggleText: qsTr("Show FPS")
                checked: FrameStatsMonitor.enabled
                onToggled: FrameStatsMonitor.enabled = checked
            }

            SettingsCard {
                title: qsTr("FPS placement")
                description: qsTr("Title bar RightHeader slot (FrameStatsBadge) or floating overlay.")
                symbol: FluentIcons.Pin
                action: ComboBox {
                    implicitWidth: 180
                    enabled: FrameStatsMonitor.enabled
                    model: [
                        { label: qsTr("Title bar"), value: true },
                        { label: qsTr("Overlay"), value: false }
                    ]
                    textRole: "label"
                    Component.onCompleted: {
                        currentIndex = FrameStatsMonitor.inTitleBar ? 0 : 1
                    }
                    onActivated: function (index) {
                        FrameStatsMonitor.inTitleBar = model[index].value
                    }
                }
            }

            SettingsCard {
                title: qsTr("Performance arc (1.86–1.89)")
                description: qsTr("Four-wave perf plan — animations stay; trim no-op work only. Arc signed off at 1.90 close-out. docs/performance.md · docs/checkpoint-190.md")
                symbol: FluentIcons.SpeedHigh
                action: ColumnLayout {
                    spacing: 2
                    Repeater {
                        model: [
                            { wave: "1.86", theme: qsTr("Shell & window runtime"), status: qsTr("Shipped") },
                            { wave: "1.87", theme: qsTr("Navigation & page stack"), status: qsTr("Shipped") },
                            { wave: "1.88", theme: qsTr("Lists & data collections"), status: qsTr("Shipped") },
                            { wave: "1.89", theme: qsTr("Style, charts & heavy pages"), status: qsTr("Shipped") }
                        ]
                        delegate: Label {
                            required property var modelData
                            text: modelData.wave + " — " + modelData.theme + " (" + modelData.status + ")"
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontCaption
                            color: Theme.textSecondary
                        }
                    }
                }
            }

            SettingsCard {
                title: qsTr("Page transition")
                description: qsTr("NavigationView pageTransition for pane clicks: slide, fade, drill, cover, … Each mode animates only its axes (1.87).")
                symbol: FluentIcons.EaseOfAccess
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
                title: qsTr("Page Component cache")
                description: qsTr("NavigationView caches compiled pages (limit %1). Count: %2. First open is instant (initialPageTransition=none). docs/performance.md (1.39)")
                             .arg(Window.window && Window.window.navigationView
                                  ? Window.window.navigationView.pageCacheLimit : 24)
                             .arg(Window.window && Window.window.navigationView
                                  ? Window.window.navigationView.pageCacheCount : 0)
                symbol: FluentIcons.DeveloperTools
                action: Button {
                    text: qsTr("Clear cache")
                    onClicked: {
                        if (Window.window && Window.window.navigationView)
                            Window.window.navigationView.clearPageCache(true)
                    }
                }
            }

            SettingsCard {
                enabled: WindowHelper.nativeChrome
                title: qsTr("Window corners")
                description: qsTr("DWM corner preference — round (Win11), round small, or square.")
                symbol: FluentIcons.Picture
                action: ComboBox {
                    id: cornerBox
                    implicitWidth: 160
                    model: root.cornerLabels
                    onActivated: function (index) { root.applyCornerAt(index) }
                }
            }

            SettingsCard {
                title: qsTr("Graphics backend")
                description: qsTr("Qt Quick RHI. Ship OpenGL on Windows for Mica/Acrylic. Change needs Restart (--rhi). Active: %1. %2 — docs/graphics-backend.md")
                             .arg(root.rhiDisplayName(GraphicsBackend.active))
                             .arg(GraphicsBackend.hint)
                symbol: FluentIcons.HardDrive
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
}
