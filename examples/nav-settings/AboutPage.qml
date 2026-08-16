import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

Page {
    padding: Theme.spacingSection

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.spacingLoose

        Text {
            text: qsTr("About")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontTitle
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
        }
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("QWinUI3 example — NavigationView + Settings. Not a full Gallery.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
        Item { Layout.fillHeight: true }
    }
}
