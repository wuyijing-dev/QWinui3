import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — UniformGrid.

CatalogPage {
    title: qsTr("UniformGrid")
    subtitle: qsTr("Equal cells with cellSpacing, RTL, and childCount.")

    ControlExample {
        headerText: qsTr("3 columns")
        qmlSource: "UniformGrid {\n    columns: 3\n    cellSpacing: 8\n}"
        UniformGrid {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            columns: 3
            cellSpacing: 8
            layoutDirection: Qt.LeftToRight
            Repeater {
                model: 6
                Rectangle {
                    radius: Theme.cornerControl
                    color: Theme.fillSubtle
                    border.width: 1
                    border.color: Theme.strokeCard
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Cell %1").arg(index + 1)
                        color: Theme.textPrimary
                    }
                }
            }
        }
    }
}
