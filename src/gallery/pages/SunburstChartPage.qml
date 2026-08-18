import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QWinUI3.Theme
import QWinUI3.Extras

CatalogPage {
    title: qsTr("SunburstChart")
    subtitle: qsTr("Experimental two-level nested rings. Prefer DonutChart for a single ring.")

    ControlExample {
        headerText: qsTr("Storage")
        qmlSource: "SunburstChart {\n    slices: [{ label: \"Apps\", value: 40, children: […] }]\n}"
        SunburstChart {
            Layout.fillWidth: true
            Layout.preferredHeight: 280
            title: qsTr("C:")
            slices: [
                {
                    label: qsTr("Apps"),
                    value: 40,
                    color: Theme.accent,
                    children: [
                        { label: qsTr("Photo"), value: 24 },
                        { label: qsTr("Mail"), value: 16 }
                    ]
                },
                {
                    label: qsTr("Media"),
                    value: 28,
                    color: Theme.systemCaution,
                    children: [
                        { label: qsTr("Video"), value: 18 },
                        { label: qsTr("Music"), value: 10 }
                    ]
                },
                { label: qsTr("System"), value: 20, color: Theme.systemSuccess }
            ]
        }
    }
}
