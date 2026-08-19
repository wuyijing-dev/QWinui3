import QtQuick
import QWinUI3.Theme
import QWinUI3.Extras

// ThemePersistenceCard — Product-friendly wrapper for ThemeAppearanceSettings.
//
// Differences vs raw ThemeAppearanceSettings:
//  - defaults persist=true (so “users expect it to save”)
//  - renames the section header for LoB shells
//
// @notes
//   For Gallery / demo pages that intentionally avoid persisting across runs,
//   prefer ThemeAppearanceSettings { persist: false } explicitly (see gallery-shell).

ThemeAppearanceSettings {
    id: root

    // LoB friendly header.
    title: qsTr("Theme")
    description: qsTr("Persist theme appearance knobs via ThemePrefs (QSettings).")

    symbol: FluentIcons.Color

    // Ensure product expectation: theme changes should be saved by default.
    persist: true
}

