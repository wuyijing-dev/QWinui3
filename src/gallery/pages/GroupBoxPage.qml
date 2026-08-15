import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

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
                title: qsTr("GroupBox")
                subtitle: qsTr("Groups related controls under a common labeled frame.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("A simple GroupBox")
                qmlSource: "GroupBox {\n    title: \"Options\"\n    ColumnLayout {\n        CheckBox { text: \"Option A\"; checked: true }\n        CheckBox { text: \"Option B\" }\n    }\n}"

                GroupBox {
                    title: qsTr("Options")
                    Layout.preferredWidth: 320
                    ColumnLayout {
                        CheckBox { text: qsTr("Option A"); checked: true }
                        CheckBox { text: qsTr("Option B") }
                        CheckBox { text: qsTr("Option C") }
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
