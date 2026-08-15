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
                title: qsTr("PersonPicture")
                subtitle: qsTr("Avatar, initials, Contact glyph when empty, focus ring, and status / count badges.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Initials, status, and counts")
                qmlSource: "PersonPicture {\n    displayName: \"Alex Rivera\"\n    badgeVisible: true\n    badgeValue: 3\n}"
                RowLayout {
                    spacing: Theme.spacingLoose
                    PersonPicture {
                        displayName: "Alex Rivera"
                        size: 32
                    }
                    PersonPicture {
                        displayName: "Jordan Lee"
                        size: 48
                        badgeVisible: true
                        badgeSeverity: 1
                    }
                    PersonPicture {
                        displayName: "Sam Chen"
                        size: 72
                        badgeVisible: true
                        badgeColor: Theme.systemCaution
                        badgeSymbol: FluentIcons.Important
                    }
                    PersonPicture {
                        displayName: "Casey Ng"
                        size: 48
                        badgeVisible: true
                        badgeSeverity: 3
                        badgeValue: 3
                    }
                    PersonPicture {
                        displayName: "Riley Fox"
                        size: 56
                        badgeVisible: true
                        badgeSeverity: 0
                        badgeValue: 128
                        badgeMaxValue: 99
                    }
                    PersonPicture {
                        displayName: "Taylor Kim"
                        size: 48
                        badgeVisible: true
                        badgeText: "NEW"
                        badgeSeverity: 2
                    }
                    PersonPicture {
                        displayName: ""
                        size: 48
                        selected: true
                    }
                    PersonPicture {
                        displayName: ""
                        size: 48
                        enabled: false
                        badgeVisible: true
                        badgeSeverity: 3
                    }
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
