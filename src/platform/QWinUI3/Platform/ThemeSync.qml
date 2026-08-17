import QtQuick
import QWinUI3.Theme

// ThemeSync — Copy OS accessibility / color scheme into Theme knobs.
//
//   ThemeSync {
//       targetWindow: window
//   }
//
//   // --- API ---
//   // methods: applyFromSystem()
//   // StandardWindow / ShellWindow attach this when syncThemeFromSystem is true (1.69).
//
// @notes
//   Item (not QtObject) so Connections can be children. Zero size / not visible.
//   Not a Gallery privilege — any StandardWindow / ShellWindow does this.

Item {
    id: root

    Accessible.ignored: true
    width: 0
    height: 0
    visible: false

    // Window whose onActiveChanged retriggers a copy (optional).
    property var targetWindow: null
    // When false, never write Theme from the OS.
    property bool enabled: true

    // Refresh WindowHelper SPI and copy into Theme when the matching follow* flags are on.
    function applyFromSystem() {
        if (!enabled)
            return
        var a11y = Theme.followSystemAccessibility
        var color = Theme.followSystemColorScheme
        if (!a11y && !color)
            return
        if (a11y) {
            WindowHelper.refreshAccessibility()
            Theme.reducedMotion = WindowHelper.systemReducedMotion
            Theme.highContrast = WindowHelper.systemHighContrast
        }
        if (color) {
            WindowHelper.refreshColorScheme()
            Theme.dark = WindowHelper.systemPrefersDark
        }
    }

    Component.onCompleted: {
        if (enabled)
            Qt.callLater(function () { root.applyFromSystem() })
    }

    Connections {
        target: Theme
        enabled: root.enabled
        function onFollowSystemAccessibilityChanged() { root.applyFromSystem() }
        function onFollowSystemColorSchemeChanged() { root.applyFromSystem() }
    }

    Connections {
        target: WindowHelper
        enabled: root.enabled
        function onAccessibilityChanged() { root.applyFromSystem() }
        function onColorSchemeChanged() { root.applyFromSystem() }
    }

    Connections {
        target: root.targetWindow
        enabled: root.enabled && root.targetWindow !== null
        function onActiveChanged() {
            if (root.targetWindow && root.targetWindow.active)
                root.applyFromSystem()
        }
    }
}
