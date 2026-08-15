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
                title: qsTr("Pane")
                subtitle: qsTr("A padded surface that groups related content.")
            }

            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Basic Pane")
                qmlSource: "Pane {\n    Label {\n        text: \"Pane content\"\n    }\n}"

                Pane {
                    Layout.preferredWidth: 320
                    Label {
                        text: qsTr("This is content inside a Pane. Use panes to visually group related controls and text.")
                        wrapMode: Text.Wrap
                        width: parent.availableWidth
                        color: Theme.textPrimary
                    }
                }
            }

            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
