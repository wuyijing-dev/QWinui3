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
            text: qsTr("Home")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontTitle
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
        }
        Text {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            text: qsTr("Copy this example to bootstrap an app with NavigationView and a Settings footer page.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
        ContentCard {
            Layout.fillWidth: true
            title: qsTr("Getting started")
            subtitle: qsTr("Open Settings from the pane footer to toggle theme and motion.")
        }
        Item { Layout.fillHeight: true }
    }
}
