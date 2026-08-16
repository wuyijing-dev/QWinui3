import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AccentButton.
//
// Always-accent primary CTA. Prefer symbol: FluentIcons.* for icons. API: docs/components/AccentButton.md

CatalogPage {
    title: qsTr("AccentButton")
    subtitle: qsTr("Always-accent primary CTA. Prefer symbol: FluentIcons.* for icons.")

    ControlExample {
        headerText: qsTr("Accent vs standard")
        qmlSource: "AccentButton {\n    text: \"Save\"\n    symbol: FluentIcons.Save\n}"

        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            AccentButton {
                text: qsTr("Save")
                symbol: FluentIcons.Save
            }
            Button { text: qsTr("Cancel") }
            AccentButton {
                text: qsTr("Share")
                symbol: FluentIcons.Share
            }
            AccentButton { text: qsTr("Disabled"); enabled: false }
        }
    }
}
