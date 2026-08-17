import QtQuick
import QtCore
import QWinUI3.Theme

// ThemePrefs — Persist Theme knobs via QtCore Settings (1.69).
//
//   ThemePrefs {
//       category: "ThemePrefs"
//       Component.onCompleted: load()
//   }
//
//   // --- API ---
//   // methods: load(), save()
//   // Then ThemeSync.applyFromSystem() so follow* flags win over stored dark/motion.
//
// @notes
//   Same QSettings recipe as docs/settings-persistence.md — not a Gallery store.
//   Keep WindowGeometry on geometryPersistenceKey; this category is Theme only.

Item {
    id: root

    Accessible.ignored: true
    width: 0
    height: 0
    visible: false

    // QSettings category (not WindowGeometry)
    property string category: "ThemePrefs"
    // Load Theme.apply(store) on completed
    property bool autoLoad: true
    // Write Theme knobs back when they change
    property bool autoSave: true

    property bool _ready: false
    property bool _writing: false

    Settings {
        id: store
        category: root.category
        property int schemaVersion: 1
        property bool dark: false
        property bool reducedMotion: false
        property bool highContrast: false
        property bool followSystemAccessibility: true
        property bool followSystemColorScheme: false
        property string density: "standard"
        property real uiScale: 1.0
        property string accentPack: "blue"
        property string customAccent: "#00000000"
    }

    function load() {
        _writing = true
        Theme.apply({
            dark: store.dark,
            reducedMotion: store.reducedMotion,
            highContrast: store.highContrast,
            followSystemAccessibility: store.followSystemAccessibility,
            followSystemColorScheme: store.followSystemColorScheme,
            density: store.density,
            uiScale: store.uiScale,
            accentPack: store.accentPack,
            customAccent: store.customAccent
        })
        _writing = false
    }

    function save() {
        _writing = true
        store.followSystemAccessibility = Theme.followSystemAccessibility
        store.followSystemColorScheme = Theme.followSystemColorScheme
        store.density = Theme.density
        store.uiScale = Theme.uiScale
        store.accentPack = Theme.accentPack
        store.customAccent = String(Theme.customAccent)
        store.dark = Theme.dark
        store.reducedMotion = Theme.reducedMotion
        store.highContrast = Theme.highContrast
        _writing = false
    }

    Component.onCompleted: {
        if (autoLoad)
            Qt.callLater(function () {
                root.load()
                root._ready = true
                if (root.autoSave)
                    root.save()
            })
        else {
            _ready = true
        }
    }

    Connections {
        target: Theme
        enabled: root.autoSave && root._ready
        function onDarkChanged() { if (!root._writing) root.save() }
        function onReducedMotionChanged() { if (!root._writing) root.save() }
        function onHighContrastChanged() { if (!root._writing) root.save() }
        function onFollowSystemAccessibilityChanged() { if (!root._writing) root.save() }
        function onFollowSystemColorSchemeChanged() { if (!root._writing) root.save() }
        function onDensityChanged() { if (!root._writing) root.save() }
        function onUiScaleChanged() { if (!root._writing) root.save() }
        function onAccentPackChanged() { if (!root._writing) root.save() }
        function onCustomAccentChanged() { if (!root._writing) root.save() }
    }
}
