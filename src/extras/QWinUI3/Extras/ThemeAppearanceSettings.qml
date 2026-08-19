import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import QWinUI3.Theme
import QWinUI3.Platform

// ThemeAppearanceSettings — Drop-in SettingsGroup for Theme knobs (1.69).
//
//   SettingsView {
//       ThemeAppearanceSettings {
//           persist: true
//           prefsCategory: "MyAppTheme"
//       }
//   }
//
//   // --- API ---
//   // persist / prefsCategory / showCopyRecipe
//   // Copy recipe uses Theme.recipeText() — paste into any app; not Gallery-only.
//
// @notes
//   Same cards Gallery Settings uses. Follow-system apply is ThemeSync (shells).
//   persist writes ThemePrefs (docs/settings-persistence.md).
//   Branding wave 2: accent packs + contrast/density — docs/theme-overrides.md (2.38).

SettingsGroup {
    id: root

    title: qsTr("Appearance")
    description: qsTr("Theme knobs for this process. Copy the recipe into any QWinUI3 app.")
    symbol: FluentIcons.Color

    // Persist via ThemePrefs (QSettings). Gallery / demo pages set persist: false explicitly.
    property bool persist: true
    property string prefsCategory: "ThemePrefs"
    property bool showCopyRecipe: true

    readonly property string recipeSnippet: Theme.recipeSnippet

    property ThemePrefs prefs: ThemePrefs {
        category: root.prefsCategory
        autoLoad: root.persist
        autoSave: root.persist
    }

    property ThemeSync systemSync: ThemeSync {
        targetWindow: Window.window
        enabled: true
    }

    function _accentIndex() {
        switch (Theme.accentPack) {
        case "purple": return 1
        case "green": return 2
        case "orange": return 3
        default: return 0
        }
    }

    SettingsCard {
        title: qsTr("Density")
        description: qsTr("Theme.density scales controlHeight / padding / spacing (not fonts). docs/density.md")
        symbol: FluentIcons.Document
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
        symbol: FluentIcons.Color
        action: ComboBox {
            model: [qsTr("Blue"), qsTr("Purple"), qsTr("Green"), qsTr("Orange")]
            currentIndex: root._accentIndex()
            onActivated: function (index) {
                Theme.setAccentPack(["blue", "purple", "green", "orange"][index])
            }
        }
    }

    SettingsCard {
        title: qsTr("Custom accent")
        description: qsTr("Theme.customAccent overrides the pack (alpha > 0). Clear via setAccentPack.")
        symbol: FluentIcons.Color
        action: RowLayout {
            spacing: 8
            ColorPickerButton {
                selectedColor: Theme.customAccent.a > 0.001
                               ? Theme.customAccent : Theme.accent
                showHexLabel: true
                onColorChosen: function (c) {
                    if (c.a > 0.001)
                        Theme.customAccent = c
                }
            }
            Button {
                flat: true
                text: qsTr("Clear")
                onClicked: Theme.setAccentPack(Theme.accentPack)
            }
        }
    }

    SettingsCard {
        title: qsTr("Appearance")
        description: Theme.followSystemColorScheme
                     ? qsTr("Driven by the OS. Turn off “Follow system color scheme” to override.")
                     : qsTr("Toggles the Theme singleton between light and dark color ramps.")
        symbol: FluentIcons.Color
        toggle: true
        toggleText: Theme.dark ? qsTr("Dark") : qsTr("Light")
        toggleEnabled: !Theme.followSystemColorScheme
        checked: Theme.dark
        onToggled: function (checked) {
            if (!Theme.followSystemColorScheme)
                Theme.dark = checked
        }
    }

    SettingsCard {
        title: qsTr("Follow system accessibility")
        description: qsTr("Copy OS reduce-motion / high-contrast into Theme (ThemeSync on the window).")
        symbol: FluentIcons.EaseOfAccess
        toggle: true
        toggleText: Theme.followSystemAccessibility ? qsTr("On") : qsTr("Off")
        checked: Theme.followSystemAccessibility
        onToggled: function (checked) { Theme.followSystemAccessibility = checked }
    }

    SettingsCard {
        title: qsTr("Follow system color scheme")
        description: qsTr("Mirror WindowHelper.systemPrefersDark into Theme.dark.")
        symbol: FluentIcons.Brightness
        toggle: true
        toggleText: Theme.followSystemColorScheme ? qsTr("On") : qsTr("Off")
        checked: Theme.followSystemColorScheme
        onToggled: function (checked) { Theme.followSystemColorScheme = checked }
    }

    SettingsCard {
        title: qsTr("Motion")
        description: Theme.followSystemAccessibility
                     ? qsTr("Driven by system (SPI client-area animation). Turn off “Follow system” to override.")
                     : qsTr("When enabled, Theme.duration() collapses animations for accessibility.")
        symbol: FluentIcons.DeveloperTools
        toggle: true
        toggleText: qsTr("Reduce motion")
        toggleEnabled: !Theme.followSystemAccessibility
        checked: Theme.reducedMotion
        onToggled: function (checked) {
            if (!Theme.followSystemAccessibility)
                Theme.reducedMotion = checked
        }
    }

    SettingsCard {
        title: qsTr("High contrast")
        description: Theme.followSystemAccessibility
                     ? qsTr("Driven by system high-contrast. Turn off “Follow system” to override.")
                     : qsTr("Strengthens borders and caption focus cues (Theme.highContrast).")
        symbol: FluentIcons.Game
        toggle: true
        toggleText: qsTr("High contrast")
        toggleEnabled: !Theme.followSystemAccessibility
        checked: Theme.highContrast
        onToggled: function (checked) {
            if (!Theme.followSystemAccessibility)
                Theme.highContrast = checked
        }
    }

    SettingsCard {
        visible: root.showCopyRecipe
        title: qsTr("Copy Theme recipe")
        description: qsTr("Theme.recipeText() — paste into your app’s onCompleted. Same knobs as this page.")
        symbol: FluentIcons.Copy
        action: CopyButton {
            textToCopy: root.recipeSnippet
        }
    }
}
