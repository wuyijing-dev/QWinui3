import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — StackPanel.

CatalogPage {
    title: qsTr("StackPanel")
    subtitle: qsTr("Horizontal/vertical stack with spacing, alignment, RTL, and childCount.")

    ControlExample {
        headerText: qsTr("Vertical")
        qmlSource: "StackPanel {\n    orientation: Qt.Vertical\n    Button { text: \"One\" }\n}"
        StackPanel {
            Layout.fillWidth: true
            orientation: Qt.Vertical
            spacing: Theme.spacing
            Button { text: qsTr("Primary action"); highlighted: true }
            Button { text: qsTr("Secondary") }
            Label { text: qsTr("Footer note"); color: Theme.textSecondary }
        }
    }
    ControlExample {
        headerText: qsTr("Horizontal + RTL")
        qmlSource: "StackPanel {\n    orientation: Qt.Horizontal\n    layoutDirection: Qt.RightToLeft\n}"
        StackPanel {
            orientation: Qt.Horizontal
            spacing: Theme.spacing
            layoutDirection: Qt.RightToLeft
            alignment: Qt.AlignVCenter
            stretchChildren: false
            Button { text: qsTr("Save"); highlighted: true }
            Button { text: qsTr("Cancel"); flat: true }
            Button { text: qsTr("More") }
        }
    }
}
