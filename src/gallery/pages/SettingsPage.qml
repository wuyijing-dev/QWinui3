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
        subtitle: qsTr("Theme knobs are kit-wide (ThemeAppearanceSettings). accent packs + ThemePrefs persist — docs/theme-overrides.md.")

        ThemeAppearanceSettings {
            persist: false
            prefsCategory: "GalleryTheme"
        }

        SettingsGroup {
            title: qsTr("Gallery")
            description: qsTr("This process only — not Theme tokens.")
            symbol: FluentIcons.DeveloperTools

            SettingsCard {
                title: qsTr("Display language")
                description: GalleryLanguage.translatorActive
                    ? qsTr("UI locale: %1 — all qsTr strings refresh live. Persisted for next launch. Full catalogs: src/gallery/translations/.")
                        .arg(GalleryLanguage.labelForLocale(GalleryLanguage.currentLocale))
                    : qsTr("English (default). Pick 简体中文 / 日本語 / 한국어 when .qm is built (Release + qt_add_translations). docs/i18n-rtl.md.")
                symbol: FluentIcons.Globe
                action: ComboBox {
                    id: langBox
                    implicitWidth: 220
                    model: GalleryLanguage.localeLabels
                    currentIndex: GalleryLanguage.indexOfLocale(GalleryLanguage.currentLocale)
                    onActivated: function (index) {
                        GalleryLanguage.applyLocale(GalleryLanguage.availableLocales[index])
                    }
                }
            }

            SettingsCard {
                title: qsTr("Right-to-left layout")
                description: qsTr("Sets layout direction via WindowHelper and mirrors the Gallery shell. Session only — docs/i18n-rtl.md.")
                symbol: FluentIcons.Globe
                toggle: true
                toggleText: qsTr("RTL")
                checked: WindowHelper.layoutDirection === Qt.RightToLeft
                onToggled: function (checked) {
                    WindowHelper.setLayoutDirection(checked ? Qt.RightToLeft : Qt.LeftToRight)
                }
            }

            SettingsCard {
                title: qsTr("Real-time FPS")
                description: qsTr("FrameStatsMonitor — title-bar badge or floating overlay. Toggle persists in QSettings (Gallery dev profile). Retail apps: applyRetailProfile() — docs/developer-diagnostics.md. CLI: --show-fps, --fps-overlay, --show-rhi, --show-diagnostics, --retail-diagnostics.")
                symbol: FluentIcons.SpeedHigh
                toggle: true
                toggleText: qsTr("Show FPS")
                checked: FrameStatsMonitor.enabled
                onToggled: function (checked) { FrameStatsMonitor.enabled = checked }
            }

            SettingsCard {
                title: qsTr("RHI in FPS badge")
                description: qsTr("Append active Qt Quick RHI backend (OpenGL, Vulkan, D3D11, …) beside FPS readout. Requires Show FPS. Persists in QSettings.")
                symbol: FluentIcons.HardDrive
                toggle: true
                toggleText: qsTr("Show RHI")
                enabled: FrameStatsMonitor.enabled
                checked: FrameStatsMonitor.showRhi
                onToggled: function (checked) { FrameStatsMonitor.showRhi = checked }
            }

            SettingsCard {
                title: qsTr("FPS placement")
                description: qsTr("Title bar RightHeader slot (FrameStatsBadge) or floating overlay.")
                symbol: FluentIcons.Pin
                action: ComboBox {
                    id: fpsPlacementBox
                    implicitWidth: 180
                    enabled: FrameStatsMonitor.enabled
                    model: [
                        { label: qsTr("Title bar"), value: true },
                        { label: qsTr("Overlay"), value: false }
                    ]
                    textRole: "label"
                    currentIndex: FrameStatsMonitor.inTitleBar ? 0 : 1
                    onActivated: function (index) {
                        FrameStatsMonitor.inTitleBar = model[index].value
                    }
                }
                Connections {
                    target: FrameStatsMonitor
                    function onChanged() {
                        fpsPlacementBox.currentIndex = FrameStatsMonitor.inTitleBar ? 0 : 1
                    }
                }
            }

            SettingsCard {
                title: qsTr("Page transition")
                description: qsTr("NavigationView pageTransition for pane clicks: slide, fade, drill, cover, … Each mode animates only its axes.")
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
                description: qsTr("Gallery keeps ≤%1 compiled pages (Home/Settings pinned). Live count: %2. StackView.replace unloads off-screen trees. docs/performance.md")
                             .arg(Window.window && Window.window.navigationView
                                  ? Window.window.navigationView.pageCacheLimit : 8)
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
                enabled: WindowHelper.nativeChrome || WindowHelper.clientShellDecoration
                title: qsTr("Window corners")
                description: WindowHelper.clientShellDecoration
                             ? qsTr("Linux / Wayland client shell — rounded window + DWM-like shadow (QtQuick.Effects). Same keys as Windows DWM preference.")
                             : qsTr("DWM corner preference — round (Win11), round small, or square.")
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
                description: qsTr("Qt Quick RHI. Defaults: Windows D3D11, Linux Vulkan (auto-fallback when unsupported). Change needs Restart (--rhi). Active: %1. %2 — docs/graphics-backend.md")
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
