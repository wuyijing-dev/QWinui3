import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Button.
//
// A control that responds to user input and raises a Click event. API: docs/components/Button.md

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
                title: qsTr("Button")
                subtitle: qsTr("A control that responds to user input and raises a Click event.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Standard")
                qmlSource: "Button {\n    text: \"Button\"\n}\nButton {\n    text: \"Disabled\"\n    enabled: false\n}"

                Flow {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    Button { text: qsTr("Button") }
                    Button { text: qsTr("Disabled"); enabled: false }
                }
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Accent")
                qmlSource: "Button {\n    text: \"Accent\"\n    highlighted: true\n}\nButton {\n    text: \"Accent disabled\"\n    highlighted: true\n    enabled: false\n}"

                Flow {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLoose
                    Button { text: qsTr("Accent"); highlighted: true }
                    Button { text: qsTr("Accent disabled"); highlighted: true; enabled: false }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
