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
                title: qsTr("ListTile")
                subtitle: qsTr("List row with glyph or leading content, title, description, selection, and trailing.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Rows")
                qmlSource: "ListTile {\n    title: \"Mail\"\n    isSelected: true\n    showChevron: true\n}"
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    ListTile {
                        Layout.fillWidth: true
                        title: qsTr("Mail")
                        description: qsTr("2 unread messages")
                        glyph: "\uE715"
                        showChevron: true
                        isSelected: true
                    }
                    ListTile {
                        Layout.fillWidth: true
                        title: qsTr("Alex Rivera")
                        description: qsTr("Available")
                        PersonPicture {
                            displayName: "Alex Rivera"
                            size: 36
                            badgeVisible: true
                            badgeSeverity: 1
                        }
                        Switch { checked: true }
                    }
                    ListTile {
                        Layout.fillWidth: true
                        title: qsTr("Storage")
                        description: qsTr("12 GB free of 128 GB")
                        glyph: "\uEDA2"
                        InfoBadge { value: 3 }
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
