import QtQuick
import QtQuick.Layouts
import QWinUI3.Theme

// Section chrome when a full Gallery page is embedded in a hub (title + description + demos).

Item {
    id: root

    property string title: ""
    property string description: ""
    default property alias body: bodySlot.data

    implicitHeight: col.implicitHeight
    Layout.fillWidth: true

    ColumnLayout {
        id: col
        width: parent.width
        spacing: Theme.spacing

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingTight
            visible: root.title.length > 0

            Text {
                Layout.fillWidth: true
                text: root.title
                font.family: Theme.fontFamilyDisplay
                font.pixelSize: Theme.fontTitle
                font.weight: Theme.fontWeightSemiBold
                color: Theme.textPrimary
            }

            Text {
                Layout.fillWidth: true
                visible: root.description.length > 0
                wrapMode: Text.WordWrap
                text: root.description
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontBody
                color: Theme.textSecondary
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: Theme.spacingTight
                Layout.preferredHeight: 1
                color: Theme.strokeDivider
            }
        }

        Item {
            id: bodySlot
            Layout.fillWidth: true
            implicitHeight: childrenRect.height
        }
    }
}
