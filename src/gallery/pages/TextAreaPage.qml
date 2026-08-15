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
                title: qsTr("TextArea")
                subtitle: qsTr("A multi-line text input control.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("A simple TextArea")
                qmlSource: "TextArea {\n    placeholderText: \"Multi-line text…\"\n    Layout.preferredWidth: 420\n    Layout.preferredHeight: 120\n}"

                TextArea {
                    Layout.preferredWidth: 420
                    Layout.preferredHeight: 120
                    placeholderText: qsTr("Multi-line text…")
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
