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
                subtitle: qsTr("A primary accent-colored button for the main call to action.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Accent vs standard")
                qmlSource: "AccentButton { text: \"Save\" }\nButton { text: \"Cancel\" }"
                Flow {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    AccentButton { text: qsTr("Save") }
                    Button { text: qsTr("Cancel") }
                    AccentButton { text: qsTr("Disabled"); enabled: false }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
