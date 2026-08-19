import QtQuick
import QWinUI3.Extras

// GeometryAndPrefsGuard — Warn when ThemeAppearanceSettings.persist=false may surprise users.
//
// @notes
//   True detection of “main ThemePrefs autoSave” requires app-side wiring.
//   This component therefore accepts the main autoSave flag as an input.

SettingsCard {
    id: root

    // Whether the Settings page is persisting changes.
    property bool settingsPersistEnabled: true

    // Whether the main window is persisting theme via ThemePrefs.
    property bool mainThemePrefsAutoSave: true

    // If both are written into the same prefs category, mismatch is more confusing.
    property bool prefsCategoryMatches: true

    title: qsTr("Theme changes may not save")
    description: qsTr(
        "Your Settings page uses ThemeAppearanceSettings { persist: false }. " +
        "If the main window writes ThemePrefs automatically, the app may behave as “changed but not persisted”. " +
        "Set persist: true on the Settings card or ensure only one ThemePrefs instance auto-saves."
    )
    symbol: FluentIcons.Warning

    // Let the app embed this next to ThemeAppearanceSettings; only show when conditions match.
    visible: (!root.settingsPersistEnabled) && root.mainThemePrefsAutoSave && root.prefsCategoryMatches
    interactive: false
}

