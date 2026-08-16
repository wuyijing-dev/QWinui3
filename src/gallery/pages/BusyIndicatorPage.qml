import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme

// Gallery — BusyIndicator.

CatalogPage {
    title: qsTr("BusyIndicator")
    subtitle: qsTr("Shows that an operation is underway when progress is not known.")

    ControlExample {
        headerText: qsTr("A simple BusyIndicator")
        qmlSource: "BusyIndicator { running: true }\nBusyIndicator { running: false }"

        Flow {
            Layout.fillWidth: true
            spacing: Theme.spacingLoose
            BusyIndicator { running: true }
            BusyIndicator { running: false }
        }
    }
}
