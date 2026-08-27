import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras
import QWinUI3.Extras.Charts

CatalogPage {
    title: qsTr("WaffleChart")
    subtitle: qsTr("Experimental 10×10 part-to-whole. Prefer DonutChart for a compact ring.")

    ControlExample {
        headerText: qsTr("Disk cells")
        qmlSource: "WaffleChart {\n    slices: [{ value: 42, label: \"Used\" }]\n}"
        WaffleChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 280
            title: qsTr("C:")
            slices: [
                { value: 42, label: qsTr("Apps"), color: Theme.accent },
                { value: 18, label: qsTr("Media"), color: Theme.systemCaution },
                { value: 14, label: qsTr("Docs"), color: Theme.systemSuccess },
                { value: 26, label: qsTr("Free"), color: Theme.strokeDivider }
            ]
        }
    }
}
