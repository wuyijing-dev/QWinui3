import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

// Gallery — TreemapChart.

CatalogPage {
    title: qsTr("TreemapChart")
    subtitle: qsTr("Experimental slice-and-dice treemap. Prefer DonutChart for part-to-whole.")

    ControlExample {
        headerText: qsTr("Disk share")
        qmlSource: "TreemapChart {\n    slices: [{ value: 42, label: \"Apps\" }]\n}"
        TreemapChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 220
            title: qsTr("C:")
            slices: [
                { value: 42, label: qsTr("Apps"), color: Theme.accent },
                { value: 18, label: qsTr("Media"), color: Theme.systemCaution },
                { value: 14, label: qsTr("Docs"), color: Theme.systemSuccess },
                { value: 9, label: qsTr("Cache"), color: Theme.accentLight1 },
                { value: 7, label: qsTr("Logs"), color: Theme.systemCritical }
            ]
        }
    }
}
