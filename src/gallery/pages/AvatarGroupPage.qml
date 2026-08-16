import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — AvatarGroup.
//
// Overlapping person pictures with overflow count and click signals. API: docs/components/AvatarGroup.md

CatalogPage {
    title: qsTr("AvatarGroup")
    subtitle: qsTr("Overlapping person pictures with overflow count and click signals.")

    ControlExample {
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
}
