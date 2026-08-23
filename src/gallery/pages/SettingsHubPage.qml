import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — Settings patterns (full inline demos). docs/forms.md

CatalogPage {
    id: page
    title: qsTr("Settings patterns")
    subtitle: qsTr("SettingsView · SettingsGroup · SettingsCard — docs/forms.md")

    ControlExample {
        headerText: qsTr("SettingsGroup + SettingsView")
        qmlSource: "SettingsView { SettingsGroup { … } }"
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("SettingsView scrolls grouped preference rows. SettingsGroup provides section headers; SettingsCard / SettingsExpander for individual rows.")
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
    }

    GalleryHubSection {
        title: qsTr("SettingsGroup")
        description: qsTr("Grouped settings with headers, toggles, and combo rows.")
        SettingsGroupPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("SettingsCard")
        description: qsTr("Card-style preference row with icon and description.")
        SettingsCardPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Settings combo + slider")
        description: qsTr("Compound settings row patterns.")
        SettingsComboSliderPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("SettingsExpander")
        description: qsTr("Collapsible settings section.")
        SettingsExpanderPage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Settings persistence")
        description: qsTr("Save / restore preferences with SettingsView.")
        SettingsPersistencePage { hubEmbed: true; width: parent.width }
    }

    GalleryHubSection {
        title: qsTr("Forms & settings templates")
        description: qsTr("Industry form templates and validation recipes.")
        FormsHubPage { hubEmbed: true; width: parent.width }
    }
}
