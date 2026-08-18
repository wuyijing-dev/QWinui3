import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Platform

// Gallery — Theme prefs belong to the kit (1.69).
// Recipe: docs/theme-overrides.md · docs/settings-persistence.md

CatalogPage {
    id: page
    title: qsTr("Theme prefs")
    subtitle: qsTr("ThemeAppearanceSettings + ThemePrefs persist recipe — docs/theme-overrides.md (2.38).")

    signal openSettings()

    ControlExample {
        headerText: qsTr("ThemePrefs for 2.x apps (2.38)")
        qmlSource: "ThemePrefs { category: \"MyAppTheme\"; autoLoad: true; autoSave: true }"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Separate ThemePrefs category from geometryPersistenceKey. ThemeAppearanceSettings { persist: true; prefsCategory: \"MyAppTheme\" } writes the same knobs. ThemeSync on StandardWindow/ShellWindow applies followSystem* after load.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    ControlExample {
        headerText: qsTr("Drop-in for any app (1.69)")
        qmlSource: "ThemeAppearanceSettings {\n    persist: true\n    prefsCategory: \"MyAppTheme\"\n}\n// Copy Theme.recipeText() into onCompleted"
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: qsTr("StandardWindow / ShellWindow already run ThemeSync (follow system a11y / color). Drop ThemeAppearanceSettings on your Settings page. Copy the recipe into another process — same knobs, no Gallery code. Persist uses ThemePrefs (QSettings), not WindowGeometry.")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacing
                CopyButton {
                    textToCopy: Theme.recipeSnippet
                }
                Button {
                    text: qsTr("Open Settings")
                    onClicked: page.openSettings()
                }
            }
            Text {
                Layout.fillWidth: true
                wrapMode: Text.WrapAnywhere
                text: Theme.recipeSnippet
                font.family: Theme.fontFamilyMono
                font.pixelSize: Theme.fontCaption
                color: Theme.textSecondary
            }
        }
    }
}
