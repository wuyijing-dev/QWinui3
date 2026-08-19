import QtQuick
import QtQuick.Layouts
import QWinUI3.Theme
import QWinUI3.Extras

// ThemeSyncCard — Summarize ThemeSync vs ThemePrefs vs persist:false semantics.
//
// @notes
//   ThemeSync copies WindowHelper system a11y / color scheme into Theme knobs.
//   ThemePrefs persists those knobs via QSettings (category).
//   ThemeAppearanceSettings.persist controls whether its internal ThemePrefs autoSave.

SettingsGroup {
    id: root

    title: qsTr("Theme Sync")
    description: qsTr("What currently drives your Theme knobs (OS vs stored prefs).")
    symbol: FluentIcons.Sync

    DetailRow {
        label: qsTr("Follow system accessibility")
        value: Theme.followSystemAccessibility ? qsTr("On") : qsTr("Off")
        symbol: FluentIcons.EaseOfAccess
    }

    DetailRow {
        label: qsTr("Follow system color scheme")
        value: Theme.followSystemColorScheme ? qsTr("On") : qsTr("Off")
        symbol: FluentIcons.Brightness
    }

    DetailRow {
        label: qsTr("Effective appearance")
        value: Theme.dark ? qsTr("Dark") : qsTr("Light")
        symbol: FluentIcons.Color
    }

    DetailRow {
        label: qsTr("Motion / reduced motion")
        value: Theme.followSystemAccessibility ? qsTr("Driven by OS") : (Theme.reducedMotion ? qsTr("On") : qsTr("Off"))
        symbol: FluentIcons.EaseOfAccess
    }
}

