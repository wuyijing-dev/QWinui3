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
                title: qsTr("AvatarGroup")
                subtitle: qsTr("Overlapping person pictures with overflow count and click signals.")
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Collaborators")
                qmlSource: "AvatarGroup {\n    model: [\"Ada Lovelace\", …]\n    onPersonClicked: …\n}"
                ColumnLayout {
                    spacing: Theme.spacing
                    Label {
                        id: avatarStatus
                        text: qsTr("Click a person or overflow")
                        color: Theme.textSecondary
                    }
                    AvatarGroup {
                        size: 40
                        maxVisible: 4
                        model: [
                            qsTr("Ada Lovelace"),
                            qsTr("Grace Hopper"),
                            qsTr("Alan Turing"),
                            qsTr("Katherine Johnson"),
                            qsTr("Margaret Hamilton"),
                            qsTr("Tim Berners-Lee")
                        ]
                        onPersonClicked: function (index, item) {
                            avatarStatus.text = qsTr("Person %1: %2").arg(index + 1).arg(item)
                        }
                        onOverflowClicked: avatarStatus.text = qsTr("Overflow clicked (+%1)").arg(overflowCount)
                    }
                }
            }
            ControlExample {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.spacingSection
                Layout.rightMargin: Theme.spacingSection
                headerText: qsTr("Compact / RTL")
                qmlSource: "AvatarGroup { size: 28; layoutDirection: Qt.RightToLeft }"
                AvatarGroup {
                    size: 28
                    overlap: 10
                    maxVisible: 3
                    layoutDirection: Qt.RightToLeft
                    model: [qsTr("Alex"), qsTr("Blake"), qsTr("Casey"), qsTr("Drew")]
                }
            }
            Item { Layout.preferredHeight: Theme.spacingSection; Layout.fillWidth: true }
        }
    }
}
