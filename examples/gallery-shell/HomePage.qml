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
            text: qsTr("This is the extractable Gallery shell (1.50): NavigationWindow, one content page, Settings footer, Bootstrap main, and geometryPersistenceKey. Open Settings from the pane footer.")
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontBody
            color: Theme.textSecondary
        }
        ContentCard {
            Layout.fillWidth: true
            title: qsTr("Keep vs delete")
            subtitle: qsTr("Keep Main.qml / main.cpp / CMakeLists.txt / your pages. Delete this card text and replace HomePage with your product UI. Full notes: examples/gallery-shell/README.md.")
        }
        ContentCard {
            Layout.fillWidth: true
            title: qsTr("vs nav-settings")
            subtitle: qsTr("nav-settings builds StandardWindow + NavigationView by hand. This shell uses NavigationWindow (recommended app chrome) with pageModule.")
        }
        Item { Layout.fillHeight: true }
    }
}
