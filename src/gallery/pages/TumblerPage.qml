import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — Tumbler.

CatalogPage {
    title: qsTr("Tumbler")
    subtitle: qsTr("A spinning wheel for selecting values from a list.")

    ControlExample {
        headerText: qsTr("Hours")
        qmlSource: "Tumbler { model: 24 }"
        Tumbler {
            Layout.alignment: Qt.AlignHCenter
            model: 24
        }
    }
}
