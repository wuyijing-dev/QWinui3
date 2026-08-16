import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

ColumnLayout {
    id: root

    property string title: ""
    property string subtitle: ""
    // When set (Gallery CatalogPage), show favorite toggle (1.20).
    property string componentId: ""

    spacing: 8
    Layout.fillWidth: true

    RowLayout {
        Layout.fillWidth: true
        spacing: Theme.spacing

        Text {
            id: titleLabel
            text: root.title
            font.family: Theme.fontFamilyDisplay
            font.pixelSize: Theme.fontTitle
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
            wrapMode: Text.Wrap
            Layout.fillWidth: true
        }

        AbstractButton {
            id: favBtn
            visible: root.componentId.length > 0
                     && root.componentId !== "HomePage"
                     && root.componentId !== "SettingsPage"
            implicitWidth: 36
            implicitHeight: 36
            focusPolicy: Qt.StrongFocus
            Accessible.role: Accessible.Button
            Accessible.name: favorited ? qsTr("Remove favorite") : qsTr("Add favorite")
            readonly property bool favorited: GalleryHistory.isFavorite(root.componentId)
            onClicked: GalleryHistory.toggleFavorite(root.componentId)

            contentItem: Text {
                anchors.centerIn: parent
                text: favBtn.favorited ? FluentIcons.FavoriteStarFill : FluentIcons.Favorite
                font.family: Theme.fontFamilyIcon
                font.pixelSize: 18
                color: favBtn.favorited ? Theme.systemCaution : Theme.textSecondary
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            background: Rectangle {
                radius: Theme.cornerControl
                color: favBtn.hovered || favBtn.visualFocus ? Theme.fillSubtle : "transparent"
            }
        }
    }

    Rectangle {
        Layout.preferredWidth: 36
        Layout.preferredHeight: 3
        radius: 1.5
        color: Theme.accent
        opacity: 0.85
    }

    Text {
        visible: root.subtitle.length > 0
        text: root.subtitle
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontBody
        color: Theme.textSecondary
        wrapMode: Text.Wrap
        Layout.fillWidth: true
        Layout.maximumWidth: 720
        Layout.topMargin: 4
    }
}
