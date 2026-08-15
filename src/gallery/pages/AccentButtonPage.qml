import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: 0
    ScrollView {
        id: scroll
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true
        ColumnLayout {
            width: scroll.availableWidth
            spacing: Theme.spacingSection
            PageHeader {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                Layout.topMargin: Theme.spacingSection
                title: qsTr("AccentButton")
                subtitle: qsTr("Always-accent primary CTA. Prefer symbol: FluentIcons.* for icons.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
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
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
