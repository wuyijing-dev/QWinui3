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
                title: qsTr("ContentCard")
                subtitle: qsTr("Elevated card with title, body, optional footer, and isClickable.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Card")
                qmlSource: "ContentCard {\n    footer: Button { … }\n    isClickable: true\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacing
                    Label {
                        id: cardMsg
                        text: qsTr("Ready")
                        color: Theme.textSecondary
                    }
                    ContentCard {
                        Layout.fillWidth: true
                        Layout.maximumWidth: 360
                        title: qsTr("QWinUI3")
                        subtitle: qsTr("Fluent-style Qt Quick Controls")
                        headerIcon: "\uE8A5"
                        isClickable: true
                        onClicked: cardMsg.text = qsTr("Card clicked")
                        Label {
                            wrapMode: Text.Wrap
                            text: qsTr("Use ContentCard to group related content with a clear surface.")
                            color: Theme.textSecondary
                        }
                        footer: RowLayout {
                            spacing: Theme.spacing
                            Button { text: qsTr("Dismiss"); flat: true }
                            AccentButton { text: qsTr("Open") }
                        }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
