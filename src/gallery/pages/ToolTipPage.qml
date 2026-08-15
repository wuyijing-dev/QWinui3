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
                title: qsTr("ToolTip")
                subtitle: qsTr("Displays informational text when the user hovers over an element.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("A simple ToolTip")
                qmlSource: "Button {\n    text: \"Hover me\"\n    ToolTip.visible: hovered\n    ToolTip.text: \"Fluent-style tooltip\"\n    ToolTip.delay: 400\n}"

                Button {
                    text: qsTr("Hover me")
                    ToolTip.visible: hovered
                    ToolTip.text: qsTr("Fluent-style tooltip")
                    ToolTip.delay: 400
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
