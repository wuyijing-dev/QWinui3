import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — SplitView.

CatalogPage {
    title: qsTr("SplitView")
    subtitle: qsTr("A layout that divides available space between resizable panes.")

    ControlExample {
        headerText: qsTr("Horizontal SplitView")
        qmlSource: "SplitView {\n    orientation: Qt.Horizontal\n    Pane { }\n    Pane { }\n}"

        SplitView {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            orientation: Qt.Horizontal

            Pane {
                SplitView.preferredWidth: 200
                SplitView.minimumWidth: 80
                Label {
                    text: qsTr("Left pane")
                    color: Theme.textPrimary
                }
            }
            Pane {
                SplitView.fillWidth: true
                SplitView.minimumWidth: 80
                Label {
                    text: qsTr("Right pane")
                    color: Theme.textPrimary
                }
            }
        }
    }
}
